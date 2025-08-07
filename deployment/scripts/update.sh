#!/bin/bash

# FastAPI + Vue Application Update Script

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

log "Starting update of FastAPI + Vue application..."

# Stop services
log "Stopping services..."
systemctl stop fastapi-vue-backend.service

# Backup current version
log "Creating backup..."
tar -czf "/opt/fastapi-vue-app-backup-$(date +%Y%m%d-%H%M%S).tar.gz" -C /opt fastapi-vue-app

# Update backend
log "Updating backend..."
cd $APP_DIR/backend
source venv/bin/activate
pip install -r requirements.txt
deactivate

# Update frontend
log "Updating frontend..."
cd $APP_DIR/frontend
npm install
npm run build

# Set permissions
log "Setting permissions..."
chown -R www-data:www-data $APP_DIR
chmod -R 755 $APP_DIR

# Restart services
log "Restarting services..."
systemctl start fastapi-vue-backend.service
systemctl restart nginx

log "Update completed successfully!"