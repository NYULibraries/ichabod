# -*- encoding : utf-8 -*-
require 'blacklight/catalog'

class CatalogController < ApplicationController
  include Blacklight::Catalog
  include Hydra::Controller::ControllerBehavior

  #add check for discoverability on collection level
  #(see https://github.com/projectblacklight/blacklight/wiki/Extending-or-Modifying-Blacklight-Search-Behavior)
  #as we are currently using older version of Blacklight, additional method couldn't be placed to search_builder class
  #So temporarily added it to the controller itself
  CatalogController.solr_search_params_logic += [:show_only_discoverable_records]

  configure_blacklight do |config|
    queryable_field_names = MetadataFields.get_queryable_fields.map do |field|
            "desc_metadata__" + field[:name].to_s + "_tesim "
    end

    config.default_solr_params = {
      :qf => queryable_field_names.join(" "),
      :qt => 'search',
      :rows => 10
    }

    # solr field configuration for search results/index views
    config.index.title_field = 'desc_metadata__title_tesim'
    config.index.display_type_field = 'has_model_ssim'


    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _tsimed_ in a page.
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.
    #
    # :show may be set to false if you don't want the facet to be drawn in the
    # facet bar

    facet_fields = MetadataFields.get_facet_fields_in_display_order
    facet_fields.each do |field|
      config.add_facet_field solr_name("desc_metadata__#{field[:name]}", :facetable),
        :label => field[:label]
    end

    # This can't be part of our new processing until this branch is merged:
    # https://github.com/NYULibraries/ichabod/tree/feature/collection_new
    config.add_facet_field 'is_part_of_ssim', :label =>  'Collection',
                                                                           :helper_method => :render_collection_links,
                                                                           :text          => 'collection_text_display'

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.default_solr_params[:'facet.field'] = config.facet_fields.keys
    # use this instead if you don't want to query facets marked :show=>false
    # config.default_solr_params[:'facet.field'] = config.facet_fields.select{ |k, v| v[:show] != false}.keys


    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    # Calls to MetadataFields.get_solr_name_opts have to be splatted below
    # because the return value is variable length.
    # Also, this has to match the upstream behavior in active_fedora:
    # https://github.com/projecthydra/active_fedora/blob/7.x-stable/lib/active_fedora/solr_service.rb#L98-L100

    search_result_fields = MetadataFields.get_search_result_fields_in_display_order
    search_result_fields.each do |field|
      if (field[:special_handling] != nil)
        config.add_index_field solr_name("desc_metadata__#{field[:name]}", *MetadataFields.get_solr_name_opts(field)),
                               :label => field[:label],
                               :helper_method => field[:special_handling][:helper_method],
                               :text          => field[:special_handling][:text]
      else
        config.add_index_field solr_name("desc_metadata__#{field[:name]}", *MetadataFields.get_solr_name_opts(field)),
                                 :label => field[:label]
      end
    end

    # solr fields to be displayed in the show (single result) view
    # The ordering of the field names is the order of the display

    detail_fields = MetadataFields.get_detail_fields_in_display_order
    detail_fields.each do |field|
      if (field[:special_handling])
        config.add_show_field solr_name("desc_metadata__#{field[:name]}", *MetadataFields.get_solr_name_opts(field)),
                               :label => field[:label],
                               :helper_method => field[:special_handling][:helper_method],
                               :text          => field[:special_handling][:text]
      else
        config.add_show_field solr_name("desc_metadata__#{field[:name]}", *MetadataFields.get_solr_name_opts(field)),
                                 :label => field[:label]
      end
    end

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.

    config.add_search_field 'all_fields', :label => 'All Fields'


    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields.

    config.add_search_field('title') do |field|
      # :solr_local_parameters will be sent using Solr LocalParams
      # syntax, as eg {! qf=$title_qf }. This is neccesary to use
      # Solr parameter de-referencing like $title_qf.
      # See: http://wiki.apache.org/solr/LocalParams
      field.solr_local_parameters = {
        :qf => '$title_qf',
        :pf => '$title_pf'
      }
    end

    config.add_search_field('author') do |field|
      field.solr_local_parameters = {
        :qf => '$author_qf',
        :pf => '$author_pf'
      }
    end

    # Specifying a :qt only to show it's possible, and so our internal automated
    # tests can test it. In this case it's the same as
    # config[:default_solr_parameters][:qt], so isn't actually neccesary.
    config.add_search_field('subject') do |field|
      field.qt = 'search'
      field.solr_local_parameters = {
        :qf => '$subject_qf',
        :pf => '$subject_pf'
      }
    end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field 'score desc, pub_date_dtsi desc, title_tesi asc', :label => 'relevance'
    config.add_sort_field 'pub_date_dtsi desc, title_tesi asc', :label => 'year'
    config.add_sort_field 'author_tesi asc, title_tesi asc', :label => 'author'
    config.add_sort_field 'title_tesi asc, pub_date_dtsi desc', :label => 'title'

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5

    #define what partials will be used to display each solr document
    config.index.partials = ['index_header','index','action_buttons']
    config.show.partials = ['show_header','show','action_buttons']

  end
end
#define what records user can discover based on his/her privillages. We get list of
#collections, which are private and show items from them only to collection editors
def show_only_discoverable_records solr_params, user_params
    solr_params[:fq] ||= []
    Collection.private_collections.each do |collection|
      if !can?(:edit, collection)
        solr_params[:fq] << '-is_part_of_ssim:'+Collection.construct_searchable_pid(collection.pid)
      end
    end
    return solr_params[:fq]
end
