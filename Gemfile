source 'https://rubygems.org'
source 'http://gems.github.com'

gem 'rails', '~> 4.1.6'

gem 'sqlite3', group: :development
gem 'mysql2', '~> 0.3.15'

gem 'sass-rails',   '>= 5.0.0.beta1'
gem 'compass-rails', '~> 2.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'therubyracer', '~> 0.12.0', platforms: :ruby
gem 'jquery-rails', '~> 3.1.0'
gem 'jquery-ui-rails', '~> 5.0.0'
gem 'jbuilder', '~> 2.1.3'

gem 'mustache', '0.99.4'
gem 'mustache-rails', github: 'josh/mustache-rails', require: 'mustache/railtie'

gem 'exlibris-aleph', github: 'barnabyalter/exlibris-aleph'
gem 'authpds', github: 'barnabyalter/authpds'
gem 'authpds-nyu', github: 'barnabyalter/authpds-nyu'

gem 'nyulibraries-assets', github: 'NYULibraries/nyulibraries-assets', branch: 'development-bootstrap3'
# gem 'nyulibraries-assets', path: '/apps/nyulibraries-assets'
gem 'nyulibraries-deploy', github: 'NYULibraries/nyulibraries-deploy', branch: 'development-fig'

gem 'hydra', '~> 7.1.0'
gem 'simple_form', '~> 3.0.2'
gem 'kaminari', '~> 0.13'
gem 'sorted', '~> 1.0.0'
gem 'unicode', platforms: [:mri_18, :mri_19]

gem 'jettywrapper', group: [:development, :test, :staging]

gem 'faraday', '~> 0.9.0'
gem 'multi_json', '~> 1.10.1'
gem 'multi_xml', '~> 0.5.5'

group :development do
  gem 'better_errors', '~> 2.0.0'
  gem 'binding_of_caller'
  # Use pry-debugger as the REPL and for debugging
  gem 'pry-debugger', '~> 0.2.2'
end

group :development, :test, :cucumber do
  gem 'rspec-rails', '~> 2.14.0'
  # Phantomjs for headless browser testing
  gem 'phantomjs', '>= 1.9.0'
  gem 'poltergeist', '~> 1.5.0'
  # Use factory girl for creating models
  gem 'factory_girl_rails', '~> 4.4.0'
end

group :test, :cucumber do
  gem 'cucumber-rails', require: false
  gem 'simplecov', require: false
  gem 'simplecov-rcov', require: false
  gem 'coveralls', '~> 0.7.0', require: false
  gem 'vcr', '~> 2.8.0'
  gem 'webmock', '>= 1.8.0', '< 1.16'
  gem 'selenium-webdriver', '~> 2.41.0'
  gem 'pickle', '~> 0.4.11'
  gem 'database_cleaner', '~> 1.2.0'
end
