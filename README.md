# Gaia Tools Workspace

This workspace contains the Gaia astrological charting system packages and applications.

## Workspace Structure

The workspace is organized as a monorepo with the following structure:

```
gaia-tools/
├── coeus-api-client/          # @gaia-tools/coeus-api-client - TypeScript API client SDK
├── coeus-api/                  # Backend API (FastAPI/Python)
├── aphrodite-d3/               # @gaia-tools/aphrodite-d3 - D3-based chart renderer
├── crius-ephemeris-core/      # crius-ephemeris-core - Python ephemeris types and interfaces
├── crius-swiss/               # crius-swiss - Swiss Ephemeris adapter (AGPL)
└── gaia-tools/                # Workspace configuration and scripts
    ├── package.json           # Root workspace package.json
    ├── pnpm-workspace.yaml    # pnpm workspace configuration
    ├── docker-compose.yml     # Docker Compose for local development
    └── TESTING.md             # Testing guide
```

## Packages

### Published Packages

#### `@gaia-tools/coeus-api-client`

TypeScript client SDK for the Gaia astrological charting backend API.

- **Repository**: [coeus-api-client](https://github.com/emmygrace/coeus-api-client)
- **Documentation**: See [coeus-api-client/README.md](../coeus-api-client/README.md)
- **Published to**: npm
- **Version**: 0.1.0

### Local Development Packages

#### `@gaia-tools/aphrodite-d3`

D3-based TypeScript + SVG library for rendering astrological charts.

- **Location**: `../aphrodite-d3/`
- **Documentation**: See [aphrodite-d3/README.md](../aphrodite-d3/README.md)

### Python Packages

#### `crius-ephemeris-core`

Core ephemeris types and interfaces for astrological calculations. Pure abstractions with no external dependencies.

- **Location**: `../crius-ephemeris-core/`
- **Documentation**: See [crius-ephemeris-core/README.md](../crius-ephemeris-core/README.md)
- **License**: MIT
- **Published to**: PyPI (when published)
- **Version**: 0.1.0

#### `crius-swiss`

Swiss Ephemeris adapter implementation that conforms to the `crius-ephemeris-core` protocol.

- **Location**: `../crius-swiss/`
- **Documentation**: See [crius-swiss/README.md](../crius-swiss/README.md)
- **License**: AGPL-3.0 (due to Swiss Ephemeris dependency)
- **Published to**: PyPI (when published)
- **Version**: 0.1.0
- **Note**: Requires Swiss Ephemeris data files (`.se1` files) - see [Swiss Ephemeris licensing](https://www.astro.com/swisseph/swephinfo_e.htm)

## Applications

### coeus-api

FastAPI backend providing the charting API.

- **Location**: `../coeus-api/`
- **Documentation**: See [coeus-api/README.md](../coeus-api/README.md)

## Getting Started

### Prerequisites

- Node.js 20+ and pnpm
- Python 3.11+ (for backend and Python packages)
- Docker and Docker Compose (optional, for containerized development)

### Installation

From the workspace root (`gaia-tools/gaia-tools/`):

**Quick Setup (Recommended):**

```bash
# Run the setup script to install all dependencies
./setup-dev.sh
```

**Manual Setup:**

```bash
# Install all Node.js dependencies
pnpm install

# Install Python packages in editable mode (for development)
cd ../crius-ephemeris-core && pip install -e . && cd -
cd ../crius-swiss && pip install -e . && cd -
cd ../coeus-api && pip install -r requirements.txt && pip install -e . && cd -
```

### Development

**Recommended Workflow - Hybrid Development:**

This workflow runs Docker services (postgres + backend) in containers while running TypeScript packages and the frontend locally for better development experience:

```bash
# Start all services and packages in development mode
./dev.sh
```

This will:
- Start PostgreSQL and backend API in Docker
- Start all TypeScript packages (`aphrodite-d3`, `coeus-api-client`) in watch mode

**Alternative - Docker Only:**

```bash
# Start only Docker services (postgres + coeus-api-backend)
docker compose up

# In separate terminals, start TypeScript packages:
cd gaia-tools && pnpm -r --parallel dev
```

**Manual Development Commands:**

```bash
# Build all packages
pnpm build

# Run all packages in dev mode (watch mode)
pnpm dev

# Run linting
pnpm lint

# Run tests
pnpm test
```

### Using Published vs Local Packages

#### Published Packages

**npm Packages:**

When `@gaia-tools/coeus-api-client` is published to npm, you can use it in your projects:

```bash
pnpm add @gaia-tools/coeus-api-client axios
```

**PyPI Packages:**

When the Python packages are published to PyPI, you can install them:

```bash
# Install crius-ephemeris-core (MIT licensed)
pip install crius-ephemeris-core

# Install crius-swiss (AGPL licensed, requires Swiss Ephemeris data files)
pip install crius-swiss
```

#### Local Development

For local development, packages are linked using `file:` protocol in `package.json`:

```json
{
  "dependencies": {
    "@gaia-tools/coeus-api-client": "file:../coeus-api-client"
  }
}
```

This allows you to:
- Make changes to packages and see them immediately in consuming applications
- Test package changes before publishing
- Develop packages and applications in parallel

## Package Publishing

### Publishing `@gaia-tools/coeus-api-client`

See the [coeus-api-client/PUBLISH_CHECKLIST.md](../coeus-api-client/PUBLISH_CHECKLIST.md) for detailed publishing instructions.

Quick steps:

1. Navigate to the package: `cd ../coeus-api-client`
2. Update version in `package.json` and `CHANGELOG.md`
3. Run `pnpm build` to build the package
4. Run `pnpm pack` to verify package contents
5. Run `npm publish` (or `pnpm publish`)

The `prepublishOnly` script will automatically run lint, test, and build before publishing.

## Workspace Configuration

### pnpm Workspace

The workspace uses pnpm workspaces defined in `pnpm-workspace.yaml`:

```yaml
packages:
  - 'packages/*'
  - 'apps/*'
  - 'aphrodite'
```

Note: The actual package locations may differ from the workspace patterns. Check individual `package.json` files for actual `file:` paths.

### TypeScript Configuration

Shared TypeScript configuration is in `tsconfig.base.json`. Individual packages extend this base configuration.

## Docker Development

The workspace includes Docker Compose configuration for local development. The recommended workflow uses a hybrid approach:

- **Docker services**: PostgreSQL and backend API (coeus-api)
- **Local development**: TypeScript packages (for better hot-reload and debugging)

### Docker Services

```bash
# Start Docker services (postgres + coeus-api-backend)
docker compose up

# Start specific service
docker compose up coeus-api-backend

# View logs
docker compose logs -f coeus-api-backend

# Stop services
docker compose down
```

### Development Workflow

The `dev.sh` script orchestrates the full development environment:

1. **First time setup:**
   ```bash
   ./setup-dev.sh
   ```

2. **Daily development:**
   ```bash
   ./dev.sh
   ```

This starts:
- PostgreSQL (port 5432)
- Backend API (http://localhost:8000)
- All TypeScript packages in watch mode

### Package Development

All packages support hot-reload during development:

- **TypeScript packages**: Use `pnpm dev` in each package or `pnpm -r --parallel dev` from workspace root
- **Python packages**: Installed in editable mode (`pip install -e .`), changes are reflected immediately
- **Backend API**: Uses uvicorn `--reload` flag for automatic restarts on code changes

See `docker-compose.yml` for service configurations.

## Testing

See [TESTING.md](./TESTING.md) for comprehensive testing documentation.

Quick test commands:

```bash
# Run all tests
pnpm test

# Run unit tests only
pnpm test:unit

# Run backend tests
pnpm test:backend

# Run integration tests
pnpm test:integration
```

## Scripts

Available workspace scripts (run from `gaia-tools/` directory):

- `pnpm build` - Build all packages
- `pnpm dev` - Run all packages in development mode
- `pnpm lint` - Lint all packages
- `pnpm test` - Run all tests
- `pnpm test:unit` - Run unit tests for packages only
- `pnpm test:backend` - Run backend tests
- `pnpm test:integration` - Run integration tests
- `pnpm test:coverage` - Run tests with coverage

## Related Documentation

### Workspace Documentation
- [TESTING.md](./TESTING.md) - Testing guide

### TypeScript/JavaScript Packages
- [coeus-api-client/README.md](../coeus-api-client/README.md) - API client documentation
- [aphrodite-d3/README.md](../aphrodite-d3/README.md) - D3-based chart renderer documentation

### Applications
- [coeus-api/README.md](../coeus-api/README.md) - Backend API documentation

### Python Packages
- [crius-ephemeris-core/README.md](../crius-ephemeris-core/README.md) - Ephemeris core types and interfaces
- [crius-swiss/README.md](../crius-swiss/README.md) - Swiss Ephemeris adapter documentation

## License

MIT

