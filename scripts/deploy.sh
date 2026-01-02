#!/bin/bash

echo "🔹 Starting staging deployment..."

# Stop old containers
echo "Stopping old containers..."
docker-compose -f docker-compose.staging.yml down

# Pull latest images
echo "Pulling latest images..."
docker-compose -f docker-compose.staging.yml pull

# Start containers
echo "Starting new containers..."
docker-compose -f docker-compose.staging.yml up -d

# Run DB migration
echo "Running database migrations..."
docker exec backend_staging python migrate.py

# Verify deployment
echo "Verifying deployment..."
sleep 10
curl http://localhost:5001/health

echo "✅ Deployment successful!"
