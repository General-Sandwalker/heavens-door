const pool = require('../config/database');
const bcrypt = require('bcryptjs');

/**
 * Create default admin account from environment variables
 * This runs automatically on server startup
 */
const createDefaultAdmin = async () => {
  try {
    const {
      ADMIN_EMAIL,
      ADMIN_PASSWORD,
      ADMIN_FIRST_NAME,
      ADMIN_LAST_NAME
    } = process.env;

    // Validate required environment variables
    if (!ADMIN_EMAIL || !ADMIN_PASSWORD) {
      console.log('⚠️  Admin credentials not set in environment variables');
      return;
    }

    // Check if admin already exists
    const existingAdmin = await pool.query(
      'SELECT id, role FROM users WHERE email = $1',
      [ADMIN_EMAIL]
    );

    if (existingAdmin.rows.length > 0) {
      // Update existing user to admin if not already
      if (existingAdmin.rows[0].role !== 'admin') {
        await pool.query(
          'UPDATE users SET role = $1 WHERE email = $2',
          ['admin', ADMIN_EMAIL]
        );
        console.log(`✅ Updated existing user ${ADMIN_EMAIL} to admin role`);
      } else {
        console.log(`✅ Admin account already exists: ${ADMIN_EMAIL}`);
      }
      return;
    }

    // Create new admin account
    const hashedPassword = await bcrypt.hash(ADMIN_PASSWORD, 10);

    await pool.query(
      `INSERT INTO users (first_name, last_name, email, password_hash, role)
       VALUES ($1, $2, $3, $4, 'admin')`,
      [
        ADMIN_FIRST_NAME || 'Admin',
        ADMIN_LAST_NAME || 'User',
        ADMIN_EMAIL,
        hashedPassword
      ]
    );

    console.log('✅ Default admin account created successfully');
    console.log(`   Email: ${ADMIN_EMAIL}`);
    console.log(`   Role: admin (super admin)`);
    console.log('   🚨 Please change the default password after first login!');
  } catch (error) {
    console.error('❌ Error creating default admin:', error.message);
    // Don't throw error to prevent server crash
  }
};

module.exports = createDefaultAdmin;
