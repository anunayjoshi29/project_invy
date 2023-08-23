FROM --platform=linux/amd64 ruby:3.1.2-alpine
RUN apk add --update --no-cache make g++ mariadb-dev
# Set an environment variable for Rails to run in production mode
ENV RAILS_ENV=production

# Set the working directory within the container
WORKDIR /app

COPY Gemfile  ./

RUN echo $(which bundle):
RUN bundle install
COPY Rakefile Rakefile
COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh
COPY . /app
ENTRYPOINT [ "docker-entrypoint.sh" ]

# Precompile assets (if needed)
# RUN bundle exec rake assets:precompile

# Expose the port that the Rails app will run on
EXPOSE 3003

