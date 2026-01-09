#!/bin/bash

echo "=============================="
echo "🚀 Deploying to STAGING"
echo "=============================="

echo "🔹 Pull latest Docker images"
docker compose -f docker-compose.staging.yml pull

echo "🔹 Stop old containers"
docker compose -f docker-compose.staging.yml down

echo "🔹 Start new containers"
docker compose -f docker-compose.staging.yml up -d

echo "🔹 Wait for services to be ready"
sleep 10

echo "🔹 Run database migrations"
docker exec backend_staging python migrate.py

echo "🔹 Verify deployment"
curl http://localhost:5001/health || exit 1

echo "✅ Deployment to STAGING successful"
