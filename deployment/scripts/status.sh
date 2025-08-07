#!/bin/bash

# FastAPI + Vue Application Status Check Script

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging function
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

log "Checking FastAPI + Vue Application Status..."

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   warn "Not running as root - some checks may be limited"
fi

# Check backend service
info "Checking backend service status..."
if systemctl is-active --quiet fastapi-vue-backend.service; then
    echo -e "${GREEN}✓${NC} Backend service is running"
else
    echo -e "${RED}✗${NC} Backend service is not running"
fi

systemctl status fastapi-vue-backend.service --no-pager -l | head -n 5

echo ""

# Check nginx
info "Checking nginx status..."
if systemctl is-active --quiet nginx; then
    echo -e "${GREEN}✓${NC} Nginx is running"
else
    echo -e "${RED}✗${NC} Nginx is not running"
fi

systemctl status nginx --no-pager -l | head -n 5

echo ""

# Check ports
info "Checking listening ports..."
if command -v ss >/dev/null 2>&1; then
    BACKEND_PORT=$(ss -tuln | grep ':8000 ')
    if [ -n "$BACKEND_PORT" ]; then
        echo -e "${GREEN}✓${NC} Backend is listening on port 8000"
    else
        echo -e "${RED}✗${NC} Backend is not listening on port 8000"
    fi
    
    NGINX_PORT=$(ss -tuln | grep ':80 ')
    if [ -n "$NGINX_PORT" ]; then
        echo -e "${GREEN}✓${NC} Nginx is listening on port 80"
    else
        echo -e "${RED}✗${NC} Nginx is not listening on port 80"
    fi
elif command -v netstat >/dev/null 2>&1; then
    BACKEND_PORT=$(netstat -tuln | grep ':8000 ')
    if [ -n "$BACKEND_PORT" ]; then
        echo -e "${GREEN}✓${NC} Backend is listening on port 8000"
    else
        echo -e "${RED}✗${NC} Backend is not listening on port 8000"
    fi
    
    NGINX_PORT=$(netstat -tuln | grep ':80 ')
    if [ -n "$NGINX_PORT" ]; then
        echo -e "${GREEN}✓${NC} Nginx is listening on port 80"
    else
        echo -e "${RED}✗${NC} Nginx is not listening on port 80"
    fi
else
    warn "Neither ss nor netstat available to check ports"
fi

echo ""

# Check application directories
info "Checking application directories..."
APP_DIR="/opt/fastapi-vue-app"
if [ -d "$APP_DIR" ]; then
    echo -e "${GREEN}✓${NC} Application directory exists"
else
    echo -e "${RED}✗${NC} Application directory does not exist"
fi

if [ -d "$APP_DIR/backend" ]; then
    echo -e "${GREEN}✓${NC} Backend directory exists"
else
    echo -e "${RED}✗${NC} Backend directory does not exist"
fi

if [ -d "$APP_DIR/frontend/dist" ]; then
    echo -e "${GREEN}✓${NC} Frontend build directory exists"
else
    echo -e "${RED}✗${NC} Frontend build directory does not exist"
fi

echo ""

# Check log files
info "Checking log files..."
if [ -f "$APP_DIR/logs/backend.log" ]; then
    echo -e "${GREEN}✓${NC} Backend log file exists"
    echo "Last 5 lines of backend log:"
    tail -n 5 "$APP_DIR/logs/backend.log"
else
    echo -e "${RED}✗${NC} Backend log file does not exist"
fi

echo ""

log "Status check completed."