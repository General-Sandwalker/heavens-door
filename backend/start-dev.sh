#!/bin/bash

# Heaven's Door Backend - Development Mode
# This script starts the backend with hot reload and development features

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Heaven's Door Backend - DEV MODE    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}✗ Node.js is not installed!${NC}"
    echo "Please install Node.js 21 or higher"
    exit 1
fi

echo -e "${GREEN}✓ Node.js version: $(node --version)${NC}"

# Check if we're in the backend directory
if [ ! -f "package.json" ]; then
    echo -e "${RED}✗ package.json not found!${NC}"
    echo "Please run this script from the backend directory"
    exit 1
fi

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}⚠ .env file not found. Creating from .env.example...${NC}"
    if [ -f ".env.example" ]; then
        cp .env.example .env
        echo -e "${GREEN}✓ Created .env file${NC}"
        echo -e "${YELLOW}⚠ Please update .env with your configuration${NC}"
    else
        echo -e "${RED}✗ .env.example not found!${NC}"
        exit 1
    fi
fi

# Install dependencies if node_modules doesn't exist
if [ ! -d "node_modules" ]; then
    echo -e "${BLUE}📦 Installing dependencies...${NC}"
    npm install
    echo -e "${GREEN}✓ Dependencies installed${NC}"
fi

# Check if database is running
echo -e "${BLUE}🔍 Checking database connection...${NC}"
DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-5432}

if command -v nc &> /dev/null; then
    if nc -z $DB_HOST $DB_PORT 2>/dev/null; then
        echo -e "${GREEN}✓ Database is running on $DB_HOST:$DB_PORT${NC}"
    else
        echo -e "${YELLOW}⚠ Database not detected on $DB_HOST:$DB_PORT${NC}"
        echo -e "${YELLOW}  Make sure PostgreSQL is running:${NC}"
        echo -e "${YELLOW}  docker-compose up -d db${NC}"
    fi
fi

echo ""
echo -e "${BLUE}🚀 Starting development server...${NC}"
echo -e "${GREEN}   • Hot reload: ENABLED${NC}"
echo -e "${GREEN}   • Debug mode: ENABLED${NC}"
echo -e "${GREEN}   • Port: ${PORT:-3000}${NC}"
echo ""
echo -e "${YELLOW}Press Ctrl+C to stop the server${NC}"
echo ""

# Start the server with nodemon for hot reload
if [ -f "node_modules/.bin/nodemon" ]; then
    npm run dev
else
    echo -e "${YELLOW}⚠ nodemon not found, installing dev dependencies...${NC}"
    npm install --save-dev nodemon
    npm run dev
fi
