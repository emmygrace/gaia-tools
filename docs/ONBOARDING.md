# Developer Onboarding Guide

Welcome to the Gaia Tools project! This guide will help you get started with development.

## Prerequisites

- **Node.js**: 20+ and pnpm
- **Python**: 3.11+
- **Docker**: For running services locally (optional)
- **Git**: For version control

## Initial Setup

### 1. Clone the Repository

```bash
git clone https://github.com/gaia-tools/gaia-tools.git
cd gaia-tools/gaia-tools
```

### 2. Install Dependencies

```bash
# Install all dependencies
./setup-dev.sh

# Or manually:
pnpm install
cd ../crius-ephemeris-core && pip install -e . && cd -
cd ../crius-swiss && pip install -e . && cd -
cd ../crius-jpl && pip install -e . && cd -
cd ../coeus-api && pip install -r requirements.txt && cd -
```

### 3. Start Development Environment

```bash
# Start all services
./dev.sh

# Or start individually:
docker compose up  # Backend services
pnpm dev           # TypeScript packages
```

## Project Structure

```
gaia-tools/
├── gaia-tools/          # Monorepo root
│   ├── scripts/         # Utility scripts
│   └── .github/         # CI/CD workflows
├── coeus-api/           # FastAPI backend
├── iris-core/           # TypeScript client bundle
├── aphrodite-d3/        # D3 chart renderer
├── aphrodite-shared/    # Shared configurations
├── crius-ephemeris-core/ # Python ephemeris types
├── crius-swiss/         # Swiss Ephemeris adapter
└── crius-jpl/           # JPL Ephemeris adapter
```

## Common Tasks

### Running Tests

```bash
# All tests
pnpm test

# Backend only
pnpm test:backend

# With coverage
pnpm test:coverage
```

### Building Packages

```bash
# Build all
pnpm build

# Build specific package
cd ../iris-core && pnpm build
```

### Version Management

```bash
# Bump version (patch/minor/major)
pnpm version:patch

# Generate changelog
pnpm changelog
```

### Publishing

```bash
# Publish all packages
pnpm publish

# Publish specific package
./scripts/publish.sh iris-core
```

## Development Tips

1. **Hot Reload**: TypeScript packages support hot-reload in dev mode
2. **Python Packages**: Installed in editable mode, changes reflect immediately
3. **Docker Services**: Use `docker compose logs -f` to view logs
4. **API Testing**: Use `/docs` endpoint for interactive API testing

## Troubleshooting

### Python Import Errors
- Ensure packages are installed in editable mode: `pip install -e .`
- Check virtual environment is activated

### TypeScript Build Errors
- Clear node_modules: `rm -rf node_modules && pnpm install`
- Check TypeScript version compatibility

### Docker Issues
- Restart services: `docker compose down && docker compose up`
- Check logs: `docker compose logs`

## Next Steps

- Read [CONTRIBUTING.md](../CONTRIBUTING.md) for contribution guidelines
- Check [ARCHITECTURE.md](./ARCHITECTURE.md) for system design
- Explore the codebase starting with `coeus-api/README.md`

## Getting Help

- Open an issue on GitHub
- Check existing documentation
- Review test files for usage examples

