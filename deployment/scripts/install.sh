#!/bin/bash

# FastAPI + Vue Application Installation Script

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
if [[ $EUID -eq 0 ]]; then
   error "This script should not be run as root"
   exit 1
fi

# Default values
APP_DIR="/opt/fastapi-vue-app"
BACKEND_PORT="8000"
FRONTEND_PORT="8080"

log "Starting installation of FastAPI + Vue application..."

# Create application directory
log "Creating application directory: $APP_DIR"
sudo mkdir -p $APP_DIR
sudo chown $USER:$USER $APP_DIR

# Create subdirectories
log "Creating subdirectories..."
mkdir -p $APP_DIR/backend
mkdir -p $APP_DIR/frontend
mkdir -p $APP_DIR/logs
mkdir -p $APP_DIR/config
mkdir -p $APP_DIR/scripts

# Install system dependencies
log "Installing system dependencies..."
sudo apt-get update
sudo apt-get install -y python3 python3-pip python3-venv nodejs npm nginx supervisor

# Setup backend
log "Setting up backend..."
cp -r ../backend/* $APP_DIR/backend/

# Create backend virtual environment
log "Creating Python virtual environment for backend..."
cd $APP_DIR/backend
python3 -m venv venv
source venv/bin/activate

# Install backend dependencies
log "Installing backend dependencies..."
# Upgrade pip first to avoid compilation issues
pip install --upgrade pip
pip install -r requirements.txt
pip install gunicorn

# Deactivate virtual environment
deactivate

# Setup frontend
log "Setting up frontend..."
cp -r ../frontend/* $APP_DIR/frontend/

# Build frontend for production
log "Building frontend for production..."
cd $APP_DIR/frontend
npm install
npm run build

# Create log files
log "Creating log files..."
touch $APP_DIR/logs/backend.log
touch $APP_DIR/logs/frontend.log
chmod 644 $APP_DIR/logs/*.log

log "Installation completed successfully!"
log "Next steps:"
log "1. Review and customize the configuration files in $APP_DIR/config/"
log "2. Configure systemd services or supervisor configs"
log "3. Start the services"