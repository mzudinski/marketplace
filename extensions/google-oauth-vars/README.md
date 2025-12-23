# Google OAuth Extension

A Xano marketplace extension that enables authentication against Google accounts.

## Overview

This extension provides three modes of Google OAuth authentication:

- **Continue with Google** - Handles both signup and login in a single request. Best for low-friction onboarding.
- **Login with Google** - Login only. Fails if the user hasn't signed up via Google previously.
- **Sign up with Google** - Signup only. Fails if the user already has an account. Useful when you have special signup requirements (e.g., invite codes).

## Setup

### Prerequisites

You need a Google OAuth **client ID** and **client secret**.

1. Go to the [Google Developer Console](https://console.developers.google.com/) and create a project (or use an existing one)
2. Configure your [OAuth consent screen](https://console.developers.google.com/apis/credentials/consent):
   - Choose "External" user type
   - Enter your app name, authorized domain, homepage link, and privacy link
   - Don't modify scopes to avoid delays
3. Go to [Credentials](https://console.developers.google.com/apis/credentials) and click **Create credentials > OAuth client ID**
4. Select your application type and name your OAuth client
5. Copy the **client ID** and **client secret**

### Environment Variables

Set these in your Xano workspace:

| Variable | Description |
|----------|-------------|
| `google_oauth_client_id` | Your Google OAuth client ID |
| `google_oauth_secret` | Your Google OAuth client secret |

## API Endpoints

All endpoints are in the `google-oauth` API group.

### `GET /oauth/google/init`

Generates the Google authentication URL to redirect users to.

**Input:**
- `redirect_uri` - Where Google should redirect after authentication

**Response:**
```json
{ "authUrl": "https://accounts.google.com/o/oauth2/auth?..." }
```

### `GET /oauth/google/continue`

Handles both login and signup. Creates a new user if one doesn't exist.

**Input:**
- `code` - The authorization code from Google's redirect
- `redirect_uri` - Must match the original redirect URI

**Response:**
```json
{
  "token": "auth_token",
  "name": "User Name",
  "email": "user@example.com"
}
```

### `GET /oauth/google/login`

Login only. Returns an error if no account exists.

**Input:**
- `code` - The authorization code from Google's redirect
- `redirect_uri` - Must match the original redirect URI

**Response:** Same as `/continue`

### `GET /oauth/google/signup`

Signup only. Returns an error if an account already exists.

**Input:**
- `code` - The authorization code from Google's redirect
- `redirect_uri` - Must match the original redirect URI

**Response:** Same as `/continue`

## Functions

### `google_oauth_getauthurl`

Builds the Google OAuth URL with proper scopes and parameters.

### `google_oauth_getaccesstoken`

Exchanges the authorization code for an access token.

### `google_oauth_getuserinfo`

Retrieves user profile information from Google using the access token.

## Database Schema

The extension merges a `google_oauth` object into your `user` table:

```
google_oauth {
  id: text      // Google user ID
  name: text    // Display name from Google
  email: email  // Email from Google
}
```

## Authentication Flow

1. Call `/oauth/google/init` with your `redirect_uri` to get the auth URL
2. Redirect the user to the auth URL
3. User authenticates with Google
4. Google redirects back to your `redirect_uri` with a `code` parameter
5. Call `/oauth/google/continue`, `/login`, or `/signup` with the `code` and `redirect_uri`
6. Receive an auth token to use for subsequent API calls

## Source

The full extension definition is in [index.xs.twig](index.xs.twig).

## License

CC BY 4.0
