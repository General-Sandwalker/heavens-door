# Authentication System Setup Guide

## ✅ Complete Authentication System Created!

### Backend (FastAPI + MySQL)
- ✅ User model with SQLAlchemy
- ✅ JWT token authentication
- ✅ Password hashing with bcrypt
- ✅ Auth controller with business logic
- ✅ Auth API endpoints

### Frontend (Flutter)
- ✅ User model
- ✅ API service with HTTP client
- ✅ Auth provider with state management
- ✅ Login screen
- ✅ Signup screen
- ✅ Home screen with user info
- ✅ Token storage with SharedPreferences

---

## 🚀 Quick Start

### 1. Backend Setup

```bash
# Navigate to backend
cd backend

# Install dependencies
pip install -r requirements.txt

# Create .env file
copy .env.example .env

# Start the backend
uvicorn app.main:app --reload
```

Backend will run at: **http://localhost:8000**
API Docs: **http://localhost:8000/docs**

### 2. Database Setup

Make sure MySQL is running and create the database:
```sql
CREATE DATABASE rentonline;
```

Or use Docker:
```bash
docker-compose up -d
```

### 3. Frontend Setup

```bash
# Navigate to frontend
cd frontend

# Get dependencies
flutter pub get

# Run the app
flutter run
```

---

## 📡 API Endpoints

### Authentication Routes (`/api/auth`)

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/auth/signup` | Register new user |
| POST | `/api/auth/login` | Login user |
| POST | `/api/auth/login/form` | OAuth2 login (Swagger) |
| GET | `/api/auth/me` | Get current user info |
| GET | `/api/auth/verify-token` | Verify token validity |

---

## 📝 API Usage Examples

### Signup
```json
POST /api/auth/signup
{
  "email": "user@example.com",
  "username": "johndoe",
  "password": "password123",
  "full_name": "John Doe"
}
```

### Login
```json
POST /api/auth/login
{
  "email": "user@example.com",
  "password": "password123"
}
```

### Response
```json
{
  "user": {
    "id": 1,
    "email": "user@example.com",
    "username": "johndoe",
    "full_name": "John Doe",
    "is_active": true,
    "is_verified": false,
    "created_at": "2025-12-03T10:00:00"
  },
  "access_token": "eyJhbGc...",
  "token_type": "bearer"
}
```

### Get Current User
```bash
GET /api/auth/me
Authorization: Bearer <your_token>
```

---

## 🗄️ Database Schema

### Users Table
```sql
users
├── id (INTEGER, PRIMARY KEY)
├── email (VARCHAR(255), UNIQUE)
├── username (VARCHAR(100), UNIQUE)
├── hashed_password (VARCHAR(255))
├── full_name (VARCHAR(255))
├── is_active (BOOLEAN)
├── is_verified (BOOLEAN)
├── created_at (DATETIME)
└── updated_at (DATETIME)
```

---

## 🔐 Security Features

- ✅ Password hashing with bcrypt
- ✅ JWT token authentication
- ✅ Token expiration (30 minutes default)
- ✅ Secure password requirements (min 6 chars)
- ✅ Email validation
- ✅ Username uniqueness check
- ✅ Email uniqueness check

---

## 📱 Flutter App Features

- ✅ Material Design UI
- ✅ Form validation
- ✅ Loading states
- ✅ Error handling
- ✅ Secure token storage
- ✅ Auto-login from stored token
- ✅ Password visibility toggle
- ✅ Responsive design

---

## 🛠️ Tech Stack

### Backend
- FastAPI
- SQLAlchemy (ORM)
- MySQL
- JWT (python-jose)
- Bcrypt (passlib)
- Pydantic (validation)

### Frontend
- Flutter
- Provider (state management)
- HTTP (API calls)
- SharedPreferences (storage)

---

## 🔧 Configuration

### Backend (.env)
```env
DATABASE_URL=mysql+pymysql://root:password@localhost:3306/rentonline
SECRET_KEY=your-secret-key-change-in-production
ACCESS_TOKEN_EXPIRE_MINUTES=30
```

### Flutter (lib/services/api_service.dart)
```dart
static const String baseUrl = 'http://localhost:8000/api';
```

For Android Emulator, use: `http://10.0.2.2:8000/api`
For iOS Simulator, use: `http://localhost:8000/api`
For Physical Device, use your computer's IP: `http://192.168.x.x:8000/api`

---

## 🧪 Testing

### Test with Swagger UI
1. Go to http://localhost:8000/docs
2. Use `/api/auth/signup` to create a user
3. Use `/api/auth/login/form` to get a token
4. Click "Authorize" and enter token
5. Test protected endpoints

### Test with Flutter App
1. Start backend: `uvicorn app.main:app --reload`
2. Start Flutter app: `flutter run`
3. Create account or login
4. View user profile

---

## 📂 Project Structure

```
RentOnline/
├── backend/
│   ├── app/
│   │   ├── models/
│   │   │   └── user.py
│   │   ├── schemas/
│   │   │   └── user.py
│   │   ├── controller/
│   │   │   └── auth_controller.py
│   │   ├── utils/
│   │   │   ├── auth.py
│   │   │   └── exceptions.py
│   │   ├── database.py
│   │   ├── config.py
│   │   └── main.py
│   ├── routers/
│   │   └── auth.py
│   └── requirements.txt
│
└── frontend/
    └── lib/
        ├── models/
        │   └── user.dart
        ├── services/
        │   └── api_service.dart
        ├── providers/
        │   └── auth_provider.dart
        ├── screens/
        │   ├── login_screen.dart
        │   ├── signup_screen.dart
        │   └── home_screen.dart
        └── main.dart
```

---

## 🎉 Next Steps

1. ✅ Test signup/login functionality
2. Add email verification
3. Add password reset
4. Add user profile editing
5. Add refresh tokens
6. Add role-based access control
7. Add social authentication
8. Deploy to production

---

## 🐛 Troubleshooting

### Backend Issues
- Make sure MySQL is running
- Check database connection in .env
- Install all requirements: `pip install -r requirements.txt`
- Check logs for errors

### Flutter Issues
- Run `flutter pub get`
- Update API baseUrl for your environment
- Check backend is running
- Enable internet permissions in Android manifest

### CORS Issues
- Backend has CORS enabled for all origins
- In production, update CORS settings in `app/main.py`
