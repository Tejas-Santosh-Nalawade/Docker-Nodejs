# Docker-Nodejs: A Complete Guide to Containerized Node.js Development

[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)
[![Node.js](https://img.shields.io/badge/Node.js-18+-339933?logo=node.js&logoColor=white)](https://nodejs.org/)

> A comprehensive, beginner-friendly guide to developing, building, and deploying Node.js applications using Docker and Docker Compose.

## 📋 Table of Contents

- [Overview](#overview)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Why Docker for Development?](#why-docker-for-development)
- [Getting Started](#getting-started)
  - [Method 1: Using Docker Commands](#method-1-using-docker-commands)
  - [Method 2: Using Docker Compose (Recommended)](#method-2-using-docker-compose-recommended)
- [Development Workflow](#development-workflow)
- [Working with Databases](#working-with-databases)
- [Running Tests](#running-tests)
- [Common Operations](#common-operations)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)

---

## 🎯 Overview

This repository demonstrates how to containerize a Node.js application using Docker. Whether you're new to Docker or looking to streamline your development workflow, this guide provides step-by-step instructions for:

- Building and running your application in isolated containers
- Setting up a complete development environment with hot-reload
- Integrating databases (PostgreSQL) using Docker Compose
- Testing your application in containerized environments
- Preparing for production deployment

**What you'll learn:**
- Docker fundamentals through practical examples
- Container orchestration with Docker Compose
- Development best practices for containerized applications

## 📁 Project Structure

```
docker-nodejs/
├── Dockerfile              # Instructions to build the Node.js app image
├── compose.yaml            # Multi-container application configuration
├── package.json            # Node.js dependencies and scripts
├── src/                    # Application source code
│   ├── index.js           # Main application entry point
│   ├── routes/            # API route handlers
│   └── persistence/       # Database connection logic
├── static/                 # Frontend assets (HTML, CSS, JavaScript)
└── spec/                   # Test files
```

## ✅ Prerequisites

Before you begin, ensure you have the following installed on your system:

### Required Software

1. **Docker Desktop for Windows** (recommended) or Docker Engine
   - Download from: <https://www.docker.com/products/docker-desktop>
   - Docker Desktop includes Docker Compose v2 by default
   - Minimum system requirements: Windows 10 64-bit or Windows 11

2. **PowerShell** (comes pre-installed with Windows)
   - Used to run Docker commands throughout this guide

### Verifying Your Installation

Open PowerShell and run these commands to verify Docker is properly installed:

```powershell
# Check Docker version (should return version 20.10 or higher)
docker --version

# Check Docker Compose version (should return version 2.0 or higher)
docker compose version

# Verify Docker is running (should list running containers, even if empty)
docker ps
```

**Expected Output:**
```
Docker version 24.0.0, build abc1234
Docker Compose version v2.20.0
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

If you see version numbers, you're ready to proceed! If you encounter errors, ensure Docker Desktop is running (check your system tray).

## 🐳 Why Docker for Development?

If you're new to Docker, you might wonder: "Why use containers instead of just running Node.js on my computer?" Here's why Docker has become essential for modern development:

### Key Benefits

#### 1. **"It Works on My Machine" - Solved!**
Docker packages your app with all its dependencies (Node.js version, system libraries, configurations) into a single container. If it works in a container on your machine, it will work identically on your teammate's machine and in production.

#### 2. **Clean, Isolated Environments**
Each project runs in its own container with its own dependencies. No more conflicts between:
- Different Node.js versions for different projects
- Global npm packages interfering with each other
- System library version mismatches

#### 3. **Quick Onboarding for New Team Members**
Instead of spending hours installing Node.js, PostgreSQL, Redis, and configuring everything, new developers just need to:
1. Install Docker
2. Run `docker compose up`
3. Start coding!

#### 4. **Mirrors Production Environment**
Your local development container can use the same image as production, reducing deployment surprises. What you test locally is what runs in production.

#### 5. **Easy Multi-Service Setup**
Need your app + database + cache? Docker Compose lets you start all services with a single command, pre-configured and networked together.

#### 6. **Safe Experimentation**
Want to try Node.js 20 instead of 18? Just change the image tag. No risk to your system installation. Delete the container when done—your host machine stays clean.

### Real-World Example

**Without Docker:**
```powershell
# Install Node.js 18
# Install PostgreSQL
# Configure PostgreSQL
# Set environment variables
# Install dependencies
# Hope everything works together
```

**With Docker:**
```powershell
docker compose up  # Everything just works!
```

### Development Best Practices with Docker

✅ **DO:**
- Use **bind mounts** to sync your code into containers (enables live-reload with nodemon)
- Keep a `.dockerignore` file to speed up builds (exclude `node_modules`, `.git`, etc.)
- Use `docker-compose.override.yaml` for local dev settings (explained later)
- Run `npm install` inside containers to avoid Windows/Linux binary conflicts

❌ **DON'T:**
- Bind-mount `node_modules` from Windows into Linux containers (causes native module issues)
- Store sensitive data in images (use environment variables or secrets)
- Run containers as root in production (use non-root users)

## 🚀 Getting Started

There are two ways to run this application with Docker. Choose the method that suits your needs:

- **Method 1**: Direct Docker commands (good for learning Docker basics)
- **Method 2**: Docker Compose (recommended for most use cases - simpler and more powerful)

### Method 1: Using Docker Commands

This method teaches you the fundamental Docker commands step-by-step.

#### Step 1: Build the Docker Image

Navigate to the project root directory (where the `Dockerfile` is located) and build the image:

```powershell
docker build -t docker-nodejs:latest .
```

**What this does:**
- `docker build` - Tells Docker to create a new image
- `-t docker-nodejs:latest` - Tags (names) your image as "docker-nodejs" with version "latest"
- `.` - Uses the current directory (looks for `Dockerfile` here)

**Expected output:**
```text
[+] Building 23.5s (12/12) FINISHED
 => [internal] load build definition from Dockerfile
 => [internal] load .dockerignore
 => [internal] load metadata for docker.io/library/node:18
 ...
 => => naming to docker.io/library/docker-nodejs:latest
```

#### Step 2: Run the Container

Start a container from the image you just built:

```powershell
docker run --rm -p 3000:3000 --name docker-nodejs-app docker-nodejs:latest
```

**What this does:**
- `docker run` - Creates and starts a new container
- `--rm` - Automatically removes the container when it stops (keeps things clean)
- `-p 3000:3000` - Maps port 3000 on your computer to port 3000 in the container
- `--name docker-nodejs-app` - Gives your container a friendly name
- `docker-nodejs:latest` - The image to use

**Expected output:**
```text
Server is listening on port 3000
```

#### Step 3: Access the Application

Open your web browser and visit:

**<http://localhost:3000>**

You should see the application running! 🎉

#### Step 4: Stop the Container

Press `Ctrl + C` in the terminal where the container is running. The container will stop and be automatically removed (thanks to the `--rm` flag).

---

### Method 2: Using Docker Compose (Recommended)

Docker Compose simplifies running multi-container applications. Even for single containers, it's more convenient than remembering long `docker run` commands.

#### Step 1: Review the Configuration

The `compose.yaml` file in the project root defines how to run your application:

```yaml
services:
  server:
    build:
      context: .
    environment:
      NODE_ENV: production
    ports:
      - 3000:3000
```

This tells Docker Compose to:
- Build an image from the current directory
- Set the environment to production
- Expose the app on port 3000

#### Step 2: Start All Services

From the project root, run:

```powershell
docker compose up --build
```

**What this does:**
- `docker compose up` - Starts all services defined in `compose.yaml`
- `--build` - Rebuilds the image if the code has changed

**Running in the background (detached mode):**

```powershell
docker compose up --build -d
```

The `-d` flag runs containers in the background, freeing up your terminal.

#### Step 3: Access the Application

Visit **<http://localhost:3000>** in your browser.

#### Step 4: View Logs (if running in detached mode)

```powershell
# View all logs
docker compose logs

# Follow logs in real-time
docker compose logs -f

# View logs for a specific service
docker compose logs server
```

#### Step 5: Stop All Services

```powershell
docker compose down
```

This stops and removes all containers, networks created by Compose. Your images remain for faster future starts.

## 💻 Development Workflow

When developing, you want your code changes to be reflected immediately without rebuilding the Docker image each time. This section shows you how to set up **live-reload** with Docker.

### Understanding the Development Setup

In development mode:
- Your source code is **mounted** into the container (not copied)
- When you edit files on your computer, changes appear instantly in the container
- **Nodemon** watches for changes and automatically restarts the Node.js server
- The debugger is exposed so you can debug from VS Code or Chrome DevTools

### Option 1: Development with Docker Run

This example mounts your `src` folder and runs the dev script:

```powershell
docker run --rm `
  -p 3000:3000 `
  -p 9229:9229 `
  -v ${PWD}/src:/app/src `
  -w /app `
  --name docker-nodejs-dev `
  node:18 `
  pwsh -c "npm install && npm run dev"
```

**Command Breakdown:**

- `-p 3000:3000` - Exposes the app on port 3000
- `-p 9229:9229` - Exposes Node.js inspector for debugging
- `-v ${PWD}/src:/app/src` - Mounts your local `src` folder into the container at `/app/src`
- `-w /app` - Sets the working directory inside the container
- `node:18` - Uses the official Node.js 18 image (lighter than building our custom image)
- `npm run dev` - Runs the dev script from `package.json` (starts nodemon)

**Note for CMD or Git Bash users:**
- In CMD, replace `${PWD}` with `%cd%`
- In Git Bash, `${PWD}` works as-is

### Option 2: Development with Docker Compose (Recommended)

Create a file named `docker-compose.override.yaml` in the project root:

```yaml
# docker-compose.override.yaml
# This file is automatically loaded by Docker Compose for local development
services:
  server:
    build:
      context: .
      target: development  # If you have a multi-stage Dockerfile
    volumes:
      - ./src:/app/src
      - ./static:/app/static
    ports:
      - "3000:3000"
      - "9229:9229"
    environment:
      - NODE_ENV=development
    command: npm run dev
```

Then simply run:

```powershell
docker compose up
```

Docker Compose automatically merges `compose.yaml` and `docker-compose.override.yaml`, applying your dev settings.

### Debugging Your Application

With port 9229 exposed, you can attach a debugger:

**VS Code Setup:**

Create `.vscode/launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Docker: Attach to Node",
      "type": "node",
      "request": "attach",
      "port": 9229,
      "address": "localhost",
      "localRoot": "${workspaceFolder}/src",
      "remoteRoot": "/app/src",
      "protocol": "inspector"
    }
  ]
}
```

1. Start your container with dev mode
2. Press `F5` in VS Code or go to Run → Start Debugging
3. Set breakpoints and debug!

---

## 🗄️ Working with Databases

Real applications need databases. This section shows you how to add PostgreSQL using Docker Compose.

### Understanding the Database Setup

The `compose.yaml` file includes a commented PostgreSQL example. When enabled:
- A PostgreSQL database runs in its own container
- The app connects to it using the service name `db` as the hostname
- Data persists in a Docker volume (survives container restarts)
- Database credentials are managed with Docker secrets (secure)

### Step 1: Enable PostgreSQL in Compose

Open `compose.yaml` and uncomment the database section:

```yaml
services:
  server:
    build:
      context: .
    depends_on:
      db:
        condition: service_healthy  # Wait for DB to be ready
    environment:
      - POSTGRES_HOST=db
      - POSTGRES_DB=example
      - POSTGRES_USER=postgres
    ports:
      - 3000:3000

  db:
    image: postgres:15
    restart: always
    secrets:
      - db-password
    volumes:
      - db-data:/var/lib/postgresql/data
    environment:
      - POSTGRES_DB=example
      - POSTGRES_PASSWORD_FILE=/run/secrets/db-password
    expose:
      - 5432
    healthcheck:
      test: ["CMD", "pg_isready", "-U", "postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

volumes:
  db-data:

secrets:
  db-password:
    file: db/password.txt
```

### Step 2: Create Database Password File

Create a directory and password file:

```powershell
# Create the directory
New-Item -ItemType Directory -Force -Path db

# Create password file (replace 'your_secure_password' with a real password)
"your_secure_password" | Out-File -FilePath db/password.txt -NoNewline
```

**Important:** Add `db/password.txt` to your `.gitignore` so passwords aren't committed!

### Step 3: Update Your Application

Modify your app to connect to PostgreSQL. Example using the `pg` library (already in `package.json`):

```javascript
// src/persistence/postgres.js
const { Pool } = require('pg');

const pool = new Pool({
  host: process.env.POSTGRES_HOST || 'db',
  database: process.env.POSTGRES_DB || 'example',
  user: process.env.POSTGRES_USER || 'postgres',
  password: process.env.POSTGRES_PASSWORD,
  port: 5432,
});

module.exports = pool;
```

### Step 4: Start Everything

```powershell
docker compose up --build
```

Docker Compose will:
1. Start the PostgreSQL container
2. Wait for it to be healthy (via the healthcheck)
3. Start your application container
4. Connect them on a private network

### Step 5: Access the Database

**From your application:** Use the hostname `db` and port `5432`

**From your host machine (for debugging):** Expose the port in `compose.yaml`:

```yaml
db:
  image: postgres:15
  ports:
    - "5432:5432"  # Add this line
```

Then connect with any PostgreSQL client:
```powershell
psql -h localhost -U postgres -d example
```

---

## 🧪 Running Tests

### Running Tests Locally (Outside Containers)

If you have Node.js installed locally:

```powershell
# Install dependencies
npm install

# Run all tests
npm test

# Run tests in watch mode
npm test -- --watch
```

### Running Tests Inside Containers

**Method 1: Quick Test Run**

```powershell
docker run --rm -v ${PWD}:/app -w /app node:18 pwsh -c "npm install && npm test"
```

**Method 2: Add a Test Service to Compose**

Add to your `docker-compose.override.yaml`:

```yaml
services:
  test:
    build:
      context: .
    volumes:
      - ./src:/app/src
      - ./spec:/app/spec
    environment:
      - NODE_ENV=test
    command: npm test
```

Run tests with:

```powershell
docker compose run --rm test
```

### Continuous Testing in Docker

For test-driven development with auto-rerun on changes:

```powershell
docker compose run --rm test npm test -- --watch
```

## 🔧 Common Operations

Here are the most frequently used Docker commands you'll need for day-to-day development.

### Viewing Running Containers

```powershell
# List all running containers
docker ps

# List all containers (including stopped ones)
docker ps -a
```

**Output example:**
```text
CONTAINER ID   IMAGE              COMMAND                  CREATED         STATUS         PORTS                    NAMES
abc123def456   docker-nodejs      "docker-entrypoint.s…"   5 minutes ago   Up 5 minutes   0.0.0.0:3000->3000/tcp   docker-nodejs-app
```

### Viewing Logs

**For standalone containers:**

```powershell
# View all logs
docker logs docker-nodejs-app

# Follow logs in real-time (like tail -f)
docker logs -f docker-nodejs-app

# View last 50 lines
docker logs --tail 50 docker-nodejs-app
```

**For Docker Compose:**

```powershell
# View logs from all services
docker compose logs

# Follow logs in real-time
docker compose logs -f

# View logs from a specific service
docker compose logs server

# View logs from multiple services
docker compose logs server db
```

### Accessing a Container Shell

Sometimes you need to run commands inside a running container:

```powershell
# Open PowerShell inside the container
docker exec -it docker-nodejs-app pwsh

# Open bash (if available)
docker exec -it docker-nodejs-app bash

# For Compose services
docker compose exec server pwsh
```

**Once inside the container, you can:**
- Inspect files: `ls`, `cat`, `pwd`
- Check environment variables: `printenv`
- Run Node.js commands: `node -v`, `npm list`
- Debug issues in the live environment

**Exit the container shell:** Type `exit` or press `Ctrl + D`

### Restarting Containers

```powershell
# Restart a specific container
docker restart docker-nodejs-app

# Restart all Compose services
docker compose restart

# Restart a specific Compose service
docker compose restart server
```

### Stopping and Removing Containers

```powershell
# Stop a container (graceful shutdown)
docker stop docker-nodejs-app

# Force stop (if container doesn't respond)
docker kill docker-nodejs-app

# Remove a stopped container
docker rm docker-nodejs-app

# Stop and remove in one command
docker rm -f docker-nodejs-app

# For Compose - stop and remove all containers
docker compose down

# Also remove volumes (CAUTION: deletes database data!)
docker compose down -v
```

### Managing Images

```powershell
# List all images
docker images

# Remove an image
docker rmi docker-nodejs:latest

# Remove unused images (frees disk space)
docker image prune

# Remove all unused images (more aggressive)
docker image prune -a
```

### Cleaning Up Docker Resources

Docker can accumulate unused resources over time. Here's how to clean up:

```powershell
# Remove stopped containers
docker container prune

# Remove unused images
docker image prune

# Remove unused volumes
docker volume prune

# Remove unused networks
docker network prune

# Remove everything unused (containers, networks, images, build cache)
docker system prune

# Include volumes in cleanup (CAUTION: removes database data!)
docker system prune --volumes

# See how much space Docker is using
docker system df
```

### Rebuilding After Code Changes

**When using direct Docker commands:**

```powershell
# Rebuild the image
docker build -t docker-nodejs:latest .

# Stop old container and start new one
docker rm -f docker-nodejs-app
docker run --rm -p 3000:3000 --name docker-nodejs-app docker-nodejs:latest
```

**When using Docker Compose:**

```powershell
# Rebuild and restart
docker compose up --build

# Force rebuild (ignores cache)
docker compose build --no-cache
docker compose up
```

---

## 🔍 Troubleshooting

### Issue: "Port 3000 is already in use"

**Error message:**
```text
Error starting userland proxy: listen tcp4 0.0.0.0:3000: bind: Only one usage of each socket address
```

**Solution:**

**Option 1 - Find and stop the process using the port:**

```powershell
# Find what's using port 3000
netstat -ano | findstr :3000

# Output shows PID (last column):
#   TCP    0.0.0.0:3000    0.0.0.0:0    LISTENING    12345

# Stop the process (replace 12345 with the actual PID)
Stop-Process -Id 12345 -Force
```

**Option 2 - Use a different port:**

```powershell
# Run on port 3001 instead
docker run --rm -p 3001:3000 --name docker-nodejs-app docker-nodejs:latest

# Or modify compose.yaml:
ports:
  - "3001:3000"
```

### Issue: "Cannot connect to Docker daemon"

**Error message:**
```text
error during connect: This error may indicate that the docker daemon is not running
```

**Solution:**

1. Open Docker Desktop from your Start menu
2. Wait for Docker Desktop to fully start (icon in system tray turns solid)
3. Verify: `docker ps` should work without errors

### Issue: Code changes not reflecting in the container

**Problem:** You edit a file but the app doesn't update.

**Solution:**

1. **Check if you're using a bind mount:**
   - Development mode requires `-v ${PWD}/src:/app/src` or similar
   - Production mode copies files into the image (requires rebuild)

2. **Verify nodemon is running:**
   ```powershell
   docker logs docker-nodejs-app
   # Should see: [nodemon] watching path(s)...
   ```

3. **Check file permissions (Windows/WSL):**
   - Make sure files aren't read-only
   - Check Docker Desktop settings → Resources → File Sharing

### Issue: "npm ERR! code ELIFECYCLE" or similar npm errors

**Solution:**

1. **Clear node_modules and reinstall:**
   ```powershell
   # Remove local node_modules
   Remove-Item -Recurse -Force node_modules
   
   # Rebuild container (it will reinstall dependencies)
   docker compose up --build
   ```

2. **Check Node.js version compatibility:**
   - Verify `package.json` "engines" field matches Dockerfile Node version

### Issue: Database connection failures

**Error:** `ECONNREFUSED` or "could not connect to server"

**Solution:**

1. **Verify database is running:**
   ```powershell
   docker compose ps
   # db service should show "Up" and "healthy"
   ```

2. **Check healthcheck:**
   ```powershell
   docker compose logs db
   # Should see: "database system is ready to accept connections"
   ```

3. **Verify connection settings:**
   - Host should be `db` (not `localhost`) when connecting from app container
   - Port should be `5432` (internal port, not mapped port)

4. **Check depends_on with condition:**
   ```yaml
   depends_on:
     db:
       condition: service_healthy  # Waits for DB to be ready
   ```

### Issue: "EACCES: permission denied" errors

**Problem:** Container can't write to mounted volumes.

**Solution:**

1. **Check Docker Desktop file sharing settings:**
   - Settings → Resources → File Sharing
   - Ensure your project directory is shared

2. **Run container with correct user (Linux/WSL):**
   ```dockerfile
   # Add to Dockerfile
   RUN chown -R node:node /app
   USER node
   ```

### Issue: Slow performance on Windows

**Problem:** Container feels sluggish, especially with many files.

**Solution:**

1. **Use WSL 2 backend (recommended):**
   - Docker Desktop → Settings → General → "Use WSL 2 based engine"

2. **Store project in WSL filesystem:**
   - Move project to `\\wsl$\Ubuntu\home\username\projects`
   - Much faster than Windows filesystem with bind mounts

3. **Use .dockerignore:**
   ```text
   node_modules
   .git
   .vscode
   *.log
   ```

### Getting Help

If you're still stuck:

1. **Check container logs:**
   ```powershell
   docker compose logs -f
   ```

2. **Inspect container:**
   ```powershell
   docker inspect docker-nodejs-app
   ```

3. **Verify Docker setup:**
   ```powershell
   docker version
   docker compose version
   docker info
   ```

4. **Test network connectivity:**
   ```powershell
   docker compose exec server ping db
   ```

---

## 📚 Best Practices

Follow these best practices to write better Dockerfiles and use Docker effectively.

### Dockerfile Best Practices

✅ **Use specific image tags, not `latest`:**
```dockerfile
# ❌ Bad - version can change unexpectedly
FROM node:latest

# ✅ Good - predictable and reproducible
FROM node:18-alpine
```

✅ **Use multi-stage builds for smaller production images:**
```dockerfile
# Build stage
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .

# Production stage
FROM node:18-alpine
WORKDIR /app
COPY --from=builder /app .
USER node
CMD ["node", "src/index.js"]
```

✅ **Create a `.dockerignore` file:**
```text
node_modules
npm-debug.log
.git
.gitignore
README.md
.env
.DS_Store
*.log
.vscode
```

✅ **Run containers as non-root user:**
```dockerfile
# Add to your Dockerfile
USER node
```

✅ **Use layer caching effectively:**
```dockerfile
# ✅ Good - only re-runs npm install if package.json changes
COPY package*.json ./
RUN npm ci
COPY . .

# ❌ Bad - reinstalls dependencies even if only code changes
COPY . .
RUN npm install
```

### Docker Compose Best Practices

✅ **Use environment files for configuration:**
```yaml
services:
  server:
    env_file:
      - .env
```

✅ **Define health checks:**
```yaml
services:
  server:
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
```

✅ **Use named volumes for persistence:**
```yaml
volumes:
  db-data:  # Named volume persists data
```

✅ **Set resource limits (production):**
```yaml
services:
  server:
    deploy:
      resources:
        limits:
          cpus: '1'
          memory: 512M
```

### Security Best Practices

🔒 **Never commit secrets to Git:**
```bash
# Add to .gitignore
.env
db/password.txt
*.pem
*.key
```

🔒 **Use Docker secrets or environment variables:**
```yaml
secrets:
  db-password:
    file: ./db/password.txt  # Store locally, never commit
```

🔒 **Scan images for vulnerabilities:**
```powershell
docker scan docker-nodejs:latest
```

🔒 **Keep base images updated:**
```powershell
# Regularly pull updated base images
docker pull node:18-alpine
docker compose build --pull
```

### Development vs Production

**Development:**
- Use bind mounts for live-reload
- Expose debug ports
- Use detailed logging
- Include dev dependencies

**Production:**
- Copy code into image (no mounts)
- Don't expose debug ports
- Use minimal logging
- Install only production dependencies (`npm ci --production`)
- Use smaller base images (alpine variants)
- Run as non-root user

---

## 🎓 Additional Resources

### Learn More About Docker

- **Official Docker Documentation:** <https://docs.docker.com/>
- **Docker Compose Specification:** <https://docs.docker.com/compose/compose-file/>
- **Node.js Docker Best Practices:** <https://github.com/nodejs/docker-node/blob/main/docs/BestPractices.md>

### Useful Docker Commands Cheat Sheet

```powershell
# Build and Run
docker build -t myapp .
docker run -p 3000:3000 myapp
docker compose up -d

# Manage Containers
docker ps                           # List running containers
docker ps -a                        # List all containers
docker stop <container_id>          # Stop container
docker rm <container_id>            # Remove container
docker logs -f <container_id>       # Follow logs

# Manage Images
docker images                       # List images
docker rmi <image_id>               # Remove image
docker pull node:18                 # Pull image

# Cleanup
docker system prune                 # Remove unused resources
docker volume prune                 # Remove unused volumes
docker image prune -a               # Remove all unused images

# Inspect and Debug
docker exec -it <container_id> sh   # Access container shell
docker inspect <container_id>       # View container details
docker stats                        # View resource usage
```

---

## 🤝 Contributing

Contributions are welcome! If you find issues or have suggestions:

1. Fork this repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

---

## 📄 License

This project is licensed under the MIT License.

---

## ✨ Summary

You've learned how to:

- ✅ Build and run Node.js applications in Docker containers
- ✅ Use Docker Compose to manage multi-container applications
- ✅ Set up a development workflow with live-reload
- ✅ Integrate PostgreSQL database with Docker
- ✅ Run tests in containerized environments
- ✅ Debug common Docker issues
- ✅ Follow best practices for security and performance

**Next Steps:**
- Explore the source code in `src/`
- Modify the application and see changes in real-time
- Add more services (Redis, MongoDB) to your Compose setup
- Deploy your Dockerized app to a cloud platform

---

**Questions or feedback?** Open an issue in this repository!

Happy Dockerizing! 🐳
