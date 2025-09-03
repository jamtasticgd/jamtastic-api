# itch.io OAuth Integration

This document describes the itch.io OAuth integration for the Jamtastic API, allowing users to authenticate and link their itch.io accounts.

## Overview

The itch.io OAuth integration provides:
- User authentication via itch.io accounts
- Account linking for existing users
- Secure token management
- Profile information synchronization

## Setup

### 1. Register OAuth Application

1. Go to [itch.io OAuth Applications](https://itch.io/user/settings/oauth)
2. Create a new OAuth application
3. Set the redirect URI to: `https://your-domain.com/users/itchio_oauth/callback`
4. Note down your Client ID

### 2. Environment Configuration

#### Option A: Using .env file (Recommended for development)

1. Copy the example environment file:
```bash
cp .env.example .env
```

2. Edit `.env` and set your itch.io OAuth credentials:
```bash
ITCHIO_CLIENT_ID=your_client_id_here
ITCHIO_CLIENT_SECRET=your_client_secret_here  # Optional
```

3. Run the setup script for guided configuration:
```bash
./scripts/setup_env.sh
```

The setup script will:
- Create `.env` from `.env.example` if it doesn't exist
- Guide you through setting up your itch.io Client ID
- Show you the correct redirect URI to use in itch.io
- Provide next steps for testing the integration

#### Option B: Using environment variables directly

Set the following environment variables:

```bash
export ITCHIO_CLIENT_ID=your_client_id_here
export ITCHIO_CLIENT_SECRET=your_client_secret_here  # Optional
```

#### Optional Configuration

You can also configure these optional environment variables:

```bash
# API URLs (defaults provided)
ITCHIO_API_BASE_URL=https://itch.io/api/1
ITCHIO_OAUTH_URL=https://itch.io/user/oauth

# Application URLs
FRONTEND_URL=http://localhost:3000
API_URL=http://localhost:3001
```

### 3. Database Migration

The integration adds the following fields to the `users` table:
- `itchio_id` (string, unique)
- `itchio_username` (string, indexed)
- `itchio_access_token` (text, encrypted)

## API Endpoints

### Authorization Flow

#### 1. Start OAuth Flow
```
GET /users/itchio_oauth/authorize
```

Redirects user to itch.io authorization page.

**Response:**
- Redirects to itch.io OAuth page

#### 2. OAuth Callback
```
GET /users/itchio_oauth/callback
```

Handles the OAuth callback from itch.io. Renders a page that extracts the access token from the URL hash and sends it to the server.

**Response:**
- HTML page that processes the OAuth callback

```
POST /users/itchio_oauth/callback
```

Processes the OAuth callback with the access token.

**Request Body:**
```json
{
  "access_token": "itchio_access_token",
  "state": "state_parameter"
}
```

**Response:**
```json
{
  "data": {
    "user": {
      "id": 1,
      "email": "user@example.com",
      "name": "User Name",
      "itchio_username": "itchio_username",
      "itchio_linked": true,
      "created_at": "2025-01-01T00:00:00Z",
      "updated_at": "2025-01-01T00:00:00Z"
    },
    "tokens": {
      "access-token": "jwt_token",
      "client": "client_id",
      "uid": "user_email",
      "expiry": "expiry_timestamp"
    }
  }
}
```

### Account Linking

#### Link itch.io Account
```
POST /users/itchio_oauth/link_account
Authorization: Bearer <access_token>
```

Links an itch.io account to the current authenticated user.

**Request Body:**
```json
{
  "access_token": "itchio_access_token"
}
```

**Response:**
```json
{
  "message": "itch.io account linked successfully",
  "user": {
    "id": 1,
    "email": "user@example.com",
    "name": "User Name",
    "itchio_username": "itchio_username",
    "itchio_linked": true,
    "created_at": "2025-01-01T00:00:00Z",
    "updated_at": "2025-01-01T00:00:00Z"
  }
}
```

#### Unlink itch.io Account
```
DELETE /users/itchio_oauth/unlink_account
Authorization: Bearer <access_token>
```

Unlinks the itch.io account from the current user.

**Response:**
```json
{
  "message": "itch.io account unlinked successfully"
}
```

## Frontend Integration

### JavaScript Example

```javascript
// Start OAuth flow
function startItchioOAuth() {
  window.location.href = '/users/itchio_oauth/authorize';
}

// Handle OAuth callback (this runs on the callback page)
function handleOAuthCallback() {
  const hash = window.location.hash.slice(1);
  const params = new URLSearchParams(hash);
  const accessToken = params.get('access_token');
  const state = params.get('state');
  
  if (accessToken) {
    // Send to server
    fetch('/users/itchio_oauth/callback', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({
        access_token: accessToken,
        state: state
      })
    })
    .then(response => response.json())
    .then(data => {
      if (data.data && data.data.tokens) {
        // Store tokens and redirect
        localStorage.setItem('auth_tokens', JSON.stringify(data.data.tokens));
        window.location.href = '/dashboard';
      }
    });
  }
}
```

## Security Considerations

1. **State Parameter**: The OAuth flow uses a state parameter to prevent CSRF attacks
2. **Token Storage**: Access tokens are stored securely in the database
3. **HTTPS**: All OAuth endpoints should be served over HTTPS in production
4. **Token Validation**: Access tokens are validated against itch.io's API before use

## Error Handling

The API returns appropriate HTTP status codes and error messages:

- `400 Bad Request`: Invalid parameters or missing access token
- `401 Unauthorized`: Invalid access token or authentication required
- `409 Conflict`: itch.io account already linked to another user
- `422 Unprocessable Entity`: Failed to fetch itch.io user data
- `503 Service Unavailable`: itch.io OAuth not configured

## Testing

Run the test suite:

```bash
bundle exec rspec spec/services/itchio_oauth_service_spec.rb
bundle exec rspec spec/requests/api/users/itchio_oauth_spec.rb
```

## Troubleshooting

### Common Issues

1. **"itch.io OAuth is not configured"**
   - Ensure `ITCHIO_CLIENT_ID` environment variable is set

2. **"Invalid state parameter"**
   - The OAuth state parameter doesn't match the session state
   - This usually indicates a CSRF attack or session timeout

3. **"This itch.io account is already linked to another user"**
   - The itch.io account is already associated with a different user
   - Users must unlink the account from the other user first

4. **"Failed to fetch itch.io user data"**
   - The access token is invalid or expired
   - itch.io API is unavailable
   - Network connectivity issues

### Debug Mode

Enable debug logging by setting the log level to debug in your environment configuration.
