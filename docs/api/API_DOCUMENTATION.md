# Heaven's Door API Documentation

## Base URL
```
http://localhost:3000/api
```

## Authentication
Most endpoints require authentication using JWT tokens. Include the token in the Authorization header:
```
Authorization: Bearer <token>
```

---

## Authentication Endpoints

### POST /auth/register
Register a new user.

**Request Body:**
```json
{
  "email": "rohan@kishibe.com",
  "password": "standpower123",
  "firstName": "Rohan",
  "lastName": "Kishibe",
  "phone": "+1234567890"
}
```

**Response:**
```json
{
  "message": "Heaven's Door welcomes you! Registration successful! 📖",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "uuid",
    "email": "rohan@kishibe.com",
    "firstName": "Rohan",
    "lastName": "Kishibe",
    "role": "user",
    "createdAt": "2024-01-01T00:00:00.000Z"
  }
}
```

### POST /auth/login
Login an existing user.

**Request Body:**
```json
{
  "email": "rohan@kishibe.com",
  "password": "standpower123"
}
```

**Response:**
```json
{
  "message": "Heaven's Door has opened! Login successful! 🌟",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": "uuid",
    "email": "rohan@kishibe.com",
    "firstName": "Rohan",
    "lastName": "Kishibe",
    "role": "user",
    "avatarUrl": null
  }
}
```

---

## User Endpoints

### GET /users/profile
Get current user profile. **Requires authentication.**

**Response:**
```json
{
  "id": "uuid",
  "email": "rohan@kishibe.com",
  "firstName": "Rohan",
  "lastName": "Kishibe",
  "phone": "+1234567890",
  "avatarUrl": "https://...",
  "bio": "Manga artist",
  "role": "user",
  "isVerified": true,
  "createdAt": "2024-01-01T00:00:00.000Z"
}
```

### PUT /users/profile
Update user profile. **Requires authentication.**

**Request Body:**
```json
{
  "firstName": "Rohan",
  "lastName": "Kishibe",
  "phone": "+1234567890",
  "bio": "Professional manga artist",
  "avatarUrl": "https://..."
}
```

---

## Property Endpoints

### GET /properties
Get all properties with optional filters.

**Query Parameters:**
- `type`: Property type (house, apartment, condo, land, commercial, other)
- `listingType`: sale or rent
- `minPrice`: Minimum price
- `maxPrice`: Maximum price
- `city`: City name
- `bedrooms`: Minimum number of bedrooms
- `bathrooms`: Minimum number of bathrooms
- `page`: Page number (default: 1)
- `limit`: Items per page (default: 20)

**Response:**
```json
{
  "properties": [
    {
      "id": "uuid",
      "title": "Beautiful 3BR House",
      "description": "Spacious house with garden",
      "propertyType": "house",
      "listingType": "sale",
      "price": 350000,
      "address": "123 Main St",
      "city": "Tokyo",
      "country": "Japan",
      "latitude": 35.6762,
      "longitude": 139.6503,
      "bedrooms": 3,
      "bathrooms": 2,
      "areaSqft": 2000,
      "yearBuilt": 2020,
      "status": "active",
      "images": ["url1", "url2"],
      "amenities": ["parking", "garden"],
      "viewsCount": 150,
      "favoriteCount": 25,
      "isFavorited": false,
      "owner": {
        "id": "uuid",
        "firstName": "Rohan",
        "lastName": "Kishibe",
        "email": "rohan@kishibe.com",
        "phone": "+1234567890",
        "avatarUrl": null
      },
      "createdAt": "2024-01-01T00:00:00.000Z",
      "updatedAt": "2024-01-01T00:00:00.000Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "pages": 5
  }
}
```

### GET /properties/:id
Get property by ID.

### GET /properties/search?q=query
Search properties by text.

### POST /properties
Create a new property. **Requires authentication.**

**Request Body:**
```json
{
  "title": "Beautiful 3BR House",
  "description": "Spacious house with garden",
  "propertyType": "house",
  "listingType": "sale",
  "price": 350000,
  "address": "123 Main St",
  "city": "Tokyo",
  "state": "Tokyo",
  "country": "Japan",
  "postalCode": "100-0001",
  "latitude": 35.6762,
  "longitude": 139.6503,
  "bedrooms": 3,
  "bathrooms": 2,
  "areaSqft": 2000,
  "yearBuilt": 2020,
  "images": ["url1", "url2"],
  "amenities": ["parking", "garden"]
}
```

### PUT /properties/:id
Update property. **Requires authentication and ownership.**

### DELETE /properties/:id
Delete property. **Requires authentication and ownership.**

---

## Favorite Endpoints

### GET /favorites
Get user's favorite properties. **Requires authentication.**

### POST /favorites/:propertyId
Add property to favorites. **Requires authentication.**

### DELETE /favorites/:propertyId
Remove property from favorites. **Requires authentication.**

### GET /favorites/check/:propertyId
Check if property is favorited. **Requires authentication.**

---

## Message Endpoints

### GET /messages
Get all conversations. **Requires authentication.**

**Response:**
```json
{
  "conversations": [
    {
      "userId": "uuid",
      "firstName": "Josuke",
      "lastName": "Higashikata",
      "avatarUrl": null,
      "lastMessage": {
        "id": "uuid",
        "content": "Is this property still available?",
        "isRead": false,
        "createdAt": "2024-01-01T00:00:00.000Z"
      }
    }
  ]
}
```

### GET /messages/conversation/:userId
Get conversation with specific user. **Requires authentication.**

### POST /messages
Send a message. **Requires authentication.**

**Request Body:**
```json
{
  "receiverId": "uuid",
  "content": "Hello, is this property still available?",
  "propertyId": "uuid"
}
```

### PUT /messages/:id/read
Mark message as read. **Requires authentication.**

### DELETE /messages/:id
Delete message. **Requires authentication.**

---

## WebSocket Events

### Connection
```javascript
const socket = io('http://localhost:3000');
```

### Join User Room
```javascript
socket.emit('join', userId);
```

### Send Message
```javascript
socket.emit('send_message', {
  senderId: 'uuid',
  receiverId: 'uuid',
  message: 'Hello!'
});
```

### Receive Message
```javascript
socket.on('receive_message', (data) => {
  console.log(data.senderId, data.message, data.timestamp);
});
```

### Typing Indicator
```javascript
socket.emit('typing', {
  senderId: 'uuid',
  receiverId: 'uuid',
  isTyping: true
});
```

---

## Error Responses

### 400 Bad Request
```json
{
  "error": "Bad Request",
  "message": "Invalid input data"
}
```

### 401 Unauthorized
```json
{
  "error": "Unauthorized",
  "message": "Invalid or expired token"
}
```

### 404 Not Found
```json
{
  "error": "Not Found",
  "message": "Resource not found"
}
```

### 500 Internal Server Error
```json
{
  "error": "Server Error",
  "message": "Something went wrong"
}
```

---

## Rate Limiting
- 100 requests per 15 minutes per IP
- Exceeding the limit returns 429 Too Many Requests

---

*"I refuse to give bad documentation!" - Rohan Kishibe (probably)*
