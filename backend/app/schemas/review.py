from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime

class ReviewBase(BaseModel):
    rating: int = Field(..., ge=1, le=5)
    comment: Optional[str] = None

class ReviewCreate(ReviewBase):
    pass

class Review(ReviewBase):
    id: int
    property_id: int
    user_id: int
    created_at: datetime

    class Config:
        from_attributes = True

class ReviewResponse(BaseModel):
    id: int
    property_id: int
    user_id: int
    username: str
    rating: int
    comment: Optional[str]
    created_at: datetime

    class Config:
        from_attributes = True
