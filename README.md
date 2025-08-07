# FastAPI + Vue + SQLite Boilerplate

This is a boilerplate project combining:
- FastAPI backend with SQLite database
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
2. Create a virtual environment: `python -m venv venv`
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
2. In a separate terminal, run the tests: `python test_integration.py`

### Manual Testing
1. Start the backend: `cd backend && python main.py`
2. Start the frontend: `cd frontend && npm run serve`
3. Visit http://localhost:8080 in your browser
4. Try creating, reading, updating, and deleting items