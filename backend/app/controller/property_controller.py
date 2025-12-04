from sqlalchemy.orm import Session, joinedload
from sqlalchemy import func
from app.models.property import Property
from app.models.review import Review
from app.schemas.property import PropertyCreate, PropertyUpdate
from typing import List, Optional
import json

class PropertyController:
    @staticmethod
    def create_property(db: Session, property_data: PropertyCreate, owner_id: int) -> Property:
        """Create a new property"""
        # Convert images list to JSON string
        images_json = json.dumps(property_data.images) if property_data.images else json.dumps([])
        
        db_property = Property(
            title=property_data.title,
            description=property_data.description,
            property_type=property_data.property_type,
            price=property_data.price,
            address=property_data.address,
            city=property_data.city,
            country=property_data.country,
            latitude=property_data.latitude,
            longitude=property_data.longitude,
            bedrooms=property_data.bedrooms,
            bathrooms=property_data.bathrooms,
            area=property_data.area,
            images=images_json,
            owner_id=owner_id
        )
        
        db.add(db_property)
        db.commit()
        db.refresh(db_property)
        return db_property
    
    @staticmethod
    def get_properties(
        db: Session,
        skip: int = 0,
        limit: int = 100,
        property_type: Optional[str] = None,
        min_price: Optional[float] = None,
        max_price: Optional[float] = None,
        city: Optional[str] = None,
        country: Optional[str] = None
    ) -> List[Property]:
        """Get all properties with optional filters"""
        query = db.query(Property).options(joinedload(Property.owner))
        
        if property_type:
            query = query.filter(Property.property_type == property_type)
        if min_price:
            query = query.filter(Property.price >= min_price)
        if max_price:
            query = query.filter(Property.price <= max_price)
        if city:
            query = query.filter(Property.city.ilike(f"%{city}%"))
        if country:
            query = query.filter(Property.country.ilike(f"%{country}%"))
        
        return query.offset(skip).limit(limit).all()
    
    @staticmethod
    def get_property_by_id(db: Session, property_id: int) -> Optional[Property]:
        """Get property by ID"""
        return db.query(Property).options(
            joinedload(Property.owner),
            joinedload(Property.reviews)
        ).filter(Property.id == property_id).first()
    
    @staticmethod
    def get_properties_by_owner(db: Session, owner_id: int) -> List[Property]:
        """Get all properties by owner"""
        return db.query(Property).filter(Property.owner_id == owner_id).all()
    
    @staticmethod
    def update_property(
        db: Session,
        property_id: int,
        property_data: PropertyUpdate,
        owner_id: int
    ) -> Optional[Property]:
        """Update property"""
        db_property = db.query(Property).filter(
            Property.id == property_id,
            Property.owner_id == owner_id
        ).first()
        
        if not db_property:
            return None
        
        update_data = property_data.dict(exclude_unset=True)
        
        # Handle images separately
        if 'images' in update_data and update_data['images'] is not None:
            update_data['images'] = json.dumps(update_data['images'])
        
        for field, value in update_data.items():
            setattr(db_property, field, value)
        
        db.commit()
        db.refresh(db_property)
        return db_property
    
    @staticmethod
    def delete_property(db: Session, property_id: int, owner_id: int) -> bool:
        """Delete property"""
        db_property = db.query(Property).filter(
            Property.id == property_id,
            Property.owner_id == owner_id
        ).first()
        
        if not db_property:
            return False
        
        db.delete(db_property)
        db.commit()
        return True
    
    @staticmethod
    def get_property_stats(db: Session, property_id: int) -> dict:
        """Get property statistics (average rating, review count)"""
        stats = db.query(
            func.avg(Review.rating).label('average_rating'),
            func.count(Review.id).label('review_count')
        ).filter(Review.property_id == property_id).first()
        
        return {
            'average_rating': float(stats.average_rating) if stats.average_rating else None,
            'review_count': stats.review_count
        }
