#!/bin/bash

echo "Stopping old containers..."
docker-compose down

echo "Pulling latest images..."
docker-compose pull

echo "Starting new containers..."
docker-compose up -d

echo "Deployment completed successfully"
