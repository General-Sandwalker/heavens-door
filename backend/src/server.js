require('dotenv').config();
const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const morgan = require('morgan');
const compression = require('compression');
const http = require('http');
const socketIo = require('socket.io');
const swaggerUi = require('swagger-ui-express');
const swaggerSpec = require('./config/swagger');
const db = require('./config/database');
const createDefaultAdmin = require('./utils/createAdmin');

// Import routes
const authRoutes = require('./routes/auth.routes');
const userRoutes = require('./routes/user.routes');
const propertyRoutes = require('./routes/property.routes');
const messageRoutes = require('./routes/message.routes');
const favoriteRoutes = require('./routes/favorite.routes');
const adminRoutes = require('./routes/admin.routes');

// Import middleware
const errorHandler = require('./middleware/errorHandler');
const rateLimiter = require('./middleware/rateLimiter');

// Initialize Express
const app = express();
const server = http.createServer(app);

// Initialize Socket.io
const io = socketIo(server, {
  cors: {
    origin: process.env.CORS_ORIGIN || '*',
    methods: ['GET', 'POST']
  }
});

// Middleware
app.use(helmet()); // Security headers
app.use(cors({
  origin: process.env.CORS_ORIGIN || '*',
  credentials: true
}));
app.use(compression()); // Compress responses
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(morgan('dev')); // Logging

// Apply rate limiting
app.use(rateLimiter);

// Swagger API Documentation
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec, {
  customCss: '.swagger-ui .topbar { background-color: #9B59B6; }',
  customSiteTitle: "Heaven's Door API Docs",
  customfavIcon: 'https://jojo.fandom.com/wiki/Heaven%27s_Door'
}));

// Swagger JSON endpoint
app.get('/api-docs.json', (req, res) => {
  res.setHeader('Content-Type', 'application/json');
  res.send(swaggerSpec);
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ 
    status: 'OK', 
    message: 'Heaven\'s Door is reading your request! 📖',
    timestamp: new Date().toISOString()
  });
});

// API Routes
app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/properties', propertyRoutes);
app.use('/api/messages', messageRoutes);
app.use('/api/favorites', favoriteRoutes);
app.use('/api/admin', adminRoutes);

// Socket.io connection handling
io.on('connection', (socket) => {
  console.log('🔗 New Stand user connected:', socket.id);

  // Join user's room
  socket.on('join', (userId) => {
    socket.join(`user_${userId}`);
    console.log(`📖 User ${userId} joined their room`);
  });

  // Handle private messages
  socket.on('send_message', (data) => {
    const { senderId, receiverId, message } = data;
    io.to(`user_${receiverId}`).emit('receive_message', {
      senderId,
      message,
      timestamp: new Date()
    });
  });

  // Handle typing indicator
  socket.on('typing', (data) => {
    socket.to(`user_${data.receiverId}`).emit('user_typing', {
      senderId: data.senderId,
      isTyping: data.isTyping
    });
  });

  socket.on('disconnect', () => {
    console.log('👋 Stand user disconnected:', socket.id);
  });
});

// Make io accessible to routes
app.set('io', io);

// 404 handler
app.use((req, res) => {
  res.status(404).json({ 
    error: 'Not Found',
    message: 'Heaven\'s Door cannot find this page! 🚫'
  });
});

// Error handling middleware
app.use(errorHandler);

// Start server
const PORT = process.env.PORT || 3000;

// Test database connection before starting server
db.testConnection()
  .then(async () => {
    // Create default admin account
    await createDefaultAdmin();
    
    server.listen(PORT, () => {
      console.log('═══════════════════════════════════════');
      console.log('🌟  HEAVEN\'S DOOR IS NOW ACTIVE! 🌟');
      console.log('═══════════════════════════════════════');
      console.log(`📖  Server running on port ${PORT}`);
      console.log(`🔗  API: http://localhost:${PORT}/api`);
      console.log(`💚  Health: http://localhost:${PORT}/health`);
      console.log(`📚  API Docs: http://localhost:${PORT}/api-docs`);
      console.log(`🗄️   Database: Connected to PostgreSQL`);
      console.log(`👑  Admin Panel: /api/admin/*`);
      console.log('═══════════════════════════════════════');
      console.log('   "I refuse!" - Rohan Kishibe');
      console.log('═══════════════════════════════════════');
    });
  })
  .catch((err) => {
    console.error('❌ Failed to connect to database:', err);
    process.exit(1);
  });

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('👋 SIGTERM received, shutting down gracefully...');
  server.close(() => {
    console.log('✅ Server closed');
    db.closePool();
    process.exit(0);
  });
});

module.exports = { app, server, io };
