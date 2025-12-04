# RentOnline Backend - MVC Structure

This backend follows the **Model-View-Controller (MVC)** architecture pattern.

## Project Structure

```
backend/
├── app/
│   ├── __init__.py
│   ├── database.py              # Database configuration and session management
│   ├── models/                  # Models (M in MVC)
│   │   ├── __init__.py
│   │   └── rental_item.py       # RentalItem SQLAlchemy model
│   ├── schemas/                 # Pydantic schemas for validation
│   │   ├── __init__.py
│   │   └── rental_item.py       # Request/Response schemas
│   ├── controller/              # Controllers (C in MVC)
│   │   ├── __init__.py
│   │   └── rental_item_controller.py  # Business logic
│   └── utils/                   # Utility functions
│       ├── __init__.py
│       └── exceptions.py        # Custom exceptions
├── routers/                     # Views/Routes (V in MVC)
│   ├── __init__.py
│   └── items.py                 # API endpoints
├── main.py                      # FastAPI application entry point
├── requirements.txt             # Python dependencies
├── Dockerfile                   # Docker configuration
├── .env.example                 # Environment variables template
└── .gitignore

```

## MVC Architecture

### Models (`app/models/`)
- Define database schema using SQLAlchemy ORM
- Represent data structure and relationships
- Handle database table definitions

### Controllers (`app/controller/`)
- Contain business logic
- Handle data processing and manipulation
- Interact with models to perform CRUD operations
- Separate business logic from routes

### Views/Routes (`routers/`)
- Define API endpoints
- Handle HTTP requests/responses
- Validate input using Pydantic schemas
- Call controllers for business logic
- Return formatted responses

## Key Components

### Database (`app/database.py`)
- Database connection management
- Session creation and dependency injection

### Schemas (`app/schemas/`)
- Request/Response validation using Pydantic
- Data serialization/deserialization
- Type checking and validation

### Utils (`app/utils/`)
- Helper functions
- Custom exceptions
- Shared utilities

## API Endpoints

All routes are prefixed with `/api`:

- `GET /api/items` - Get all items (with optional filters)
- `GET /api/items/{item_id}` - Get item by ID
- `POST /api/items` - Create new item
- `PUT /api/items/{item_id}` - Update item
- `DELETE /api/items/{item_id}` - Delete item

## Running the Backend

```bash
# Install dependencies
pip install -r requirements.txt

# Run the server
uvicorn main:app --reload

# Access API documentation
http://localhost:8000/docs
```

## Environment Variables

Copy `.env.example` to `.env` and configure:

```env
DATABASE_URL=mysql+pymysql://root:password@localhost:3306/rentonline
DATABASE_HOST=localhost
DATABASE_PORT=3306
DATABASE_USER=root
DATABASE_PASSWORD=password
DATABASE_NAME=rentonline
```
