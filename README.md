# Maillayer Railway Template

This folder contains files for deploying Maillayer on Railway using the same release mechanism as the one-command installer.

## How It Works

The Dockerfile pulls the latest release from `mddanishyusuf/maillayer-releases` - the same source used by `install.sh`. This means:

- No need to give Railway access to your private source code
- Same build artifacts as the VPS installer
- Automatic updates when you publish new releases

## Setup

### Option 1: Create a Separate Deploy Repo

1. Create a new public repo (e.g., `maillayer-railway`)
2. Copy these files to that repo:
   - `Dockerfile`
   - `railway.json`
3. Create a Railway template using that repo

### Option 2: Add to Releases Repo

Add these files to your `maillayer-releases` repo alongside the release tarballs.

## Creating the Railway Template

1. Go to https://railway.app/button
2. Add your deploy repo as a service
3. Add MongoDB database
4. Add Redis database
5. Configure environment variables:

```
NODE_ENV=production
MONGODB_URI=${{MongoDB.MONGO_URL}}
REDIS_URL=${{Redis.REDIS_URL}}
NEXTAUTH_SECRET=${{secret(32)}}
TRACKING_SECRET=${{secret(32)}}
ENCRYPTION_KEY=${{secret(32)}}
JWT_SECRET=${{secret(32)}}
```

6. Mark `BASE_URL` as user-provided
7. Publish the template

## Environment Variables

| Variable | Description | Type |
|----------|-------------|------|
| `NODE_ENV` | Set to `production` | Static |
| `BASE_URL` | User's domain URL | User Provided |
| `MONGODB_URI` | MongoDB connection string | Reference |
| `REDIS_URL` | Redis connection string | Reference |
| `NEXTAUTH_SECRET` | Auth secret (32 chars) | Generated |
| `TRACKING_SECRET` | Tracking secret | Generated |
| `ENCRYPTION_KEY` | Encryption key | Generated |
| `JWT_SECRET` | JWT signing secret | Generated |
