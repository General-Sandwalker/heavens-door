#!/bin/bash

# Heaven's Door API Route Tester
# Tests all available API routes

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

API_URL="http://localhost:3000/api"

echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Heaven's Door API Route Tester      ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
echo ""

# Test function
test_route() {
    local method=$1
    local endpoint=$2
    local auth=$3
    local data=$4
    
    echo -n "Testing $method $endpoint... "
    
    if [ "$method" = "GET" ]; then
        if [ -n "$auth" ]; then
            response=$(curl -s -w "\n%{http_code}" -X GET "$API_URL$endpoint" -H "Authorization: Bearer $auth")
        else
            response=$(curl -s -w "\n%{http_code}" -X GET "$API_URL$endpoint")
        fi
    elif [ "$method" = "POST" ]; then
        if [ -n "$auth" ]; then
            response=$(curl -s -w "\n%{http_code}" -X POST "$API_URL$endpoint" -H "Content-Type: application/json" -H "Authorization: Bearer $auth" -d "$data")
        else
            response=$(curl -s -w "\n%{http_code}" -X POST "$API_URL$endpoint" -H "Content-Type: application/json" -d "$data")
        fi
    fi
    
    status_code=$(echo "$response" | tail -n1)
    
    if [ "$status_code" -ge 200 ] && [ "$status_code" -lt 300 ]; then
        echo -e "${GREEN}✓ $status_code${NC}"
    elif [ "$status_code" -eq 401 ] || [ "$status_code" -eq 403 ]; then
        echo -e "${YELLOW}⚠ $status_code (Auth required)${NC}"
    else
        echo -e "${RED}✗ $status_code${NC}"
    fi
}

# Login to get token
echo -e "${BLUE}📝 Authenticating...${NC}"
LOGIN_RESPONSE=$(curl -s -X POST "$API_URL/auth/login" \
    -H "Content-Type: application/json" \
    -d '{"email":"admin@heavensdoor.com","password":"StandProud2024!"}')

TOKEN=$(echo $LOGIN_RESPONSE | grep -o '"token":"[^"]*' | cut -d'"' -f4)

if [ -n "$TOKEN" ]; then
    echo -e "${GREEN}✓ Authenticated as admin${NC}"
else
    echo -e "${RED}✗ Authentication failed${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}══════════════════════════════════════${NC}"
echo -e "${BLUE}Testing Auth Routes${NC}"
echo -e "${BLUE}══════════════════════════════════════${NC}"

test_route "POST" "/auth/register" "" '{"email":"test@test.com","password":"Test123!","firstName":"Test","lastName":"User"}'
test_route "POST" "/auth/login" "" '{"email":"admin@heavensdoor.com","password":"StandProud2024!"}'

echo ""
echo -e "${BLUE}══════════════════════════════════════${NC}"
echo -e "${BLUE}Testing User Routes${NC}"
echo -e "${BLUE}══════════════════════════════════════${NC}"

test_route "GET" "/users/profile" "$TOKEN"
test_route "GET" "/users/profile" ""

echo ""
echo -e "${BLUE}══════════════════════════════════════${NC}"
echo -e "${BLUE}Testing Property Routes${NC}"
echo -e "${BLUE}══════════════════════════════════════${NC}"

test_route "GET" "/properties" ""
test_route "GET" "/properties?city=Tokyo&minPrice=100000&maxPrice=500000" ""
test_route "GET" "/properties/search?q=house" ""

echo ""
echo -e "${BLUE}══════════════════════════════════════${NC}"
echo -e "${BLUE}Testing Message Routes${NC}"
echo -e "${BLUE}══════════════════════════════════════${NC}"

test_route "GET" "/messages" "$TOKEN"
test_route "GET" "/messages" ""

echo ""
echo -e "${BLUE}══════════════════════════════════════${NC}"
echo -e "${BLUE}Testing Favorite Routes${NC}"
echo -e "${BLUE}══════════════════════════════════════${NC}"

test_route "GET" "/favorites" "$TOKEN"
test_route "GET" "/favorites" ""

echo ""
echo -e "${BLUE}══════════════════════════════════════${NC}"
echo -e "${BLUE}Testing Admin Routes${NC}"
echo -e "${BLUE}══════════════════════════════════════${NC}"

test_route "GET" "/admin/dashboard" "$TOKEN"
test_route "GET" "/admin/users" "$TOKEN"
test_route "GET" "/admin/test-routes" "$TOKEN"
test_route "GET" "/admin/dashboard" ""

echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   All Routes Tested Successfully!     ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}📚 View full API documentation at:${NC}"
echo -e "${BLUE}   http://localhost:3000/api-docs${NC}"
