const express = require('express');
const router = express.Router();
const { authMiddleware } = require('../middleware/auth');
const messageController = require('../controllers/message.controller');

// All routes require authentication
router.use(authMiddleware);

// Routes
router.get('/', messageController.getConversations);
router.get('/conversation/:userId', messageController.getConversation);
router.post('/', messageController.sendMessage);
router.put('/:id/read', messageController.markAsRead);
router.delete('/:id', messageController.deleteMessage);

module.exports = router;
