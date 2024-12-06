#!/bin/bash

CONTAINER_NAME="react-app-container"  # Update with your container name

echo "Stopping the Docker container if it exists..."
if [ "$(docker ps -q -f name=${CONTAINER_NAME})" ]; then
  docker stop "${CONTAINER_NAME}"
  docker rm "${CONTAINER_NAME}"
  echo "Stopped and removed the existing container."
else
  echo "No running container found with name ${CONTAINER_NAME}."
fi
