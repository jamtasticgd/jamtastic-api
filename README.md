# Jamtastic API

[![CircleCI](https://dl.circleci.com/status-badge/img/gh/jamtasticgd/jamtastic-api/tree/main.svg?style=shield)](https://dl.circleci.com/status-badge/redirect/gh/jamtasticgd/jamtastic-api/tree/main)
[![Maintainability](https://api.codeclimate.com/v1/badges/8464b62ccad16bde6805/maintainability)](https://api.codeclimate.com/github/jamtasticgd/jamtastic-api/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/8464b62ccad16bde6805/test_coverage)](https://api.codeclimate.com/github/jamtasticgd/jamtastic-api/test_coverage)

A RESTful JSON API for team management, skill tracking, and user authentication built with Rails 7.0.

## Quick Start

```bash
# Clone and setup
git clone https://github.com/jamtasticgd/jamtastic-api.git
cd jamtastic-api
./bin/setup

# Start development server
./scripts/dev.sh
```

The API will be available at `http://localhost:3000`

## Documentation

- **[Development Guide](docs/DEVELOPMENT.md)** - Complete development setup and workflow
- **[API Documentation](docs/API.md)** - Endpoint reference and usage examples
- **[Deployment Guide](docs/DEPLOYMENT.md)** - Production deployment instructions
- **[Contributing Guide](docs/CONTRIBUTING.md)** - How to contribute to the project
- **[Changelog](docs/CHANGELOG.md)** - Version history and changes

## Tech Stack

- **Ruby**: 3.3.5 (compatible with >=3.2.2)
- **Rails**: 7.0.5
- **Database**: SQLite (development/test), PostgreSQL (production)
- **Authentication**: Devise Token Auth
- **API**: RESTful JSON API

## Development Scripts

- `./scripts/dev.sh` - Quick development server start
- `./scripts/start_dev.sh` - Full development environment setup
- `./scripts/stop_dev.sh` - Stop development server

### Using Make Commands

```bash
make help          # Show available commands
make setup         # Full development setup
make dev           # Quick development start
make test          # Run test suite
make clean         # Clean temporary files
```

## Project Structure

```
├── app/                    # Application code
│   ├── controllers/        # API controllers
│   ├── models/            # ActiveRecord models
│   ├── serializers/       # JSON serializers
│   ├── services/          # Business logic
│   ├── contracts/         # Input validation
│   └── views/             # HTML views
├── config/                # Configuration files
├── db/                    # Database files and migrations
├── docs/                  # Documentation
├── public/                # Static assets
│   ├── logos/            # Brand logos
│   └── icons/            # UI icons
├── scripts/               # Development scripts
├── Makefile              # Development shortcuts
├── spec/                  # Test files
└── vendor/                # Dependencies
```

## API Endpoints

### Authentication
- `POST /users` - User registration
- `POST /users/sign_in` - User login
- `DELETE /users/sign_out` - User logout

### Core Resources
- `GET /skills` - List available skills
- `GET /teams` - List teams
- `POST /teams` - Create team
- `GET /teams/:id` - Get team details
- `PUT /teams/:id` - Update team
- `DELETE /teams/:id` - Delete team

### Team Management
- `POST /teams/:id/enrollments` - Join team
- `DELETE /teams/:id/enrollments` - Leave team
- `POST /teams/:id/enrollments/:id/approvals` - Approve enrollment

## Testing

```bash
# Run test suite
bundle exec rspec

# Run with coverage
COVERAGE=true bundle exec rspec
```

## License

This project is part of the Jamtastic ecosystem. See the main project for licensing information.

## Support

- Check the [API documentation](https://documenter.getpostman.com/view/2140691/2s93sW8vcf)
- Review the [development guide](docs/DEVELOPMENT.md)
- Open an issue for bugs or feature requests