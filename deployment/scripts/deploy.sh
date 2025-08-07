#!/bin/bash

# FastAPI + Vue Application Deployment Script

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   error "This script must be run as root"
   exit 1
fi

# Default values
APP_DIR="/opt/fastapi-vue-app"

log "Starting deployment of FastAPI + Vue application..."

# Copy systemd service file
log "Installing systemd service for backend..."
cp $APP_DIR/config/backend.service /etc/systemd/system/fastapi-vue-backend.service
systemctl daemon-reload

# Enable and start backend service
log "Enabling and starting backend service..."
systemctl enable fastapi-vue-backend.service
systemctl start fastapi-vue-backend.service

# Configure nginx
log "Configuring nginx..."
cp $APP_DIR/config/nginx.conf /etc/nginx/sites-available/fastapi-vue
ln -sf /etc/nginx/sites-available/fastapi-vue /etc/nginx/sites-enabled/

# Test nginx configuration
log "Testing nginx configuration..."
nginx -t

# Restart nginx
log "Restarting nginx..."
systemctl restart nginx

# Set permissions
log "Setting permissions..."
chown -R www-data:www-data $APP_DIR
chmod -R 755 $APP_DIR

log "Deployment completed successfully!"
log "Application should now be accessible at http://your-server-ip/"
log "Backend API is available at http://your-server-ip/api/"