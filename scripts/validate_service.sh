#!/bin/bash

APP_URL="http://localhost:3000"  # Update with your React app's health check endpoint

echo "Validating the application is running..."
curl --silent --fail "${APP_URL}"
if [ $? -ne 0 ]; then
  echo "Application validation failed. The service is not running on port 3000."
  exit 1
fi

echo "Application is running and validated successfully."
