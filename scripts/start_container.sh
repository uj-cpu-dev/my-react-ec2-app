#!/bin/bash

AWS_REGION="us-east-1"  # Update to your AWS region
ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
REPO_URI="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
IMAGE_NAME="frontend/react-app"  # Update to your ECR repository name
IMAGE_TAG=$(cat /home/ec2-user/app/image_tag.txt)
CONTAINER_NAME="react-app-container"
PORT="3000"

echo "Pulling the Docker image from ECR..."
docker pull "${REPO_URI}/${IMAGE_NAME}:feature-branch-${IMAGE_TAG}"
if [ $? -ne 0 ]; then
  echo "Failed to pull the image from ECR."
  exit 1
fi

echo "Starting the Docker container..."
docker run -d --name "${CONTAINER_NAME}" -p "${PORT}:${PORT}" "${REPO_URI}/${IMAGE_NAME}:feature-branch-${IMAGE_TAG}"
if [ $? -ne 0 ]; then
  echo "Failed to start the Docker container."
  exit 1
fi

echo "Docker container started successfully on port ${PORT}."
