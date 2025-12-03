const express = require('express');
const router = express.Router();
const { authMiddleware } = require('../middleware/auth');
const userController = require('../controllers/user.controller');

// All routes require authentication
router.use(authMiddleware);

// Routes
router.get('/profile', userController.getProfile);
router.put('/profile', userController.updateProfile);
router.get('/:id', userController.getUserById);
router.delete('/account', userController.deleteAccount);

module.exports = router;
