# Custom Swiss Ephemeris Data Setup

This guide explains how to use your own Swiss Ephemeris data files with the Gaia backend.

## Overview

Swiss Ephemeris is dual-licensed under AGPL or a commercial license. Users must provide their own licensed ephemeris data files. The backend supports two methods for providing ephemeris data:

1. **Runtime Mounting** - Mount your ephemeris files as a Docker volume
2. **Custom Image Build** - Bake your ephemeris files into a custom Docker image

## Required Files

Your ephemeris directory should contain the Swiss Ephemeris data files, typically:
- `sepl_18.se1` - Planetary ephemeris
- `seplm18.se1` - Planetary ephemeris (monthly)
- `seas_18.se1` - Asteroids ephemeris
- `seasm18.se1` - Asteroids ephemeris (monthly)
- `semo_18.se1` - Moon ephemeris
- `semom18.se1` - Moon ephemeris (monthly)
- `sefstars.txt` - Fixed stars
- `seorbel.txt` - Orbital elements

## Method 1: Runtime Mounting (Recommended for Development)

This method mounts your ephemeris files at runtime, allowing you to update them without rebuilding images.

### Step 1: Prepare Your Ephemeris Directory

Place your licensed Swiss Ephemeris files in a directory on your host machine, for example:
```
~/my-ephemeris/
├── sepl_18.se1
├── seplm18.se1
├── seas_18.se1
├── seasm18.se1
├── semo_18.se1
├── semom18.se1
├── sefstars.txt
└── seorbel.txt
```

### Step 2: Update docker-compose.yml

Uncomment and configure the ephemeris volume mount in `docker-compose.yml`:

```yaml
backend:
  environment:
    SWISS_EPHEMERIS_PATH: /opt/ephemeris
  volumes:
    # ... other volumes ...
    - ${EPHEMERIS_DATA_PATH:-./custom-ephemeris}:/opt/ephemeris:ro
```

### Step 3: Set Environment Variable

Create a `.env` file in the project root (or export the variable):

```bash
EPHEMERIS_DATA_PATH=/path/to/your/ephemeris/directory
```

Or set it inline:
```bash
EPHEMERIS_DATA_PATH=~/my-ephemeris docker compose up
```

### Step 4: Start Services

```bash
docker compose up --build
```

The backend will now use your ephemeris files from the mounted volume.

## Method 2: Custom Image Build (Recommended for Production)

This method bakes your ephemeris files into the Docker image, creating a self-contained image that can be shared or deployed.

**Note:** If the default `coeus-api/swisseph/` directory doesn't exist or you want to exclude it from the build, you can create a `.dockerignore` file in the `coeus-api/` directory with:
```
swisseph/
```

This will prevent Docker from trying to copy the default ephemeris directory during build.

### Step 1: Prepare Your Ephemeris Directory

Create a directory structure for your build:

```
custom-backend/
├── Dockerfile
└── swisseph/
    ├── sepl_18.se1
    ├── seplm18.se1
    ├── seas_18.se1
    ├── seasm18.se1
    ├── semo_18.se1
    ├── semom18.se1
    ├── sefstars.txt
    └── seorbel.txt
```

### Step 2: Create Custom Dockerfile

Create a `Dockerfile` in your `custom-backend/` directory:

```dockerfile
FROM gaia-tools/coeus-api-backend:latest

# Copy your licensed ephemeris files
COPY swisseph/ /usr/local/share/swisseph/
RUN chmod -R 755 /usr/local/share/swisseph
```

Or build from the base image directly:

```dockerfile
# Build from the project's backend Dockerfile
FROM python:3.11-slim as base

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    libpq-dev \
    postgresql-client \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Create ephemeris directory
RUN mkdir -p /usr/local/share/swisseph && \
    chmod -R 755 /usr/local/share/swisseph

# Copy your licensed ephemeris files
COPY swisseph/ /usr/local/share/swisseph/
RUN chmod -R 755 /usr/local/share/swisseph

WORKDIR /app

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose port
EXPOSE 8000

# Production command
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

### Step 3: Build Custom Image

If using the first approach (extending the base image):

```bash
# First, build the base backend image
cd /path/to/gaia-tools/coeus-api
docker build -t gaia-tools/coeus-api-backend:latest .

# Then build your custom image
cd /path/to/custom-backend
docker build -t gaia-tools/coeus-api-backend-custom:latest .
```

If using the second approach (standalone Dockerfile):

```bash
# Copy the backend code and your ephemeris files
cp -r /path/to/gaia-tools/coeus-api/* /path/to/custom-backend/
cp -r /path/to/gaia-tools/coeus-api/requirements.txt /path/to/custom-backend/

# Build the image
cd /path/to/custom-backend
docker build -t gaia-tools/coeus-api-backend-custom:latest .
```

### Step 4: Update docker-compose.yml

Update `docker-compose.yml` to use your custom image:

```yaml
coeus-api-backend:
  image: gaia-tools/coeus-api-backend-custom:latest
  build:  # Remove this if using pre-built image
    context: ./custom-backend
    dockerfile: Dockerfile
  environment:
    SWISS_EPHEMERIS_PATH: /usr/local/share/swisseph
  # ... rest of configuration ...
```

### Step 5: Start Services

```bash
docker compose up
```

## Verification

To verify that your ephemeris files are being used correctly:

1. Check the backend logs:
   ```bash
   docker compose logs coeus-api-backend
   ```

2. Test an API endpoint that requires ephemeris calculations:
   ```bash
   curl http://localhost:8000/api/v1/chart-instances/{instance_id}/render
   ```

3. If you see errors about missing ephemeris files, verify:
   - The `SWISS_EPHEMERIS_PATH` environment variable points to the correct directory
   - The ephemeris files are present and readable
   - The file permissions are correct (755 for directories, 644 for files)

## Troubleshooting

### Ephemeris Files Not Found

If you see errors like "ephemeris file not found":
- Verify the `SWISS_EPHEMERIS_PATH` environment variable is set correctly
- Check that the files are actually present in the container:
  ```bash
  docker compose exec coeus-api-backend ls -la $SWISS_EPHEMERIS_PATH
  ```
- Ensure file permissions allow reading

### Permission Denied

If you see permission errors:
- For mounted volumes, ensure the files are readable:
  ```bash
  chmod -R 755 /path/to/your/ephemeris
  ```
- For custom images, the Dockerfile should set permissions during build

### Wrong Ephemeris Data

If calculations seem incorrect:
- Verify you're using the correct version of ephemeris files for your use case
- Check that all required files are present (not just a subset)
- Ensure files are not corrupted

## Licensing Notes

**Important:** Swiss Ephemeris is dual-licensed:
- **AGPL License** - If you use AGPL-licensed Swiss Ephemeris, your entire application must be licensed under AGPL or compatible license
- **Commercial License** - Purchase a commercial license from Astrodienst to use Swiss Ephemeris in proprietary applications

Ensure you have the appropriate license for your use case before distributing images or services that include Swiss Ephemeris data.

## Additional Resources

- [Swiss Ephemeris Documentation](https://www.astro.com/swisseph/swephinfo_e.htm)
- [Swiss Ephemeris Licensing](https://www.astro.com/swisseph/swephinfo_e.htm#_Toc505244836)

