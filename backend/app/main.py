from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.database import engine, Base
from routers import auth, properties, messages

# Create database tables
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="RentOnline API",
    version="1.0.0",
    description="A rental marketplace API built with FastAPI following MVC pattern"
)

# Configure CORS for Flutter app
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, replace with your Flutter app URL
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth.router, prefix="/api/auth", tags=["Authentication"])
app.include_router(properties.router)
app.include_router(messages.router, prefix="/api/messages", tags=["Messages"])

@app.get("/")
def read_root():
    return {"message": "Welcome to RentOnline API", "version": "1.0.0"}

@app.get("/health")
def health_check():
    return {"status": "healthy"}
