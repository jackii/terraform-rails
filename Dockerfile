######################
# Stage: Builder
FROM ruby:2.5.3-alpine as Builder

RUN apk add --update --no-cache \
    build-base \
    postgresql-dev \
    git \
    imagemagick \
    nodejs-current \
    yarn \
    tzdata

WORKDIR /app

# Install gems
ADD Gemfile* /app/
RUN bundle config --global frozen 1 \
 && bundle install --without development test -j4 --retry 3 \
 # Remove unneeded files (cached *.gem, *.o *.c)
 && rm -rf /usr/local/bundle/cache/*/gem \
 && find /usr/local/bundle/gems/ -name "*.c" -delete \
 && find /usr/local/bundle/gems/ -name "*.o" -delete

# Install yarn packages
COPY package.json yarn.lock /app/

# Add the Rails app
ADD . /app

# Precompile assets
# This will run `yarn install ` too
RUN RAILS_ENV=production SECRET_KEY_BASE=foo bundle exec rake assets:precompile

# Remove folders not needed in resulting image
RUN rm -rf node_modules tmp/cache app/assets vendor/assets lib/assets spec

#######################
# Stage Final
FROM ruby:2.5.3-alpine

ARG EXECJS_RUNTIME

# Add Alpine packages
RUN apk add --update --no-cache \
    postgresql-client \
    imagemagick \
    tzdata \
    file

# Add user
RUN addgroup -g 1000 -S app \
 && adduser -u 1000 -S app -G app
USER app

# Copy app with gems from former build stage
COPY --from=Builder /usr/local/bundle/ /usr/local/bundle/
COPY --from=Builder --chown=app:app /app /app


# Set Rails env
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_SERVE_STATIC_FILES true
ENV EXECJS_RUNTIME Disabled

WORKDIR /app

# Expose puma port
EXPOSE 3000

# Save timestamp of image building
RUN date -u > BUILD_TIME

# Start up
CMD ["bundle exec puma -C config/puma.rb"]
