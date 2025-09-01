# Jamtastic API Documentation

## Overview

The Jamtastic API is a RESTful JSON API built with Rails 7.0, providing endpoints for team management, skill tracking, and user authentication.

**Base URL**: `http://localhost:3000` (development)

## Authentication

The API uses Devise Token Auth for authentication. Include the following headers in authenticated requests:

```
Authorization: Bearer <access_token>
Content-Type: application/json
```

### Authentication Endpoints

#### Register User
```http
POST /users
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123",
  "password_confirmation": "password123",
  "name": "John Doe"
}
```

#### Sign In
```http
POST /users/sign_in
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

#### Sign Out
```http
DELETE /users/sign_out
Authorization: Bearer <access_token>
```

## Core Resources

### Skills

#### List Skills
```http
GET /skills
```

**Response:**
```json
[
  {
    "id": 1,
    "code": "ruby",
    "created_at": "2023-01-01T00:00:00.000Z",
    "updated_at": "2023-01-01T00:00:00.000Z"
  }
]
```

### Teams

#### List Teams
```http
GET /teams
Authorization: Bearer <access_token>
```

#### Create Team
```http
POST /teams
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "name": "My Team",
  "description": "Team description",
  "approve_new_members": true
}
```

#### Get Team
```http
GET /teams/:id
Authorization: Bearer <access_token>
```

#### Update Team
```http
PUT /teams/:id
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "name": "Updated Team Name",
  "description": "Updated description"
}
```

#### Delete Team
```http
DELETE /teams/:id
Authorization: Bearer <access_token>
```

### Team Members

#### Join Team
```http
POST /teams/:id/enrollments
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "kind": "member"
}
```

#### Leave Team
```http
DELETE /teams/:id/enrollments
Authorization: Bearer <access_token>
```

#### Approve Enrollment
```http
POST /teams/:id/enrollments/:enrollment_id/approvals
Authorization: Bearer <access_token>
```

### Companies

#### Create Company
```http
POST /companies
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "name": "Company Name",
  "email": "contact@company.com",
  "url": "https://company.com"
}
```

### Groups

#### Update Group
```http
PUT /groups/:id
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "name": "Group Name",
  "member_count": 10
}
```

## Response Formats

### Success Response
```json
{
  "data": {
    "id": 1,
    "type": "team",
    "attributes": {
      "name": "Team Name",
      "description": "Team description",
      "created_at": "2023-01-01T00:00:00.000Z"
    }
  }
}
```

### Error Response
```json
{
  "errors": [
    {
      "field": "name",
      "message": "can't be blank"
    }
  ]
}
```

### Validation Error Response
```json
{
  "errors": [
    {
      "field": "email",
      "message": "is invalid"
    }
  ]
}
```

## HTTP Status Codes

- `200 OK` - Successful GET, PUT requests
- `201 Created` - Successful POST requests
- `204 No Content` - Successful DELETE requests
- `400 Bad Request` - Invalid request data
- `401 Unauthorized` - Authentication required
- `403 Forbidden` - Insufficient permissions
- `404 Not Found` - Resource not found
- `422 Unprocessable Entity` - Validation errors
- `500 Internal Server Error` - Server error

## Rate Limiting

Currently no rate limiting is implemented. Consider implementing rate limiting for production use.

## CORS

CORS is configured for development with `CORS_ORIGIN=*`. For production, configure specific origins.

## Pagination

Pagination is not currently implemented. Consider adding pagination for endpoints that return large datasets.

## Filtering and Sorting

Filtering and sorting are not currently implemented. Consider adding query parameters for:
- Team filtering by name, description
- User filtering by skills
- Sorting by creation date, name

## Webhooks

Webhooks are not currently implemented. Consider adding webhooks for:
- Team creation
- User enrollment
- Team member approval

## SDKs and Libraries

No official SDKs are currently available. The API follows RESTful conventions and can be consumed by any HTTP client.

## Examples

### Complete Team Management Flow

1. **Create a team**
```bash
curl -X POST http://localhost:3000/teams \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"name": "Development Team", "description": "Our dev team", "approve_new_members": true}'
```

2. **Join the team**
```bash
curl -X POST http://localhost:3000/teams/1/enrollments \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{"kind": "member"}'
```

3. **Approve the enrollment**
```bash
curl -X POST http://localhost:3000/teams/1/enrollments/1/approvals \
  -H "Authorization: Bearer <token>"
```

## Testing

### Using Postman

Import the Postman collection from the [API documentation](https://documenter.getpostman.com/view/2140691/2s93sW8vcf).

### Using cURL

All examples above use cURL. Ensure you have a valid authentication token.

### Using JavaScript/Fetch

```javascript
// Authenticate
const response = await fetch('http://localhost:3000/users/sign_in', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    email: 'user@example.com',
    password: 'password123'
  })
});

const { access_token } = await response.json();

// Use token for authenticated requests
const teamsResponse = await fetch('http://localhost:3000/teams', {
  headers: {
    'Authorization': `Bearer ${access_token}`,
    'Content-Type': 'application/json'
  }
});
```

## Support

For API support and questions:
- Check the [development guide](DEVELOPMENT.md)
- Review the test files for usage examples
- Check the controller implementations for detailed behavior
