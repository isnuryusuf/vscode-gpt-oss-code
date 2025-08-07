#!/bin/bash
# Startup script for Vue frontend

# Check if node_modules exists, if not install dependencies
if [ ! -d "node_modules" ]; then
    echo "Installing dependencies..."
    npm install
    echo "Dependencies installed."
fi

# Start the Vue development server
echo "Starting Vue development server..."
npm run serve