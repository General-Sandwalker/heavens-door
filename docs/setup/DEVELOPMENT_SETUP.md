# Development Setup Guide

## Prerequisites

Before you begin, ensure you have the following installed:

1. **Docker & Docker Compose**
   ```bash
   # Install Docker on Arch Linux
   sudo pacman -S docker docker-compose
   sudo systemctl enable docker
   sudo systemctl start docker
   sudo usermod -aG docker $USER
   ```

2. **Flutter SDK**
   ```bash
   # Download Flutter
   cd ~
   git clone https://github.com/flutter/flutter.git -b stable
   
   # Add to PATH in ~/.zshrc
   export PATH="$PATH:$HOME/flutter/bin"
   
   # Verify installation
   flutter doctor
   ```

3. **Android SDK** (at ~/Android/sdk)
   ```bash
   # Install Android Studio or command-line tools
   # Set ANDROID_HOME
   export ANDROID_HOME=$HOME/Android/sdk
   export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
   ```

4. **OpenJDK 21**
   ```bash
   sudo pacman -S jdk21-openjdk
   ```

5. **Node.js** (handled by Docker, but useful for local development)
   ```bash
   sudo pacman -S nodejs npm
   ```

---

## Backend Setup

### 1. Navigate to project directory
```bash
cd /path/to/heavens-door
```

### 2. Create environment file
```bash
cp backend/.env.example backend/.env
```

Edit `backend/.env` and update values if needed:
```env
NODE_ENV=development
PORT=3000
DATABASE_URL=postgresql://postgres:stand_power_2024@db:5432/heavens_door
JWT_SECRET=your_secure_jwt_secret_here
JWT_EXPIRES_IN=7d
CORS_ORIGIN=*
```

### 3. Start Docker containers
```bash
# Start all services (PostgreSQL + Node.js backend)
docker-compose up -d

# View logs
docker-compose logs -f

# Check running containers
docker-compose ps
```

### 4. Database will be automatically initialized
The `init.sql` migration runs automatically when PostgreSQL starts for the first time.

### 5. Verify backend is running
```bash
curl http://localhost:3000/health
```

Expected response:
```json
{
  "status": "OK",
  "message": "Heaven's Door is reading your request! 📖",
  "timestamp": "2024-01-01T00:00:00.000Z"
}
```

---

## Frontend Setup

### 1. Navigate to frontend directory
```bash
cd frontend
```

### 2. Create environment file
```bash
cp .env.example .env
```

Edit `.env`:
```env
API_BASE_URL=http://localhost:3000/api
GOOGLE_MAPS_API_KEY=your_google_maps_api_key
```

### 3. Get Flutter dependencies
```bash
flutter pub get
```

### 4. Create asset directories
```bash
mkdir -p assets/images assets/icons
```

### 5. Check Flutter setup
```bash
flutter doctor
```

Fix any issues reported by flutter doctor.

### 6. Run on Android
```bash
# List available devices
flutter devices

# Run on connected device or emulator
flutter run

# Or specify device
flutter run -d <device-id>
```

### 7. Run on Web
```bash
flutter run -d chrome
```

### 8. Run on Linux Desktop
```bash
flutter run -d linux
```

---

## Development Workflow

### Backend Development

**Watch logs:**
```bash
docker-compose logs -f backend
```

**Restart backend:**
```bash
docker-compose restart backend
```

**Access PostgreSQL:**
```bash
docker-compose exec db psql -U postgres -d heavens_door
```

**Run SQL commands:**
```sql
-- List all tables
\dt

-- View users
SELECT * FROM users;

-- View properties
SELECT * FROM properties;
```

**Install new npm packages:**
```bash
# Add to package.json, then rebuild
docker-compose down
docker-compose up -d --build
```

### Frontend Development

**Hot reload:**
Flutter automatically reloads when you save changes. Press `r` in terminal to manually reload, or `R` for hot restart.

**Install new packages:**
```bash
# Add to pubspec.yaml, then:
flutter pub get
```

**Generate code (if using code generation):**
```bash
flutter pub run build_runner build
```

**Run tests:**
```bash
flutter test
```

**Build for production:**
```bash
# Android APK
flutter build apk

# Android App Bundle
flutter build appbundle

# Web
flutter build web

# Linux
flutter build linux
```

---

## Common Issues & Solutions

### Backend Issues

**Port 3000 already in use:**
```bash
# Find process using port 3000
sudo lsof -i :3000
# Kill process
kill -9 <PID>
# Or change PORT in .env
```

**Database connection error:**
```bash
# Reset database
docker-compose down -v
docker-compose up -d
```

**View backend logs:**
```bash
docker-compose logs backend
```

### Frontend Issues

**Gradle build fails:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

**Package conflicts:**
```bash
flutter pub cache repair
flutter pub get
```

**Android SDK not found:**
```bash
# Set in ~/.zshrc
export ANDROID_HOME=$HOME/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools
```

---

## Testing the Application

### 1. Register a new user
- Open the app
- Click "Register"
- Fill in the form
- Submit

### 2. Login
- Use registered credentials
- You'll be redirected to the home screen

### 3. Browse properties
- View the list of properties
- Search for properties
- Apply filters

### 4. Add favorites
- Click the heart icon on any property
- View favorites in the Favorites tab

### 5. Send messages
- Click on a property owner
- Send a message
- View conversation in Messages tab

---

## Production Deployment

### Backend

1. **Set production environment variables**
2. **Use a production PostgreSQL instance**
3. **Enable HTTPS**
4. **Set up reverse proxy (Nginx)**
5. **Configure domain and SSL certificates**

### Frontend

1. **Update API_BASE_URL to production URL**
2. **Build for target platform**
3. **Deploy web build to hosting service**
4. **Publish Android app to Play Store**

---

## Useful Commands

### Docker
```bash
# Stop all containers
docker-compose down

# Rebuild containers
docker-compose up -d --build

# View all logs
docker-compose logs

# Remove all data (WARNING: deletes database)
docker-compose down -v
```

### Flutter
```bash
# Clean build
flutter clean

# Analyze code
flutter analyze

# Format code
flutter format .

# Check for outdated packages
flutter pub outdated
```

---

## Development Tools

### Recommended VS Code Extensions
- Flutter
- Dart
- Docker
- PostgreSQL
- REST Client
- GitLens

### API Testing
- Use REST Client extension in VS Code
- Or use Postman/Insomnia
- cURL from terminal

### Database Management
- DBeaver
- pgAdmin
- Or use docker-compose exec db psql

---

*"Good preparation is the key to victory!" - Joseph Joestar*
