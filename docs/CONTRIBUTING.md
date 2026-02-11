# Contributing to Jamtastic API

Thank you for your interest in contributing to the Jamtastic API! This document provides guidelines and information for contributors.

## Getting Started

### Prerequisites
- Ruby 3.2+ (tested with 3.3.5)
- Git
- Basic knowledge of Rails and RESTful APIs

### Development Setup
1. Fork the repository
2. Clone your fork: `git clone https://github.com/yourusername/jamtastic-api.git`
3. Set up the development environment: `./bin/setup`
4. Start the development server: `./dev.sh`

## Development Workflow

### Branch Naming
Use descriptive branch names:
- `feature/user-authentication-improvements`
- `fix/team-creation-validation`
- `docs/api-endpoint-documentation`

### Commit Messages
Follow conventional commit format:
- `feat: add user profile endpoint`
- `fix: resolve team member validation issue`
- `docs: update API documentation`
- `test: add tests for team creation`

### Code Style
- Follow Ruby style guide
- Use RuboCop for linting: `bundle exec rubocop`
- Write clear, self-documenting code
- Add comments for complex logic

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

### Writing Tests
- Write tests for new functionality
- Ensure existing tests still pass
- Use descriptive test names
- Follow the existing test patterns

### Test Structure
- **Models**: Test validations, associations, and methods
- **Controllers**: Test request/response cycles
- **Services**: Test business logic
- **Serializers**: Test JSON output format

## API Development

### Adding New Endpoints
1. Create controller in `app/controllers/`
2. Add routes in `config/routes.rb`
3. Create serializer in `app/serializers/`
4. Add validation contract in `app/contracts/`
5. Write tests in `spec/requests/`
6. Update API documentation

### Controller Guidelines
- Inherit from `ApplicationController` for API endpoints
- Use proper HTTP status codes
- Handle errors gracefully
- Keep controllers thin (use services for business logic)

### Serializer Guidelines
- Use Blueprinter for consistent JSON format
- Include only necessary fields
- Handle associations appropriately
- Maintain backward compatibility

## Documentation

### Code Documentation
- Document complex methods
- Add inline comments for business logic
- Keep README.md updated
- Update API documentation for new endpoints

### Documentation Files
- `README.md` - Project overview and setup
- `DEVELOPMENT.md` - Development guide
- `API.md` - API documentation
- `DEPLOYMENT.md` - Production deployment
- `CHANGELOG.md` - Version history

## Pull Request Process

### Before Submitting
1. Ensure all tests pass
2. Run RuboCop and fix any issues
3. Update documentation if needed
4. Test your changes thoroughly

### Pull Request Template
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tests pass
- [ ] New tests added
- [ ] Manual testing completed

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] Changelog updated
```

### Review Process
1. Automated tests must pass
2. Code review by maintainers
3. Documentation review
4. Final approval and merge

## Issue Reporting

### Bug Reports
Include the following information:
- Clear description of the issue
- Steps to reproduce
- Expected vs actual behavior
- Environment details (Ruby version, OS, etc.)
- Relevant logs or error messages

### Feature Requests
- Clear description of the feature
- Use case and motivation
- Proposed implementation (if applicable)
- Consideration of breaking changes

## Code of Conduct

### Our Standards
- Be respectful and inclusive
- Focus on constructive feedback
- Help others learn and grow
- Maintain a welcoming environment

### Unacceptable Behavior
- Harassment or discrimination
- Trolling or inflammatory comments
- Personal attacks
- Spam or off-topic discussions

## Development Environment

### Scripts
- `./dev.sh` - Quick development server start
- `./start_dev.sh` - Full development setup
- `./stop_dev.sh` - Stop development server

### Database
- Development uses SQLite
- Run migrations: `bundle exec rails db:migrate`
- Reset database: `bundle exec rails db:reset`

### Dependencies
- Update gems: `bundle update`
- Install new gems: `bundle install`
- Check for vulnerabilities: `bundle audit`

## Release Process

### Versioning
- Follow semantic versioning (MAJOR.MINOR.PATCH)
- Update version in appropriate files
- Tag releases in Git
- Update CHANGELOG.md

### Release Checklist
- [ ] All tests pass
- [ ] Documentation updated
- [ ] Changelog updated
- [ ] Version bumped
- [ ] Tagged in Git
- [ ] Deployed to production

## Getting Help

### Resources
- Check existing documentation
- Review test files for examples
- Look at similar implementations
- Ask questions in issues or discussions

### Community
- GitHub Issues for bug reports
- GitHub Discussions for questions
- Pull requests for contributions
- Code reviews for feedback

## License

By contributing to this project, you agree that your contributions will be licensed under the same license as the project.

## Recognition

Contributors will be recognized in:
- CHANGELOG.md
- Release notes
- Project documentation
- GitHub contributors list

Thank you for contributing to the Jamtastic API!