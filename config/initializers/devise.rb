 Devise.setup do |config|
   config.mailer_sender = 'no-reply@library.nyu.edu'
   require 'devise/orm/active_record'
   config.secret_key = ENV['SECRET_KEY_BASE']
   config.strip_whitespace_keys = [ :email ]
   config.skip_session_storage = [:http_auth]
   config.stretches = Rails.env.test? ? 1 : 10
