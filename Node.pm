# $Id: Node.pm 14645 2015-04-25 18:00:00Z rr102 $
#
# Library to interface with drupal nodes.
#
# Author: Rasan Rasch <rasan@nyu.edu>

package Node;

use strict;
use warnings;

our $VERSION = "0.01";

use Data::Dumper;
use DBI;
use File::Basename;
use File::MimeInfo;
use HTTP::Cookies;
use JSON;
use Number::Bytes::Human qw(format_bytes);
use Storable qw(dclone);
use Time::Duration;
use WWW::Mechanize;
use MyConfig;
use MyLogger;
use Util;

my $log = MyLogger->get_logger();

if ($log->is_trace()) {
	eval 'use XMLRPC::Lite +trace => "debug";';
} else {
	eval 'use XMLRPC::Lite';
}

if ($@) {
	$log->logdie("Can't lode module: $@");
}

my %non_translatable_fields = (
	title                      => 1,
	publication_date_text      => 1,
	publication_location       => 1,
	rights                     => 1,
	binding_orientation_select => 1,
	scan_date                  => 1,
);


# XXX: put this in db module
my $dsn =
  "DBI:mysql:database=" . config('dbname') . ';host=' . config('dbhost');
my $dbh = DBI->connect($dsn, config('dbuser'), config('dbpass'))
  or $log->logdie($DBI::errstr);
my $fid_sth =
  $dbh->prepare("SELECT fid FROM "
	  . config('dbprefix')
	  . "file_managed WHERE filename = ?")
  or $log->die($dbh->errstr);


# construct xmlrpc agent to talk to drupal services,
# we define our basic authentication credentials and create
# a cookie jar to hold the authentication cookie we receive
# from server.
sub SOAP::Transport::HTTP::Client::get_basic_credentials
{
	return (config('http_user') => config('http_pass'));
}

my $cookie_jar = HTTP::Cookies->new(ignore_discard => 1);

my $FAULT_STRING;

my $on_fault = sub {
	my ($xmlrpc, $res) = @_;
	if (ref($res) && $res->faultstring) {
		$FAULT_STRING = $res->faultstring;
	} else {
# 		$FAULT_STRING = $xmlrpc->transport->status;
		$FAULT_STRING = get_fault($xmlrpc->transport->http_response->content);
	} 
};

my $xmlrpc = XMLRPC::Lite->proxy(config('drupal_services_proxy'),
	cookie_jar => $cookie_jar, timeout => 60)->on_fault($on_fault);

my $result = rpc("system.listMethods");
$log->debug("Available methods: ", Dumper($result));
my %methods = map { $_ => 1 } @$result;

# login in to services interface
$log->debug("Logging into drupal services interface");
$result = rpc("user.login", config('drupal_user'), config('drupal_pass'));
$log->debug("login user: ", Dumper($result));
my $sessid       = $result->{sessid};
my $session_name = $result->{session_name};
$log->debug("Session id: $sessid");
$log->debug("Cookie Jar: ", $cookie_jar->as_string);

my $agent = WWW::Mechanize->new(cookie_jar => $cookie_jar);
$agent->credentials(config('http_user'), config('http_pass'));

if ($methods{'user.token'})
{
	$result = rpc("user.token");
	$log->debug("user.token: ", Dumper($result));
	my $token = $result->{token};
	my $header_name = 'X-CSRF-Token';
	$xmlrpc->transport->http_request->header($header_name => $token);
	$agent->add_header($header_name, $token);
}


sub new
{
	my ($class, %args) = @_;

	my $self = {};
	for my $arg (keys %args)
	{
		$self->{$arg} = $args{$arg};
	}

	my $nid;
	my $item_id = $self->{obj}{identifier};
	my $lang = $self->{obj}{node_lang};

	if ($item_id)
	{
		$nid = get_node_id($item_id, $lang);
	}

	if ($nid) {
		$log->debug("node[$nid] already exists for item[$item_id]");
	} else {
		$nid = create_node($self->{obj});
	}

	$self->{node} = get_node($nid);

	bless ($self, $class);
	return $self;
}


#XXX: Combine this with new()
sub new_from_nid
{
	my ($class, $nid) = @_;
	my $self = { node => get_node($nid) };
	bless ($self, $class);
	return $self;
}


sub create_node
{
	my ($obj) = @_;

	my $new_node = create_node_skeleton($obj);

	set_value($new_node, $obj);

	$log->trace("new $obj->{node_type} node: ", Dumper($new_node));

	my $result = rpc("node.create", $new_node);
	$log->debug("node.create result: ", Dumper($result));
	my $nid = $result->{nid};

	$log->info("Saved $obj->{node_type} node $nid: $new_node->{title}");
	
	return $nid;
}


sub update
{
	my ($self, $new_vals) = @_;

	my $node = {};

	my $cur_lang = $self->{node}{language};
	my $new_lang = $new_vals->{node_lang};

	my $lang;
	if ($new_lang && $new_lang ne $cur_lang) {
		$lang = $new_lang;
	} else {
		set_value($node, $new_vals, $cur_lang);
	}

	my $now = time;
	$node->{language} = $lang if $lang;
	$node->{tnid} = $new_vals->{tnid} if $new_vals->{tnid};
# 	$node->{revision} = 1;
# 	$node->{"log"} = "Updated programmatically at " . localtime($now) . ".";

	$log->trace("update $self->{node}{type} node: ", Dumper($node));

	my $result = rpc("node.update", $self->{node}{nid}, $node);
	$log->debug("node.update result: ", Dumper($result));
	my $nid = $result->{nid};

	$log->info("Updated $self->{node}{type} node $nid: $self->{node}{title}");
	return $nid;
}


sub translate
{
	my ($self, $new_vals, $new_lang) = @_;
	my $node = {};
	set_value($node, $new_vals, $new_lang);
	$log->debug("Translate values: ", Dumper($node));
	my $result = rpc("node.translate", $self->{node}{nid}, $node, $new_lang);
	$log->debug("node.translate result: ", Dumper($result));
	$log->info("Node $self->{node}{nid} translated to $new_lang");
}


sub create_node_skeleton
{
	my ($obj) = @_;
	my $now = time;
	my $lang = $obj->{node_lang} || 'und';
	my $tnid = $obj->{tnid} || 0;
	return {
		type     => $obj->{node_type},
		status   => 1,                     # Published?
		uid      => 1,
		title    => Util::trunc($obj->{title}),
		body     => '',
		created  => $now,
		changed  => $now,
# 		promote  => 0,                     # Display on front page?
# 		sticky   => 0,                     # Display top of page?
		format   => 0,                     # Filtered HTML?
		language => $lang,
		name     => config('drupal_user'),
		tnid     => $tnid,                 # Source nid for translation
	};
}


sub is_non_translatable
{
	my $field = shift;
	$non_translatable_fields{$field} || $field =~ /_ref$/;
}


sub set_value
{
	my ($node, $obj, $field_lang) = @_;

	$field_lang = $field_lang || $obj->{node_lang} || 'und';

	for my $field (sort keys %$obj)
	{
		my $lang = is_non_translatable($field) ? 'und' : $field_lang;

		my $val = $obj->{$field};
		if ($field =~ /^(node_lang|node_type|files_subdir|tnid)$/)
		{
			next;
		}
		elsif ($field =~ /^(path)$/)
		{
			$node->{$field} = { alias => $val };
		}
		# auto complete node refs
		elsif ($field =~ /^(.*)_ref$/)
		{
			my @nids = ref($val) eq "ARRAY" ? @$val : $val;
			my $data = [map { {nid => $_} } @nids];
			$node->{"field_$1"} = {
				$lang => dclone($data),
			};
		}
		elsif ($field =~ /^(subject)$/)
		{
			my $field_name = $1;
			my $terms = $val;
			create_tax_term($terms, $lang);
			my $data = join(",", @$terms) || "";
			$node->{"field_$field_name"} = {
				$lang => $data,
			};
		}
		elsif ($field =~ /_date$/)
		{
			my $date_str = $val || "";
			my ($start_date, $end_date) = split(/-/, $date_str);
			my $data = [{value => {date => $start_date}}];
			$data->[0]{value2}{date} = $end_date if $end_date;
			$node->{"field_$field"} = {
				$lang => $data,
			};
		}
		# select list
		elsif ($field =~ /^(.*)_select$/)
		{
			my @nids = ref($val) eq "ARRAY" ? @$val : $val;
			my $data = [@nids];
			$node->{"field_$1"} = {
				$lang => $data,
			};
		}
		elsif ($field =~ /^(.*)_file$/)
		{
			my @args = ($val);
			push(@args, $obj->{files_subdir}) if $obj->{files_subdir};
			my $data = [add_file(@args)];
			$node->{"field_$1"} = {
				$lang => $data,
			};
		}
		elsif ($field =~ /^(.*)_filelist$/)
		{
			my $name = $1;
			my @files = ref($val) eq "ARRAY" ? @$val : $val;
			my @fids;
			for my $file (@files)
			{
				my @args = ($file);
				push(@args, $obj->{files_subdir}) if $obj->{files_subdir};
				push(@fids, add_file(@args));
			}
			my $data = [@fids];
			$node->{"field_$name"} = {
				$lang => $data,
			};
		}
		elsif ($field =~ /^(.*)_list$/)
		{
			my $data = [ map { { value => $_ } } @$val ];
			$node->{"field_$1"} = {
				$lang => $data,
			};
		}
		elsif ($field =~ /^(.*)_fid/)
		{
			my $data = [ map { { fid => $_, display => 1 } } @$val ];
			$node->{"field_$1"} = {
				$lang => $data,
			};
		}
		else
		{
			$node->{$field} = $val if $field =~ /^(title)$/;
			$val = Util::trunc($val) if $field =~ /^subtitle$/;
			my $data = ref($val) eq "ARRAY" ? $val : [{value => $val}];
			$node->{"field_$field"} = {
				$lang => $data,
			};
		}
	}

}


sub get_node
{
	my $nodeid = shift;
	my $node = rpc("node.retrieve", $nodeid);
	utf8::encode($node->{title});
	utf8::encode($node->{path}) if $node->{path};
	$log->trace("node $nodeid: ", Dumper($node));
	return $node;
}


sub get_node_id
{
	my ($item_id, $lang) = @_;
	my $url = config('baseurl') . "/content/$item_id/nodeid";
	$url .= "/$lang" if $lang;
	$log->debug("fetching url $url");
	$agent->get($url);
	# Added these debugging lines to check if apache is
	# returning gzip compressed body
	$log->trace($agent->res->as_string());
	$log->trace($agent->content());

	my @node_id = @{from_json($agent->content())};
	if (!@node_id)
	{
		$log->debug("Couldn't find node id at $url");
		return undef;
	}
	$log->debug("nodeid $item_id: $node_id[0]");
	return $node_id[0];
}


sub get_page_nodeids
{
	my ($item_id) = @_;
	my $url = config('baseurl') . "/content/$item_id/page_nodeids";
	$log->debug("fetching url $url");
	$agent->get($url);
	my $json_text = $agent->content(); 
	$log->debug("json text: ", $json_text);
	if (!$json_text)
	{
		$log->debug("Couldn't find page node ids at $url");
		return undef;
	}
	my $node_ids = from_json($json_text);
	$log->debug(Dumper($node_ids));
	return $node_ids;
}


sub get_fault
{
	my $resp_body_xml = shift;
	my $body = XML::LibXML->load_xml(string => $resp_body_xml);
	my @fault_vals =
	  $body->findnodes('/methodResponse/fault/value/struct/member');

	my $fault_str = "";
	for my $fault_val (@fault_vals)
	{
		my $name = $fault_val->findnodes('./name')->to_literal;
		my $val  = $fault_val->findnodes('./value')->to_literal;
		$fault_str .= "$name: $val\n";
	}

	return $fault_str;

}


sub rpc
{
	my ($method, @args) = @_;
	my $num_attempts = 0;
	my $max_attempts = 5;
	while ($num_attempts < $max_attempts)
	{
		$num_attempts++;
		$FAULT_STRING = "";

		my $start_time = time;
		my $result = $xmlrpc->call($method, @args);
		my $end_time = time;

		$log->debug("xmlrpc time: ", duration_exact($end_time - $start_time));
		$log->debug("xmlrpc status: ", $xmlrpc->transport->status);
		
		if ($xmlrpc->transport->status =~ /^401/)
		{
			$FAULT_STRING .= $xmlrpc->transport->status;
		}

		my $err_str = "XMLRPC Fault (Method:$method Attempt#:$num_attempts): "
		  . $FAULT_STRING;

		if (!$FAULT_STRING)
		{
			return $result->result;
		}
		elsif ($FAULT_STRING =~ /No vocabulary with id \d+ found./)
		{
			$log->error($err_str);
			return [];
		}
		elsif ($FAULT_STRING =~ /^(2|5)00/ && $num_attempts < $max_attempts)
		{
			$log->error($err_str);
			sleep(180);
		}
		else
		{
			$log->logdie($err_str);
		}

	}
}

sub mknid
{
        my ($node) = @_;
        my $title = $node->title();
        my $nid = $node->nid();
        return "$title [nid:$nid]";
}
# sub rpc
# {
# 	my ($method, @args) = @_;
# 	my $start_time = time;
# 	my $result = $xmlrpc->call($method, @args)->result;
# 	my $end_time = time;
# 	$log->debug("xmlrpc time: ", duration_exact($end_time - $start_time));
# 	return $result;
# }


sub add_file
{
	my ($input_file, $subdir) = @_;

	# XXX should we return undef?
	if (!-f $input_file) {
		$log->logdie("$input_file does not exist.");
	}
	
	my $ext = "";
	if ($input_file =~ /\.([^.]+)$/) {
		$ext = lc($1);
	}

	my $filename = basename($input_file);
	my $filepath = "public://" . ($subdir ? "$subdir/" : "") . $filename;
	my $mimetype = mimetype($input_file);
	my $now      = time;

	my @fids;
	$fid_sth->execute($filename);
	while (my ($fid) = $fid_sth->fetchrow_array)
	{
		$log->debug("Found fid $fid for $filename.");
		push(@fids, $fid);
	}

	if (@fids)
	{
		return {fid => $fids[0]};
	}

	my ($buf, $size);
	my $fmt_regexp = config('skip_formats_regexp');
	if ($fmt_regexp && $filename =~ $fmt_regexp)
	{
		$log->debug("Will not enocde $input_file");
		my $sample = Util::get_sample($ext);
		$buf = $sample->{base64};
		$size = $sample->{size};
	}
	else
	{
		$buf = Util::encode_file($input_file);
		$size = (stat($input_file))[7];
	}

	$log->debug("Adding file $input_file (" . format_bytes($size) . ")");

	my $file = {
		file      => $buf,
		filename  => $filename,
		filepath  => $filepath,
		filemime  => $mimetype,
		filesize  => $size,
		uid       => 1,
		timestamp => $now,
	};

	$log->trace(Dumper($file));
	
	my $result = rpc("file.create", $file);
	$log->debug("file.create result: ", Dumper($result));
	my $fid = $result->{fid};

	return {
		'fid'         => $fid,
# 		'description' => $filename,
		'display'     => 1,
	};
}


sub nid
{
	my $self = shift;
	$self->{node}{nid};
}


sub title
{
	my $self = shift;
	$self->{node}{title};
}


sub get_attr
{
	my ($self, $attr) = @_;
	$self->{node}{$attr};
}


sub set_attr
{
	my ($self, $attr, $val) = @_;
	$self->{node}{$attr} = $val;
}


sub auto_nid
{
	my $self = shift;
	my $title = $self->title();
	my $nid = $self->nid();
	return "$title [nid:$nid]";
}


sub get_field
{
	my $self  = shift;
	my $field = shift;
	if (!exists($self->{node}{"field_$field"}))
	{
		return;
	}
	for my $lang (qw(en und))
	{
		if (exists($self->{node}{"field_$field"}{$lang}))
		{
			return $self->{node}{"field_$field"}{$lang}[0]{value};
		}
	}
}


# sub create_page_title
# {
# 	my ($title, $pagenum) = @_;
# 	my $max_title_length = 250;
# 
# 	my $desc = "Page $pagenum";
# 
# 	my $length_title = length($title);
# 	my $length_desc  = length($desc);
# 	my $length_total = $length_title + $length_desc + 1;
# 
# 	if ($length_total > $max_title_length)
# 	{
# 		$title =
# 		  substr($title, 0,
# 			$length_title - ($length_total - $max_title_length));
# 	}
# 
# 	return $title . " " . $desc;
# }


# Clear out drupal file registry
# XXX: move this to different module
sub clear_file_registry
{
	my $pattern = shift;
	my $dsn =
	  "DBI:mysql:database=" . config('dbname') . ';host=' . config('dbhost');
	my $dbh = DBI->connect($dsn, config('dbuser'), config('dbpass'))
	  or $log->logdie($DBI::errstr);

	my $sel_stmt = "SELECT fid FROM " . config('dbprefix') . "file_managed";
	my $del_stmt =
	  "DELETE FROM " . config('dbprefix') . "file_usage WHERE fid = ?";
	if ($pattern)
	{
		$sel_stmt .= " WHERE filename LIKE '$pattern'";
# 		$sel_stmt .= " WHERE uri LIKE '$pattern'";
	}

	my $sel = $dbh->prepare($sel_stmt) or $log->die($dbh->errstr);
	my $del = $dbh->prepare($del_stmt) or $log->die($dbh->errstr);
	$sel->execute;
	while (my ($fid) = $sel->fetchrow_array)
	{
		$log->debug("Removing $fid from file_usage table.");
		$del->execute($fid);
		$log->debug("deleting fid $fid");
		$result = rpc("file.delete", $fid);
		$log->trace("File delete result: ", Dumper($result));
# 		sleep 1;
	}
	$sel->finish;
	$del->finish;
	$dbh->disconnect;
}


# sub clear_duplicates
# {
# 	my $dsn =
# 	  "DBI:mysql:database=" . config('dbname') . ';host=' . config('dbhost');
# 	my $dbh = DBI->connect($dsn, config('dbuser'), config('dbpass'))
# 	  or $log->logdie($DBI::errstr);
# 
# 	my $sel_dups_stmt = "SELECT fid, filename FROM " . config('dbprefix') . 'file_managed WHERE uri regexp \'_[0-9]\.[[:alnum:]]{3}$\'';
# 
# 	my $sel_main_stmt = "SELECT fid, filename FROM " . config('dbprefix') . 'file_managed WHERE uri = ?';
# 
# 	my $del_stmt =
# 	  "DELETE FROM " . config('dbprefix') . "file_usage WHERE fid = ?";
# 
# 	my $update_stmt = "UPDATE " . config('dbprefix') . "field_data_field_pdf_file SET field_pdf_file_fid = ? WHERE field_pdf_file_fid = ?";
# 
# 
# 	my $sel_dups = $dbh->prepare($sel_dups_stmt) or $log->die($dbh->errstr);
# 	my $sel_main = $dbh->prepare($sel_main_stmt) or $log->die($dbh->errstr);
# 	my $del      = $dbh->prepare($del_stmt)      or $log->die($dbh->errstr);
# 
# 	$sel_dups->execute;
# 	while (my ($fid, $filename) = $sel_dups->fetchrow_array)
# 	{
# 		$sel_main->execute("public://$filename");
# 		my ($old_fid, $old_filename) = $sel_main->fetchrow_array;
# 		$log->debug("$old_fid: $old_filename");
# 
# # 		$log->debug("Removing $fid from file_usage table.");
# # 		$del->execute($fid);
# # 		$log->debug("deleting fid $fid");
# # 		$result = rpc("file.delete", $fid);
# # 		$log->trace("File delete result: ", Dumper($result));
# 		sleep 1;
# 	}
# 	$sel_dups->finish;
# 	$sel_main->finish;
# 	$del->finish;
# 	$dbh->disconnect;
# }


sub get_vocab_id
{
	my $vocab_name = shift || "subjects";
	my $vocab_id;
	my $index = rpc("taxonomy_vocabulary.index");
	$log->trace("taxonomy_vocabulary.index result: ", Dumper($index));
	for my $vocab (@$index)
	{
		if ($vocab->{machine_name} eq $vocab_name)
		{
			$vocab_id = $vocab->{vid};
			last;
		}
	}
	return $vocab_id;
}


sub create_tax_term
{
	my ($term_names, $lang) = @_;
	$lang ||= "";
	$log->debug("create_tax_term('@$term_names', '$lang')");

	my $vocab_name = "subjects";
# 	$vocab_name .= "_$lang" if $lang && $lang ne 'und';
	my $vocab_id = get_vocab_id($vocab_name);
	if (!$vocab_id)
	{
		my $result = rpc(
			"taxonomy_vocabulary.create",
			{
				machine_name => $vocab_name,
				name         => "Subjects",
				description  => "Use subject tags to group books.",
			}
		);
		$log->debug("taxonomy_vocabulary.create result: ", Dumper($result));
		$vocab_id = get_vocab_id($vocab_name);
	}
	$log->debug("Vocab id: $vocab_id");

	my $parent    = 0;
	my $max_depth = 1;
	my $vocab_tree =
	  rpc("taxonomy_vocabulary.getTree", $vocab_id, $parent, $max_depth);
	$log->trace("taxonomy_vocabulary.getTree result: ", Dumper($vocab_tree));

	my %term_id;
	for my $term (@$vocab_tree)
	{
		$term_id{$term->{name}} = $term->{tid};
	}

	for my $term_name (@$term_names)
	{
		if (!$term_id{$term_name})
		{
			my $new_term_id = rpc(
				"taxonomy_term.create",
				{
					vid  => $vocab_id,
					name => $term_name
				}
			);
			$term_id{$term_name} = $new_term_id;
			$log->debug("taxonomy_term.create result: $new_term_id");
		}
	}

}


1;
