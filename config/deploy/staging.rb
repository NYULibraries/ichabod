set :rails_env, "staging"
set :branch, "master"
server "webdev3.library.nyu.edu", :app, :web, :db, :primary => true