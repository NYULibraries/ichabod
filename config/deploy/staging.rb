set :rails_env, "staging"
set(:branch, ENV["GIT_BRANCH"].gsub(/remotes\//,"").gsub(/origin\//,""))

after "deploy", "deploy:create_jetty_symlink"
