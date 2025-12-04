from sqlalchemy.orm import Session
from sqlalchemy import or_, and_, func
from app.models.message import Message
from app.models.user import User
from app.models.property import Property
from app.schemas.message import MessageCreate
from typing import List, Optional

class MessageController:
    @staticmethod
    def create_message(db: Session, sender_id: int, message_data: MessageCreate) -> Message:
        """Create a new message"""
        message = Message(
            sender_id=sender_id,
            receiver_id=message_data.receiver_id,
            property_id=message_data.property_id,
            content=message_data.content,
            is_read=False
        )
        db.add(message)
        db.commit()
        db.refresh(message)
        return message

    @staticmethod
    def get_conversation(
        db: Session,
        user_id: int,
        other_user_id: int,
        property_id: Optional[int] = None
    ) -> List[Message]:
        """Get all messages in a conversation between two users"""
        query = db.query(Message).filter(
            or_(
                and_(
                    Message.sender_id == user_id,
                    Message.receiver_id == other_user_id
                ),
                and_(
                    Message.sender_id == other_user_id,
                    Message.receiver_id == user_id
                )
            )
        )
        
        if property_id:
            query = query.filter(Message.property_id == property_id)
        
        return query.order_by(Message.created_at.asc()).all()

    @staticmethod
    def get_conversations(db: Session, user_id: int) -> List[dict]:
        """Get all conversations for a user with the last message"""
        # Get all unique users the current user has conversed with
        conversations = []
        
        # Subquery to get unique conversation partners
        sent_to = db.query(Message.receiver_id).filter(Message.sender_id == user_id).distinct()
        received_from = db.query(Message.sender_id).filter(Message.receiver_id == user_id).distinct()
        
        # Combine both lists
        all_user_ids = set()
        for user in sent_to:
            all_user_ids.add(user[0])
        for user in received_from:
            all_user_ids.add(user[0])
        
        for other_user_id in all_user_ids:
            # Get last message in conversation
            last_message = db.query(Message).filter(
                or_(
                    and_(Message.sender_id == user_id, Message.receiver_id == other_user_id),
                    and_(Message.sender_id == other_user_id, Message.receiver_id == user_id)
                )
            ).order_by(Message.created_at.desc()).first()
            
            if last_message:
                # Get unread count
                unread_count = db.query(func.count(Message.id)).filter(
                    Message.sender_id == other_user_id,
                    Message.receiver_id == user_id,
                    Message.is_read == False
                ).scalar()
                
                # Get user info
                other_user = db.query(User).filter(User.id == other_user_id).first()
                
                # Get property info if available
                property_title = None
                if last_message.property_id:
                    property = db.query(Property).filter(Property.id == last_message.property_id).first()
                    if property:
                        property_title = property.title
                
                conversations.append({
                    'user_id': other_user_id,
                    'user_name': other_user.full_name if other_user else 'Unknown',
                    'user_email': other_user.email if other_user else '',
                    'last_message': last_message.content,
                    'last_message_time': last_message.created_at,
                    'unread_count': unread_count or 0,
                    'property_id': last_message.property_id,
                    'property_title': property_title
                })
        
        # Sort by last message time
        conversations.sort(key=lambda x: x['last_message_time'], reverse=True)
        return conversations

    @staticmethod
    def mark_as_read(db: Session, user_id: int, other_user_id: int) -> int:
        """Mark all messages from other_user as read"""
        messages = db.query(Message).filter(
            Message.sender_id == other_user_id,
            Message.receiver_id == user_id,
            Message.is_read == False
        ).all()
        
        count = len(messages)
        for message in messages:
            message.is_read = True
        
        db.commit()
        return count

    @staticmethod
    def get_unread_count(db: Session, user_id: int) -> int:
        """Get total unread message count for a user"""
        return db.query(func.count(Message.id)).filter(
            Message.receiver_id == user_id,
            Message.is_read == False
        ).scalar() or 0

    @staticmethod
    def delete_message(db: Session, message_id: int, user_id: int) -> bool:
        """Delete a message (only if user is sender)"""
        message = db.query(Message).filter(
            Message.id == message_id,
            Message.sender_id == user_id
        ).first()
        
        if message:
            db.delete(message)
            db.commit()
            return True
        return False
