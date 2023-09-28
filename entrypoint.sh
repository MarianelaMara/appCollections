#!/bin/bash
set -e

#if [[ $(rake database:needs_migration?) = "true" ]]; then
if [[ $SETUP_DB = "true" ]]; then
  bundle exec rake db:create db:migrate db:seed
fi
bundle exec rake assets:clean
bundle exec rake assets:precompile

# Then exec the container's main process (what's set as CMD in the Dockerfile).
rm -f tmp/pids/server.pid
exec bundle exec rails s -b 0.0.0.0 -p 3000
