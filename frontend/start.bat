@echo off
REM Startup script for Vue frontend on Windows

REM Check if node_modules exists, if not install dependencies
if not exist "node_modules" (
    echo Installing dependencies...
    npm install
    echo Dependencies installed.
)

REM Start the Vue development server
echo Starting Vue development server...
npm run serve