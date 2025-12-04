from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List, Optional
from app.database import get_db
from app.schemas.message import MessageCreate, MessageResponse, ConversationResponse
from app.controller.message_controller import MessageController
from app.controller.auth_controller import AuthController
from app.utils.auth import AuthUtils
from fastapi.security import OAuth2PasswordBearer

router = APIRouter()
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

def get_current_user_id(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)) -> int:
    """Get current user ID from token"""
    email = AuthUtils.decode_access_token(token)
    if not email:
        raise HTTPException(status_code=401, detail="Invalid token")
    
    user = AuthController.get_user_by_email(db, email=email)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    return user.id

@router.post("/", response_model=MessageResponse)
async def send_message(
    message: MessageCreate,
    db: Session = Depends(get_db),
    current_user_id: int = Depends(get_current_user_id)
):
    """Send a message to another user"""
    try:
        new_message = MessageController.create_message(db, current_user_id, message)
        
        # Get sender and receiver names
        sender = AuthController.get_user_by_id(db, current_user_id)
        receiver = AuthController.get_user_by_id(db, message.receiver_id)
        
        return MessageResponse(
            id=new_message.id,
            sender_id=new_message.sender_id,
            receiver_id=new_message.receiver_id,
            property_id=new_message.property_id,
            content=new_message.content,
            is_read=new_message.is_read,
            created_at=new_message.created_at,
            sender_name=sender.full_name if sender else None,
            receiver_name=receiver.full_name if receiver else None
        )
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))

@router.get("/conversations", response_model=List[ConversationResponse])
async def get_conversations(
    db: Session = Depends(get_db),
    current_user_id: int = Depends(get_current_user_id)
):
    """Get all conversations for current user"""
    conversations = MessageController.get_conversations(db, current_user_id)
    return conversations

@router.get("/conversation/{other_user_id}", response_model=List[MessageResponse])
async def get_conversation(
    other_user_id: int,
    property_id: Optional[int] = None,
    db: Session = Depends(get_db),
    current_user_id: int = Depends(get_current_user_id)
):
    """Get conversation with specific user"""
    messages = MessageController.get_conversation(
        db, current_user_id, other_user_id, property_id
    )
    
    # Mark messages as read
    MessageController.mark_as_read(db, current_user_id, other_user_id)
    
    result = []
    for msg in messages:
        sender = AuthController.get_user_by_id(db, msg.sender_id)
        receiver = AuthController.get_user_by_id(db, msg.receiver_id)
        
        result.append(MessageResponse(
            id=msg.id,
            sender_id=msg.sender_id,
            receiver_id=msg.receiver_id,
            property_id=msg.property_id,
            content=msg.content,
            is_read=msg.is_read,
            created_at=msg.created_at,
            sender_name=sender.full_name if sender else None,
            receiver_name=receiver.full_name if receiver else None
        ))
    
    return result

@router.get("/unread-count")
async def get_unread_count(
    db: Session = Depends(get_db),
    current_user_id: int = Depends(get_current_user_id)
):
    """Get unread message count"""
    count = MessageController.get_unread_count(db, current_user_id)
    return {"unread_count": count}

@router.delete("/{message_id}")
async def delete_message(
    message_id: int,
    db: Session = Depends(get_db),
    current_user_id: int = Depends(get_current_user_id)
):
    """Delete a message"""
    success = MessageController.delete_message(db, message_id, current_user_id)
    if not success:
        raise HTTPException(status_code=404, detail="Message not found or not authorized")
    return {"message": "Message deleted successfully"}
