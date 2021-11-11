FROM ruby:2.7.4-alpine3.13 as bundle-gems
WORKDIR /src
RUN apk --update --no-cache add bash git g++ make postgresql-client postgresql-dev tzdata
RUN bundle config set path 'vendor/bundle'
COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs "$(nproc)"

FROM ruby:2.7.4-alpine3.13 as release
WORKDIR /src
LABEL maintainer="Jamtastic"
RUN apk --update --no-cache add postgresql-client tzdata
RUN bundle config set path 'vendor/bundle'
COPY . .
COPY --from=bundle-gems src/vendor/bundle/ vendor/bundle/

FROM release as development
RUN apk --update --no-cache add bash
CMD ["bundle", "exec", "rails", "s", "-p", ${PORT}, "-b", "'0.0.0.0'"]
