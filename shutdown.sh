#!/bin/bash
# Print out process ID
echo $$
# Load up RVM
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
# Switch directory to where this script resides
cd $(dirname ${BASH_SOURCE[0]})
# Find out current ruby version
RUBY_VERSION=$(head -n 1 .ruby-version)
# Set default version
DEFAULT_RUBY_VERSION="2.1.3"
# RVM set to ruby version
rvm use ${RUBY_VERSION-$DEFAULT_RUBY_VERSION}
# Stop fedora server under RAILS_ENV taken from ps
RAILS_ENVIRONMENT=$(ps u -U $(whoami) | grep 'RubyApp' | head -1 | grep production)
if [[ $RAILS_ENVIRONMENT == *"production"* ]]
then
  bundle exec rake tomcat:shutdown
else
  bundle exec rake jetty:stop
fi
