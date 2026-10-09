#!/bin/bash

set -e

IMAGE_NAME="jenkins-ci-cd-demo:${BUILD_NUMBER:-latest}"
CONTAINER_NAME="jenkins-demo"

echo "Stopping the previous container if it exists..."

if docker container inspect "$CONTAINER_NAME" >/dev/null 2>&1; then
    docker stop "$CONTAINER_NAME"
    docker rm "$CONTAINER_NAME"
fi

echo "Starting the new application container..."

docker run -d \
    --name "$CONTAINER_NAME" \
    --restart unless-stopped \
    -p 5000:5000 \
    "$IMAGE_NAME"

echo "Deployment completed successfully."
echo "Application is available on port 5000."
