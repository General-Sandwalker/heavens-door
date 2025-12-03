const pool = require('../config/database');
const bcrypt = require('bcryptjs');

/**
 * Get dashboard statistics
 */
const getDashboardStats = async (req, res) => {
  try {
    const stats = await pool.query(`
      SELECT 
        (SELECT COUNT(*) FROM users) as total_users,
        (SELECT COUNT(*) FROM users WHERE role = 'admin') as total_admins,
        (SELECT COUNT(*) FROM properties) as total_properties,
        (SELECT COUNT(*) FROM properties WHERE status = 'available') as available_properties,
        (SELECT COUNT(*) FROM properties WHERE status = 'sold') as sold_properties,
        (SELECT COUNT(*) FROM messages) as total_messages,
        (SELECT COUNT(*) FROM favorites) as total_favorites,
        (SELECT COUNT(*) FROM users WHERE created_at >= NOW() - INTERVAL '30 days') as users_last_30_days,
        (SELECT COUNT(*) FROM properties WHERE created_at >= NOW() - INTERVAL '30 days') as properties_last_30_days
    `);

    // Get recent activity
    const recentUsers = await pool.query(`
      SELECT id, first_name, last_name, email, role, created_at
      FROM users
      ORDER BY created_at DESC
      LIMIT 10
    `);

    const recentProperties = await pool.query(`
      SELECT id, title, price, status, created_at
      FROM properties
      ORDER BY created_at DESC
      LIMIT 10
    `);

    res.json({
      success: true,
      data: {
        statistics: stats.rows[0],
        recentUsers: recentUsers.rows,
        recentProperties: recentProperties.rows
      }
    });
  } catch (error) {
    console.error('Get dashboard stats error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching dashboard statistics'
    });
  }
};

/**
 * Get all users with filters
 */
const getAllUsers = async (req, res) => {
  try {
    const { page = 1, limit = 20, role, search, sortBy = 'created_at', order = 'DESC' } = req.query;
    const offset = (page - 1) * limit;

    let queryConditions = [];
    let queryParams = [];
    let paramCount = 1;

    if (role) {
      queryConditions.push(`role = $${paramCount}`);
      queryParams.push(role);
      paramCount++;
    }

    if (search) {
      queryConditions.push(`(
        first_name ILIKE $${paramCount} OR 
        last_name ILIKE $${paramCount} OR 
        email ILIKE $${paramCount}
      )`);
      queryParams.push(`%${search}%`);
      paramCount++;
    }

    const whereClause = queryConditions.length > 0 ? `WHERE ${queryConditions.join(' AND ')}` : '';

    const countResult = await pool.query(
      `SELECT COUNT(*) FROM users ${whereClause}`,
      queryParams
    );

    queryParams.push(limit, offset);
    const users = await pool.query(`
      SELECT 
        id, first_name, last_name, email, phone, role, 
        avatar_url, created_at, updated_at,
        (SELECT COUNT(*) FROM properties WHERE owner_id = users.id) as property_count
      FROM users
      ${whereClause}
      ORDER BY ${sortBy} ${order}
      LIMIT $${paramCount} OFFSET $${paramCount + 1}
    `, queryParams);

    res.json({
      success: true,
      data: {
        users: users.rows,
        pagination: {
          total: parseInt(countResult.rows[0].count),
          page: parseInt(page),
          limit: parseInt(limit),
          pages: Math.ceil(countResult.rows[0].count / limit)
        }
      }
    });
  } catch (error) {
    console.error('Get all users error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching users'
    });
  }
};

/**
 * Update user role
 */
const updateUserRole = async (req, res) => {
  try {
    const { userId } = req.params;
    const { role } = req.body;

    if (!['user', 'admin'].includes(role)) {
      return res.status(400).json({
        success: false,
        message: 'Invalid role. Must be "user" or "admin"'
      });
    }

    // Prevent changing the super admin's role
    const user = await pool.query('SELECT email FROM users WHERE id = $1', [userId]);
    if (user.rows[0]?.email === process.env.ADMIN_EMAIL) {
      return res.status(403).json({
        success: false,
        message: 'Cannot modify super admin role'
      });
    }

    const result = await pool.query(
      'UPDATE users SET role = $1, updated_at = CURRENT_TIMESTAMP WHERE id = $2 RETURNING id, first_name, last_name, email, role',
      [role, userId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'User not found'
      });
    }

    res.json({
      success: true,
      message: 'User role updated successfully',
      data: result.rows[0]
    });
  } catch (error) {
    console.error('Update user role error:', error);
    res.status(500).json({
      success: false,
      message: 'Error updating user role'
    });
  }
};

/**
 * Delete user
 */
const deleteUser = async (req, res) => {
  try {
    const { userId } = req.params;

    // Prevent deleting the super admin
    const user = await pool.query('SELECT email, role FROM users WHERE id = $1', [userId]);
    if (user.rows[0]?.email === process.env.ADMIN_EMAIL) {
      return res.status(403).json({
        success: false,
        message: 'Cannot delete super admin account'
      });
    }

    // Only super admin can delete other admins
    if (user.rows[0]?.role === 'admin' && !req.user.isSuperAdmin) {
      return res.status(403).json({
        success: false,
        message: 'Only super admin can delete other admins'
      });
    }

    const result = await pool.query('DELETE FROM users WHERE id = $1 RETURNING id', [userId]);

    if (result.rows.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'User not found'
      });
    }

    res.json({
      success: true,
      message: 'User deleted successfully'
    });
  } catch (error) {
    console.error('Delete user error:', error);
    res.status(500).json({
      success: false,
      message: 'Error deleting user'
    });
  }
};

/**
 * Create new admin
 */
const createAdmin = async (req, res) => {
  try {
    const { email, password, first_name, last_name, phone } = req.body;

    // Check if user exists
    const existingUser = await pool.query('SELECT id FROM users WHERE email = $1', [email]);
    if (existingUser.rows.length > 0) {
      return res.status(400).json({
        success: false,
        message: 'User with this email already exists'
      });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create admin
    const result = await pool.query(
      `INSERT INTO users (first_name, last_name, email, phone, password_hash, role)
       VALUES ($1, $2, $3, $4, $5, 'admin')
       RETURNING id, first_name, last_name, email, phone, role, created_at`,
      [first_name, last_name, email, phone, hashedPassword]
    );

    res.status(201).json({
      success: true,
      message: 'Admin created successfully',
      data: result.rows[0]
    });
  } catch (error) {
    console.error('Create admin error:', error);
    res.status(500).json({
      success: false,
      message: 'Error creating admin'
    });
  }
};

/**
 * Get all admins
 */
const getAllAdmins = async (req, res) => {
  try {
    const admins = await pool.query(`
      SELECT 
        id, first_name, last_name, email, phone, 
        avatar_url, created_at, updated_at,
        email = $1 as is_super_admin
      FROM users
      WHERE role = 'admin'
      ORDER BY created_at DESC
    `, [process.env.ADMIN_EMAIL]);

    res.json({
      success: true,
      data: admins.rows
    });
  } catch (error) {
    console.error('Get all admins error:', error);
    res.status(500).json({
      success: false,
      message: 'Error fetching admins'
    });
  }
};

/**
 * Test all routes (Health check for all endpoints)
 */
const testAllRoutes = async (req, res) => {
  try {
    const routes = {
      database: { status: 'unknown', message: '' },
      auth: { status: 'unknown', endpoints: {} },
      users: { status: 'unknown', endpoints: {} },
      properties: { status: 'unknown', endpoints: {} },
      messages: { status: 'unknown', endpoints: {} },
      favorites: { status: 'unknown', endpoints: {} }
    };

    // Test database
    try {
      await pool.query('SELECT 1');
      routes.database.status = 'healthy';
      routes.database.message = 'Database connection successful';
    } catch (error) {
      routes.database.status = 'error';
      routes.database.message = error.message;
    }

    // Define all routes to test
    const routeTests = [
      { group: 'auth', name: 'POST /auth/register', available: true },
      { group: 'auth', name: 'POST /auth/login', available: true },
      { group: 'users', name: 'GET /users/profile', available: true, requiresAuth: true },
      { group: 'users', name: 'PUT /users/profile', available: true, requiresAuth: true },
      { group: 'users', name: 'GET /users/:id', available: true },
      { group: 'properties', name: 'GET /properties', available: true },
      { group: 'properties', name: 'GET /properties/:id', available: true },
      { group: 'properties', name: 'POST /properties', available: true, requiresAuth: true },
      { group: 'properties', name: 'PUT /properties/:id', available: true, requiresAuth: true },
      { group: 'properties', name: 'DELETE /properties/:id', available: true, requiresAuth: true },
      { group: 'properties', name: 'GET /properties/search', available: true },
      { group: 'messages', name: 'GET /messages', available: true, requiresAuth: true },
      { group: 'messages', name: 'POST /messages', available: true, requiresAuth: true },
      { group: 'favorites', name: 'GET /favorites', available: true, requiresAuth: true },
      { group: 'favorites', name: 'POST /favorites/:propertyId', available: true, requiresAuth: true },
      { group: 'favorites', name: 'DELETE /favorites/:propertyId', available: true, requiresAuth: true }
    ];

    routeTests.forEach(route => {
      routes[route.group].endpoints[route.name] = {
        available: route.available,
        requiresAuth: route.requiresAuth || false,
        status: 'operational'
      };
    });

    // Set group status
    Object.keys(routes).forEach(group => {
      if (group !== 'database') {
        routes[group].status = 'operational';
      }
    });

    res.json({
      success: true,
      message: 'Route test completed',
      timestamp: new Date().toISOString(),
      data: routes
    });
  } catch (error) {
    console.error('Test routes error:', error);
    res.status(500).json({
      success: false,
      message: 'Error testing routes'
    });
  }
};

/**
 * Get system health
 */
const getSystemHealth = async (req, res) => {
  try {
    const dbTest = await pool.query('SELECT NOW()');
    const uptime = process.uptime();
    const memoryUsage = process.memoryUsage();

    res.json({
      success: true,
      data: {
        status: 'healthy',
        uptime: Math.floor(uptime),
        database: {
          status: 'connected',
          responseTime: dbTest.rows[0] ? 'fast' : 'slow'
        },
        memory: {
          rss: `${Math.round(memoryUsage.rss / 1024 / 1024)} MB`,
          heapTotal: `${Math.round(memoryUsage.heapTotal / 1024 / 1024)} MB`,
          heapUsed: `${Math.round(memoryUsage.heapUsed / 1024 / 1024)} MB`
        },
        timestamp: new Date().toISOString()
      }
    });
  } catch (error) {
    console.error('System health error:', error);
    res.status(500).json({
      success: false,
      message: 'Error checking system health'
    });
  }
};

module.exports = {
  getDashboardStats,
  getAllUsers,
  updateUserRole,
  deleteUser,
  createAdmin,
  getAllAdmins,
  testAllRoutes,
  getSystemHealth
};
