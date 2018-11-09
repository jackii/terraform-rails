# Ruby on Rails

### Requirements:
- Rails 5.2.1 (latest)
- ruby 2.5.3
- postgresql
- reactjs

## Setup Ruby on Rails

1. Create new project

    ```
    rails new project_name -d postgresql --webpack=react
    ```

2. Setup database

    ```
    rails db:setup
    rails db:migrate
    ```

3. Create `index_controller.rb` to make sure Rails is running on localhost


4. Start server and visit [http://localhost:3000](http://localhost:3000)

    ```
    rails server
    ```

## Setup Docker

The docker setup is modified from the [docker-rails](https://github.com/ledermann/docker-rails/) repo.

__Features:__

- Use Alpine (ruby:2.5.3-alpine) as base image - smaller image size
- Use Multi-stage build - The idea is to first build the stuff and then copy only the resulting artefacts into the final image.
- Remove bundler cache - the cache folder, C source file and compiled object file for gems with native extensions.

  ```
  RUN rm -rf /usr/local/bundle/cache/*.gem \
    && find /usr/local/bundle/gems/ -name "*.c" -delete \
    && find /usr/local/bundle/gems/ -name "*.o" -delete
  ```

- Remove parts of the app not needed in resulting image - `node_modules/`, `tmp/cache`, `spec/`, `test/` and the `assets/` folders

  ```
  # Remove folders not needed in resulting image
  RUN rm -rf node_modules tmp/cache app/assets vendor/assets lib/assets spec
  ```

5. Add `Dockerfile`

6. Build the docker image

    ```
    docker build . -t terraform-rails
    ```

    ```
    ...
    ...
    Successfully built 04e42927d47b
    Successfully tagged terraform-rails:latest
    ```

7. Check that the image is built

    ```
    docker images
    ```

    ```
    REPOSITORY          TAG       IMAGE ID        CREATED                SIZE
    terraform-rails     latest    04e42927d47b    About a minute ago     203MB
    ```

## Docker Compose

Compose is a tool for defining and running multi-container Docker applications.

Having dockerized your rails app is not enough, the app still needs to communite with other services, at the
minimal, to a database server. Rails app contain is only one of the services.

By using Compose, you can define multiple container services and how they are linked to each other.

8. Add `docker-compose.yml`

9. Build containers

    ```
    docker-compose build
    ```

10. Check if the image is built

    ```
    docker images
    ```

    ```
    REPOSITORY          TAG        IMAGE ID         CREATED             SIZE
    terraform-rails     latest     724c9b8a43e8     32 seconds ago      203MB
    ```

11. Remember to change the database config

    ```
    # docker-compose.yml
    services:
      db:
        environment:
          - POSTGRES_PASSWORD
      ...

      app: &app_base
        ...
        ...
        environment:
          - POSTGRES_HOST=db
          - POSTGRES_PASSWORD
          - POSTGRES_USER=postgres
    ```

    ```
    # config/database.yml

    default: &default
      ...
      host: <%= ENV['POSTGRES_HOST'] %>
      username: <%= ENV['POSTGRES_USER'] %>
      password: <%= ENV['POSTGRES_PASSWORD'] %>
      ...

    ```

12. Start the containers

    ```
    docker-compose up
    ```

    To stop the containers

    ```
    docker-compose down
    ```

    To remove built images

    ```
    docker-compose clean
    ```




# Troubleshooting

### Running version of bundler is different from the version that created the Gemfile.lock

```
Warning: the running version of Bundler (1.16.6) is older than the version that created the lockfile (1.17.1).
```
__Why?__

When you are running `bundle install`, bundler will generate the bundler version in the Gemlock.lock file.

```
# Gemfile.lock
...

BUNDLED WITH
   1.17.1
```

If the bundler version on the docker environment is different from the local bundler version,
bundler will raise this warning.

__How to fix:__

- You can safely ignore this warning, or
- Use the same bundler version on localhost, or
- Use the same bundler version on docker environment


### yarn `integrity check failed`
```
Step 13/25 : RUN bundle exec rake assets:precompile
 ---> Running in 557f374f560e

========================================
  Your Yarn packages are out of date!
  Please run `yarn install` to update.
========================================

To disable this check, please add `config.webpacker.check_yarn_integrity = false`
to your Rails development config file (config/environments/development.rb).

yarn check v1.7.0
warning Integrity check: System parameters don't match
error Integrity check failed
error Found 1 errors.
info Visit https://yarnpkg.com/en/docs/cli/check for documentation about this command.

The command '/bin/sh -c bundle exec rake assets:precompile' returned a non-zero code: 1
```

__Why?__

This is caused by a config introduced in Rails 5, called `config.webpacker.check_yarn_integrity`, where
Rails will verify the versions and hashed value of the package contents in the project's package.json

If the yarn version on your local machine is different from the yarn version that the docker image installed,
(in this case, alpine v3.8), Rails will raise this error. The yarn version that docker installs is
[yarn v1.7.0](http://dl-cdn.alpinelinux.org/alpine/v3.8/community/x86_64/yarn-1.7.0-r0.apk)

__How to fix__

- Downgrade your local machine yarn's version
- (__Recommended__) Set `config.webpacker.check_yarn_integrity = false` in `config/development.rb`

### `yarn install` raises [unmet peer dependency warning](https://github.com/rails/webpacker/issues/1078)

```
warning "@rails/webpacker > postcss-cssnext@3.1.0" has unmet peer dependency "caniuse-lite@^1.0.30000697".
warning " > webpack-dev-server@2.11.2" has unmet peer dependency "webpack@^2.2.0 || ^3.0.0".
warning "webpack-dev-server > webpack-dev-middleware@1.12.2" has unmet peer dependency "webpack@^1.0.0 || ^2.0.0 || ^3.0.0".
```

Recommended [fix](https://github.com/rails/webpacker#installation) for this is to run `yarn upgrade`, but it doesn't seem to solve this error.


