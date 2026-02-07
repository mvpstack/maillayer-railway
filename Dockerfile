# Maillayer Railway Deployment
# Pulls from GitHub releases (same as install.sh)

FROM node:20-alpine

WORKDIR /app

# Install dependencies for downloading
RUN apk add --no-cache curl tar

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

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s \
  CMD curl -f http://localhost:3000/api/health || exit 1

# Start the application
CMD ["npm", "start"]
