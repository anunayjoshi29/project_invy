#!/bin/sh

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi
echo "starting db migrate"
sleep 30
bin/rails db:create
rails generate after_party:install
rake db:migrate
bin/rails after_party:run
bundle exec rails s -p 3003 -b 0.0.0.0