# Jamtastic API - Development Makefile
# Common development tasks and shortcuts

.PHONY: help setup dev start stop test clean install

# Default target
help:
	@echo "Jamtastic API - Available Commands:"
	@echo ""
	@echo "  setup     - Full development environment setup"
	@echo "  dev       - Quick development server start"
	@echo "  start     - Full development environment start"
	@echo "  stop      - Stop development server"
	@echo "  test      - Run test suite"
	@echo "  install   - Install dependencies"
	@echo "  clean     - Clean up temporary files"
	@echo "  help      - Show this help message"
	@echo ""

# Full development environment setup
setup:
	@echo ">> Setting up development environment..."
	./bin/setup

# Quick development server start
dev:
	@echo ">> Starting development server..."
	./scripts/dev.sh

# Full development environment start
start:
	@echo ">> Starting full development environment..."
	./scripts/start_dev.sh

# Stop development server
stop:
	@echo ">> Stopping development server..."
	./scripts/stop_dev.sh

# Run test suite
test:
	@echo ">> Running test suite..."
	bundle exec rspec

# Run tests with coverage
test-coverage:
	@echo ">> Running tests with coverage..."
	COVERAGE=true bundle exec rspec

# Install dependencies
install:
	@echo ">> Installing dependencies..."
	bundle install

# Clean up temporary files
clean:
	@echo ">> Cleaning up temporary files..."
	rm -rf tmp/cache/*
	rm -rf log/*
	rm -rf public/assets/*
	rm -rf public/packs/*
	rm -rf public/packs-test/*
	rm -f tmp/pids/server.pid
	rm -f .byebug_history

# Database tasks
db-migrate:
	@echo ">> Running database migrations..."
	bundle exec rails db:migrate

db-reset:
	@echo ">> Resetting database..."
	bundle exec rails db:reset

db-seed:
	@echo ">> Seeding database..."
	bundle exec rails db:seed

# Code quality
lint:
	@echo ">> Running RuboCop..."
	bundle exec rubocop

lint-fix:
	@echo ">> Running RuboCop with auto-fix..."
	bundle exec rubocop -a

# Security
audit:
	@echo ">> Running security audit..."
	bundle exec bundle audit

# Documentation
docs:
	@echo ">> Opening documentation..."
	@echo "Documentation available in docs/ directory:"
	@echo "  - README.md: Project overview"
	@echo "  - DEVELOPMENT.md: Development guide"
	@echo "  - API.md: API documentation"
	@echo "  - DEPLOYMENT.md: Deployment guide"
	@echo "  - CONTRIBUTING.md: Contribution guidelines"
	@echo "  - CHANGELOG.md: Version history"
	@echo "  - PROJECT_STRUCTURE.md: Project structure"

# Production tasks
production-setup:
	@echo ">> Setting up production environment..."
	RAILS_ENV=production bundle install --without development test
	RAILS_ENV=production bundle exec rails db:create
	RAILS_ENV=production bundle exec rails db:migrate
	RAILS_ENV=production bundle exec rails assets:precompile

# Docker tasks
docker-build:
	@echo ">> Building Docker image..."
	docker build -t jamtastic-api .

docker-run:
	@echo ">> Running Docker container..."
	docker run -p 3000:3000 jamtastic-api

# Development shortcuts
console:
	@echo ">> Starting Rails console..."
	bundle exec rails console

routes:
	@echo ">> Showing routes..."
	bundle exec rails routes

# Quick development workflow
quick-start: install db-migrate dev

# Full development workflow
full-start: setup start
