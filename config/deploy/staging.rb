set :rails_env, "staging"
set(:branch, ENV["GIT_BRANCH"].gsub(/remotes\//,"").gsub(/origin\//,""))

before "deploy", "jetty:stop"
before "deploy", "jetty:start"
# after "deploy", "deploy:create_jetty_symlink", "jetty:start"
