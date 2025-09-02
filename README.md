[![Tests](https://github.com/jamtasticgd/jamtastic-api/actions/workflows/test.yml/badge.svg)](https://github.com/jamtasticgd/jamtastic-api/actions/workflows/test.yml)
[![Maintainability](https://qlty.sh/gh/jamtasticgd/projects/jamtastic-api/maintainability.svg)](https://qlty.sh/gh/jamtasticgd/projects/jamtastic-api)
[![Code Coverage](https://qlty.sh/gh/jamtasticgd/projects/jamtastic-api/coverage.svg)](https://qlty.sh/gh/jamtasticgd/projects/jamtastic-api)

# Jamtastic API
This project contains all API related code for jamtastic.org tools and website.

The complete endpoint documentation can be found [here](https://documenter.getpostman.com/view/2140691/2s93sW8vcf).

## Setup
This project is currently using
- Ruby 3.3
- Rails 7.0
- Postgres 12

To make the project setup, first clone the project

```zsh
git clone https://github.com/jamtasticgd/jamtastic-api.git
```

And then use run the application `setup`

```zsh
bin/setup
```

**Important** If the setup fails make sure to properly configure the `.env` file.

## Running the tests
To run the test suite, run the command

```zsh
bundle exec rspec
```
