FROM ruby:2.6.4-alpine

RUN apk add --update --no-cache \
    build-base \
    postgresql-client \
    git \
    file \
    tzdata

WORKDIR /app

COPY Gemfile* ./
RUN gem install bundler
RUN bundle install

COPY . .

EXPOSE 3000

# Precompile assets
# RUN RAILS_ENV=production SECRET_KEY_BASE=foo bundle exec rake assets:precompile

CMD ["bundle", "exec", "rails", "server", "-p", "3000", "-b", "0.0.0.0"]
