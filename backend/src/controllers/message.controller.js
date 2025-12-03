const { query } = require('../config/database');

// Get all conversations for current user
exports.getConversations = async (req, res) => {
  try {
    const result = await query(
      `SELECT DISTINCT ON (other_user_id)
        m.id, m.content, m.is_read, m.created_at,
        CASE 
          WHEN m.sender_id = $1 THEN m.receiver_id
          ELSE m.sender_id
        END as other_user_id,
        u.first_name, u.last_name, u.avatar_url
      FROM messages m
      JOIN users u ON (
        CASE 
          WHEN m.sender_id = $1 THEN m.receiver_id = u.id
          ELSE m.sender_id = u.id
        END
      )
      WHERE m.sender_id = $1 OR m.receiver_id = $1
      ORDER BY other_user_id, m.created_at DESC`,
      [req.user.id]
    );

    res.json({
      conversations: result.rows.map(row => ({
        userId: row.other_user_id,
        firstName: row.first_name,
        lastName: row.last_name,
        avatarUrl: row.avatar_url,
        lastMessage: {
          id: row.id,
          content: row.content,
          isRead: row.is_read,
          createdAt: row.created_at
        }
      }))
    });
  } catch (error) {
    console.error('Get conversations error:', error);
    res.status(500).json({ 
      error: 'Server Error',
      message: 'Failed to retrieve conversations' 
    });
  }
};

// Get conversation with specific user
exports.getConversation = async (req, res) => {
  try {
    const { userId } = req.params;
    const { page = 1, limit = 50 } = req.query;
    const offset = (page - 1) * limit;

    const result = await query(
      `SELECT m.*, 
        sender.first_name as sender_first_name, sender.last_name as sender_last_name,
        sender.avatar_url as sender_avatar_url,
        receiver.first_name as receiver_first_name, receiver.last_name as receiver_last_name,
        receiver.avatar_url as receiver_avatar_url
      FROM messages m
      JOIN users sender ON m.sender_id = sender.id
      JOIN users receiver ON m.receiver_id = receiver.id
      WHERE (m.sender_id = $1 AND m.receiver_id = $2) 
         OR (m.sender_id = $2 AND m.receiver_id = $1)
      ORDER BY m.created_at DESC
      LIMIT $3 OFFSET $4`,
      [req.user.id, userId, limit, offset]
    );

    res.json({
      messages: result.rows.map(m => ({
        id: m.id,
        senderId: m.sender_id,
        receiverId: m.receiver_id,
        content: m.content,
        propertyId: m.property_id,
        isRead: m.is_read,
        sender: {
          firstName: m.sender_first_name,
          lastName: m.sender_last_name,
          avatarUrl: m.sender_avatar_url
        },
        receiver: {
          firstName: m.receiver_first_name,
          lastName: m.receiver_last_name,
          avatarUrl: m.receiver_avatar_url
        },
        createdAt: m.created_at
      })).reverse() // Show oldest first
    });
  } catch (error) {
    console.error('Get conversation error:', error);
    res.status(500).json({ 
      error: 'Server Error',
      message: 'Failed to retrieve conversation' 
    });
  }
};

// Send message
exports.sendMessage = async (req, res) => {
  try {
    const { receiverId, content, propertyId } = req.body;

    if (!receiverId || !content) {
      return res.status(400).json({ 
        error: 'Bad Request',
        message: 'Receiver and content are required' 
      });
    }

    const result = await query(
      `INSERT INTO messages (sender_id, receiver_id, content, property_id)
       VALUES ($1, $2, $3, $4)
       RETURNING *`,
      [req.user.id, receiverId, content, propertyId || null]
    );

    const message = result.rows[0];

    // Emit socket event
    const io = req.app.get('io');
    io.to(`user_${receiverId}`).emit('receive_message', {
      id: message.id,
      senderId: message.sender_id,
      content: message.content,
      propertyId: message.property_id,
      createdAt: message.created_at
    });

    // Create notification
    await query(
      `INSERT INTO notifications (user_id, title, message, type, reference_id)
       VALUES ($1, $2, $3, $4, $5)`,
      [
        receiverId,
        'New Message',
        `You have a new message from ${req.user.email}`,
        'message',
        message.id
      ]
    );

    res.status(201).json({
      message: 'Heaven\'s Door has delivered your message! 📬',
      data: message
    });
  } catch (error) {
    console.error('Send message error:', error);
    res.status(500).json({ 
      error: 'Server Error',
      message: 'Failed to send message' 
    });
  }
};

// Mark message as read
exports.markAsRead = async (req, res) => {
  try {
    const { id } = req.params;

    await query(
      `UPDATE messages SET is_read = true 
       WHERE id = $1 AND receiver_id = $2`,
      [id, req.user.id]
    );

    res.json({
      message: 'Heaven\'s Door has read your message! 👁️'
    });
  } catch (error) {
    console.error('Mark as read error:', error);
    res.status(500).json({ 
      error: 'Server Error',
      message: 'Failed to mark message as read' 
    });
  }
};

// Delete message
exports.deleteMessage = async (req, res) => {
  try {
    const { id } = req.params;

    // Only sender can delete
    const result = await query(
      'DELETE FROM messages WHERE id = $1 AND sender_id = $2',
      [id, req.user.id]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ 
        error: 'Not Found',
        message: 'Message not found or you are not authorized to delete it' 
      });
    }

    res.json({
      message: 'Heaven\'s Door has erased your message! 🗑️'
    });
  } catch (error) {
    console.error('Delete message error:', error);
    res.status(500).json({ 
      error: 'Server Error',
      message: 'Failed to delete message' 
    });
  }
};
