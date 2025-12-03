# Heaven's Door - Architecture Documentation

## C4 Model Overview

This document follows the C4 model for visualizing software architecture at different levels of abstraction.

## Level 1: System Context Diagram

Shows how Heaven's Door fits into the world around it.

```mermaid
C4Context
    title System Context Diagram for Heaven's Door

    Person(user, "User", "A person looking to buy, rent, or list properties")
    Person(propertyOwner, "Property Owner", "A person who wants to list properties for sale or rent")
    
    System(heavensDoor, "Heaven's Door", "Real estate platform enabling property search, listing, and communication")
    
    System_Ext(googleMaps, "Google Maps API", "Provides geolocation and mapping services")
    System_Ext(notifications, "Push Notification Service", "Sends notifications to users")
    System_Ext(storage, "Cloud Storage", "Stores property images and user avatars")
    
    Rel(user, heavensDoor, "Searches properties, views details, sends messages", "HTTPS")
    Rel(propertyOwner, heavensDoor, "Lists properties, manages listings, responds to inquiries", "HTTPS")
    Rel(heavensDoor, googleMaps, "Fetches location data and displays maps", "HTTPS/JSON")
    Rel(heavensDoor, notifications, "Sends push notifications", "HTTPS")
    Rel(heavensDoor, storage, "Uploads and retrieves images", "HTTPS")
```

**Key Users:**
- **End Users**: Search and view properties, save favorites, contact property owners
- **Property Owners**: Create and manage property listings, respond to inquiries

**External Systems:**
- **Google Maps API**: Geolocation and interactive maps
- **Push Notification Service**: Real-time notifications
- **Cloud Storage**: Image and media storage

## Level 2: Container Diagram

Shows the high-level technology choices and how containers communicate.

```mermaid
C4Container
    title Container Diagram for Heaven's Door

    Person(user, "User", "Mobile/Web user")
    
    Container(mobileApp, "Flutter Mobile App", "Flutter/Dart", "Provides mobile interface for property search and management")
    Container(webApp, "Flutter Web App", "Flutter/Dart", "Provides web interface for property search and management")
    
    Container(apiGateway, "API Gateway", "Node.js/Express", "Handles all API requests, authentication, and routing")
    Container(authService, "Authentication Service", "JWT", "Manages user authentication and authorization")
    Container(messagingService, "Messaging Service", "Socket.io", "Handles real-time messaging between users")
    
    ContainerDb(database, "Database", "PostgreSQL 17", "Stores users, properties, messages, favorites, and notifications")
    
    System_Ext(googleMaps, "Google Maps API", "Mapping service")
    System_Ext(storage, "Cloud Storage", "Image storage")
    
    Rel(user, mobileApp, "Uses", "")
    Rel(user, webApp, "Uses", "")
    
    Rel(mobileApp, apiGateway, "Makes API calls", "HTTPS/JSON")
    Rel(webApp, apiGateway, "Makes API calls", "HTTPS/JSON")
    
    Rel(mobileApp, messagingService, "Real-time messaging", "WebSocket")
    Rel(webApp, messagingService, "Real-time messaging", "WebSocket")
    
    Rel(apiGateway, authService, "Validates tokens", "")
    Rel(apiGateway, database, "Reads/Writes", "SQL")
    Rel(messagingService, database, "Reads/Writes messages", "SQL")
    
    Rel(mobileApp, googleMaps, "Displays maps", "HTTPS")
    Rel(webApp, googleMaps, "Displays maps", "HTTPS")
    Rel(apiGateway, storage, "Uploads/retrieves images", "HTTPS")
```

**Containers:**

1. **Flutter Mobile/Web App** (Frontend)
   - Technology: Flutter, Dart
   - Responsibilities: UI/UX, user interactions, state management
   - Communication: REST API (HTTPS/JSON), WebSocket for messaging

2. **API Gateway** (Backend)
   - Technology: Node.js, Express.js
   - Responsibilities: Request routing, business logic, data validation
   - Port: 3000

3. **Authentication Service**
   - Technology: JWT, bcrypt
   - Responsibilities: User authentication, token management, password security

4. **Messaging Service**
   - Technology: Socket.io
   - Responsibilities: Real-time bidirectional communication

5. **PostgreSQL Database**
   - Technology: PostgreSQL 17
   - Responsibilities: Persistent data storage
   - Port: 5432

## Level 3: Component Diagram

### Backend API Components

```mermaid
C4Component
    title Component Diagram - Backend API

    Container(frontend, "Frontend App", "Flutter", "User interface")
    
    Component(authController, "Authentication Controller", "Express Router", "Handles login, register, logout")
    Component(propertyController, "Property Controller", "Express Router", "Manages property CRUD operations")
    Component(messageController, "Message Controller", "Express Router", "Handles messaging endpoints")
    Component(userController, "User Controller", "Express Router", "Manages user profiles")
    Component(favoriteController, "Favorite Controller", "Express Router", "Handles favorites")
    
    Component(authMiddleware, "Auth Middleware", "JWT", "Validates authentication tokens")
    Component(validationMiddleware, "Validation Middleware", "Express Validator", "Validates request data")
    
    Component(userService, "User Service", "Business Logic", "User management logic")
    Component(propertyService, "Property Service", "Business Logic", "Property management logic")
    Component(messageService, "Message Service", "Business Logic", "Messaging logic")
    Component(searchService, "Search Service", "Business Logic", "Advanced property search")
    
    Component(userModel, "User Model", "PostgreSQL", "User data access")
    Component(propertyModel, "Property Model", "PostgreSQL", "Property data access")
    Component(messageModel, "Message Model", "PostgreSQL", "Message data access")
    Component(favoriteModel, "Favorite Model", "PostgreSQL", "Favorite data access")
    
    ComponentDb(database, "Database", "PostgreSQL", "Data storage")
    
    Rel(frontend, authController, "API calls", "HTTPS/JSON")
    Rel(frontend, propertyController, "API calls", "HTTPS/JSON")
    Rel(frontend, messageController, "API calls", "HTTPS/JSON")
    
    Rel(authController, authMiddleware, "Uses")
    Rel(propertyController, authMiddleware, "Uses")
    Rel(messageController, authMiddleware, "Uses")
    
    Rel(authController, userService, "Uses")
    Rel(propertyController, propertyService, "Uses")
    Rel(messageController, messageService, "Uses")
    
    Rel(userService, userModel, "Uses")
    Rel(propertyService, propertyModel, "Uses")
    Rel(messageService, messageModel, "Uses")
    
    Rel(userModel, database, "SQL queries")
    Rel(propertyModel, database, "SQL queries")
    Rel(messageModel, database, "SQL queries")
```

### Frontend Components

```mermaid
graph TD
    A[Main App] --> B[Authentication Module]
    A --> C[Property Module]
    A --> D[Messaging Module]
    A --> E[User Profile Module]
    A --> F[Favorites Module]
    
    B --> B1[Login Screen]
    B --> B2[Register Screen]
    B --> B3[Auth Service]
    
    C --> C1[Property List Screen]
    C --> C2[Property Detail Screen]
    C --> C3[Property Create Screen]
    C --> C4[Map View Screen]
    C --> C5[Property Service]
    
    D --> D1[Message List Screen]
    D --> D2[Chat Screen]
    D --> D3[Message Service]
    
    E --> E1[Profile Screen]
    E --> E2[Edit Profile Screen]
    E --> E3[User Service]
    
    F --> F1[Favorites Screen]
    F --> F2[Favorite Service]
    
    B3 --> G[HTTP Client]
    C5 --> G
    D3 --> G
    E3 --> G
    F2 --> G
    
    D3 --> H[WebSocket Client]
    
    G --> I[Backend API]
    H --> I
```

## Data Flow

### Property Search Flow
1. User enters search criteria in Flutter app
2. App sends GET request to `/api/properties?filters=...`
3. API Gateway validates request
4. Property Service queries database with filters
5. Results returned to app with pagination
6. App displays properties in list/grid view
7. User can view location on map via Google Maps integration

### Messaging Flow
1. User sends message from chat screen
2. Message sent via WebSocket to Messaging Service
3. Service stores message in database
4. Service broadcasts message to recipient in real-time
5. Recipient receives notification
6. Message appears in recipient's chat screen

### Property Listing Flow
1. Property owner creates listing with photos
2. Images uploaded to Cloud Storage
3. API creates property record with image URLs
4. Database stores property data
5. Property appears in search results for other users

## Security Architecture

- **Authentication**: JWT tokens with 7-day expiration
- **Authorization**: Role-based access control (User, Property Owner, Admin)
- **Password Storage**: bcrypt hashing with salt rounds
- **API Security**: CORS, Rate limiting, Input validation
- **Database**: Parameterized queries to prevent SQL injection
- **HTTPS**: All API communication encrypted

## Deployment Architecture

```
┌─────────────────────────────────────────────┐
│           Docker Compose Stack              │
│                                             │
│  ┌──────────────┐      ┌─────────────────┐ │
│  │   Backend    │      │   PostgreSQL    │ │
│  │  (Node.js)   │◄────►│   Database      │ │
│  │   Port 3000  │      │   Port 5432     │ │
│  └──────────────┘      └─────────────────┘ │
│         ▲                                   │
│         │                                   │
└─────────┼───────────────────────────────────┘
          │
          │ HTTPS/JSON
          │
    ┌─────▼──────┐
    │  Flutter   │
    │    App     │
    │ (Mobile/Web)│
    └────────────┘
```

## Technology Decisions

### Why Flutter?
- Single codebase for mobile and web
- High performance with native compilation
- Rich UI widgets and animations (perfect for JoJo theme!)
- Strong community and package ecosystem

### Why Node.js/Express?
- JavaScript ecosystem familiarity
- Fast development with middleware pattern
- Excellent async I/O performance
- Large package ecosystem (npm)

### Why PostgreSQL?
- ACID compliance for data integrity
- Advanced querying capabilities for property search
- JSON support for flexible data
- Robust and reliable

### Why Docker?
- Consistent development environment
- Easy deployment and scaling
- Isolated services
- Simple multi-container orchestration

## Performance Considerations

- **Database Indexing**: Indexes on search fields (location, price, type)
- **Caching**: Redis for frequently accessed data (future enhancement)
- **Image Optimization**: CDN for image delivery
- **Pagination**: Limit query results to improve response time
- **Lazy Loading**: Load images on demand in Flutter
- **Connection Pooling**: Database connection pooling for efficiency

## Scalability Strategy

- **Horizontal Scaling**: Multiple backend instances behind load balancer
- **Database Replication**: Read replicas for search queries
- **Microservices**: Split services as needed (messaging, search)
- **CDN**: Distribute static assets globally
- **Caching Layer**: Redis for session management and frequent queries

---

*"With Heaven's Door, the architecture is as precisely crafted as Rohan's manga panels!"*
