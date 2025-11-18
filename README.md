# Gaia Tools Workspace

This workspace contains the Gaia astrological charting system packages and applications.

## Workspace Structure

The workspace is organized as a monorepo with the following structure:

```
gaia-tools/
├── iris-core/                 # @gaia-tools/iris-core - Framework-agnostic client bundle
├── aphrodite-d3/              # @gaia-tools/aphrodite-d3 - D3-based chart renderer
├── aphrodite-shared/          # @gaia-tools/aphrodite-shared - Shared wheel definitions and configs
├── coeus-api/                 # Backend API (FastAPI/Python)
├── crius-ephemeris-core/      # crius-ephemeris-core - Python ephemeris types and interfaces
├── crius-swiss/               # crius-swiss - Swiss Ephemeris adapter (AGPL)
├── crius-jpl/                 # crius-jpl - JPL Ephemeris adapter (MIT)
└── gaia-tools/                # Workspace configuration and scripts
    ├── package.json           # Root workspace package.json
    ├── pnpm-workspace.yaml    # pnpm workspace configuration
    ├── docker-compose.yml     # Docker Compose for local development
    └── TESTING.md             # Testing guide
```

## Packages

### TypeScript/JavaScript Packages

#### `@gaia-tools/iris-core`

Lightweight, framework-agnostic client bundle for Gaia astrological charting. Combines API client, chart rendering, and client-side processing utilities.

- **Location**: `../iris-core/`
- **Documentation**: See [iris-core/README.md](../iris-core/README.md)
- **Published to**: npm (when published)
- **Version**: 0.1.0

#### `@gaia-tools/aphrodite-d3`

D3-based TypeScript + SVG library for rendering astrological charts.

- **Location**: `../aphrodite-d3/`
- **Documentation**: See [aphrodite-d3/README.md](../aphrodite-d3/README.md)
- **Published to**: npm (when published)
- **Version**: 0.1.0

#### `@gaia-tools/aphrodite-shared`

Platform-agnostic wheel definitions, visual/glyph configurations, and chart presets for the Aphrodite chart rendering system.

- **Location**: `../aphrodite-shared/`
- **Documentation**: See [aphrodite-shared/README.md](../aphrodite-shared/README.md)
- **Published to**: npm (when published)
- **Version**: 0.1.0

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

#### `crius-jpl`

JPL Ephemeris adapter implementation that conforms to the `crius-ephemeris-core` protocol. Uses NASA JPL's DE430t ephemeris data via the `skyfield` library.

- **Location**: `../crius-jpl/`
- **Documentation**: See [crius-jpl/README.md](../crius-jpl/README.md)
- **License**: MIT (JPL ephemeris data is public domain)
- **Published to**: PyPI (when published)
- **Version**: 0.1.0
- **Note**: Automatically downloads DE430t ephemeris file (~16MB) on first use

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
cd ../crius-jpl && pip install -e . && cd -
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
- Start all TypeScript packages (`iris-core`, `aphrodite-d3`, `aphrodite-shared`) in watch mode

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

When packages are published to npm, you can use them in your projects:

```bash
# Install the main client bundle
pnpm add @gaia-tools/iris-core @gaia-tools/aphrodite-d3 @gaia-tools/aphrodite-shared axios d3

# Or install individual packages as needed
pnpm add @gaia-tools/aphrodite-d3
pnpm add @gaia-tools/aphrodite-shared
```

**PyPI Packages:**

When the Python packages are published to PyPI, you can install them:

```bash
# Install crius-ephemeris-core (MIT licensed)
pip install crius-ephemeris-core

# Install crius-swiss (AGPL licensed, requires Swiss Ephemeris data files)
pip install crius-swiss

# Install crius-jpl (MIT licensed, uses JPL ephemeris)
pip install crius-jpl
```

#### Local Development

For local development, packages are linked using `file:` protocol in `package.json`:

```json
{
  "dependencies": {
    "@gaia-tools/iris-core": "file:../iris-core",
    "@gaia-tools/aphrodite-d3": "file:../aphrodite-d3",
    "@gaia-tools/aphrodite-shared": "file:../aphrodite-shared"
  }
}
```

This allows you to:
- Make changes to packages and see them immediately in consuming applications
- Test package changes before publishing
- Develop packages and applications in parallel

## Package Publishing

### Publishing TypeScript Packages

For publishing TypeScript packages (`iris-core`, `aphrodite-d3`, `aphrodite-shared`):

1. Navigate to the package: `cd ../iris-core` (or `aphrodite-d3`, `aphrodite-shared`)
2. Update version in `package.json` and `CHANGELOG.md` (if present)
3. Run `pnpm build` to build the package
4. Run `pnpm pack` to verify package contents
5. Run `npm publish` (or `pnpm publish`)

The `prepublishOnly` script will automatically run lint, test, and build before publishing.

### Publishing Python Packages

For publishing Python packages (`crius-ephemeris-core`, `crius-swiss`, `crius-jpl`):

1. Navigate to the package: `cd ../crius-ephemeris-core` (or `crius-swiss`, `crius-jpl`)
2. Update version in `pyproject.toml` or `setup.py`
3. Build the package: `python -m build`
4. Test the build: `pip install dist/crius-*.whl`
5. Publish: `twine upload dist/*`

## Workspace Configuration

### pnpm Workspace

The workspace uses pnpm workspaces defined in `pnpm-workspace.yaml`:

```yaml
packages:
  - 'packages/*'
  - 'apps/*'
  - '../iris-core'
  - '../aphrodite-d3'
  - '../aphrodite-shared'
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
- [iris-core/README.md](../iris-core/README.md) - Framework-agnostic client bundle documentation
- [aphrodite-d3/README.md](../aphrodite-d3/README.md) - D3-based chart renderer documentation
- [aphrodite-shared/README.md](../aphrodite-shared/README.md) - Shared wheel definitions and configs documentation

### Applications
- [coeus-api/README.md](../coeus-api/README.md) - Backend API documentation

### Python Packages
- [crius-ephemeris-core/README.md](../crius-ephemeris-core/README.md) - Ephemeris core types and interfaces
- [crius-swiss/README.md](../crius-swiss/README.md) - Swiss Ephemeris adapter documentation
- [crius-jpl/README.md](../crius-jpl/README.md) - JPL Ephemeris adapter documentation

## License

MIT

