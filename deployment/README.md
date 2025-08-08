# Deployment Guide (Python 3)

This directory contains scripts and configuration files for deploying the FastAPI + Vue application to a Linux server. The application is built with Python 3.

## Prerequisites

- Linux server with SSH access
- sudo privileges
- Python 3.7+ installed
- Node.js and npm installed
- nginx installed
- systemd (for service management)

## Deployment Steps

1. Copy the application files to your server
2. Run the installation script
3. Configure the services
4. Start the services

## Directory Structure

```
/opt/fastapi-vue-app/
├── backend/          # FastAPI application
├── frontend/         # Built Vue application
├── logs/             # Application logs
├── config/           # Configuration files
└── scripts/          # Deployment scripts
```

## Detailed Deployment Process

### 1. Copy Files to Server

Transfer the application files to your Linux server:

```bash
# From your local machine
scp -r ../backend user@your-server:/tmp/fastapi-vue-app/
scp -r ../frontend user@your-server:/tmp/fastapi-vue-app/
scp -r ./ user@your-server:/tmp/fastapi-vue-app/deployment/
```

### 2. Run Installation Script

SSH into your server and run the installation script:

```bash
# On your server
ssh user@your-server
cd /tmp/fastapi-vue-app/deployment
chmod +x scripts/*.sh
sudo scripts/install.sh
```

### 3. Configure Services

Before deploying, customize the configuration files:

1. Edit `/opt/fastapi-vue-app/config/nginx.conf`:
   - Replace `your-domain.com` with your actual domain or server IP
   - Uncomment and configure SSL sections if needed

2. Review `/opt/fastapi-vue-app/config/backend.service`:
   - Adjust user/group if needed
   - Modify worker count or other Gunicorn settings

### 4. Deploy Services

Run the deployment script:

```bash
# On your server
sudo /opt/fastapi-vue-app/scripts/deploy.sh
```

### 5. Verify Deployment

Check the status of your services:

```bash
# On your server
sudo /opt/fastapi-vue-app/scripts/status.sh
```

## Managing the Application

### Starting Services
```bash
sudo systemctl start fastapi-vue-backend.service
sudo systemctl start nginx
```

### Stopping Services
```bash
sudo systemctl stop fastapi-vue-backend.service
sudo systemctl stop nginx
```

### Restarting Services
```bash
sudo systemctl restart fastapi-vue-backend.service
sudo systemctl restart nginx
```

### Viewing Logs
```bash
# Backend logs
sudo journalctl -u fastapi-vue-backend.service -f

# Nginx logs
sudo tail -f /var/log/nginx/fastapi-vue-access.log
sudo tail -f /var/log/nginx/fastapi-vue-error.log
```

## Updating the Application

To update the application with new code:

1. Transfer new files to the server
2. Run the update script:

```bash
# On your server
sudo /opt/fastapi-vue-app/scripts/update.sh
```

## Troubleshooting

### Common Issues

1. **Permission denied errors**:
   - Ensure all scripts have execute permissions: `chmod +x scripts/*.sh`
   - Run deployment scripts with sudo

2. **Services not starting**:
   - Check logs with: `sudo journalctl -u fastapi-vue-backend.service`
   - Verify configuration files are correct

3. **Nginx configuration errors**:
   - Test configuration: `sudo nginx -t`
   - Check for syntax errors in nginx.conf

4. **Port conflicts**:
   - Verify ports 80 and 8000 are free
   - Check with: `sudo ss -tuln | grep ':80\|:8000'`

5. **httptools/parser/parser.c:212:12: fatal error: longintrepr.h: No such file or directory**

   This error occurs due to compatibility issues with older versions of dependencies. The installation script has been updated to resolve this issue by upgrading pip before installing dependencies.
   
   If you encounter this error, try:
   ```bash
   # In the backend directory on your server
   source venv/bin/activate
   pip install --upgrade pip
   pip install -r requirements.txt
   ```

### Useful Commands

```bash
# Check service status
sudo systemctl status fastapi-vue-backend.service
sudo systemctl status nginx

# View application logs
sudo tail -f /opt/fastapi-vue-app/logs/backend.log

# Test nginx configuration
sudo nginx -t

# Reload nginx after config changes
sudo systemctl reload nginx