#!/bin/bash

# Variables
AWS_REGION="us-east-1"  # Update to your AWS region
ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
REPO_URI="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
IMAGE_NAME="frontend/react-app"  # Update to your ECR repository name
IMAGE_TAG=$(cat /home/ec2-user/app/image_tag.txt)
CONTAINER_NAME="react-app-container"
PORT="3000"

# Check if Docker is running
echo "Checking Docker daemon status..."
if ! systemctl is-active --quiet docker; then
  echo "Docker is not running. Starting Docker..."
  sudo systemctl start docker
fi

# Check Docker permissions
echo "Checking Docker permissions..."
if ! docker info > /dev/null 2>&1; then
  echo "Docker permissions are not set correctly. Ensure the ec2-user is in the docker group."
  exit 1
fi

# Pull the Docker image from ECR
echo "Pulling the Docker image from ECR..."
docker pull "${REPO_URI}/${IMAGE_NAME}:${IMAGE_TAG}"
if [ $? -ne 0 ]; then
  echo "Failed to pull the image from ECR."
  exit 1
fi

# Run the container
echo "Running the Docker container..."
docker run -d --name "${CONTAINER_NAME}" -p ${PORT}:${PORT} "${REPO_URI}/${IMAGE_NAME}:${IMAGE_TAG}"
if [ $? -ne 0 ]; then
  echo "Failed to start the container."
  exit 1
fi

echo "Container started successfully and running on port ${PORT}."
