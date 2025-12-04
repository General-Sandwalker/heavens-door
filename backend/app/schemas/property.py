from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import datetime, date
from enum import Enum

class PropertyType(str, Enum):
    APARTMENT = "apartment"
    HOUSE = "house"
    VILLA = "villa"
    STUDIO = "studio"
    SHOP = "shop"

class PropertyBase(BaseModel):
    title: str = Field(..., min_length=3, max_length=200)
    description: Optional[str] = None
    property_type: PropertyType
    price: float = Field(..., gt=0)
    address: str = Field(..., min_length=5)
    city: str = Field(..., min_length=1, max_length=100)
    country: str = Field(..., min_length=1, max_length=100)
    latitude: float = Field(..., ge=-90, le=90)
    longitude: float = Field(..., ge=-180, le=180)
    bedrooms: int = Field(default=1, ge=0)
    bathrooms: int = Field(default=1, ge=0)
    area: Optional[float] = Field(None, gt=0)
    images: Optional[List[str]] = []

class PropertyCreate(PropertyBase):
    pass

class PropertyUpdate(BaseModel):
    title: Optional[str] = Field(None, min_length=3, max_length=200)
    description: Optional[str] = None
    property_type: Optional[PropertyType] = None
    price: Optional[float] = Field(None, gt=0)
    address: Optional[str] = Field(None, min_length=5)
    city: Optional[str] = Field(None, min_length=1, max_length=100)
    country: Optional[str] = Field(None, min_length=1, max_length=100)
    latitude: Optional[float] = Field(None, ge=-90, le=90)
    longitude: Optional[float] = Field(None, ge=-180, le=180)
    bedrooms: Optional[int] = Field(None, ge=0)
    bathrooms: Optional[int] = Field(None, ge=0)
    area: Optional[float] = Field(None, gt=0)
    images: Optional[List[str]] = None

class Property(PropertyBase):
    id: int
    owner_id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

class PropertyResponse(BaseModel):
    id: int
    title: str
    description: Optional[str]
    property_type: str
    price: float
    address: str
    city: str
    country: str
    latitude: float
    longitude: float
    bedrooms: int
    bathrooms: int
    area: Optional[float]
    images: List[str]
    owner_id: int
    owner_username: Optional[str] = None
    average_rating: Optional[float] = None
    review_count: int = 0
    is_rented: bool = False
    rental_start_date: Optional[date] = None
    rental_end_date: Optional[date] = None
    rented_to_user_id: Optional[int] = None
    created_at: datetime

    class Config:
        from_attributes = True

class RentalStatusUpdate(BaseModel):
    is_rented: bool
    rental_start_date: Optional[date] = None
    rental_end_date: Optional[date] = None
    rented_to_user_id: Optional[int] = None
