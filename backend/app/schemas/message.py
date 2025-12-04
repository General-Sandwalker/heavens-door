from pydantic import BaseModel
from datetime import datetime
from typing import Optional

class MessageCreate(BaseModel):
    receiver_id: int
    property_id: Optional[int] = None
    content: str

class MessageResponse(BaseModel):
    id: int
    sender_id: int
    receiver_id: int
    property_id: Optional[int]
    content: str
    is_read: bool
    created_at: datetime
    sender_name: Optional[str] = None
    receiver_name: Optional[str] = None
    property_title: Optional[str] = None

    class Config:
        from_attributes = True

class ConversationResponse(BaseModel):
    user_id: int
    user_name: str
    user_email: str
    last_message: str
    last_message_time: datetime
    unread_count: int
    property_id: Optional[int] = None
    property_title: Optional[str] = None
