from sqlalchemy import Column, Integer, String, Float, Text, DateTime, ForeignKey, Enum, Boolean, Date
from sqlalchemy.orm import relationship
from datetime import datetime
from app.database import Base
import enum

class PropertyType(enum.Enum):
    APARTMENT = "apartment"
    HOUSE = "house"
    VILLA = "villa"
    STUDIO = "studio"
    SHOP = "shop"

class Property(Base):
    __tablename__ = "properties"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(200), nullable=False)
    description = Column(Text, nullable=True)
    property_type = Column(Enum(PropertyType), nullable=False)
    price = Column(Float, nullable=False)
    address = Column(String(500), nullable=False)
    city = Column(String(100), nullable=False)
    country = Column(String(100), nullable=False)
    latitude = Column(Float, nullable=False)
    longitude = Column(Float, nullable=False)
    bedrooms = Column(Integer, default=1)
    bathrooms = Column(Integer, default=1)
    area = Column(Float, nullable=True)  # in square meters
    images = Column(Text, nullable=True)  # JSON array of image URLs
    owner_id = Column(Integer, ForeignKey("users.id"), nullable=False)
    
    # Rental status fields
    is_rented = Column(Boolean, default=False)
    rental_start_date = Column(Date, nullable=True)
    rental_end_date = Column(Date, nullable=True)
    rented_to_user_id = Column(Integer, ForeignKey("users.id"), nullable=True)
    
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)

    # Relationships
    owner = relationship("User", back_populates="properties", foreign_keys=[owner_id])
    rented_to = relationship("User", foreign_keys=[rented_to_user_id])
    reviews = relationship("Review", back_populates="property", cascade="all, delete-orphan")
