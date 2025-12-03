const express = require('express');
const router = express.Router();
const { authMiddleware } = require('../middleware/auth');
const favoriteController = require('../controllers/favorite.controller');

// All routes require authentication
router.use(authMiddleware);

// Routes
router.get('/', favoriteController.getFavorites);
router.post('/:propertyId', favoriteController.addFavorite);
router.delete('/:propertyId', favoriteController.removeFavorite);
router.get('/check/:propertyId', favoriteController.checkFavorite);

module.exports = router;
