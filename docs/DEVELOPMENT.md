# Development Guide

This guide provides detailed information for developers working on the Jamtastic API.

## Development Environment

### Prerequisites
- Ruby 3.2+ (currently using 3.3.5)
- Bundler
- SQLite3
- Git

### Initial Setup

1. **Clone and setup**
   ```bash
   git clone https://github.com/jamtasticgd/jamtastic-api.git
   cd jamtastic-api
   ./bin/setup
   ```

2. **Start development server**
   ```bash
   ./dev.sh
   ```

## Development Scripts

### `./dev.sh` - Quick Development
- Sets up Ruby environment
- Creates database directory
- Starts Rails server
- **Use for**: Daily development work

### `./start_dev.sh` - Full Setup
- Comprehensive environment setup
- Dependency checks
- Database migration
- Log cleanup
- Server startup
- **Use for**: First-time setup or after major changes

### `./stop_dev.sh` - Stop Environment
- Stops Rails server
- Cleans up processes
- **Use for**: Stopping development server

## Database Management

### Development Database (SQLite)
- **Location**: `db/development.sqlite3`
- **Migrations**: `bundle exec rails db:migrate`
- **Reset**: `bundle exec rails db:reset`
- **Console**: `bundle exec rails console`

### Schema
The database uses a simplified schema optimized for SQLite:
- `users` - User accounts with Devise authentication
- `teams` - Team management
- `team_members` - Team membership and approvals
- `skills` - Available skills
- `known_skills` - User skill associations
- `needed_skills` - Team skill requirements
- `companies` - Company information
- `groups` - Group management

## API Development

### Controller Structure
- **Base**: `ApplicationController < ActionController::API`
- **Welcome**: `WelcomeController < ActionController::Base` (for HTML pages)
- **Authentication**: Devise Token Auth integration

### Serializers
- Uses Blueprinter for JSON serialization
- Located in `app/serializers/`
- Consistent response format across endpoints

### Services
- Business logic separated into service objects
- Located in `app/services/`
- Examples: `CreateTeam`, `JoinTeam`, `ApproveEnrollment`

### Contracts
- Input validation using dry-validation
- Located in `app/contracts/`
- Ensures data integrity before processing

## Static Assets

### Directory Structure
```
public/
├── logos/              # Brand logos (jamtastic-white-logo.png)
└── icons/              # UI icons and small graphics
```

### Usage
- **Logos**: Company/brand assets
- **Icons**: UI elements, status indicators
- **Access**: Direct HTTP access (e.g., `/logos/logo.png`)

## Custom Welcome Page

### Features
- Random gradient backgrounds
- Jamtastic logo display
- Modern glassmorphism design
- Responsive layout

### Implementation
- **Controller**: `WelcomeController`
- **View**: `app/views/welcome/index.html.erb`
- **Route**: Root path (`/`)

## Testing

### Running Tests
```bash
# Full test suite
bundle exec rspec

# Specific test file
bundle exec rspec spec/models/user_spec.rb

# With coverage
COVERAGE=true bundle exec rspec
```

### Test Structure
- **Models**: `spec/models/`
- **Controllers**: `spec/requests/`
- **Services**: `spec/services/`
- **Serializers**: `spec/serializers/`

### Factories
- User factory with Devise integration
- Team factory with associations
- Team member factory with approval states

## Code Style

### Ruby Style
- Follow Ruby style guide
- Use RuboCop for linting
- Run `bundle exec rubocop` to check style

### Rails Conventions
- RESTful routes
- Service objects for complex logic
- Serializers for JSON responses
- Contracts for validation

## Environment Configuration

### Development Settings
```bash
# .env file
RAILS_ENV=development
RAILS_LOG_LEVEL=debug
CORS_ORIGIN=*
```

### Database Configuration
- **Development**: SQLite (no setup required)
- **Test**: SQLite (automatic)
- **Production**: PostgreSQL (configured via environment)

## Troubleshooting

### Common Issues

1. **Migration errors**
   - Reset database: `bundle exec rails db:reset`
   - Check migration files in `db/migrate/`

2. **Server won't start**
   - Check port availability: `lsof -i :3000`
   - Clean up processes: `./stop_dev.sh`

3. **Bundle issues**
   - Update gems: `bundle update`
   - Clean install: `rm -rf vendor/bundle && bundle install`

4. **Database connection**
   - Check SQLite file: `ls -la db/`
   - Verify permissions

### Debugging

1. **Rails console**
   ```bash
   bundle exec rails console
   ```

2. **Log files**
   - Development: `log/development.log`
   - Test: `log/test.log`

3. **Server logs**
   - Check terminal output when running `./dev.sh`

## Deployment Considerations

### Production Setup
- PostgreSQL database
- Environment variables configuration
- Asset compilation
- Database migrations

### Environment Variables
- `DATABASE_URL` - PostgreSQL connection
- `SECRET_KEY_BASE` - Rails secret
- `DEVISE_SECRET_KEY` - Authentication secret

## Contributing

### Workflow
1. Create feature branch
2. Make changes
3. Add tests
4. Run test suite
5. Submit pull request

### Code Review
- Ensure tests pass
- Check code style
- Verify API documentation
- Test endpoint functionality

## Resources

- [Rails API Guide](https://guides.rubyonrails.org/api_app.html)
- [Devise Token Auth](https://devise-token-auth.gitbook.io/devise-token-auth/)
- [Blueprinter](https://github.com/procore/blueprinter)
- [Dry Validation](https://dry-rb.org/gems/dry-validation/)
