#!/bin/sh

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi
echo "starting db migrate"
sleep 5
echo $(bundle --version)
bin/rails db:create
rake db:migrate
# sleep 5000
bundle exec rails s -p 3003 -b 0.0.0.0