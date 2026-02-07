# Maillayer Railway Deployment
# Pulls from GitHub releases (same as install.sh)

FROM node:20-alpine

WORKDIR /app

# Install dependencies for downloading and PM2
RUN apk add --no-cache curl tar && \
    npm install -g pm2

# Download latest release from GitHub
ARG MAILLAYER_VERSION=latest
ENV GITHUB_REPO=mddanishyusuf/maillayer-releases

# Fetch latest version if not specified
RUN if [ "$MAILLAYER_VERSION" = "latest" ]; then \
      MAILLAYER_VERSION=$(curl -s "https://api.github.com/repos/${GITHUB_REPO}/releases/latest" | grep '"tag_name"' | cut -d'"' -f4); \
    fi && \
    echo "Downloading Maillayer ${MAILLAYER_VERSION}..." && \
    curl -fsSL "https://github.com/${GITHUB_REPO}/releases/download/${MAILLAYER_VERSION}/maillayer.tar.gz" | tar -xz --strip-components=1

# Install production dependencies
RUN npm ci --only=production

# Expose port
EXPOSE 3000

# Start with PM2 (runs both app and workers)
CMD ["pm2-runtime", "ecosystem.config.js"]
