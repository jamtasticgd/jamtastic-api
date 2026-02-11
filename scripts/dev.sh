#!/bin/bash

# Jamtastic API Development Environment Manager
# Usage: ./dev [start|stop|restart|status|setup]

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show usage
show_usage() {
    echo "Jamtastic API Development Environment Manager"
    echo "=============================================="
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start    - Start development environment (default)"
    echo "  stop     - Stop development environment"
    echo "  restart  - Restart development environment"
    echo "  status   - Show environment status"
    echo "  setup    - Setup environment without starting server"
    echo ""
    echo "Examples:"
    echo "  $0        # Start development environment"
    echo "  $0 start  # Start development environment"
    echo "  $0 stop   # Stop development environment"
    echo "  $0 setup  # Setup environment only"
}

# Function to check if we're in the right directory
check_project_directory() {
    if [ ! -f "Gemfile" ]; then
        print_error "Gemfile not found. Please run this script from the project root directory."
        exit 1
    fi
}

# Function to setup Ruby environment
setup_ruby_environment() {
    print_status "Setting up Ruby environment..."
    
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)" 2>/dev/null || true
    export PATH="$PATH:/home/deck/.local/share/gem/ruby/3.3.0/bin"
    
    # Check if bundle is available
    if ! command -v bundle &> /dev/null; then
        print_error "Bundler not found. Please install bundler first."
        exit 1
    fi
    
    print_success "Ruby environment configured"
}

# Function to setup environment file
setup_env_file() {
    if [ ! -f ".env" ]; then
        print_warning ".env file not found. Creating from .env.example..."
        if [ -f ".env.example" ]; then
            cp .env.example .env
            print_success ".env file created"
        else
            print_error ".env.example not found. Please create .env file manually."
            exit 1
        fi
    fi
}

# Function to setup database
setup_database() {
    print_status "Setting up SQLite database..."
    
    # Create db directory if it doesn't exist
    mkdir -p db
    
    # Test database connection
    if bundle exec rails runner "ActiveRecord::Base.connection" &>/dev/null; then
        print_success "Database connection successful"
    else
        print_warning "Database connection failed. Setting up database..."
        
        # Run migrations to create database
        print_status "Running database migrations..."
        if bundle exec rails db:migrate; then
            print_success "Database setup completed"
        else
            print_error "Database migration failed. Please check your database configuration."
            exit 1
        fi
    fi
}

# Function to install dependencies
install_dependencies() {
    print_status "Installing dependencies..."
    
    # Always install gems if vendor/bundle doesn't exist or is outdated
    if [ ! -d "vendor/bundle" ] || [ "Gemfile" -nt "vendor/bundle" ]; then
        bundle install
        print_success "Dependencies installed"
    else
        # Even if vendor/bundle exists, check if rails command is available
        if ! bundle exec rails --version &>/dev/null; then
            print_warning "Rails command not found, reinstalling dependencies..."
            bundle install
            print_success "Dependencies reinstalled"
        else
            print_success "Dependencies are up to date"
        fi
    fi
}

# Function to clear logs and temp files
clear_logs_and_temp() {
    print_status "Clearing logs and temp files..."
    bundle exec rails log:clear tmp:clear 2>/dev/null || true
}

# Function to check if Rails server is running
is_server_running() {
    pgrep -f "rails server" > /dev/null 2>&1
}

# Function to get server PID
get_server_pid() {
    pgrep -f "rails server" 2>/dev/null || echo ""
}

# Function to start development environment
start_environment() {
    echo "Starting Jamtastic API Development Environment"
    echo "=============================================="
    
    check_project_directory
    setup_ruby_environment
    setup_env_file
    install_dependencies
    setup_database
    clear_logs_and_temp
    
    print_success "Development environment ready!"
    
    echo ""
    echo ">> Starting Rails server..."
    echo "   Server will be available at: http://localhost:3000"
    echo "   Press Ctrl+C to stop the server"
    echo ""
    
    # Start the Rails server
    bundle exec rails server
}

# Function to stop development environment
stop_environment() {
    echo "Stopping Jamtastic API Development Environment"
    echo "=============================================="
    
    if is_server_running; then
        print_status "Stopping Rails server..."
        pkill -f "rails server" 2>/dev/null || true
        print_success "Rails server stopped"
    else
        print_warning "Rails server is not running"
    fi
    
    print_success "Development environment stopped!"
    echo ""
    echo ">> To start again, run: $0 start"
}

# Function to restart development environment
restart_environment() {
    echo "Restarting Jamtastic API Development Environment"
    echo "================================================"
    
    stop_environment
    sleep 2
    start_environment
}

# Function to show environment status
show_status() {
    echo "Jamtastic API Development Environment Status"
    echo "============================================"
    
    if is_server_running; then
        local pid=$(get_server_pid)
        print_success "Rails server is running (PID: $pid)"
        echo "   Server should be available at: http://localhost:3000"
    else
        print_warning "Rails server is not running"
    fi
    
    # Check if .env file exists
    if [ -f ".env" ]; then
        print_success ".env file exists"
    else
        print_warning ".env file not found"
    fi
    
    # Check if database exists
    if [ -f "db/development.sqlite3" ]; then
        print_success "Database file exists"
    else
        print_warning "Database file not found"
    fi
    
    # Check if dependencies are installed
    if [ -d "vendor/bundle" ]; then
        print_success "Dependencies are installed"
    else
        print_warning "Dependencies not installed"
    fi
}

# Function to setup environment without starting server
setup_environment() {
    echo "Setting up Jamtastic API Development Environment"
    echo "==============================================="
    
    check_project_directory
    setup_ruby_environment
    setup_env_file
    install_dependencies
    setup_database
    clear_logs_and_temp
    
    print_success "Development environment setup completed!"
    echo ""
    echo ">> To start the server, run: $0 start"
}

# Main script logic
COMMAND=${1:-start}

case $COMMAND in
    start)
        start_environment
        ;;
    stop)
        stop_environment
        ;;
    restart)
        restart_environment
        ;;
    status)
        show_status
        ;;
    setup)
        setup_environment
        ;;
    help|--help|-h)
        show_usage
        ;;
    *)
        print_error "Unknown command: $COMMAND"
        echo ""
        show_usage
        exit 1
        ;;
esac
