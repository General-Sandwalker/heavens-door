from fastapi import APIRouter, Depends, HTTPException, Query, status
from sqlalchemy.orm import Session
from typing import Optional, List
from app.database import get_db
from app.schemas.property import PropertyCreate, PropertyUpdate, PropertyResponse, RentalStatusUpdate
from app.schemas.review import ReviewCreate, ReviewResponse
from app.controller.property_controller import PropertyController
from app.controller.review_controller import ReviewController
from app.controller.auth_controller import AuthController
from app.utils.auth import AuthUtils
from fastapi.security import OAuth2PasswordBearer
import json

router = APIRouter(prefix="/api/properties", tags=["Properties"])
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/auth/login/form")

async def get_current_user_id(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)) -> int:
    """Get current authenticated user ID"""
    email = AuthUtils.decode_access_token(token)
    if email is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials"
        )
    user = AuthController.get_user_by_email(db, email=email)
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials"
        )
    return user.id

@router.post("/", response_model=PropertyResponse, status_code=status.HTTP_201_CREATED)
async def create_property(
    property_data: PropertyCreate,
    db: Session = Depends(get_db),
    current_user_id: int = Depends(get_current_user_id)
):
    """Create a new property"""
    try:
        property = PropertyController.create_property(db, property_data, current_user_id)
        
        # Parse images JSON
        images = json.loads(property.images) if property.images else []
        
        return PropertyResponse(
            id=property.id,
            title=property.title,
            description=property.description,
            property_type=property.property_type.value,
            price=property.price,
            address=property.address,
            city=property.city,
            country=property.country,
            latitude=property.latitude,
            longitude=property.longitude,
            bedrooms=property.bedrooms,
            bathrooms=property.bathrooms,
            area=property.area,
            images=images,
            owner_id=property.owner_id,
            owner_username=property.owner.username if property.owner else None,
            created_at=property.created_at,
            average_rating=None,
            review_count=0
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )

@router.get("/", response_model=List[PropertyResponse])
async def get_properties(
    skip: int = 0,
    limit: int = 100,
    property_type: Optional[str] = None,
    min_price: Optional[float] = None,
    max_price: Optional[float] = None,
    city: Optional[str] = None,
    country: Optional[str] = None,
    db: Session = Depends(get_db)
):
    """Get all properties with optional filters"""
    properties = PropertyController.get_properties(
        db, skip, limit, property_type, min_price, max_price, city, country
    )
    
    result = []
    for prop in properties:
        stats = PropertyController.get_property_stats(db, prop.id)
        images = json.loads(prop.images) if prop.images else []
        
        result.append(PropertyResponse(
            id=prop.id,
            title=prop.title,
            description=prop.description,
            property_type=prop.property_type.value,
            price=prop.price,
            address=prop.address,
            city=prop.city,
            country=prop.country,
            latitude=prop.latitude,
            longitude=prop.longitude,
            bedrooms=prop.bedrooms,
            bathrooms=prop.bathrooms,
            area=prop.area,
            images=images,
            owner_id=prop.owner_id,
            owner_username=prop.owner.username if prop.owner else None,
            created_at=prop.created_at,
            average_rating=stats['average_rating'],
            review_count=stats['review_count'],
            is_rented=prop.is_rented,
            rental_start_date=prop.rental_start_date,
            rental_end_date=prop.rental_end_date,
            rented_to_user_id=prop.rented_to_user_id
        ))
    
    return result

@router.get("/{property_id}", response_model=PropertyResponse)
async def get_property(property_id: int, db: Session = Depends(get_db)):
    """Get property by ID"""
    property = PropertyController.get_property_by_id(db, property_id)
    if not property:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Property not found"
        )
    
    stats = PropertyController.get_property_stats(db, property.id)
    images = json.loads(property.images) if property.images else []
    
    return PropertyResponse(
        id=property.id,
        title=property.title,
        description=property.description,
        property_type=property.property_type.value,
        price=property.price,
        address=property.address,
        city=property.city,
        country=property.country,
        latitude=property.latitude,
        longitude=property.longitude,
        bedrooms=property.bedrooms,
        bathrooms=property.bathrooms,
        area=property.area,
        images=images,
        owner_id=property.owner_id,
        owner_username=property.owner.username if property.owner else None,
        created_at=property.created_at,
        average_rating=stats['average_rating'],
        review_count=stats['review_count'],
        is_rented=property.is_rented or False,
        rental_start_date=property.rental_start_date,
        rental_end_date=property.rental_end_date,
        rented_to_user_id=property.rented_to_user_id
    )

@router.put("/{property_id}", response_model=PropertyResponse)
async def update_property(
    property_id: int,
    property_data: PropertyUpdate,
    db: Session = Depends(get_db),
    current_user_id: int = Depends(get_current_user_id)
):
    """Update property"""
    property = PropertyController.update_property(db, property_id, property_data, current_user_id)
    if not property:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Property not found or you don't have permission"
        )
    
    stats = PropertyController.get_property_stats(db, property.id)
    images = json.loads(property.images) if property.images else []
    
    return PropertyResponse(
        id=property.id,
        title=property.title,
        description=property.description,
        property_type=property.property_type.value,
        price=property.price,
        address=property.address,
        city=property.city,
        country=property.country,
        latitude=property.latitude,
        longitude=property.longitude,
        bedrooms=property.bedrooms,
        bathrooms=property.bathrooms,
        area=property.area,
        images=images,
        owner_id=property.owner_id,
        created_at=property.created_at,
        average_rating=stats['average_rating'],
        review_count=stats['review_count']
    )

@router.delete("/{property_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_property(
    property_id: int,
    db: Session = Depends(get_db),
    current_user_id: int = Depends(get_current_user_id)
):
    """Delete property"""
    success = PropertyController.delete_property(db, property_id, current_user_id)
    if not success:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Property not found or you don't have permission"
        )
    return None

@router.post("/{property_id}/reviews", response_model=ReviewResponse, status_code=status.HTTP_201_CREATED)
async def create_review(
    property_id: int,
    review_data: ReviewCreate,
    db: Session = Depends(get_db),
    current_user_id: int = Depends(get_current_user_id)
):
    """Create a review for a property"""
    # Check if property exists
    property = PropertyController.get_property_by_id(db, property_id)
    if not property:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Property not found"
        )
    
    # Check if user already reviewed
    if ReviewController.check_user_reviewed(db, property_id, current_user_id):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="You have already reviewed this property"
        )
    
    review = ReviewController.create_review(db, review_data, property_id, current_user_id)
    
    return ReviewResponse(
        id=review.id,
        property_id=review.property_id,
        user_id=review.user_id,
        username=review.user.username,
        rating=review.rating,
        comment=review.comment,
        created_at=review.created_at
    )

@router.get("/{property_id}/reviews", response_model=List[ReviewResponse])
async def get_property_reviews(
    property_id: int,
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db)
):
    """Get all reviews for a property"""
    reviews = ReviewController.get_property_reviews(db, property_id, skip, limit)
    
    return [
        ReviewResponse(
            id=review.id,
            property_id=review.property_id,
            user_id=review.user_id,
            username=review.user.username,
            rating=review.rating,
            comment=review.comment,
            created_at=review.created_at
        )
        for review in reviews
    ]

@router.delete("/reviews/{review_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_review(
    review_id: int,
    db: Session = Depends(get_db),
    current_user_id: int = Depends(get_current_user_id)
):
    """Delete a review"""
    success = ReviewController.delete_review(db, review_id, current_user_id)
    if not success:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Review not found or you don't have permission"
        )
    return None

@router.patch("/{property_id}/rental-status", response_model=PropertyResponse)
async def update_rental_status(
    property_id: int,
    rental_status: RentalStatusUpdate,
    db: Session = Depends(get_db),
    current_user_id: int = Depends(get_current_user_id)
):
    """Update property rental status (owner only)"""
    property = PropertyController.get_property_by_id(db, property_id)
    if not property:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Property not found"
        )
    
    if property.owner_id != current_user_id:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="You don't have permission to update this property's rental status"
        )
    
    # Update rental status
    property.is_rented = rental_status.is_rented
    property.rental_start_date = rental_status.rental_start_date
    property.rental_end_date = rental_status.rental_end_date
    property.rented_to_user_id = rental_status.rented_to_user_id
    
    db.commit()
    db.refresh(property)
    
    stats = PropertyController.get_property_stats(db, property.id)
    images = json.loads(property.images) if property.images else []
    
    return PropertyResponse(
        id=property.id,
        title=property.title,
        description=property.description,
        property_type=property.property_type.value,
        price=property.price,
        address=property.address,
        city=property.city,
        country=property.country,
        latitude=property.latitude,
        longitude=property.longitude,
        bedrooms=property.bedrooms,
        bathrooms=property.bathrooms,
        area=property.area,
        images=images,
        owner_id=property.owner_id,
        owner_username=property.owner.username if property.owner else None,
        created_at=property.created_at,
        average_rating=stats['average_rating'],
        review_count=stats['review_count'],
        is_rented=property.is_rented or False,
        rental_start_date=property.rental_start_date,
        rental_end_date=property.rental_end_date,
        rented_to_user_id=property.rented_to_user_id
    )
