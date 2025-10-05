# syntax=docker/dockerfile:1

ARG NODE_VERSION=24.8.0
FROM node:${NODE_VERSION}-alpine

# Set working directory inside container
WORKDIR /usr/src/app

# Set environment to production
ENV NODE_ENV=production

# Copy dependency files first for efficient caching
COPY package*.json ./

# Install dependencies (omit devDependencies in production)
RUN npm ci --omit=dev

# Copy all other project files
COPY . .

# Use a non-root user
USER node

# Expose app port
EXPOSE 3000

# Run the app (your entry file is inside src)
CMD ["node", "src/index.js"]
