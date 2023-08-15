# Use the official Ruby image with version 2.4.1 as the base image
FROM --platform=linux/amd64 ruby:3.1.2-alpine
RUN apk add --update --no-cache make g++ mariadb-dev
# Set an environment variable for Rails to run in production mode
ENV RAILS_ENV=production

# Set the working directory within the container
WORKDIR /app

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile  ./

# Install dependencies using Bundler
# RUN gem install bundler && bundle install --without development test
# RUN gem install bundler -v 2.3.26
# RUN /bin/sh -c apt-get update && apt-get install libsqlite3-dev
RUN echo $(which bundle):
RUN bundle install
COPY Rakefile Rakefile
COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh
COPY . /app
ENTRYPOINT [ "docker-entrypoint.sh" ]
# Copy the rest of the application code into the container
# COPY . .

# Precompile assets (if needed)
# RUN bundle exec rake assets:precompile

# Expose the port that the Rails app will run on
EXPOSE 3003

# Start the Rails application
# CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
