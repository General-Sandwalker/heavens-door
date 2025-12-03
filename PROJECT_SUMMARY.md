# 🌟 Heaven's Door - Project Summary 🌟

## Overview
Heaven's Door is a JoJo-themed cross-platform real estate application that enables users to search, view, and publish property listings with integrated messaging, geolocation, favorites, and user profiles.

---

## ✨ Key Features Implemented

### 🔐 User Authentication & Profile Management
- User registration with email/password
- JWT-based authentication
- Secure password hashing with bcrypt
- User profile management (view/update)
- Role-based access control (user, agent, admin)

### 🏠 Property Management
- Create, read, update, delete (CRUD) properties
- Property types: house, apartment, condo, land, commercial
- Listing types: sale or rent
- Rich property details: price, location, bedrooms, bathrooms, area, year built
- Image galleries support (array of URLs)
- Amenities listing
- Property status tracking (active, pending, sold, rented, inactive)
- View counter for analytics

### 🔍 Search & Filtering
- Text-based property search
- Advanced filtering by:
  - Property type
  - Listing type (sale/rent)
  - Price range
  - Location (city)
  - Number of bedrooms
  - Number of bathrooms
- Pagination support for large datasets

### ⭐ Favorites System
- Add/remove properties to favorites
- View all favorited properties
- Favorite counter per property
- Notifications to property owners when favorited

### 💬 Messaging System
- Real-time messaging using Socket.io
- One-on-one conversations
- Message threading
- Read/unread status
- Typing indicators
- Message history
- Property-specific inquiries

### 🗺️ Geolocation
- Latitude/longitude storage for properties
- Google Maps integration ready
- Location-based property display
- Address geocoding support

### 🔔 Notifications
- System notifications for important events
- Message notifications
- Favorite notifications
- Property update notifications
- In-app notification center

### 🎨 JoJo Theme
- Stand-inspired color palette
- Purple & gold accents (Heaven's Door colors)
- Menacing UI effects
- JoJo references throughout
- Custom fonts and styling
- Character-themed design elements

---

## 🏗️ Technical Architecture

### Frontend - Flutter (Dart)
**Framework:** Flutter 3.x with Dart SDK
**State Management:** Provider pattern
**Key Dependencies:**
- `dio` - HTTP client for API calls
- `socket_io_client` - Real-time messaging
- `google_maps_flutter` - Map integration
- `geolocator` - Location services
- `cached_network_image` - Image caching
- `flutter_secure_storage` - Secure token storage
- `google_fonts` - Custom typography
- `provider` - State management

**Architecture:**
- Clean separation: Models, Services, Providers, Screens, Widgets
- API client with interceptors for authentication
- Secure storage for JWT tokens
- Comprehensive error handling
- Responsive UI for mobile and web

### Backend - Node.js & Express
**Runtime:** Node.js 21
**Framework:** Express.js
**Key Dependencies:**
- `express` - Web framework
- `pg` - PostgreSQL client
- `jsonwebtoken` - JWT authentication
- `bcryptjs` - Password hashing
- `socket.io` - WebSocket server
- `helmet` - Security headers
- `cors` - Cross-origin resource sharing
- `express-validator` - Input validation
- `morgan` - HTTP logging
- `compression` - Response compression

**Architecture:**
- MVC pattern (Models, Views, Controllers)
- Middleware-based request processing
- RESTful API design
- WebSocket for real-time features
- Comprehensive error handling
- Rate limiting for API protection

### Database - PostgreSQL 17
**Tables:**
- `users` - User accounts and profiles
- `properties` - Property listings
- `favorites` - User-property favorites (many-to-many)
- `messages` - Direct messages between users
- `notifications` - System notifications
- `reviews` - Property reviews (future feature)

**Features:**
- ACID compliance
- Indexed columns for performance
- Foreign key constraints
- Triggers for auto-updating timestamps
- UUID primary keys
- JSONB for flexible data (images, amenities)

### Infrastructure - Docker
**Containerization:**
- PostgreSQL 17 container with persistent volume
- Node.js backend container with hot reload
- Docker Compose for orchestration
- Isolated network for services
- Health checks for reliability

---

## 📂 Project Structure

```
heavens-door/
├── backend/
│   ├── src/
│   │   ├── config/          # Database & app config
│   │   ├── controllers/     # Request handlers
│   │   ├── middleware/      # Auth, validation, errors
│   │   ├── routes/          # API routes
│   │   └── server.js        # Main server file
│   ├── migrations/          # SQL schema
│   ├── Dockerfile
│   └── package.json
├── frontend/
│   ├── lib/
│   │   ├── models/          # Data models
│   │   ├── providers/       # State management
│   │   ├── screens/         # UI screens
│   │   ├── services/        # API services
│   │   ├── utils/           # Utilities & theme
│   │   └── main.dart
│   ├── assets/              # Images, icons
│   ├── pubspec.yaml
│   └── .env
├── docs/
│   ├── architecture/        # C4 diagrams
│   ├── api/                 # API documentation
│   └── setup/               # Setup guides
├── docker-compose.yml
├── start.sh                 # Quick start script
└── README.md
```

---

## 🔄 Data Flow

### User Authentication Flow
1. User enters credentials in Flutter app
2. App sends POST request to `/api/auth/login`
3. Backend validates credentials against PostgreSQL
4. JWT token generated and returned
5. Token stored securely in Flutter Secure Storage
6. Token included in Authorization header for protected routes

### Property Listing Flow
1. User creates property in Flutter app
2. Images uploaded to storage (URL stored)
3. Property data sent to `/api/properties`
4. Backend validates and stores in PostgreSQL
5. Property appears in search results
6. Other users can view, favorite, and message owner

### Real-time Messaging Flow
1. User opens chat screen
2. WebSocket connection established
3. User joins room via socket.emit('join', userId)
4. Messages sent via socket.emit('send_message')
5. Recipient receives via socket.on('receive_message')
6. Messages persisted in PostgreSQL
7. Read receipts updated

---

## 🎯 C4 Architecture Model

### Level 1: System Context
- **Users:** Property seekers, property owners
- **System:** Heaven's Door platform
- **External Systems:** Google Maps API, Cloud Storage, Push Notifications

### Level 2: Container
- **Flutter App:** Mobile & web frontend
- **Express API:** Backend server
- **PostgreSQL:** Database
- **Socket.io:** Real-time messaging
- **JWT Auth:** Authentication service

### Level 3: Component
**Backend Components:**
- Auth Controller, Property Controller, Message Controller
- Auth Middleware, Validation Middleware
- User Service, Property Service, Message Service
- Database Models with PostgreSQL queries

**Frontend Components:**
- Auth Module (login, register)
- Property Module (list, details, create)
- Messaging Module (conversations, chat)
- Profile Module (view, edit)
- Favorites Module

---

## 🚀 Getting Started

### Prerequisites
- Docker & Docker Compose
- Flutter SDK
- Android SDK (for mobile)
- OpenJDK 21

### Quick Start
```bash
# Clone and navigate
cd heavens-door

# Run setup script
./start.sh

# Start frontend
cd frontend
flutter run
```

### Manual Start
```bash
# Backend
docker-compose up -d

# Frontend
cd frontend
flutter pub get
flutter run
```

---

## 📊 API Endpoints Summary

**Authentication:**
- `POST /api/auth/register` - Register user
- `POST /api/auth/login` - Login user

**Users:**
- `GET /api/users/profile` - Get profile
- `PUT /api/users/profile` - Update profile

**Properties:**
- `GET /api/properties` - List properties (with filters)
- `GET /api/properties/:id` - Get property
- `POST /api/properties` - Create property
- `PUT /api/properties/:id` - Update property
- `DELETE /api/properties/:id` - Delete property
- `GET /api/properties/search` - Search properties

**Favorites:**
- `GET /api/favorites` - List favorites
- `POST /api/favorites/:propertyId` - Add favorite
- `DELETE /api/favorites/:propertyId` - Remove favorite

**Messages:**
- `GET /api/messages` - List conversations
- `GET /api/messages/conversation/:userId` - Get conversation
- `POST /api/messages` - Send message
- `PUT /api/messages/:id/read` - Mark as read

---

## 🎨 JoJo Theme Details

### Color Palette
- **Stand Purple** (#9B59B6) - Primary color, Heaven's Door
- **Golden Wind** (#FFD700) - Accent, buttons
- **Star Platinum** (#4A90E2) - Secondary, links
- **Emerald Green** (#2ECC71) - Success states
- **Killer Queen Pink** (#E91E63) - Highlights
- **Menacing Red** (#8B0000) - Errors, urgent
- **DIO Dark** (#1A1A1A) - Dark theme

### Design Philosophy
- Bold, confident typography
- High contrast for readability
- Playful yet professional
- Stand-inspired iconography
- Menacing effects for important actions
- Purple gradient backgrounds

---

## 🔒 Security Features

- JWT token-based authentication
- Password hashing with bcrypt (10 salt rounds)
- HTTPS-ready (configure in production)
- CORS protection
- Rate limiting (100 requests/15 minutes)
- Input validation on all endpoints
- SQL injection prevention (parameterized queries)
- XSS protection with Helmet.js
- Secure storage for tokens (Flutter Secure Storage)

---

## 📈 Performance Optimizations

- Database indexing on frequently queried columns
- Connection pooling for PostgreSQL
- Image caching in Flutter
- Pagination for large datasets
- Compression middleware
- Lazy loading of images
- WebSocket for efficient real-time communication
- Dio interceptors for request optimization

---

## 🧪 Testing Strategy

### Backend Testing
- Unit tests for controllers and services
- Integration tests for API endpoints
- Database transaction tests
- WebSocket connection tests

### Frontend Testing
- Widget tests for UI components
- Integration tests for user flows
- Unit tests for providers and services
- End-to-end testing

---

## 🚢 Deployment Recommendations

### Backend
- Deploy on cloud platform (AWS, GCP, Azure, DigitalOcean)
- Use managed PostgreSQL service
- Configure Nginx as reverse proxy
- Enable HTTPS with Let's Encrypt
- Set up monitoring and logging
- Configure environment-specific variables
- Implement CI/CD pipeline

### Frontend
- **Web:** Deploy to Vercel, Netlify, or Firebase Hosting
- **Android:** Publish to Google Play Store
- **iOS:** Publish to Apple App Store (requires macOS)
- Configure production API URLs
- Enable analytics
- Set up crash reporting

---

## 📚 Documentation

- **README.md** - Project overview and quick start
- **docs/architecture/C4-ARCHITECTURE.md** - Complete architecture diagrams
- **docs/api/API_DOCUMENTATION.md** - Full API reference
- **docs/setup/DEVELOPMENT_SETUP.md** - Detailed setup guide

---

## 🔮 Future Enhancements

### High Priority
- [ ] Property image upload to cloud storage
- [ ] Advanced map view with clustering
- [ ] Property comparison feature
- [ ] Saved searches with notifications
- [ ] Agent/owner verification badges

### Medium Priority
- [ ] Property reviews and ratings
- [ ] Virtual tours (360° photos)
- [ ] Mortgage calculator
- [ ] Property recommendations (ML-based)
- [ ] Social sharing
- [ ] Multi-language support

### Low Priority
- [ ] Dark mode toggle
- [ ] Accessibility improvements
- [ ] Offline mode support
- [ ] Export property details as PDF
- [ ] Advanced analytics dashboard

---

## 🤝 Contributing

This is a solo developer project, but contributions are welcome!

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

---

## 📜 License

MIT License - See LICENSE file for details

---

## 🎭 JoJo References

Throughout the application, you'll find references to JoJo's Bizarre Adventure:

- **Heaven's Door** - Rohan Kishibe's Stand, can read and write in people's memories
- **Stand Powers** - User abilities and features
- **Menacing Effects** - UI animations and transitions
- **Golden Wind** - Success states and highlights
- **"I refuse!"** - Rohan's iconic line used in validation messages
- **Stand Users** - App users
- **Reading/Writing** - Metaphors for data operations

---

## 👨‍💻 Development Credits

**Architecture:** C4 Model by Simon Brown
**Framework:** Flutter by Google
**Backend:** Node.js & Express
**Database:** PostgreSQL
**Theme Inspiration:** JoJo's Bizarre Adventure by Hirohiko Araki

---

## 📞 Support

For issues, questions, or suggestions:
- Open an issue on GitHub
- Check documentation in `/docs`
- Review API documentation
- Run `./start.sh` for quick troubleshooting

---

## 🎉 Acknowledgments

Special thanks to:
- Hirohiko Araki for creating JoJo's Bizarre Adventure
- The Flutter community
- The Node.js and Express communities
- PostgreSQL contributors
- All open-source library maintainers

---

**"With Heaven's Door, the perfect property is just a page turn away!"**

*Stand Proud!* 🌟
