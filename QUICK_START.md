# 🚀 QUICK START - Heaven's Door

## What You Have Now

A complete, production-ready real estate application with:
- ✅ Backend API (Node.js/Express)
- ✅ Database (PostgreSQL 17)
- ✅ Frontend (Flutter)
- ✅ Real-time Messaging (Socket.io)
- ✅ Authentication (JWT)
- ✅ JoJo Theme
- ✅ Complete Documentation

---

## Getting Started (3 Simple Steps)

### Step 1: Start the Backend (30 seconds)
```bash
cd /home/greed/Desktop/heavens-door
./start.sh
```

This will:
- Start PostgreSQL database
- Start Node.js backend
- Initialize database schema
- Verify everything is running

### Step 2: Start the Frontend (1 minute)
```bash
cd frontend
flutter pub get
flutter run
```

Choose your platform:
- **Android:** Connect device or start emulator, then `flutter run`
- **Web:** `flutter run -d chrome`
- **Linux:** `flutter run -d linux`

### Step 3: Test the Application
1. Register a new account
2. Login with your credentials
3. Browse properties
4. Add favorites
5. Send messages

---

## 📂 Project Structure

```
heavens-door/
├── 📱 frontend/          # Flutter app
│   ├── lib/
│   │   ├── screens/      # UI screens
│   │   ├── providers/    # State management
│   │   ├── models/       # Data models
│   │   └── services/     # API client
│   └── pubspec.yaml
│
├── 🔧 backend/           # Node.js API
│   ├── src/
│   │   ├── controllers/  # Request handlers
│   │   ├── routes/       # API endpoints
│   │   └── middleware/   # Auth, validation
│   └── package.json
│
├── 🗄️ database/          # PostgreSQL
│   └── migrations/       # SQL schema
│
└── 📚 docs/              # Documentation
    ├── architecture/     # C4 diagrams
    ├── api/             # API reference
    └── setup/           # Setup guides
```

---

## 🎯 Key Features

### ✅ Implemented
- User registration and authentication
- Property listings (CRUD)
- Search and filtering
- Favorites system
- Real-time messaging
- User profiles
- JoJo-themed UI
- Responsive design

### 🚧 Needs Configuration
- **Google Maps API Key**
  - Get key from: https://console.cloud.google.com/
  - Add to `frontend/.env`: `GOOGLE_MAPS_API_KEY=your_key`

- **Image Upload** (Optional)
  - Currently stores URLs
  - Can integrate AWS S3, Cloudinary, or Firebase Storage

---

## 🛠️ Development Commands

### Backend
```bash
# View logs
docker-compose logs -f backend

# Restart backend
docker-compose restart backend

# Access database
docker-compose exec db psql -U postgres -d heavens_door

# Stop all services
docker-compose down
```

### Frontend
```bash
# Run on Android
flutter run

# Run on web
flutter run -d chrome

# Run on Linux desktop
flutter run -d linux

# Hot reload: Press 'r' in terminal
# Hot restart: Press 'R' in terminal

# Run tests
flutter test

# Analyze code
flutter analyze

# Format code
flutter format .
```

---

## 📡 API Endpoints

**Base URL:** `http://localhost:3000/api`

### Authentication
- `POST /auth/register` - Register new user
- `POST /auth/login` - Login user

### Properties
- `GET /properties` - List all properties
- `GET /properties/:id` - Get property details
- `POST /properties` - Create property (auth required)
- `PUT /properties/:id` - Update property (auth required)
- `DELETE /properties/:id` - Delete property (auth required)
- `GET /properties/search?q=query` - Search properties

### Favorites
- `GET /favorites` - Get user favorites (auth required)
- `POST /favorites/:propertyId` - Add favorite (auth required)
- `DELETE /favorites/:propertyId` - Remove favorite (auth required)

### Messages
- `GET /messages` - Get conversations (auth required)
- `GET /messages/conversation/:userId` - Get chat (auth required)
- `POST /messages` - Send message (auth required)

### Users
- `GET /users/profile` - Get profile (auth required)
- `PUT /users/profile` - Update profile (auth required)

**Full API docs:** `docs/api/API_DOCUMENTATION.md`

---

## 🎨 Customization

### Change Theme Colors
Edit `frontend/lib/utils/theme.dart`:
```dart
static const Color standPurple = Color(0xFF9B59B6); // Change this
static const Color goldenWind = Color(0xFFFFD700);  // And this
```

### Change App Name
Edit `frontend/pubspec.yaml`:
```yaml
name: your_app_name
description: Your app description
```

### Change Backend Port
Edit `docker-compose.yml`:
```yaml
ports:
  - "3001:3000"  # Change to your preferred port
```

---

## 🐛 Troubleshooting

### Backend won't start
```bash
# Check if port 3000 is in use
sudo lsof -i :3000

# Reset everything
docker-compose down -v
docker-compose up -d
```

### Frontend errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

### Database issues
```bash
# View database logs
docker-compose logs db

# Reset database (WARNING: deletes all data)
docker-compose down -v
docker-compose up -d
```

### Can't connect to backend
- Check backend is running: `curl http://localhost:3000/health`
- Check `frontend/.env` has correct `API_BASE_URL`
- Restart backend: `docker-compose restart backend`

---

## 📚 Documentation

| Document | Description |
|----------|-------------|
| `README.md` | Project overview and quick start |
| `PROJECT_SUMMARY.md` | Complete feature list and architecture |
| `CHANGELOG.md` | Version history and release notes |
| `CONTRIBUTING.md` | How to contribute |
| `docs/architecture/C4-ARCHITECTURE.md` | System architecture diagrams |
| `docs/api/API_DOCUMENTATION.md` | Complete API reference |
| `docs/setup/DEVELOPMENT_SETUP.md` | Detailed setup instructions |

---

## 🚀 Next Steps

### For Development
1. ✅ You're ready to develop!
2. Start backend: `./start.sh`
3. Start frontend: `cd frontend && flutter run`
4. Make changes (hot reload is enabled)
5. Test your changes
6. Commit and push

### For Production
1. Configure environment variables
2. Set up cloud database (AWS RDS, DigitalOcean, etc.)
3. Deploy backend (Heroku, AWS, DigitalOcean)
4. Build and deploy frontend:
   - Web: `flutter build web`
   - Android: `flutter build apk`
   - iOS: `flutter build ios` (requires macOS)
5. Configure domain and SSL
6. Set up monitoring and logging

### Add More Features
Common additions:
- Image upload to S3/Cloudinary
- Google Maps integration
- Property comparison
- Reviews and ratings
- Virtual tours
- Payment integration
- Email notifications
- Push notifications

---

## 💡 Tips

### Backend Development
- Use `docker-compose logs -f backend` to watch logs
- Hot reload is enabled (changes reflect automatically)
- Test endpoints with curl or Postman
- Access database: `docker-compose exec db psql -U postgres -d heavens_door`

### Frontend Development
- Press 'r' for hot reload, 'R' for hot restart
- Use `flutter analyze` to check for issues
- Use `flutter doctor` to check setup
- Use VSCode/Android Studio for better debugging

### Database
- View all tables: `\dt`
- View users: `SELECT * FROM users;`
- View properties: `SELECT * FROM properties;`
- Count records: `SELECT COUNT(*) FROM properties;`

---

## 🆘 Need Help?

1. **Check Documentation**
   - Read `docs/` folder
   - Check API documentation
   - Review setup guide

2. **Common Issues**
   - Port already in use → Kill process or change port
   - Database connection error → Restart Docker
   - Flutter errors → Run `flutter clean && flutter pub get`

3. **Debugging**
   - Backend logs: `docker-compose logs backend`
   - Database logs: `docker-compose logs db`
   - Flutter: Check terminal output

4. **Community**
   - Open GitHub issue
   - Check existing issues
   - Review CONTRIBUTING.md

---

## 🎉 You're All Set!

Your Heaven's Door application is ready to use. Here's what you can do now:

1. **Try It Out**
   ```bash
   ./start.sh
   cd frontend && flutter run
   ```

2. **Customize It**
   - Change colors in `frontend/lib/utils/theme.dart`
   - Add your logo to `frontend/assets/images/`
   - Modify API responses in `backend/src/controllers/`

3. **Extend It**
   - Add new features
   - Integrate more services
   - Deploy to production

4. **Share It**
   - Show your friends
   - Deploy to cloud
   - Publish to app stores

---

## 📞 Project Info

**Version:** 1.0.0
**Created:** December 3, 2024
**Stack:** Flutter + Node.js + PostgreSQL
**Theme:** JoJo's Bizarre Adventure
**Status:** ✅ Production Ready

---

**"Heaven's Door has opened! Your real estate journey begins now!"**

*Stand Proud!* 🌟

---

## Quick Reference Card

```
📁 Project: /home/greed/Desktop/heavens-door

🚀 Start Backend:    ./start.sh
🚀 Start Frontend:   cd frontend && flutter run

🔧 Backend URL:      http://localhost:3000
💾 Database:         PostgreSQL on port 5432
📱 Flutter:          Mobile, Web, Desktop

📊 View Logs:        docker-compose logs -f
⏹️  Stop Services:   docker-compose down
🔄 Restart:          docker-compose restart

📚 Docs:             docs/
🐛 Issues:           Check TROUBLESHOOTING section
✨ Features:         See PROJECT_SUMMARY.md
```

---

**Everything is set up and ready to go! Happy coding!** 🎉
