source 'https://rubygems.org'

gem 'rails', '>= 4.1.14.1', '< 4.2.0'

gem 'sqlite3', group: :development
gem 'mysql2', '~> 0.3.15'

gem 'sass-rails',   '5.0.0.beta1'
gem 'compass-rails', '~> 2.0.0'
gem 'uglifier', '~> 2.7.2'
gem 'coffee-rails', '~> 4.0.0'
gem 'therubyracer', '~> 0.12.0', platforms: :ruby
gem 'jquery-rails', '~> 3.1.3'
gem 'jquery-ui-rails', '~> 5.0.0'
gem 'jbuilder', '~> 2.1.3'
gem 'rsolr', '1.0.10'

#gem 'oai','~> 0.3.1'
gem 'oai', github: 'code4lib/ruby-oai', branch: 'master'
gem 'mustache', '0.99.4'
gem 'mustache-rails', github: 'NYULibraries/mustache-rails', require: 'mustache/railtie'

# None of these gems should be included in a real production instance.
# This entire auth process should be handled by login
gem 'authlogic', github: 'binarylogic/authlogic', ref: 'e4b2990d6282f3f7b50249b4f639631aef68b939'
gem 'exlibris-aleph', '~> 2.0', '>= 2.0.4'
gem 'authpds', github: 'barnabyalter/authpds'
gem 'authpds-nyu', github: 'barnabyalter/authpds-nyu'

gem 'nyulibraries-assets', github: 'NYULibraries/nyulibraries-assets', tag: 'v4.0.0'
# gem 'nyulibraries-assets', path: '/apps/nyulibraries-assets'
gem 'formaggio', github: 'NYULibraries/formaggio', tag: 'v1.4.2'

gem 'hydra', '~> 7.1.0'
gem 'simple_form', '~> 3.1.0.rc2'
gem 'kaminari', '~> 0.13'
gem 'sorted', '~> 1.0.0'
gem 'unicode', platforms: [:mri_18, :mri_19]
gem 'hydra-validations', '~> 0.5.0'

gem 'jettywrapper', group: [:development, :test, :staging]
gem "rack-test", require: "rack/test", group: [:development, :test]


gem 'iso-639'
gem 'faraday', '~> 0.9.0'
gem 'multi_json', '~> 1.11.1'
gem 'multi_xml', '~> 0.5.5'
gem 'smarter_csv', '~> 1.0.19'
gem "octokit", "~> 3.0"

group :development do
  gem 'better_errors', '~> 2.0.0'
  gem 'binding_of_caller'
end

group :development, :test, :cucumber do
  gem 'rspec-rails', '~> 2.14.0'
  # Phantomjs for headless browser testing
  gem 'phantomjs', '>= 1.9.0'
  gem 'poltergeist', '~> 1.6.0'
  # Use factory girl for creating models
  gem 'factory_girl_rails', '~> 4.4.0'
  # Use pry-debugger as the REPL and for debugging
  gem 'pry', '~> 0.10.1'
end

group :test, :cucumber do
  gem 'cucumber-rails', require: false
  gem 'simplecov', require: false
  gem 'simplecov-rcov', require: false
  gem 'coveralls', '~> 0.7.0', require: false
  gem 'vcr', '~> 2.9.3'
  gem 'webmock', '~> 1.19.0'
  gem 'selenium-webdriver', '~> 2.47.0'
  gem 'pickle', '~> 0.4.11'
  gem 'database_cleaner', '~> 1.3.0'
end
