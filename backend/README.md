# Backend Startup Scripts

## Development Mode

Start the backend with hot reload and development features:

```bash
cd backend
./start-dev.sh
```

Or using npm:
```bash
cd backend
npm run dev
```

**Features:**
- ✅ Hot reload with nodemon
- ✅ Debug mode enabled
- ✅ Detailed error messages
- ✅ Auto-restart on file changes
- ✅ Dev dependencies included

**Requirements:**
- Node.js 21+
- PostgreSQL running (can use docker-compose)
- `.env` file (created from `.env.example` if missing)

---

## Production Mode

Start the backend optimized for production:

```bash
cd backend
./start-prod.sh
```

Or using npm:
```bash
cd backend
npm run prod
```

**Features:**
- ✅ Production optimizations
- ✅ PM2 process management (if installed)
- ✅ Auto-logging to `logs/` directory
- ✅ Environment validation
- ✅ Only production dependencies
- ✅ Zero-downtime restart capabilities

**Requirements:**
- Node.js 21+
- PostgreSQL running
- `.env` file with production config
- All environment variables set

**Optional but Recommended:**
```bash
npm install -g pm2
```

PM2 provides:
- Process monitoring
- Auto-restart on crash
- Load balancing
- Log management
- Zero-downtime reloads

---

## Environment Variables

Required for production:
- `DB_HOST` - Database host
- `DB_PORT` - Database port (usually 5432)
- `DB_NAME` - Database name
- `DB_USER` - Database user
- `DB_PASSWORD` - Database password
- `JWT_SECRET` - Secret for JWT tokens
- `PORT` - Server port (default: 3000)
- `NODE_ENV` - Set to "production"

Optional:
- `JWT_EXPIRES_IN` - Token expiration (default: 7d)
- `RATE_LIMIT_WINDOW` - Rate limit window (default: 15min)
- `RATE_LIMIT_MAX` - Max requests per window (default: 100)

---

## Quick Start Examples

### Local Development
```bash
# Start database
docker-compose up -d db

# Start backend in dev mode
cd backend
./start-dev.sh
```

### Production with Docker
```bash
# Start everything
docker-compose up -d

# View logs
docker-compose logs -f backend
```

### Production with PM2
```bash
# Start with PM2
cd backend
./start-prod.sh

# Monitor
pm2 monit

# View logs
pm2 logs heavens-door-backend

# Restart
pm2 restart heavens-door-backend
```

---

## Troubleshooting

### Dev Mode Issues

**"nodemon not found"**
```bash
cd backend
npm install
```

**"Database not detected"**
```bash
docker-compose up -d db
# Wait 10 seconds for database to initialize
```

**Port already in use**
```bash
# Find and kill process
lsof -ti:3000 | xargs kill -9
```

### Prod Mode Issues

**"Missing environment variables"**
- Check `.env` file exists
- Verify all required variables are set
- No empty values

**"Cannot connect to database"**
- Database must be running before starting backend
- Check database credentials
- Test connection: `psql -h localhost -U postgres -d heavens_door`

**PM2 not starting**
```bash
# Install PM2 globally
npm install -g pm2

# Start manually
cd backend
pm2 start src/server.js --name heavens-door-backend
```

---

## Scripts Comparison

| Feature | Development | Production |
|---------|-------------|------------|
| Hot Reload | ✅ Yes | ❌ No |
| Debug Mode | ✅ Yes | ❌ No |
| Auto-restart | ✅ On file change | ✅ On crash (PM2) |
| Dependencies | All | Production only |
| Logging | Console | File + Console |
| Process Management | Node.js | PM2 (recommended) |
| Performance | Slower | Optimized |
| Use Case | Development | Production |

---

## Advanced Usage

### Custom Port
```bash
# Dev
PORT=4000 ./start-dev.sh

# Prod
PORT=4000 ./start-prod.sh
```

### Watch Specific Files (Dev)
Edit `backend/nodemon.json`:
```json
{
  "watch": ["src"],
  "ext": "js,json",
  "ignore": ["src/public/*", "node_modules/*"]
}
```

### Multiple Instances (Prod with PM2)
```bash
pm2 start src/server.js -i 4 --name heavens-door-backend
# Starts 4 instances with load balancing
```

### View Real-time Logs
```bash
# Dev (in terminal)
# Logs show automatically

# Prod with PM2
pm2 logs heavens-door-backend --lines 100

# Prod without PM2
tail -f logs/production.log
```

---

## Health Check

After starting, verify the backend is running:

```bash
curl http://localhost:3000/health
```

Expected response:
```json
{
  "status": "healthy",
  "timestamp": "2025-12-03T16:53:00.000Z",
  "database": "connected"
}
```

---

## Stopping the Server

### Development
Press `Ctrl + C` in the terminal

### Production with PM2
```bash
pm2 stop heavens-door-backend
# or
pm2 delete heavens-door-backend  # Removes from PM2
```

### Production without PM2
Press `Ctrl + C` or:
```bash
# Find and kill process
pkill -f "node src/server.js"
```

### Docker
```bash
docker-compose stop backend
# or
docker-compose down  # Stops everything
```
