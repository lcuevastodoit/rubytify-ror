FROM ruby:2.7.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs postgresql-client
RUN mkdir /myapp
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY . /myapp
RUN gem install bundler
RUN bundle install