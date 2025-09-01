#!/bin/bash

# Jamtastic API - Stop Development Environment
# This script stops the Rails server and cleans up processes

echo ">> Stopping Jamtastic API Development Environment"

# Stop Rails server
echo ">> Stopping Rails server..."
pkill -f "rails server" 2>/dev/null || true

# Clean up PID files
echo ">> Cleaning up process files..."
rm -f tmp/pids/server.pid 2>/dev/null || true

# Wait a moment for processes to stop
sleep 2

echo ">> Development environment stopped"
echo ">> To start again, run: ./scripts/start_dev.sh or ./scripts/dev.sh"
