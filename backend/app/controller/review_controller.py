from sqlalchemy.orm import Session, joinedload
from app.models.review import Review
from app.schemas.review import ReviewCreate
from typing import List, Optional

class ReviewController:
    @staticmethod
    def create_review(
        db: Session,
        review_data: ReviewCreate,
        property_id: int,
        user_id: int
    ) -> Review:
        """Create a new review"""
        db_review = Review(
            property_id=property_id,
            user_id=user_id,
            rating=review_data.rating,
            comment=review_data.comment
        )
        
        db.add(db_review)
        db.commit()
        db.refresh(db_review)
        return db_review
    
    @staticmethod
    def get_property_reviews(
        db: Session,
        property_id: int,
        skip: int = 0,
        limit: int = 100
    ) -> List[Review]:
        """Get all reviews for a property"""
        return db.query(Review).options(
            joinedload(Review.user)
        ).filter(
            Review.property_id == property_id
        ).offset(skip).limit(limit).all()
    
    @staticmethod
    def get_user_reviews(db: Session, user_id: int) -> List[Review]:
        """Get all reviews by a user"""
        return db.query(Review).filter(Review.user_id == user_id).all()
    
    @staticmethod
    def delete_review(db: Session, review_id: int, user_id: int) -> bool:
        """Delete a review (only by the review author)"""
        db_review = db.query(Review).filter(
            Review.id == review_id,
            Review.user_id == user_id
        ).first()
        
        if not db_review:
            return False
        
        db.delete(db_review)
        db.commit()
        return True
    
    @staticmethod
    def check_user_reviewed(db: Session, property_id: int, user_id: int) -> bool:
        """Check if user already reviewed this property"""
        review = db.query(Review).filter(
            Review.property_id == property_id,
            Review.user_id == user_id
        ).first()
        return review is not None
