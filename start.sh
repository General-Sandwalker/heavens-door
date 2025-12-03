#!/bin/bash

# Heaven's Door - Quick Start Script
# Run this script to set up and start the application

echo "════════════════════════════════════════"
echo "🌟  HEAVEN'S DOOR - QUICK START  🌟"
echo "════════════════════════════════════════"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker is not installed!${NC}"
    echo "Please install Docker first: sudo pacman -S docker docker-compose"
    exit 1
fi

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter is not installed!${NC}"
    echo "Please install Flutter first. See docs/setup/DEVELOPMENT_SETUP.md"
    exit 1
fi

echo -e "${BLUE}📦 Setting up backend...${NC}"

# Create backend .env if it doesn't exist
if [ ! -f backend/.env ]; then
    echo -e "${YELLOW}Creating backend .env file...${NC}"
    cp backend/.env.example backend/.env
    echo -e "${GREEN}✅ Backend .env created${NC}"
else
    echo -e "${GREEN}✅ Backend .env already exists${NC}"
fi

# Start Docker containers
echo -e "${BLUE}🐳 Starting Docker containers...${NC}"
docker-compose up -d

# Wait for database to be ready
echo -e "${YELLOW}⏳ Waiting for database to be ready...${NC}"
sleep 5

# Check backend health
echo -e "${BLUE}🔍 Checking backend health...${NC}"
for i in {1..10}; do
    if curl -s http://localhost:3000/health > /dev/null; then
        echo -e "${GREEN}✅ Backend is running!${NC}"
        break
    fi
    if [ $i -eq 10 ]; then
        echo -e "${RED}❌ Backend failed to start${NC}"
        echo "Check logs with: docker-compose logs backend"
        exit 1
    fi
    echo -e "${YELLOW}⏳ Waiting... ($i/10)${NC}"
    sleep 2
done

echo ""
echo -e "${PURPLE}📱 Setting up Flutter frontend...${NC}"

# Create frontend .env if it doesn't exist
if [ ! -f frontend/.env ]; then
    echo -e "${YELLOW}Creating frontend .env file...${NC}"
    cat > frontend/.env << EOF
API_BASE_URL=http://localhost:3000/api
GOOGLE_MAPS_API_KEY=YOUR_GOOGLE_MAPS_API_KEY_HERE
EOF
    echo -e "${GREEN}✅ Frontend .env created${NC}"
else
    echo -e "${GREEN}✅ Frontend .env already exists${NC}"
fi

# Get Flutter dependencies
echo -e "${BLUE}📦 Getting Flutter dependencies...${NC}"
cd frontend
flutter pub get
cd ..

echo ""
echo "════════════════════════════════════════"
echo -e "${GREEN}✅  SETUP COMPLETE! ✅${NC}"
echo "════════════════════════════════════════"
echo ""
echo -e "${PURPLE}🚀 To run the application:${NC}"
echo ""
echo -e "${BLUE}Backend (already running):${NC}"
echo "  URL: http://localhost:3000"
echo "  Health: http://localhost:3000/health"
echo "  Logs: docker-compose logs -f backend"
echo ""
echo -e "${BLUE}Frontend:${NC}"
echo "  cd frontend"
echo "  flutter run              # Android/Emulator"
echo "  flutter run -d chrome    # Web"
echo "  flutter run -d linux     # Linux Desktop"
echo ""
echo -e "${BLUE}Database:${NC}"
echo "  Access: docker-compose exec db psql -U postgres -d heavens_door"
echo ""
echo -e "${BLUE}Stop services:${NC}"
echo "  docker-compose down"
echo ""
echo "════════════════════════════════════════"
echo -e "${PURPLE}   \"I refuse!\" - Rohan Kishibe${NC}"
echo "════════════════════════════════════════"
