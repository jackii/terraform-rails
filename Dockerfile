######################
# Stage: Builder
FROM ruby:2.5.3-alpine as Builder

ARG RAILS_ENV
ARG NODE_ENV

ENV RAILS_ENV ${RAILS_ENV}
ENV NODE_ENV ${NODE_ENV}

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
 && bundle install -j4 --retry 3 \
 # Remove unneeded files (cached *.gem, *.o *.c)
 && rm -rf /usr/local/bundle/cache/*/gem \
 && find /usr/local/bundle/gems/ -name "*.c" -delete \
 && find /usr/local/bundle/gems/ -name "*.o" -delete

# Install yarn packages
COPY package.json yarn.lock /app/
RUN yarn install

# Add the Rails app
ADD . /app

# Precompile assets
RUN bundle exec rake assets:precompile

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
ENV EXECJS_RUNTIME $EXECJS_RUNTIME

WORKDIR /app

# Expose puma port
EXPOSE 3000

# Save timestamp of image building
RUN date -u > BUILD_TIME

# Start up
CMD ["bundle exec puma -C config/puma.rb"]
