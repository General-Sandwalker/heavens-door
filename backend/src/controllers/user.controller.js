const { query } = require('../config/database');

// Get current user profile
exports.getProfile = async (req, res) => {
  try {
    const result = await query(
      `SELECT id, email, first_name, last_name, phone, avatar_url, bio, role, is_verified, created_at
       FROM users WHERE id = $1`,
      [req.user.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ 
        error: 'Not Found',
        message: 'User not found' 
      });
    }

    const user = result.rows[0];

    res.json({
      id: user.id,
      email: user.email,
      firstName: user.first_name,
      lastName: user.last_name,
      phone: user.phone,
      avatarUrl: user.avatar_url,
      bio: user.bio,
      role: user.role,
      isVerified: user.is_verified,
      createdAt: user.created_at
    });
  } catch (error) {
    console.error('Get profile error:', error);
    res.status(500).json({ 
      error: 'Server Error',
      message: 'Failed to retrieve profile' 
    });
  }
};

// Update user profile
exports.updateProfile = async (req, res) => {
  try {
    const { firstName, lastName, phone, bio, avatarUrl } = req.body;

    const result = await query(
      `UPDATE users 
       SET first_name = COALESCE($1, first_name),
           last_name = COALESCE($2, last_name),
           phone = COALESCE($3, phone),
           bio = COALESCE($4, bio),
           avatar_url = COALESCE($5, avatar_url)
       WHERE id = $6
       RETURNING id, email, first_name, last_name, phone, avatar_url, bio, role`,
      [firstName, lastName, phone, bio, avatarUrl, req.user.id]
    );

    const user = result.rows[0];

    res.json({
      message: 'Heaven\'s Door has updated your profile! ✨',
      user: {
        id: user.id,
        email: user.email,
        firstName: user.first_name,
        lastName: user.last_name,
        phone: user.phone,
        avatarUrl: user.avatar_url,
        bio: user.bio,
        role: user.role
      }
    });
  } catch (error) {
    console.error('Update profile error:', error);
    res.status(500).json({ 
      error: 'Server Error',
      message: 'Failed to update profile' 
    });
  }
};

// Get user by ID
exports.getUserById = async (req, res) => {
  try {
    const { id } = req.params;

    const result = await query(
      `SELECT id, first_name, last_name, avatar_url, bio, role, created_at
       FROM users WHERE id = $1`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ 
        error: 'Not Found',
        message: 'Heaven\'s Door cannot find this user!' 
      });
    }

    const user = result.rows[0];

    res.json({
      id: user.id,
      firstName: user.first_name,
      lastName: user.last_name,
      avatarUrl: user.avatar_url,
      bio: user.bio,
      role: user.role,
      createdAt: user.created_at
    });
  } catch (error) {
    console.error('Get user error:', error);
    res.status(500).json({ 
      error: 'Server Error',
      message: 'Failed to retrieve user' 
    });
  }
};

// Delete account
exports.deleteAccount = async (req, res) => {
  try {
    await query('DELETE FROM users WHERE id = $1', [req.user.id]);

    res.json({
      message: 'Heaven\'s Door has erased your account. Farewell! 👋'
    });
  } catch (error) {
    console.error('Delete account error:', error);
    res.status(500).json({ 
      error: 'Server Error',
      message: 'Failed to delete account' 
    });
  }
};
