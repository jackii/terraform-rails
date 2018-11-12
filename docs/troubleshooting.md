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

### Docker error: OCI runtime create failed

```
ERROR: for your_app_1  Cannot start service app: OCI runtime create failed: container_linux.go:348: starting container process caused "exec: \"bundle exec puma -C config/puma.rb\": stat bundle exec puma -C config/puma.rb: no such file or directory": unknown

ERROR: for app  Cannot start service app: OCI runtime create failed: container_linux.go:348: starting container process caused "exec: \"bundle exec puma -C config/puma.rb\": stat bundle exec puma -C config/puma.rb: no such file or directory": unknown
ERROR: Encountered errors while bringing up the project.
```

__Why?__
If a string had been to the CMD, Docker would have invoked `sh` shell as a tokenizer. And there is no `sh`
in the container

__How to fix__
- Use json array in the CMD or ENTRYPOINT
    ```
    CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
    ```

