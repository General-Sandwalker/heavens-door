const pool = require('../config/database');
const bcrypt = require('bcryptjs');

/**
 * Initialize default admin account from environment variables
 */
const initializeAdmin = async () => {
  try {
    const adminEmail = process.env.ADMIN_EMAIL;
    const adminPassword = process.env.ADMIN_PASSWORD;
    const adminFirstName = process.env.ADMIN_FIRST_NAME || 'Admin';
    const adminLastName = process.env.ADMIN_LAST_NAME || 'User';

    if (!adminEmail || !adminPassword) {
      console.log('⚠️  No admin credentials in environment variables. Skipping admin initialization.');
      return;
    }

    // Check if admin already exists
    const existingAdmin = await pool.query(
      'SELECT id, email, role FROM users WHERE email = $1',
      [adminEmail]
    );

    if (existingAdmin.rows.length > 0) {
      const existing = existingAdmin.rows[0];
      
      // Update to super_admin if not already
      if (existing.role !== 'super_admin') {
        await pool.query(
          'UPDATE users SET role = $1 WHERE id = $2',
          ['super_admin', existing.id]
        );
        console.log(`✅ Updated existing user ${adminEmail} to super_admin role`);
      } else {
        console.log(`ℹ️  Admin account already exists: ${adminEmail}`);
      }
      return;
    }

    // Create new super admin account
    const passwordHash = await bcrypt.hash(adminPassword, 10);
    
    const result = await pool.query(
      `INSERT INTO users (email, password_hash, first_name, last_name, role, is_verified)
       VALUES ($1, $2, $3, $4, 'super_admin', TRUE)
       RETURNING id, email, first_name, last_name, role`,
      [adminEmail, passwordHash, adminFirstName, adminLastName]
    );

    console.log('✅ Default super admin account created:');
    console.log(`   Email: ${result.rows[0].email}`);
    console.log(`   Name: ${result.rows[0].first_name} ${result.rows[0].last_name}`);
    console.log(`   Role: ${result.rows[0].role}`);
    console.log('⚠️  Make sure to change the password after first login!');
  } catch (error) {
    console.error('❌ Error initializing admin account:', error.message);
  }
};

module.exports = { initializeAdmin };
