#!/bin/bash

# Jamtastic API - Full Development Environment Setup
# This script provides comprehensive setup for the development environment

set -e

echo ">> Starting Jamtastic API Development Environment Setup"

# Check if we're in the right directory
if [ ! -f "Gemfile" ]; then
    echo ">> Error: Please run this script from the project root directory"
    exit 1
fi

# Set up Ruby environment
echo ">> Setting up Ruby environment..."
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)" 2>/dev/null || true
export PATH="$PATH:/home/deck/.local/share/gem/ruby/3.3.0/bin"

# Check Ruby version
echo ">> Checking Ruby version..."
ruby_version=$(ruby -v | cut -d' ' -f2)
echo ">> Using Ruby version: $ruby_version"

# Install dependencies if needed
echo ">> Checking dependencies..."
if ! command -v bundle &> /dev/null; then
    echo ">> Installing Bundler..."
    gem install bundler
fi

# Install gems
echo ">> Installing gems..."
bundle install

# Set up database directory
echo ">> Setting up database..."
mkdir -p db

# Run database migrations
echo ">> Running database migrations..."
bundle exec rails db:migrate

# Clean up old logs
echo ">> Cleaning up logs..."
rm -f log/development.log
rm -f log/newrelic_agent.log

# Stop any existing Rails server
echo ">> Stopping any existing Rails server..."
pkill -f "rails server" 2>/dev/null || true
rm -f tmp/pids/server.pid 2>/dev/null || true
sleep 2

# Start Rails server
echo ">> Starting Rails server..."
echo ">> Server will be available at: http://localhost:3000"
echo ">> Press Ctrl+C to stop the server"
echo ""

bundle exec rails server
