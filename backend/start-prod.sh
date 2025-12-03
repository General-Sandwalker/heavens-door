#!/bin/bash

# Heaven's Door Backend - Production Mode
# This script starts the backend optimized for production

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Heaven's Door Backend - PROD MODE   ║${NC}"
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
    echo -e "${RED}✗ .env file not found!${NC}"
    echo "Please create .env file with production configuration"
    exit 1
fi

# Install production dependencies only
echo -e "${BLUE}📦 Installing production dependencies...${NC}"
npm ci --omit=dev
echo -e "${GREEN}✓ Dependencies installed${NC}"

# Check if database is running
echo -e "${BLUE}🔍 Checking database connection...${NC}"
DB_HOST=${DB_HOST:-localhost}
DB_PORT=${DB_PORT:-5432}

if command -v nc &> /dev/null; then
    if ! nc -z $DB_HOST $DB_PORT 2>/dev/null; then
        echo -e "${RED}✗ Cannot connect to database on $DB_HOST:$DB_PORT${NC}"
        echo -e "${RED}  Production server requires database to be running${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ Database is running on $DB_HOST:$DB_PORT${NC}"
fi

# Verify required environment variables
REQUIRED_VARS=("DB_HOST" "DB_PORT" "DB_NAME" "DB_USER" "DB_PASSWORD" "JWT_SECRET")
MISSING_VARS=()

for var in "${REQUIRED_VARS[@]}"; do
    if [ -z "${!var}" ]; then
        MISSING_VARS+=("$var")
    fi
done

if [ ${#MISSING_VARS[@]} -ne 0 ]; then
    echo -e "${RED}✗ Missing required environment variables:${NC}"
    for var in "${MISSING_VARS[@]}"; do
        echo -e "${RED}  • $var${NC}"
    done
    echo ""
    echo "Please set these variables in your .env file"
    exit 1
fi

echo -e "${GREEN}✓ Environment variables validated${NC}"

# Set NODE_ENV to production
export NODE_ENV=production

echo ""
echo -e "${BLUE}🚀 Starting production server...${NC}"
echo -e "${GREEN}   • Environment: PRODUCTION${NC}"
echo -e "${GREEN}   • Hot reload: DISABLED${NC}"
echo -e "${GREEN}   • Debug mode: DISABLED${NC}"
echo -e "${GREEN}   • Port: ${PORT:-3000}${NC}"
echo ""
echo -e "${YELLOW}Server is running in production mode${NC}"
echo -e "${YELLOW}Logs are being written to: logs/production.log${NC}"
echo ""

# Create logs directory if it doesn't exist
mkdir -p logs

# Start the server with PM2 for production process management
if command -v pm2 &> /dev/null; then
    echo -e "${GREEN}✓ Using PM2 for process management${NC}"
    pm2 start src/server.js --name "heavens-door-backend" \
        --log logs/production.log \
        --error logs/error.log \
        --time \
        --merge-logs \
        --watch false
    
    echo ""
    echo -e "${GREEN}✓ Server started with PM2${NC}"
    echo ""
    echo "Useful PM2 commands:"
    echo "  pm2 logs heavens-door-backend  - View logs"
    echo "  pm2 restart heavens-door-backend - Restart server"
    echo "  pm2 stop heavens-door-backend - Stop server"
    echo "  pm2 delete heavens-door-backend - Remove from PM2"
    echo "  pm2 monit - Monitor all processes"
else
    echo -e "${YELLOW}⚠ PM2 not found, using Node.js directly${NC}"
    echo -e "${YELLOW}  For production, consider installing PM2:${NC}"
    echo -e "${YELLOW}  npm install -g pm2${NC}"
    echo ""
    
    # Start with node directly
    npm start 2>&1 | tee logs/production.log
fi
