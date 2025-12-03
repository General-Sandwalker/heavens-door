# 🌟 Heaven's Door - Real Estate Application 🌟

<p align="center">
  <img src="https://i.imgur.com/heavens-door-logo.png" alt="Heaven's Door Logo" width="200"/>
</p>

> *"Heaven's Door has the ability to turn people into books, reading their memories and experiences. Similarly, our app opens the door to your dream property!"*

A JoJo-themed cross-platform real estate application that enables users to search, view, and publish property listings with integrated messaging, geolocation, favorites, and user profiles.

## ✨ Stand Powers (Features)

### 🏠 **Property Stand**
- 🔍 Search and filter properties by price, location, and type
- 📸 View property details with photo galleries
- 📝 Publish listings for sale or rent
- 🗺️ Interactive map-based property localization

### 👤 **User Stand**
- 🔐 User registration and profile management
- ⭐ Save favorite properties
- 🔔 Receive notifications
- 💬 In-app messaging between users

### 🎨 **JoJo Theme**
- Stand-inspired UI elements
- Character-themed color schemes
- Menacing UI effects
- JoJo references throughout the app

## 🏗️ Architecture

This project follows the **C4 Model** for software architecture visualization:
- **System Context**: Overview of Heaven's Door and its users
- **Container**: Frontend (Flutter), Backend (Node.js/Express), Database (PostgreSQL)
- **Component**: Detailed breakdown of each container's internal structure

See `/docs/architecture/` for complete C4 diagrams.

## 🛠️ Technical Stack

### Frontend
- **Flutter** - Cross-platform mobile and web development
- **Dart** - Programming language
- **Provider/Riverpod** - State management
- **Google Maps Flutter** - Map integration
- **Dio** - HTTP client

### Backend
- **Node.js** - Runtime environment
- **Express.js** - Web framework
- **PostgreSQL 17** - Relational database
- **JWT** - Authentication
- **bcrypt** - Password hashing
- **Socket.io** - Real-time messaging

### Infrastructure
- **Docker** - Containerization
- **Docker Compose** - Multi-container orchestration
- **Nginx** - Reverse proxy (production)

## 📂 Project Structure

```
heavens-door/
├── backend/              # Node.js/Express API
│   ├── src/
│   │   ├── config/      # Configuration files
│   │   ├── controllers/ # Route controllers
│   │   ├── middleware/  # Custom middleware
│   │   ├── models/      # Database models
│   │   ├── routes/      # API routes
│   │   ├── services/    # Business logic
│   │   └── utils/       # Utility functions
│   ├── migrations/      # Database migrations
│   ├── Dockerfile
│   └── package.json
├── frontend/            # Flutter application
│   ├── lib/
│   │   ├── models/      # Data models
│   │   ├── screens/     # UI screens
│   │   ├── services/    # API services
│   │   ├── widgets/     # Reusable widgets
│   │   ├── providers/   # State management
│   │   └── utils/       # Helper functions
│   └── pubspec.yaml
├── docs/                # Documentation
│   ├── architecture/    # C4 diagrams
│   ├── api/            # API documentation
│   └── setup/          # Setup guides
├── docker-compose.yml   # Docker orchestration
└── README.md
```

## 🚀 Getting Started

### Prerequisites

- **Arch Linux** (or any Linux distribution)
- **Docker** and **Docker Compose**
- **Flutter SDK** (for mobile/web development)
- **Android SDK** at `~/Android/sdk`
- **OpenJDK 21**

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd heavens-door
   ```

2. **Start the backend with Docker Compose**
   ```bash
   docker-compose up -d
   ```

3. **Run database migrations**
   ```bash
   docker-compose exec backend npm run migrate
   ```

4. **Set up Flutter frontend**
   ```bash
   cd frontend
   flutter pub get
   flutter run
   ```

### Environment Variables

Create `.env` files in both `backend/` and `frontend/` directories:

**Backend `.env`:**
```env
NODE_ENV=development
PORT=3000
DATABASE_URL=postgresql://postgres:password@db:5432/heavens_door
JWT_SECRET=your_jwt_secret_key
JWT_EXPIRES_IN=7d
```

**Frontend `.env`:**
```env
API_BASE_URL=http://localhost:3000/api
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
```

## 📱 Running the Application

### Backend API
```bash
docker-compose up -d
```
API will be available at `http://localhost:3000`

### Flutter Mobile (Android)
```bash
cd frontend
flutter run
```

### Flutter Web
```bash
cd frontend
flutter run -d chrome
```

## 🧪 Testing

### Backend Tests
```bash
cd backend
npm test
```

### Flutter Tests
```bash
cd frontend
flutter test
```

## 📖 API Documentation

API documentation is available at:
- Swagger UI: `http://localhost:3000/api-docs`
- See `/docs/api/` for detailed endpoint documentation

## 🎯 Development Roadmap

- [x] Project setup and architecture design
- [x] Docker containerization
- [x] Database schema design
- [x] Backend API implementation
- [x] Flutter frontend setup
- [x] User authentication
- [x] Property CRUD operations
- [x] Search and filtering
- [x] Map integration
- [x] Messaging system
- [x] Favorites functionality
- [x] Notifications
- [ ] Unit and integration tests
- [ ] Performance optimization
- [ ] Production deployment

## 🤝 Contributing

Contributions are welcome! Please read our contributing guidelines before submitting PRs.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🎭 JoJo References

This application is inspired by Hirohiko Araki's JoJo's Bizarre Adventure. Heaven's Door is a Stand belonging to Rohan Kishibe, a manga artist who can read and write in people's memories.

*"I refuse!"* - Rohan Kishibe

---

Built with 💜 and a lot of Stand energy!
