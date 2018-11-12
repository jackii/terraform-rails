#! /bin/sh

./devops/docker/wait-for-service.sh
./devops/docker/prepare-db.sh
bundle exec puma -C config/puma.rb

