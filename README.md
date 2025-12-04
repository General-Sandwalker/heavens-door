---

# 🌈✨ Welcome to RentOnline! ✨🌈

> **A vibrant rental marketplace built with Flutter, FastAPI, and MySQL.**

---

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-3.0+-blue?logo=flutter" />
  <img src="https://img.shields.io/badge/FastAPI-Python-green?logo=fastapi" />
  <img src="https://img.shields.io/badge/MySQL-8.0+-orange?logo=mysql" />
</div>

---

## 🗺️ System Overview (C4 Model)

### 🎯 Context Diagram
```mermaid
graph TD
   User[👤 User]
   MobileApp[📱 Flutter App]
   WebApp[🖥️ Flutter Web]
   API[🚀 FastAPI Backend]
   DB[(🗄️ MySQL Database)]
   User -->|Uses| MobileApp
   User -->|Uses| WebApp
   MobileApp -->|REST API| API
   WebApp -->|REST API| API
   API -->|ORM| DB
```

### 🏗️ Container Diagram
```mermaid
graph LR
   subgraph Frontend
      FApp[📱 Flutter App]
      FWeb[🖥️ Flutter Web]
   end
   subgraph Backend
      FastAPI[🚀 FastAPI]
      SQLAlchemy[🧩 SQLAlchemy ORM]
   end
   subgraph Database
      MySQL[(🗄️ MySQL)]
   end
   FApp -- HTTP/JSON --> FastAPI
   FWeb -- HTTP/JSON --> FastAPI
   FastAPI -- ORM --> SQLAlchemy
   SQLAlchemy -- SQL --> MySQL
```

### 🧩 Component Diagram (Backend)
```mermaid
graph TD
   FastAPI[🚀 FastAPI] --> Routers[🔗 Routers]
   FastAPI --> Controllers[🧠 Controllers]
   FastAPI --> Models[📦 Models]
   FastAPI --> Schemas[📑 Schemas]
   FastAPI --> Utils[🛠️ Utils]
   Routers --> AuthRouter[🔐 AuthRouter]
   Controllers --> AuthController[🔐 AuthController]
   Models --> UserModel[👤 UserModel]
   Schemas --> UserSchema[👤 UserSchema]
   Utils --> AuthUtils[🔐 AuthUtils]
```

---

## 🚀 Quick Start

### 🧰 Prerequisites
• Flutter SDK (3.0+)
• Python 3.11+
• MySQL 8.0+ or Docker
• Docker Compose (optional)

### 🏁 Backend & Database
```bash
cd backend
pip install -r requirements.txt
cp .env.example .env
# Edit .env with your MySQL credentials
uvicorn app.main:app --reload
```
🌐 API: [http://localhost:8000](http://localhost:8000)  |  📚 Docs: [http://localhost:8000/docs](http://localhost:8000/docs)

#### 🗄️ Create Database
```sql
CREATE DATABASE rentonline;
```
Or use Docker:
```bash
docker-compose up -d
```

### 🎨 Frontend
```bash
cd frontend
flutter pub get
flutter run
```

---

## 👟 User Flows

### ✍️ Signup
1. Open the app and tap **Sign Up**
2. Fill in your email, username, password, and full name
3. Tap **Register** → API `/api/auth/signup`
4. Receive your user info and token

### 🔑 Login
1. Enter your email & password
2. Tap **Login** → API `/api/auth/login`
3. Get your token and auto-login

### 🧑‍💻 View Profile
1. App loads your token from storage
2. Calls `/api/auth/me` with Bearer token
3. Displays your profile info

> 💡 **Tip:** You can log out and log back in anytime!

---

## 🔗 API Reference

| Method | Endpoint                | Description           |
|--------|------------------------|-----------------------|
| POST   | `/api/auth/signup`     | Register new user     |
| POST   | `/api/auth/login`      | Login user            |
| POST   | `/api/auth/login/form` | OAuth2 login (Swagger)|
| GET    | `/api/auth/me`         | Get current user info |
| GET    | `/api/auth/verify-token` | Verify token validity |

---

## 🗄️ Database Schema

```mermaid
erDiagram
   USERS {
      INT id PK
      VARCHAR email
      VARCHAR username
      VARCHAR hashed_password
      VARCHAR full_name
      BOOLEAN is_active
      BOOLEAN is_verified
      DATETIME created_at
      DATETIME updated_at
   }
```

---

## ⚙️ Tech Stack

- **Frontend:** Flutter, Dart
- **Backend:** FastAPI, Python
- **Database:** MySQL
- **ORM:** SQLAlchemy
- **Auth:** JWT, bcrypt
- **Validation:** Pydantic
- **State Management:** Provider (Flutter)
- **Storage:** SharedPreferences (Flutter)

---

## 🐛 Troubleshooting & FAQ

### 🛠️ Backend Issues
- Is MySQL running? (Check with `systemctl status mysql` or Docker)
- Is your `.env` file correct?
- Did you run `pip install -r requirements.txt`?
- Check logs for errors (they’re super helpful!)

### 📱 Flutter Issues
- Run `flutter pub get` to fetch packages
- Update API baseUrl for your device (see `lib/services/api_service.dart`)
- Is the backend running?
- Enable internet permissions in Android manifest

### 🌐 CORS Issues
- Backend has CORS enabled for all origins (update for production!)

> 🧠 **Did you know?** You can test the API with Swagger UI at [http://localhost:8000/docs](http://localhost:8000/docs)

---

## 📦 Project Structure
```text
backend/
├── app/
│   ├── models/user.py
│   ├── schemas/user.py
│   ├── controller/auth_controller.py
│   ├── utils/auth.py
│   ├── utils/exceptions.py
│   ├── config.py
│   ├── database.py
│   └── main.py
├── routers/auth.py
└── requirements.txt

frontend/
└── lib/
   ├── models/user.dart
   ├── services/api_service.dart
   ├── providers/auth_provider.dart
   ├── screens/
   │   ├── login_screen.dart
   │   ├── signup_screen.dart
   │   └── home_screen.dart
   └── main.dart
```

---

## 📈 Next Steps

1. Add email verification
2. Add password reset
3. Add user profile editing
4. Add refresh tokens
5. Add role-based access control
6. Add social authentication
7. Deploy to production

---

## 📄 License

MIT
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
