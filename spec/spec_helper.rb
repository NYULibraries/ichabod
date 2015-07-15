require 'simplecov'
require 'simplecov-rcov'
require 'coveralls'

SimpleCov.merge_timeout 3600
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::RcovFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

ENV["RAILS_ENV"] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'vcr'
require 'capybara/rspec'
require 'database_cleaner'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Refresh jetty data before rspec tests run
if Rails.env.test?
  begin
    WebMock.allow_net_connect!
    Nyucore.destroy_all
    Collection.destroy_all
    Ichabod::DataLoader.new('spatial_data_repository', File.join(Rails.root, 'ingest/test_sdr.xml')).load
    Ichabod::DataLoader.new('lib_guides', File.join(Rails.root, 'ingest/test_libguides.xml')).load
    Ichabod::DataLoader.new('faculty_digital_archive_ngo','https://archive.nyu.edu/request','hdl_2451_33605',5).load
    Ichabod::DataLoader.new('nyu_press_open_access_book', 'http://discovery.dlib.nyu.edu:8080/solr3_discovery/nyupress/select','0','5').load
  ensure
    WebMock.disable_net_connect!
  end
end

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  #config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.include FactoryGirl::Syntax::Methods

  config.include SpecTestHelper, :type => :controller

  # Include ResourceSet macros
  config.include ResourceSetMacros

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  # Set a "half baked" exclusion filter for saying that the feature is not
  # ready for testing
  config.filter_run_excluding half_baked: true

  config.before(:suite) do
    # Startout by trucating all the tables
    DatabaseCleaner.clean_with :truncation
    # Then use transactions to roll back other changes
    DatabaseCleaner.strategy = :transaction

    # Run factory girl lint before the suite
    begin
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean
    end
  end

  config.around(:each) do |example|
    DatabaseCleaner.start
    example.run
    DatabaseCleaner.clean
  end
end

VCR.configure do |c|
  c.default_cassette_options = { allow_playback_repeats: true, record: :new_episodes }
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.ignore_localhost = true
  c.configure_rspec_metadata!
  c.hook_into :webmock
  c.filter_sensitive_data('user') { ENV['ICHABOD_ROSIE_USER'] }
  c.filter_sensitive_data('password') { ENV['ICHABOD_ROSIE_PASSWORD'] }
end
