# Development Workflow Guide

This guide explains the recommended workflow for developing all Gaia Tools packages together in real-time.

## Overview

The development workflow uses a **hybrid approach**:
- **Docker**: PostgreSQL and backend API (for service isolation)
- **Local**: TypeScript packages and Next.js frontend (for better hot-reload and debugging)

## Quick Start

### First Time Setup

```bash
cd /home/emmy/git/gaia-tools/gaia-tools
./setup-dev.sh
```

This will:
- Install Python packages in editable mode (`crius-ephemeris-core`, `crius-swiss`, `coeus-api`)
- Install Node.js dependencies via pnpm
- Verify Docker is available

### Daily Development

```bash
cd /home/emmy/git/gaia-tools/gaia-tools
./dev.sh
```

This starts:
- PostgreSQL (port 5432)
- Backend API (http://localhost:8000)
- All TypeScript packages in watch mode
- Next.js frontend (http://localhost:3000)

Press `Ctrl+C` to stop all services.

## Package Structure

```
gaia-tools/
├── gaia-tools/              # Workspace root (pnpm workspace)
│   ├── setup-dev.sh        # Initial setup script
│   ├── dev.sh              # Development runner script
│   └── docker-compose.yml  # Docker services config
├── aphrodite-core/          # TypeScript package (no deps)
├── aphrodite-react/         # TypeScript package (depends on aphrodite-core, coeus-api-client)
├── coeus-api-client/        # TypeScript package (no deps)
├── coeus-api/               # Python FastAPI backend (depends on crius-swiss)
├── crius-ephemeris-core/    # Python package (no deps)
├── crius-swiss/             # Python package (depends on crius-ephemeris-core)
└── hyperion-server/         # Next.js frontend (depends on all TS packages)
```

## How It Works

### Python Packages

Python packages are installed in **editable mode** (`pip install -e .`), which means:
- Changes to source code are immediately available
- No need to reinstall after code changes
- Backend API automatically reloads via uvicorn `--reload` flag

### TypeScript Packages

TypeScript packages use **watch mode** (`pnpm dev`), which:
- Automatically rebuilds on file changes
- Updates consuming packages/apps immediately
- Provides fast feedback during development

### Docker Services

The backend runs in Docker with:
- Volume mounts for live code changes
- Editable Python package installation on startup
- Automatic reload on code changes
- Health checks for service dependencies

## Development Commands

### Individual Package Development

```bash
# TypeScript packages
cd ../aphrodite-core && pnpm dev
cd ../aphrodite-react && pnpm dev
cd ../coeus-api-client && pnpm dev

# Python packages (changes are immediate with editable install)
cd ../crius-ephemeris-core
# Edit code, changes are live

# Backend API
cd ../coeus-api
# Edit code, uvicorn auto-reloads
```

### Workspace Commands

```bash
# From gaia-tools/gaia-tools/
pnpm build          # Build all packages
pnpm dev            # Run all packages in watch mode
pnpm lint           # Lint all packages
pnpm test           # Test all packages
```

### Docker Commands

```bash
# From gaia-tools/gaia-tools/
docker compose up              # Start services
docker compose up -d           # Start in background
docker compose down            # Stop services
docker compose logs -f coeus-api-backend # View backend logs
docker compose ps              # Check service status
```

## Troubleshooting

### Backend not starting

1. Check Docker logs: `docker compose logs coeus-api-backend`
2. Verify Python packages are installed: `docker compose exec coeus-api-backend pip list | grep crius`
3. Check database connection: `docker compose ps postgres`

### TypeScript packages not rebuilding

1. Check if watch mode is running: `ps aux | grep "pnpm dev"`
2. Verify pnpm workspace: `cd gaia-tools && pnpm list`
3. Check for build errors: `pnpm build`

### Frontend not connecting to backend

1. Verify backend is running: `curl http://localhost:8000/`
2. Check frontend environment variables
3. Verify CORS settings in backend

### Python package changes not reflected

1. Verify editable install: `pip show crius-ephemeris-core` (should show location)
2. Restart backend: `docker compose restart coeus-api-backend`
3. Check PYTHONPATH in docker-compose.yml

## Best Practices

1. **Start with services**: Always start Docker services first, then packages
2. **One change at a time**: Make changes to one package at a time for easier debugging
3. **Check logs**: Use `docker compose logs -f` and package-specific logs
4. **Test incrementally**: Test changes as you make them
5. **Use watch mode**: Always use `pnpm dev` for TypeScript packages during development

## Alternative Workflows

### Docker-Only Development

If you prefer everything in Docker, uncomment the `nextjs` service in `docker-compose.yml` and update the volumes to match your structure.

### Local-Only Development

For local-only development (no Docker):
1. Install and run PostgreSQL locally
2. Run backend with: `cd ../coeus-api && uvicorn app.main:app --reload`
3. Run packages and frontend as usual

## Next Steps

- See [README.md](./README.md) for more details
- See [TESTING.md](./TESTING.md) for testing guidelines
- Check individual package READMEs for package-specific documentation

