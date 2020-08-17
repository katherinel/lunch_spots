FROM ruby:2.5.8-alpine

RUN apk add --update --no-cache \
    build-base \
    postgresql-dev \
    postgresql-client \
    nodejs \
    file \
    tzdata

WORKDIR /app

COPY Gemfile* ./
RUN gem install bundler
RUN bundle install

COPY . .

EXPOSE 3000

RUN bundle exec rake assets:precompile

CMD ["bundle", "exec", "rails", "server", "-p", "3000", "-b", "0.0.0.0"]
