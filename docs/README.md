[![CircleCI](https://dl.circleci.com/status-badge/img/gh/jamtasticgd/jamtastic-api/tree/main.svg?style=shield)](https://dl.circleci.com/status-badge/redirect/gh/jamtasticgd/jamtastic-api/tree/main)
[![Maintainability](https://api.codeclimate.com/v1/badges/8464b62ccad16bde6805/maintainability)](https://api.codeclimate.com/github/jamtasticgd/jamtastic-api/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/8464b62ccad16bde6805/test_coverage)](https://api.codeclimate.com/github/jamtasticgd/jamtastic-api/test_coverage)

# Jamtastic API

This project contains all API related code for jamtastic.org tools and website.

The complete endpoint documentation can be found [here](https://documenter.getpostman.com/view/2140691/2s93sW8vcf).

## Tech Stack

- **Ruby**: 3.3.5 (compatible with >=3.2.2)
- **Rails**: 7.0.5
- **Database**: SQLite (development/test), PostgreSQL (production)
- **Authentication**: Devise Token Auth
- **API**: RESTful JSON API

## Quick Start

### Prerequisites

- Ruby 3.2+ (tested with 3.3.5)
- Bundler
- SQLite3 (for development)

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/jamtasticgd/jamtastic-api.git
   cd jamtastic-api
   ```

2. **Run the setup script**
   ```bash
   ./bin/setup
   ```

3. **Start the development server**
   ```bash
   ./dev.sh
   ```

The API will be available at `http://localhost:3000`

## Development Scripts

### Quick Development
```bash
./dev.sh
```
Starts the Rails server with SQLite database.

### Full Development Setup
```bash
./start_dev.sh
```
Comprehensive setup including dependency checks, database setup, and server startup.

### Stop Development Environment
```bash
./stop_dev.sh
```
Stops the Rails server and cleans up processes.

## Database Configuration

### Development & Test
- **Database**: SQLite
- **Location**: `db/development.sqlite3`, `db/test.sqlite3`
- **No additional setup required**

### Production
- **Database**: PostgreSQL
- **Configuration**: Environment variables in `.env`

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

## Project Structure

```
app/
├── controllers/          # API controllers
├── models/              # ActiveRecord models
├── serializers/         # JSON serializers
├── services/            # Business logic
├── contracts/           # Input validation
└── views/
    └── welcome/         # Custom welcome page

public/
├── logos/              # Brand logos
└── icons/              # UI icons

config/
├── routes.rb           # API routes
├── database.yml        # Database configuration
└── environments/       # Environment configs
```

## Custom Welcome Page

The API includes a custom welcome page at the root URL (`/`) featuring:
- Jamtastic logo display
- Random gradient backgrounds on each load
- Modern glassmorphism design
- Responsive layout

## Testing

Run the test suite:
```bash
bundle exec rspec
```

## Environment Configuration

The `.env` file contains development-specific settings:
- Database configuration (SQLite for development)
- Email settings (letter_opener for local development)
- CORS configuration
- Logging levels

## Troubleshooting

### Common Issues

1. **Bundle install fails**
   - Ensure Ruby 3.2+ is installed
   - Run `gem install bundler`

2. **Database connection issues**
   - For development: SQLite is used automatically
   - For production: Ensure PostgreSQL is configured

3. **Server won't start**
   - Check if port 3000 is available
   - Run `./stop_dev.sh` to clean up processes

### Getting Help

- Check the [API documentation](https://documenter.getpostman.com/view/2140691/2s93sW8vcf)
- Review the test files in `spec/` for usage examples
- Check the controller files for endpoint implementations

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Run the test suite
6. Submit a pull request

## License

This project is part of the Jamtastic ecosystem. See the main project for licensing information.