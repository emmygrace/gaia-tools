# Gaia Tools Architecture

## Overview

Gaia Tools is a monorepo containing multiple packages for astrological charting applications.

## System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      Client Applications                     │
│  (React, Vue, Angular, or any framework)                   │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       │ HTTP/REST API
                       │
┌──────────────────────▼──────────────────────────────────────┐
│                    coeus-api (FastAPI)                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │   Render     │  │    Vedic     │  │ Astrocartog. │     │
│  │  Endpoints  │  │  Endpoints   │  │  Endpoints   │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│                                                              │
│  ┌────────────────────────────────────────────────────┐    │
│  │         Ephemeris Adapter Factory                  │    │
│  └──────────────┬───────────────────┬─────────────────┘    │
│                 │                   │                       │
│    ┌────────────▼────┐   ┌─────────▼─────────┐            │
│    │ crius-swiss     │   │   crius-jpl       │            │
│    │ (Swiss Ephem.)  │   │   (JPL Ephem.)    │            │
│    └─────────────────┘   └───────────────────┘            │
└──────────────────────────────────────────────────────────────┘
                       │
                       │
┌──────────────────────▼──────────────────────────────────────┐
│              crius-ephemeris-core                            │
│         (Core Types & Interfaces)                            │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│              TypeScript Packages                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ iris-core   │  │ aphrodite-d3 │  │aphrodite-    │      │
│  │ (Client)    │  │ (Renderer)   │  │ shared       │      │
│  └──────────────┘  └──────────────┘  └──────────────┘      │
└──────────────────────────────────────────────────────────────┘
```

## Package Relationships

### Backend (Python)

- **coeus-api**: FastAPI application providing REST API
- **crius-ephemeris-core**: Core types and interfaces (no dependencies)
- **crius-swiss**: Swiss Ephemeris adapter implementation
- **crius-jpl**: JPL Ephemeris adapter implementation

### Frontend (TypeScript)

- **iris-core**: Framework-agnostic client bundle
- **aphrodite-d3**: D3-based chart renderer
- **aphrodite-shared**: Shared wheel definitions and configs

## Data Flow

1. **Client Request** → `iris-core` formats request
2. **API Call** → HTTP request to `coeus-api`
3. **Ephemeris Calculation** → Adapter (Swiss/JPL) computes positions
4. **Response** → JSON with positions, houses, nakshatras, etc.
5. **Rendering** → `aphrodite-d3` renders chart from positions

## Key Components

### Ephemeris Adapters

Both adapters implement the same interface from `crius-ephemeris-core`:
- `calc_positions()`: Calculate planetary positions
- `calc_houses()`: Calculate house cusps
- Support for tropical/sidereal zodiac

### Caching Layer

- **Redis**: Distributed caching (optional)
- **In-memory**: Fallback cache
- Caches: Ephemeris calculations, geocoding results, astrocartography lines

### Rate Limiting

- Per-endpoint limits
- Redis-backed (if available) or in-memory
- Configurable via `ENDPOINT_LIMITS`

## Deployment

See [coeus-api/docs/DEPLOYMENT.md](../../coeus-api/docs/DEPLOYMENT.md) for deployment details.

