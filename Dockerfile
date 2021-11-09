FROM ruby:2.7.2

LABEL maintainer="Wilkinson Da Rolt de Souza"

RUN apt-get update
RUN apt-get install -qq -y --no-install-recommends apt-utils build-essential

RUN mkdir /app

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

CMD bundle exec rails s -p ${PORT} -b '0.0.0.0'
