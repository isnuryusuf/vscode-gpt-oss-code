# FastAPI + Vue + SQLite Boilerplate (Python 3)

This is a boilerplate project combining:
- FastAPI backend with SQLite database (Python 3)
- Vue.js frontend
- RESTful API integration

## Project Structure
```
├── backend/
│   ├── main.py          # FastAPI application
│   ├── requirements.txt # Python dependencies
│   ├── start.sh         # Unix startup script
│   └── start.bat        # Windows startup script
├── frontend/
│   ├── src/             # Vue application source
│   │   ├── components/  # Vue components
│   │   ├── App.vue      # Main Vue component
│   │   └── main.js      # Vue entry point
│   ├── package.json     # Node.js dependencies
│   ├── vue.config.js    # Vue configuration
│   ├── start.sh         # Unix startup script
│   └── start.bat        # Windows startup script
├── test_integration.py  # Integration tests
└── test_requirements.txt # Test dependencies
```

## Setup Instructions

### Backend Setup
1. Navigate to the backend directory: `cd backend`
2. Create a virtual environment: `python3 -m venv venv` (or `python -m venv venv` on Windows)
3. Activate the virtual environment:
   - On Windows: `venv\Scripts\activate`
   - On macOS/Linux: `source venv/bin/activate`
4. Install dependencies: `pip install -r requirements.txt`
5. Run the server: `python main.py` or `uvicorn main:app --reload`

The backend will be available at http://localhost:8000

### Frontend Setup
1. Navigate to the frontend directory: `cd frontend`
2. Install dependencies: `npm install`
3. Run the development server: `npm run serve`

The frontend will be available at http://localhost:8080

## API Endpoints

The backend provides the following RESTful API endpoints:

- `GET /` - Welcome message
- `GET /items/` - Get all items
- `GET /items/{id}` - Get a specific item
- `POST /items/` - Create a new item
- `PUT /items/{id}` - Update an existing item
- `DELETE /items/{id}` - Delete an item

## Features

- SQLite database integration
- Full CRUD operations
- RESTful API
- Responsive Vue frontend
- CORS enabled for frontend-backend communication
- Proxy configuration for development

## Development

### Backend Development
The backend is built with FastAPI, which provides automatic API documentation:
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

### Frontend Development
The frontend is built with Vue 3 and includes:
- Component-based architecture
- Axios for API communication
- Responsive design

## Testing

### Automated Integration Tests
Run the integration tests to verify the application works correctly:
1. Ensure the backend is running: `cd backend && python main.py`
2. In a separate terminal, run the tests: `python3 test_integration.py` (or `python test_integration.py` on Windows)

### Manual Testing
1. Start the backend: `cd backend && python main.py`
2. Start the frontend: `cd frontend && npm run serve`
3. Visit http://localhost:8080 in your browser
4. Try creating, reading, updating, and deleting items

## Deployment

For deploying to a Linux server via SSH, see the detailed instructions in the [deployment](deployment/) directory.

### Quick Deployment Steps:
1. Copy the application files to your Linux server
2. Run the installation script: `sudo deployment/scripts/install.sh`
3. Customize configuration files in `/opt/fastapi-vue-app/config/`
4. Deploy services: `sudo /opt/fastapi-vue-app/scripts/deploy.sh`

The application will be accessible at:
- Web interface: http://your-server-ip/
- API: http://your-server-ip/api/