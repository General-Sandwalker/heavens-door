const { query } = require('../config/database');
const { validationResult } = require('express-validator');

// Get all properties with filtering
exports.getProperties = async (req, res) => {
  try {
    const { 
      type, 
      listingType, 
      minPrice, 
      maxPrice, 
      city, 
      bedrooms,
      bathrooms,
      status = 'active',
      page = 1, 
      limit = 20 
    } = req.query;

    let queryText = `
      SELECT p.*, 
             u.first_name, u.last_name, u.email, u.phone, u.avatar_url,
             (SELECT COUNT(*) FROM favorites WHERE property_id = p.id) as favorite_count
      FROM properties p
      JOIN users u ON p.owner_id = u.id
      WHERE p.status = $1
    `;
    
    const queryParams = [status];
    let paramCount = 1;

    if (type) {
      paramCount++;
      queryText += ` AND p.property_type = $${paramCount}`;
      queryParams.push(type);
    }

    if (listingType) {
      paramCount++;
      queryText += ` AND p.listing_type = $${paramCount}`;
      queryParams.push(listingType);
    }

    if (minPrice) {
      paramCount++;
      queryText += ` AND p.price >= $${paramCount}`;
      queryParams.push(minPrice);
    }

    if (maxPrice) {
      paramCount++;
      queryText += ` AND p.price <= $${paramCount}`;
      queryParams.push(maxPrice);
    }

    if (city) {
      paramCount++;
      queryText += ` AND LOWER(p.city) = LOWER($${paramCount})`;
      queryParams.push(city);
    }

    if (bedrooms) {
      paramCount++;
      queryText += ` AND p.bedrooms >= $${paramCount}`;
      queryParams.push(bedrooms);
    }

    if (bathrooms) {
      paramCount++;
      queryText += ` AND p.bathrooms >= $${paramCount}`;
      queryParams.push(bathrooms);
    }

    // Add user's favorites if authenticated
    if (req.user) {
      queryText = queryText.replace(
        'FROM properties p',
        `FROM properties p
         LEFT JOIN favorites f ON p.id = f.property_id AND f.user_id = '${req.user.id}'`
      );
      queryText = queryText.replace(
        'SELECT p.*,',
        'SELECT p.*, (f.id IS NOT NULL) as is_favorited,'
      );
    }

    queryText += ` ORDER BY p.created_at DESC`;

    // Pagination
    const offset = (page - 1) * limit;
    paramCount++;
    queryText += ` LIMIT $${paramCount}`;
    queryParams.push(limit);
    
    paramCount++;
    queryText += ` OFFSET $${paramCount}`;
    queryParams.push(offset);

    const result = await query(queryText, queryParams);

    // Get total count
    let countQuery = `SELECT COUNT(*) FROM properties WHERE status = $1`;
    const countParams = [status];
    
    const countResult = await query(countQuery, countParams);
    const totalCount = parseInt(countResult.rows[0].count);

    res.json({
      properties: result.rows.map(p => ({
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
        postalCode: p.postal_code,
        latitude: p.latitude ? parseFloat(p.latitude) : null,
        longitude: p.longitude ? parseFloat(p.longitude) : null,
        bedrooms: p.bedrooms,
        bathrooms: p.bathrooms ? parseFloat(p.bathrooms) : null,
        areaSqft: p.area_sqft,
        yearBuilt: p.year_built,
        status: p.status,
        images: p.images,
        amenities: p.amenities,
        viewsCount: p.views_count,
        favoriteCount: parseInt(p.favorite_count),
        isFavorited: p.is_favorited || false,
        owner: {
          id: p.owner_id,
          firstName: p.first_name,
          lastName: p.last_name,
          email: p.email,
          phone: p.phone,
          avatarUrl: p.avatar_url
        },
        createdAt: p.created_at,
        updatedAt: p.updated_at
      })),
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total: totalCount,
        pages: Math.ceil(totalCount / limit)
      }
    });
  } catch (error) {
    console.error('Get properties error:', error);
    res.status(500).json({ 
      error: 'Server Error',
      message: 'Failed to retrieve properties' 
    });
  }
};

// Search properties with text search
exports.searchProperties = async (req, res) => {
  try {
    const { q, page = 1, limit = 20 } = req.query;

    if (!q) {
      return res.status(400).json({ 
        error: 'Bad Request',
        message: 'Search query is required' 
      });
    }

    const searchTerm = `%${q}%`;
    const offset = (page - 1) * limit;

    const queryText = `
      SELECT p.*, 
             u.first_name, u.last_name, u.email, u.phone, u.avatar_url,
             (SELECT COUNT(*) FROM favorites WHERE property_id = p.id) as favorite_count
      FROM properties p
      JOIN users u ON p.owner_id = u.id
      WHERE p.status = 'active' AND (
        LOWER(p.title) LIKE LOWER($1) OR
        LOWER(p.description) LIKE LOWER($1) OR
        LOWER(p.city) LIKE LOWER($1) OR
        LOWER(p.address) LIKE LOWER($1)
      )
      ORDER BY p.created_at DESC
      LIMIT $2 OFFSET $3
    `;

    const result = await query(queryText, [searchTerm, limit, offset]);

    res.json({
      properties: result.rows.map(p => ({
        id: p.id,
        title: p.title,
        description: p.description,
        propertyType: p.property_type,
        listingType: p.listing_type,
        price: parseFloat(p.price),
        city: p.city,
        images: p.images,
        owner: {
          firstName: p.first_name,
          lastName: p.last_name
        },
        createdAt: p.created_at
      })),
      searchQuery: q
    });
  } catch (error) {
    console.error('Search properties error:', error);
    res.status(500).json({ 
      error: 'Server Error',
      message: 'Search failed' 
    });
  }
};

// Get property by ID
exports.getPropertyById = async (req, res) => {
  try {
    const { id } = req.params;

    let queryText = `
      SELECT p.*, 
             u.first_name, u.last_name, u.email, u.phone, u.avatar_url, u.bio,
             (SELECT COUNT(*) FROM favorites WHERE property_id = p.id) as favorite_count
      FROM properties p
      JOIN users u ON p.owner_id = u.id
      WHERE p.id = $1
    `;

    const result = await query(queryText, [id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ 
        error: 'Not Found',
        message: 'Heaven\'s Door cannot find this property!' 
      });
    }

    const p = result.rows[0];

    // Increment view count
    await query('UPDATE properties SET views_count = views_count + 1 WHERE id = $1', [id]);

    // Check if favorited by current user
    let isFavorited = false;
    if (req.user) {
      const favResult = await query(
        'SELECT id FROM favorites WHERE user_id = $1 AND property_id = $2',
        [req.user.id, id]
      );
      isFavorited = favResult.rows.length > 0;
    }

    res.json({
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
      postalCode: p.postal_code,
      latitude: p.latitude ? parseFloat(p.latitude) : null,
      longitude: p.longitude ? parseFloat(p.longitude) : null,
      bedrooms: p.bedrooms,
      bathrooms: p.bathrooms ? parseFloat(p.bathrooms) : null,
      areaSqft: p.area_sqft,
      yearBuilt: p.year_built,
      status: p.status,
      images: p.images,
      amenities: p.amenities,
      viewsCount: p.views_count + 1,
      favoriteCount: parseInt(p.favorite_count),
      isFavorited,
      owner: {
        id: p.owner_id,
        firstName: p.first_name,
        lastName: p.last_name,
        email: p.email,
        phone: p.phone,
        avatarUrl: p.avatar_url,
        bio: p.bio
      },
      createdAt: p.created_at,
      updatedAt: p.updated_at
    });
  } catch (error) {
    console.error('Get property error:', error);
    res.status(500).json({ 
      error: 'Server Error',
      message: 'Failed to retrieve property' 
    });
  }
};

// Create property
exports.createProperty = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const {
      title, description, propertyType, listingType, price,
      address, city, state, country, postalCode,
      latitude, longitude, bedrooms, bathrooms, areaSqft, yearBuilt,
      images, amenities
    } = req.body;

    const result = await query(
      `INSERT INTO properties (
        owner_id, title, description, property_type, listing_type, price,
        address, city, state, country, postal_code,
        latitude, longitude, bedrooms, bathrooms, area_sqft, year_built,
        images, amenities
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19)
      RETURNING *`,
      [
        req.user.id, title, description, propertyType, listingType, price,
        address, city, state, country, postalCode,
        latitude, longitude, bedrooms, bathrooms, areaSqft, yearBuilt,
        JSON.stringify(images || []), JSON.stringify(amenities || [])
      ]
    );

    res.status(201).json({
      message: 'Heaven\'s Door has written your property! 📖✨',
      property: result.rows[0]
    });
  } catch (error) {
    console.error('Create property error:', error);
    res.status(500).json({ 
      error: 'Server Error',
      message: 'Failed to create property' 
    });
  }
};

// Update property
exports.updateProperty = async (req, res) => {
  try {
    const { id } = req.params;

    // Check ownership
    const ownerCheck = await query(
      'SELECT owner_id FROM properties WHERE id = $1',
      [id]
    );

    if (ownerCheck.rows.length === 0) {
      return res.status(404).json({ 
        error: 'Not Found',
        message: 'Property not found' 
      });
    }

    if (ownerCheck.rows[0].owner_id !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({ 
        error: 'Forbidden',
        message: 'Heaven\'s Door denies access! You can only edit your own properties.' 
      });
    }

    const {
      title, description, propertyType, listingType, price,
      address, city, state, country, postalCode,
      latitude, longitude, bedrooms, bathrooms, areaSqft, yearBuilt,
      status, images, amenities
    } = req.body;

    const result = await query(
      `UPDATE properties SET
        title = COALESCE($1, title),
        description = COALESCE($2, description),
        property_type = COALESCE($3, property_type),
        listing_type = COALESCE($4, listing_type),
        price = COALESCE($5, price),
        address = COALESCE($6, address),
        city = COALESCE($7, city),
        state = COALESCE($8, state),
        country = COALESCE($9, country),
        postal_code = COALESCE($10, postal_code),
        latitude = COALESCE($11, latitude),
        longitude = COALESCE($12, longitude),
        bedrooms = COALESCE($13, bedrooms),
        bathrooms = COALESCE($14, bathrooms),
        area_sqft = COALESCE($15, area_sqft),
        year_built = COALESCE($16, year_built),
        status = COALESCE($17, status),
        images = COALESCE($18, images),
        amenities = COALESCE($19, amenities)
      WHERE id = $20
      RETURNING *`,
      [
        title, description, propertyType, listingType, price,
        address, city, state, country, postalCode,
        latitude, longitude, bedrooms, bathrooms, areaSqft, yearBuilt,
        status, 
        images ? JSON.stringify(images) : null,
        amenities ? JSON.stringify(amenities) : null,
        id
      ]
    );

    res.json({
      message: 'Heaven\'s Door has rewritten your property! ✨',
      property: result.rows[0]
    });
  } catch (error) {
    console.error('Update property error:', error);
    res.status(500).json({ 
      error: 'Server Error',
      message: 'Failed to update property' 
    });
  }
};

// Delete property
exports.deleteProperty = async (req, res) => {
  try {
    const { id } = req.params;

    // Check ownership
    const ownerCheck = await query(
      'SELECT owner_id FROM properties WHERE id = $1',
      [id]
    );

    if (ownerCheck.rows.length === 0) {
      return res.status(404).json({ 
        error: 'Not Found',
        message: 'Property not found' 
      });
    }

    if (ownerCheck.rows[0].owner_id !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).json({ 
        error: 'Forbidden',
        message: 'You can only delete your own properties' 
      });
    }

    await query('DELETE FROM properties WHERE id = $1', [id]);

    res.json({
      message: 'Heaven\'s Door has erased your property! 🗑️'
    });
  } catch (error) {
    console.error('Delete property error:', error);
    res.status(500).json({ 
      error: 'Server Error',
      message: 'Failed to delete property' 
    });
  }
};

// Get user's properties
exports.getUserProperties = async (req, res) => {
  try {
    const { userId } = req.params;
    const { page = 1, limit = 20 } = req.query;
    const offset = (page - 1) * limit;

    const result = await query(
      `SELECT * FROM properties 
       WHERE owner_id = $1 
       ORDER BY created_at DESC 
       LIMIT $2 OFFSET $3`,
      [userId, limit, offset]
    );

    res.json({
      properties: result.rows
    });
  } catch (error) {
    console.error('Get user properties error:', error);
    res.status(500).json({ 
      error: 'Server Error',
      message: 'Failed to retrieve properties' 
    });
  }
};
