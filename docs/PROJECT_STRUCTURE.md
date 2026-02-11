# Project Structure

This document describes the organization and structure of the Jamtastic API project.

## Directory Overview

```
jamtastic-api/
├── app/                    # Application code
├── bin/                    # Executable scripts
├── config/                 # Configuration files
├── db/                     # Database files and migrations
├── docs/                   # Documentation
├── log/                    # Application logs
├── public/                 # Static assets
├── scripts/                # Development scripts
├── spec/                   # Test files
├── tmp/                    # Temporary files
├── vendor/                 # Dependencies
├── .env                    # Environment variables
├── .gitignore              # Git ignore rules
├── config.ru               # Rack configuration
├── Dockerfile              # Docker configuration
├── fly.toml                # Fly.io configuration
├── Gemfile                 # Ruby dependencies
├── Gemfile.lock            # Locked dependency versions
├── README.md               # Project overview
└── Rakefile                # Rake tasks
```

## Application Code (`app/`)

### Controllers (`app/controllers/`)
- `application_controller.rb` - Base API controller
- `welcome_controller.rb` - Custom welcome page controller
- `companies_controller.rb` - Company management
- `groups_controller.rb` - Group management
- `skills_controller.rb` - Skill management
- `teams_controller.rb` - Team management
- `teams/enrollments_controller.rb` - Team enrollment management
- `teams/enrollments/approvals_controller.rb` - Enrollment approval
- `users/` - User authentication controllers (Devise)

### Models (`app/models/`)
- `application_record.rb` - Base model class
- `user.rb` - User model with Devise authentication
- `team.rb` - Team model
- `team_member.rb` - Team membership model
- `skill.rb` - Skill model
- `known_skill.rb` - User-skill association
- `needed_skill.rb` - Team-skill requirement
- `company.rb` - Company model
- `group.rb` - Group model

### Serializers (`app/serializers/`)
- `companies_serializer.rb` - Company JSON serialization
- `groups_serializer.rb` - Group JSON serialization
- `skills_serializer.rb` - Skill JSON serialization
- `teams_serializer.rb` - Team JSON serialization
- `users_serializer.rb` - User JSON serialization
- `enrollments_serializer.rb` - Enrollment JSON serialization
- `error_serializer.rb` - Error response serialization
- `contracts/` - Contract error serialization
- `models/` - Model error serialization

### Services (`app/services/`)
- `create_team.rb` - Team creation business logic
- `update_team.rb` - Team update business logic
- `join_team.rb` - Team joining business logic
- `approve_enrollment.rb` - Enrollment approval logic
- `remove_enrollment.rb` - Enrollment removal logic

### Contracts (`app/contracts/`)
- `application_contract.rb` - Base contract class
- `companies/create_contract.rb` - Company creation validation
- `groups/update_contract.rb` - Group update validation
- `teams/create_contract.rb` - Team creation validation
- `teams/update_contract.rb` - Team update validation
- `teams/enrollments/` - Enrollment validation contracts

### Views (`app/views/`)
- `welcome/index.html.erb` - Custom welcome page
- `devise/` - Devise authentication views

### Other App Directories
- `concerns/` - Shared concerns and modules
- `errors/` - Custom error classes
- `helpers/` - View helpers
- `jobs/` - Background jobs
- `mailers/` - Email templates

## Configuration (`config/`)

### Main Configuration
- `application.rb` - Application configuration
- `boot.rb` - Boot configuration
- `environment.rb` - Environment setup
- `routes.rb` - URL routing
- `database.yml` - Database configuration
- `puma.rb` - Web server configuration
- `storage.yml` - File storage configuration

### Environment-Specific
- `environments/development.rb` - Development settings
- `environments/production.rb` - Production settings
- `environments/staging.rb` - Staging settings
- `environments/test.rb` - Test settings

### Initializers (`config/initializers/`)
- `application_controller_renderer.rb` - Controller rendering
- `cors.rb` - Cross-origin resource sharing
- `devise.rb` - Authentication configuration
- `devise_token_auth.rb` - Token authentication
- `sentry.rb` - Error tracking
- Other Rails initializers

### Localization (`config/locales/`)
- `pt-BR.yml` - Portuguese (Brazil) translations
- `api.pt-BR.yml` - API-specific translations
- `devise.pt-BR.yml` - Authentication translations
- `dry-errors.yml` - Validation error translations
- `models/` - Model-specific translations

## Database (`db/`)

- `development.sqlite3` - Development database
- `schema.rb` - Database schema
- `seeds.rb` - Seed data
- `migrate/` - Database migrations
  - `20250901103702_create_basic_tables.rb` - Main schema migration

## Documentation (`docs/`)

- `README.md` - Detailed project overview
- `DEVELOPMENT.md` - Development guide
- `API.md` - API documentation
- `DEPLOYMENT.md` - Deployment guide
- `CONTRIBUTING.md` - Contribution guidelines
- `CHANGELOG.md` - Version history
- `PROJECT_STRUCTURE.md` - This file

## Development Scripts (`scripts/`)

- `dev.sh` - Quick development server start
- `start_dev.sh` - Full development environment setup
- `stop_dev.sh` - Stop development server

## Static Assets (`public/`)

- `logos/` - Brand logos
  - `jamtastic-white-logo.png` - Main logo
- `icons/` - UI icons and small graphics

## Testing (`spec/`)

### Test Structure
- `rails_helper.rb` - Test configuration
- `spec_helper.rb` - Test setup
- `factories/` - Test data factories
- `fixtures/` - Test fixtures
- `models/` - Model tests
- `requests/` - Controller/API tests
- `serializers/` - Serializer tests
- `services/` - Service tests

### Test Files
- `factories/user.rb` - User factory
- `factories/team.rb` - Team factory
- `factories/team_member.rb` - Team member factory
- `requests/api/` - API endpoint tests
- `requests/welcome_spec.rb` - Welcome page tests
- `services/` - Service object tests

## Temporary Files (`tmp/`)

- `cache/` - Application cache
- `pids/` - Process ID files
- `sockets/` - Unix sockets
- `restart.txt` - Restart trigger

## Dependencies (`vendor/`)

- `bundle/` - Bundler-managed gems
- Ruby version-specific gem installations

## Key Files

### Root Level
- `Gemfile` - Ruby dependencies
- `Gemfile.lock` - Locked dependency versions
- `.env` - Environment variables
- `.gitignore` - Git ignore rules
- `config.ru` - Rack configuration
- `Dockerfile` - Docker configuration
- `fly.toml` - Fly.io deployment configuration

### Configuration
- `config/database.yml` - Database connections
- `config/routes.rb` - URL routing
- `config/application.rb` - Application settings

## File Naming Conventions

### Controllers
- `snake_case.rb` - Standard Rails convention
- Namespaced controllers in subdirectories

### Models
- `snake_case.rb` - Standard Rails convention
- Singular names for models

### Services
- `snake_case.rb` - Descriptive action names
- Examples: `create_team.rb`, `approve_enrollment.rb`

### Contracts
- `snake_case.rb` - Validation contracts
- Organized by resource and action

### Serializers
- `snake_case.rb` - JSON serialization
- Resource-specific serializers

### Tests
- `snake_case_spec.rb` - RSpec convention
- Organized by type (models, requests, services)

## Asset Organization

### Logos
- Location: `public/logos/`
- Purpose: Brand assets, company logos
- Format: PNG, SVG preferred

### Icons
- Location: `public/icons/`
- Purpose: UI elements, status indicators
- Format: PNG, SVG, ICO

## Development Workflow

1. **Setup**: Use `./scripts/start_dev.sh` for full setup
2. **Daily Development**: Use `./scripts/dev.sh` for quick start
3. **Testing**: Run `bundle exec rspec`
4. **Documentation**: Update files in `docs/` directory
5. **Deployment**: Follow `docs/DEPLOYMENT.md`

## Best Practices

### Code Organization
- Keep controllers thin, use services for business logic
- Use contracts for input validation
- Use serializers for consistent JSON output
- Organize related functionality in namespaces

### File Management
- Use descriptive file names
- Follow Rails conventions
- Keep related files together
- Document complex functionality

### Testing
- Write tests for new functionality
- Use factories for test data
- Test both success and failure cases
- Maintain good test coverage
