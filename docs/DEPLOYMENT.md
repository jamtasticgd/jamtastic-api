# Deployment Guide

This guide covers deploying the Jamtastic API to production environments.

## Production Requirements

### System Requirements
- **Ruby**: 3.2+ (tested with 3.3.5)
- **Rails**: 7.0.5
- **Database**: PostgreSQL 12+
- **Web Server**: Nginx or Apache
- **Application Server**: Puma
- **Memory**: Minimum 512MB RAM
- **Storage**: Minimum 1GB disk space

### Environment Variables

Create a `.env` file with the following production variables:

```bash
# Database
DATABASE_URL=postgresql://username:password@localhost:5432/jamtastic_production
POSTGRES_USER=your_db_user
POSTGRES_PASSWORD=your_db_password
POSTGRES_HOST=localhost
POSTGRES_PORT=5432
POSTGRES_PROD_NAME=jamtastic_production

# Rails
RAILS_ENV=production
RAILS_LOG_LEVEL=info
SECRET_KEY_BASE=your_secret_key_base
DEVISE_SECRET_KEY=your_devise_secret_key

# Email (Production SMTP)
EMAIL_ADDRESS=smtp.yourdomain.com
EMAIL_PORT=587
EMAIL_USER_NAME=your_smtp_user
EMAIL_PASSWORD=your_smtp_password
EMAIL_AUTHENTICATION=plain
EMAIL_AUTO_STARTTLS=true

# Monitoring
NEW_RELIC_LICENSE_KEY=your_newrelic_key
NEW_RELIC_APP_NAME=Jamtastic API (Production)
SENTRY_DSN=your_sentry_dsn

# CORS
CORS_ORIGIN=https://yourdomain.com
```

## Database Setup

### PostgreSQL Installation

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
```

**CentOS/RHEL:**
```bash
sudo yum install postgresql-server postgresql-contrib
sudo postgresql-setup initdb
```

### Database Configuration

1. **Create database user**
```bash
sudo -u postgres createuser --interactive
# Enter username: jamtastic
# Enter role: y
# Enter superuser: n
# Enter create databases: y
# Enter create roles: n
```

2. **Create database**
```bash
sudo -u postgres createdb jamtastic_production
```

3. **Set password**
```bash
sudo -u postgres psql
ALTER USER jamtastic PASSWORD 'your_secure_password';
\q
```

## Application Deployment

### 1. Clone Repository
```bash
git clone https://github.com/jamtasticgd/jamtastic-api.git
cd jamtastic-api
```

### 2. Install Dependencies
```bash
# Install Ruby (using rbenv)
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
rbenv install 3.3.5
rbenv global 3.3.5

# Install gems
gem install bundler
bundle install --deployment --without development test
```

### 3. Database Migration
```bash
RAILS_ENV=production bundle exec rails db:create
RAILS_ENV=production bundle exec rails db:migrate
```

### 4. Asset Compilation
```bash
RAILS_ENV=production bundle exec rails assets:precompile
```

### 5. Create Systemd Service

Create `/etc/systemd/system/jamtastic-api.service`:

```ini
[Unit]
Description=Jamtastic API
After=network.target

[Service]
Type=simple
User=deploy
WorkingDirectory=/path/to/jamtastic-api
Environment=RAILS_ENV=production
ExecStart=/path/to/jamtastic-api/bin/puma -C config/puma.rb
ExecReload=/bin/kill -USR1 $MAINPID
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

### 6. Start Service
```bash
sudo systemctl daemon-reload
sudo systemctl enable jamtastic-api
sudo systemctl start jamtastic-api
```

## Web Server Configuration

### Nginx Configuration

Create `/etc/nginx/sites-available/jamtastic-api`:

```nginx
upstream jamtastic_api {
    server unix:///path/to/jamtastic-api/tmp/puma.sock;
}

server {
    listen 80;
    server_name yourdomain.com;

    root /path/to/jamtastic-api/public;
    index index.html;

    # Static assets
    location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # API requests
    location / {
        try_files $uri @app;
    }

    location @app {
        proxy_pass http://jamtastic_api;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Enable the site:
```bash
sudo ln -s /etc/nginx/sites-available/jamtastic-api /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

## SSL Configuration

### Using Let's Encrypt
```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d yourdomain.com
```

## Monitoring

### Log Management

**Application Logs:**
```bash
sudo journalctl -u jamtastic-api -f
```

**Nginx Logs:**
```bash
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

### Health Checks

Create a health check endpoint in your application:

```ruby
# app/controllers/health_controller.rb
class HealthController < ApplicationController
  def index
    render json: { status: 'ok', timestamp: Time.current }
  end
end
```

Add to routes:
```ruby
get '/health', to: 'health#index'
```

### Monitoring Setup

1. **New Relic** - Application performance monitoring
2. **Sentry** - Error tracking and reporting
3. **Log aggregation** - Consider ELK stack or similar

## Backup Strategy

### Database Backups
```bash
# Daily backup script
#!/bin/bash
pg_dump jamtastic_production > /backups/jamtastic_$(date +%Y%m%d).sql
```

### Application Backups
```bash
# Backup application code
tar -czf /backups/jamtastic-app-$(date +%Y%m%d).tar.gz /path/to/jamtastic-api
```

## Security Considerations

### Firewall Configuration
```bash
# Allow only necessary ports
sudo ufw allow 22    # SSH
sudo ufw allow 80    # HTTP
sudo ufw allow 443   # HTTPS
sudo ufw enable
```

### Database Security
- Use strong passwords
- Limit database user permissions
- Enable SSL connections
- Regular security updates

### Application Security
- Keep dependencies updated
- Use environment variables for secrets
- Enable CORS restrictions
- Implement rate limiting
- Regular security audits

## Scaling

### Horizontal Scaling
- Use load balancer (HAProxy, Nginx)
- Multiple application servers
- Database read replicas
- Redis for session storage

### Vertical Scaling
- Increase server resources
- Optimize database queries
- Enable caching
- CDN for static assets

## Maintenance

### Regular Tasks
- Security updates
- Dependency updates
- Database maintenance
- Log rotation
- Backup verification

### Deployment Process
1. Test in staging environment
2. Create database migration
3. Deploy application code
4. Run migrations
5. Restart services
6. Verify deployment

## Troubleshooting

### Common Issues

1. **Service won't start**
   - Check logs: `sudo journalctl -u jamtastic-api`
   - Verify environment variables
   - Check file permissions

2. **Database connection errors**
   - Verify PostgreSQL is running
   - Check connection string
   - Verify user permissions

3. **Asset loading issues**
   - Check Nginx configuration
   - Verify asset compilation
   - Check file permissions

### Performance Issues
- Monitor database queries
- Check server resources
- Review application logs
- Use profiling tools

## Rollback Procedure

1. **Stop services**
```bash
sudo systemctl stop jamtastic-api
```

2. **Restore previous version**
```bash
git checkout previous-commit-hash
bundle install
```

3. **Rollback database (if needed)**
```bash
RAILS_ENV=production bundle exec rails db:rollback
```

4. **Restart services**
```bash
sudo systemctl start jamtastic-api
```

## Support

For deployment issues:
- Check application logs
- Review system logs
- Verify configuration files
- Test individual components
