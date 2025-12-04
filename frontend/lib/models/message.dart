class Message {
  final int id;
  final int senderId;
  final int receiverId;
  final int? propertyId;
  final String content;
  final bool isRead;
  final DateTime createdAt;
  final String? senderName;
  final String? receiverName;
  final String? propertyTitle;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    this.propertyId,
    required this.content,
    required this.isRead,
    required this.createdAt,
    this.senderName,
    this.receiverName,
    this.propertyTitle,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      propertyId: json['property_id'],
      content: json['content'],
      isRead: json['is_read'],
      createdAt: DateTime.parse(json['created_at']),
      senderName: json['sender_name'],
      receiverName: json['receiver_name'],
      propertyTitle: json['property_title'],
    );
  }
}

class MessageCreate {
  final int receiverId;
  final int? propertyId;
  final String content;

  MessageCreate({
    required this.receiverId,
    this.propertyId,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'receiver_id': receiverId,
      'property_id': propertyId,
      'content': content,
    };
  }
}

class Conversation {
  final int userId;
  final String userName;
  final String userEmail;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final int? propertyId;
  final String? propertyTitle;

  Conversation({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.unreadCount,
    this.propertyId,
    this.propertyTitle,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      userId: json['user_id'],
      userName: json['user_name'],
      userEmail: json['user_email'],
      lastMessage: json['last_message'],
      lastMessageTime: DateTime.parse(json['last_message_time']),
      unreadCount: json['unread_count'],
      propertyId: json['property_id'],
      propertyTitle: json['property_title'],
    );
  }
}
