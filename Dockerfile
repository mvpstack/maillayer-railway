FROM node:20-alpine
WORKDIR /app

RUN apk add --no-cache curl tar && \
    npm install -g pm2

ARG MAILLAYER_VERSION=latest
ENV GITHUB_REPO=mddanishyusuf/maillayer-releases

RUN if [ "$MAILLAYER_VERSION" = "latest" ]; then \
      MAILLAYER_VERSION=$(curl -s "https://api.github.com/repos/${GITHUB_REPO}/releases/latest" | grep '"tag_name"' | cut -d'"' -f4); \
    fi && \
    echo "Downloading Maillayer ${MAILLAYER_VERSION}..." && \
    curl -fsSL "https://github.com/${GITHUB_REPO}/releases/download/${MAILLAYER_VERSION}/maillayer.tar.gz" | tar -xz --strip-components=1

RUN npm ci --only=production

# Create logs directory for PM2 workers
RUN mkdir -p logs

EXPOSE 3000

# Add --env production so workers get env_production config
CMD ["pm2-runtime", "ecosystem.config.js", "--env", "production"]
