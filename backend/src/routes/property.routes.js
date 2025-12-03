const express = require('express');
const router = express.Router();
const { authMiddleware, optionalAuth } = require('../middleware/auth');
const { body, query } = require('express-validator');
const propertyController = require('../controllers/property.controller');

// Validation middleware
const createPropertyValidation = [
  body('title').trim().notEmpty().isLength({ max: 255 }),
  body('description').trim().notEmpty(),
  body('propertyType').isIn(['house', 'apartment', 'condo', 'land', 'commercial', 'other']),
  body('listingType').isIn(['sale', 'rent']),
  body('price').isFloat({ min: 0 }),
  body('address').trim().notEmpty(),
  body('city').trim().notEmpty(),
  body('country').trim().notEmpty(),
  body('latitude').optional().isFloat({ min: -90, max: 90 }),
  body('longitude').optional().isFloat({ min: -180, max: 180 })
];

// Public routes (no auth required, but optional for favorites)
router.get('/', optionalAuth, propertyController.getProperties);
router.get('/search', optionalAuth, propertyController.searchProperties);
router.get('/:id', optionalAuth, propertyController.getPropertyById);

// Protected routes (require authentication)
router.use(authMiddleware);
router.post('/', createPropertyValidation, propertyController.createProperty);
router.put('/:id', propertyController.updateProperty);
router.delete('/:id', propertyController.deleteProperty);
router.get('/user/:userId', propertyController.getUserProperties);

module.exports = router;
