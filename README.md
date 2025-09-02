[![CircleCI](https://dl.circleci.com/status-badge/img/gh/jamtasticgd/jamtastic-api/tree/main.svg?style=shield)](https://dl.circleci.com/status-badge/redirect/gh/jamtasticgd/jamtastic-api/tree/main)
[![Maintainability](https://qlty.sh/gh/jamtasticgd/projects/jamtastic-api/maintainability.svg)](https://qlty.sh/gh/jamtasticgd/projects/jamtastic-api)
[![Test Coverage](https://api.codeclimate.com/v1/badges/8464b62ccad16bde6805/test_coverage)](https://codeclimate.com/github/jamtasticgd/jamtastic-api/test_coverage)
# Jamtastic API
This project contains all API related code for jamtastic.org tools and website.

The complete endpoint documentation can be found [here](https://documenter.getpostman.com/view/2140691/2s93sW8vcf).

## Setup
This project is currently using
- Ruby 3.2
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
