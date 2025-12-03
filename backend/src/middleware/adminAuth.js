const jwt = require('jsonwebtoken');

/**
 * Middleware to verify admin access
 * Must be used after authMiddleware
 */
const adminMiddleware = async (req, res, next) => {
  try {
    // Check if user is authenticated
    if (!req.user) {
      return res.status(401).json({
        success: false,
        message: 'Authentication required'
      });
    }

    // Check if user has admin role
    if (req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        message: 'Access denied. Admin privileges required.'
      });
    }

    next();
  } catch (error) {
    console.error('Admin auth error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error during authorization'
    });
  }
};

/**
 * Middleware to verify super admin access (can manage other admins)
 */
const superAdminMiddleware = async (req, res, next) => {
  try {
    if (!req.user) {
      return res.status(401).json({
        success: false,
        message: 'Authentication required'
      });
    }

    // Super admin is identified by a flag or specific email
    const isSuperAdmin = req.user.email === process.env.ADMIN_EMAIL || req.user.is_super_admin;

    if (!isSuperAdmin && req.user.role !== 'admin') {
      return res.status(403).json({
        success: false,
        message: 'Access denied. Super admin privileges required.'
      });
    }

    req.user.isSuperAdmin = isSuperAdmin;
    next();
  } catch (error) {
    console.error('Super admin auth error:', error);
    res.status(500).json({
      success: false,
      message: 'Server error during authorization'
    });
  }
};

module.exports = {
  adminMiddleware,
  superAdminMiddleware
};
