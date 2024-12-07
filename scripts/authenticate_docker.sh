#!/bin/bash

echo "Authenticating Docker with ECR..."
AWS_REGION="us-east-1"  # Update to your AWS region
ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
REPO_URI="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/my-react-app"

# Check if Docker is installed
echo "Checking if Docker is installed..."
if ! command -v docker &> /dev/null; then
  echo "Docker is not installed. Installing Docker..."
  sudo yum update -y
  sudo amazon-linux-extras enable docker
  sudo yum install -y docker
  sudo systemctl enable docker
  echo "Docker installed successfully."
fi

# Authenticate Docker with ECR
aws ecr get-login-password --region "${AWS_REGION}" | docker login --username AWS --password-stdin "${REPO_URI}"
if [ $? -ne 0 ]; then
  echo "Docker authentication with ECR failed."
  exit 1
fi

echo "Docker authenticated successfully."
