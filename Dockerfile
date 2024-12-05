# Stage 1: Build the React application
FROM node:18-alpine AS builder

# Set working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application files
COPY . .

# Build the React application for production
RUN npm run build

# Stage 2: Serve the React app using Nginx
FROM nginx:1.25-alpine

# Copy custom Nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Remove default Nginx website
RUN rm -rf /usr/share/nginx/html/*

# Copy React build artifacts from the builder stage
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port 80 for Nginx
EXPOSE 3000

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
