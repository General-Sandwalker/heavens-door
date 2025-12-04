import bcrypt
from jose import JWTError, jwt
from datetime import datetime, timedelta
from typing import Optional
from app.config import settings
import hashlib

class AuthUtils:
    """Utility class for authentication operations"""
    
    @staticmethod
    def _prepare_password(password: str) -> bytes:
        """
        Prepare password for bcrypt by hashing with SHA256 first.
        This handles passwords longer than 72 bytes and provides additional security.
        Returns bytes that are safe for bcrypt (64 bytes from hex encoding).
        """
        # Hash the password with SHA256 first to handle length limits
        # Returns a 64-character hex string, then encode to bytes (64 bytes)
        return hashlib.sha256(password.encode('utf-8')).hexdigest().encode('utf-8')
    
    @staticmethod
    def verify_password(plain_password: str, hashed_password: str) -> bool:
        """Verify a plain password against a hashed password"""
        prepared_password = AuthUtils._prepare_password(plain_password)
        return bcrypt.checkpw(prepared_password, hashed_password.encode('utf-8'))
    
    @staticmethod
    def get_password_hash(password: str) -> str:
        """Hash a password"""
        prepared_password = AuthUtils._prepare_password(password)
        # Generate salt and hash the password with 12 rounds
        salt = bcrypt.gensalt(rounds=12)
        hashed = bcrypt.hashpw(prepared_password, salt)
        return hashed.decode('utf-8')
    
    @staticmethod
    def create_access_token(data: dict, expires_delta: Optional[timedelta] = None) -> str:
        """Create a JWT access token"""
        to_encode = data.copy()
        if expires_delta:
            expire = datetime.utcnow() + expires_delta
        else:
            expire = datetime.utcnow() + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
        
        to_encode.update({"exp": expire})
        encoded_jwt = jwt.encode(to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM)
        return encoded_jwt
    
    @staticmethod
    def decode_access_token(token: str) -> Optional[str]:
        """Decode and verify a JWT token"""
        try:
            payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
            email: str = payload.get("sub")
            return email
        except JWTError:
            return None
