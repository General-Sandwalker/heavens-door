const { query } = require('../config/database');

// Get all favorites for current user
exports.getFavorites = async (req, res) => {
  try {
    const result = await query(
      `SELECT p.*, f.created_at as favorited_at,
        u.first_name, u.last_name, u.email, u.avatar_url
      FROM favorites f
      JOIN properties p ON f.property_id = p.id
      JOIN users u ON p.owner_id = u.id
      WHERE f.user_id = $1
      ORDER BY f.created_at DESC`,
      [req.user.id]
    );

    res.json({
      favorites: result.rows.map(p => ({
        id: p.id,
        title: p.title,
        description: p.description,
        propertyType: p.property_type,
        listingType: p.listing_type,
        price: parseFloat(p.price),
        address: p.address,
        city: p.city,
        state: p.state,
        country: p.country,
        latitude: p.latitude ? parseFloat(p.latitude) : null,
        longitude: p.longitude ? parseFloat(p.longitude) : null,
        bedrooms: p.bedrooms,
        bathrooms: p.bathrooms ? parseFloat(p.bathrooms) : null,
        areaSqft: p.area_sqft,
        images: p.images,
        amenities: p.amenities,
        owner: {
          firstName: p.first_name,
          lastName: p.last_name,
          email: p.email,
          avatarUrl: p.avatar_url
        },
        favoritedAt: p.favorited_at,
        createdAt: p.created_at
      }))
    });
  } catch (error) {
    console.error('Get favorites error:', error);
    res.status(500).json({ 
      error: 'Server Error',
      message: 'Failed to retrieve favorites' 
    });
  }
};

// Add property to favorites
exports.addFavorite = async (req, res) => {
  try {
    const { propertyId } = req.params;

    // Check if property exists
    const propertyCheck = await query(
      'SELECT id FROM properties WHERE id = $1',
      [propertyId]
    );

    if (propertyCheck.rows.length === 0) {
      return res.status(404).json({ 
        error: 'Not Found',
        message: 'Heaven\'s Door cannot find this property!' 
      });
    }

    // Check if already favorited
    const existingFav = await query(
      'SELECT id FROM favorites WHERE user_id = $1 AND property_id = $2',
      [req.user.id, propertyId]
    );

    if (existingFav.rows.length > 0) {
      return res.status(409).json({ 
        error: 'Conflict',
        message: 'Heaven\'s Door has already bookmarked this property for you!' 
      });
    }

    const result = await query(
      'INSERT INTO favorites (user_id, property_id) VALUES ($1, $2) RETURNING *',
      [req.user.id, propertyId]
    );

    // Create notification for property owner
    const property = await query('SELECT owner_id FROM properties WHERE id = $1', [propertyId]);
    
    await query(
      `INSERT INTO notifications (user_id, title, message, type, reference_id)
       VALUES ($1, $2, $3, $4, $5)`,
      [
        property.rows[0].owner_id,
        'New Favorite',
        'Someone favorited your property!',
        'favorite',
        propertyId
      ]
    );

    res.status(201).json({
      message: 'Heaven\'s Door has bookmarked this property! ⭐',
      favorite: result.rows[0]
    });
  } catch (error) {
    console.error('Add favorite error:', error);
    res.status(500).json({ 
      error: 'Server Error',
      message: 'Failed to add favorite' 
    });
  }
};

// Remove property from favorites
exports.removeFavorite = async (req, res) => {
  try {
    const { propertyId } = req.params;

    const result = await query(
      'DELETE FROM favorites WHERE user_id = $1 AND property_id = $2',
      [req.user.id, propertyId]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ 
        error: 'Not Found',
        message: 'Favorite not found' 
      });
    }

    res.json({
      message: 'Heaven\'s Door has removed this bookmark! 🗑️'
    });
  } catch (error) {
    console.error('Remove favorite error:', error);
    res.status(500).json({ 
      error: 'Server Error',
      message: 'Failed to remove favorite' 
    });
  }
};

// Check if property is favorited
exports.checkFavorite = async (req, res) => {
  try {
    const { propertyId } = req.params;

    const result = await query(
      'SELECT id FROM favorites WHERE user_id = $1 AND property_id = $2',
      [req.user.id, propertyId]
    );

    res.json({
      isFavorited: result.rows.length > 0
    });
  } catch (error) {
    console.error('Check favorite error:', error);
    res.status(500).json({ 
      error: 'Server Error',
      message: 'Failed to check favorite status' 
    });
  }
};
