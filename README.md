# RentOnline - Flutter + FastAPI + MySQL

A full-stack rental marketplace application with Flutter frontend, FastAPI backend, and MySQL database.

## Project Structure

```
RentOnline/
├── frontend/          # Flutter mobile/web application
├── backend/           # FastAPI REST API
│   ├── routers/       # API endpoints
│   ├── main.py        # FastAPI application
│   ├── models.py      # SQLAlchemy models
│   ├── schemas.py     # Pydantic schemas
│   ├── database.py    # Database configuration
│   └── requirements.txt
└── docker-compose.yml # Docker orchestration
```

## Prerequisites

- Flutter SDK (3.0+)
- Python 3.11+
- MySQL 8.0+ or Docker
- Docker & Docker Compose (optional, for containerized setup)

## Setup Instructions

### Option 1: Using Docker (Recommended)

1. **Start the backend and database:**
   ```bash
   docker-compose up -d
   ```

2. **The API will be available at:**
   - API: http://localhost:8000
   - API Docs: http://localhost:8000/docs

3. **Run the Flutter app:**
   ```bash
   cd frontend
   flutter pub get
   flutter run
   ```

### Option 2: Manual Setup

#### Backend Setup

1. **Create a virtual environment:**
   ```bash
   cd backend
   python -m venv venv
   .\venv\Scripts\activate  # On Windows
   ```

2. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

3. **Set up environment variables:**
   ```bash
   copy .env.example .env
   # Edit .env with your MySQL credentials
   ```

4. **Make sure MySQL is running and create the database:**
   ```sql
   CREATE DATABASE rentonline;
   ```

5. **Run the backend:**
   ```bash
   uvicorn main:app --reload
   ```

#### Frontend Setup

1. **Navigate to frontend directory:**
   ```bash
   cd frontend
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## API Endpoints

- `GET /` - Welcome message
- `GET /health` - Health check
- `GET /api/items` - Get all rental items
- `GET /api/items/{item_id}` - Get specific item
- `POST /api/items` - Create new item
- `PUT /api/items/{item_id}` - Update item
- `DELETE /api/items/{item_id}` - Delete item

## Database Schema

### rental_items
- `id` - Primary key
- `title` - Item title
- `description` - Item description
- `price_per_day` - Rental price per day
- `category` - Item category
- `image_url` - Image URL
- `owner_name` - Owner's name
- `owner_contact` - Contact information
- `created_at` - Creation timestamp
- `updated_at` - Update timestamp

## Development

### Backend Development
```bash
cd backend
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### Flutter Development
```bash
cd frontend
flutter run -d chrome  # For web
flutter run -d windows # For Windows desktop
```

### View API Documentation
Navigate to http://localhost:8000/docs for interactive Swagger documentation.

## Docker Commands

```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f

# Rebuild containers
docker-compose up -d --build
```

## Environment Variables

Create a `.env` file in the `backend` directory:

```env
DATABASE_URL=mysql+pymysql://root:password@localhost:3306/rentonline
DATABASE_HOST=localhost
DATABASE_PORT=3306
DATABASE_USER=root
DATABASE_PASSWORD=password
DATABASE_NAME=rentonline
SECRET_KEY=your-secret-key-here
```

## Technologies Used

- **Frontend:** Flutter 3.x, Dart
- **Backend:** FastAPI, Python 3.11
- **Database:** MySQL 8.0
- **ORM:** SQLAlchemy
- **Validation:** Pydantic
- **Containerization:** Docker, Docker Compose

## Next Steps

1. Configure Flutter app to connect to the API endpoint
2. Implement authentication (JWT)
3. Add file upload for item images
4. Create user management
5. Add booking/reservation system
6. Implement payment integration

## License

MIT
