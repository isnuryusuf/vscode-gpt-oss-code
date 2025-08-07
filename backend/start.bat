@echo off
REM Startup script for FastAPI backend on Windows

REM Check if virtual environment exists, if not create it
if not exist "venv" (
    echo Creating virtual environment...
    python -m venv venv
    echo Virtual environment created.
)

REM Activate virtual environment
echo Activating virtual environment...
call venv\Scripts\activate

REM Install dependencies
echo Installing dependencies...
pip install -r requirements.txt

REM Start the FastAPI server
echo Starting FastAPI server...
uvicorn main:app --reload --host 0.0.0.0 --port 8000