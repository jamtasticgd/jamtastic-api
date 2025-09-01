# Contributing to Jamtastic API

Thank you for your interest in contributing to the Jamtastic API! This document provides guidelines and information for contributors.

## Development Setup

### Prerequisites

- Ruby 3.2.2
- Rails 7.0
- PostgreSQL 12
- Git

### Getting Started

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/your-username/jamtastic-api.git
   cd jamtastic-api
   ```

3. Run the setup script:
   ```bash
   bin/setup
   ```

4. Configure your environment variables in the `.env` file

## Code Style and Standards

### Ruby Style Guide

This project uses RuboCop for code style enforcement. Please ensure your code follows the established style guidelines:

```bash
bundle exec rubocop
```

Key style guidelines:
- Maximum line length: 120 characters
- Maximum method length: 12 lines
- Use `frozen_string_literal: true` at the top of files
- Prefer explicit over implicit code
- Use meaningful variable and method names

### Architecture Patterns

#### Controllers
- Keep controllers thin - delegate business logic to services
- Use the `Contractable` concern for parameter validation
- Follow RESTful conventions
- Use appropriate HTTP status codes

Example:
```ruby
class TeamsController < ApplicationController
  before_action :authenticate_user!, only: %w[create update destroy]
  contracts create: ::Teams::CreateContract, update: ::Teams::UpdateContract

  def create
    team = CreateTeam.new(user: current_user, params: contract_result.to_h).call

    if team.persisted?
      render(json: TeamsSerializer.render(team), status: :created)
    else
      render(json: Models::ErrorsSerializer.render(team), status: :unprocessable_entity)
    end
  end
end
```

#### Services
- Use service objects for complex business logic
- Keep services focused on a single responsibility
- Use dependency injection for better testability

Example:
```ruby
class CreateTeam
  def initialize(user:, params:)
    @user = user
    @params = params
  end

  def call
    # Implementation here
  end

  private

  attr_reader :user, :params
end
```

#### Contracts
- Use Dry::Validation contracts for parameter validation
- Inherit from `ApplicationContract`
- Use Portuguese (pt-BR) for error messages

Example:
```ruby
class Teams::CreateContract < ApplicationContract
  params do
    required(:name).filled(:string)
    required(:description).filled(:string)
    optional(:needed_skills).array(:string)
  end
end
```

#### Serializers
- Use Blueprinter for JSON serialization
- Keep serializers focused and reusable
- Use views for different serialization contexts

## Testing

### Running Tests

```bash
bundle exec rspec
```

### Test Guidelines

- Write tests for all new features and bug fixes
- Use FactoryBot for test data generation
- Follow the AAA pattern (Arrange, Act, Assert)
- Use descriptive test names and contexts
- Test both happy path and edge cases

Example test structure:
```ruby
RSpec.describe CreateTeam, type: :service do
  describe '#call' do
    context 'when a valid user is informed' do
      it 'creates a new team' do
        # Arrange
        user = users(:confirmed_user)
        params = { name: 'Test Team' }

        # Act
        create_team = described_class.new(user: user, params: params)
        team = create_team.call

        # Assert
        expect(team).to be_persisted
      end
    end
  end
end
```

### Test Coverage

The project uses SimpleCov for test coverage. Maintain high test coverage for new code.

## Database

### Migrations

- Use descriptive migration names
- Always include rollback instructions
- Test migrations in both directions
- Use UUIDs for primary keys

### Seeds

- Keep seed data minimal and focused
- Use fixtures for test data

## API Documentation

- Update API documentation when adding new endpoints
- Use consistent response formats
- Document error responses
- Follow the existing API patterns

## Pull Request Process

1. Create a feature branch from `main`
2. Make your changes following the style guidelines
3. Write tests for your changes
4. Ensure all tests pass
5. Run RuboCop and fix any style violations
6. Update documentation if needed
7. Submit a pull request with a clear description

### Pull Request Guidelines

- Use clear, descriptive commit messages
- Keep pull requests focused on a single feature or bug fix
- Include tests for new functionality
- Update documentation as needed
- Reference any related issues

### Commit Message Format

Use clear, descriptive commit messages:

```
Add team creation endpoint

- Implement CreateTeam service
- Add Teams::CreateContract for validation
- Add TeamsSerializer for JSON response
- Include comprehensive test coverage
```

## Issue Reporting

When reporting issues, please include:

- Clear description of the problem
- Steps to reproduce
- Expected vs actual behavior
- Environment details (Ruby version, Rails version, etc.)
- Any relevant error messages or logs

## Questions or Need Help?

- Check existing issues and pull requests
- Review the codebase for similar implementations
- Ask questions in issue comments

## Code of Conduct

Please be respectful and constructive in all interactions. We aim to create a welcoming environment for all contributors.

Thank you for contributing to Jamtastic API!
