# Testing Guide

This document provides an overview of the testing strategy for the Gaia full stack application.

## Overview

The application uses a comprehensive testing strategy covering:
- **Unit Tests**: Fast, isolated tests for components and utilities
- **Integration Tests**: Test API client with mocked HTTP requests
- **Backend Integration**: Test API endpoints with FastAPI TestClient
- **Full Stack**: Test complete flows with running backend

## Running Tests

### All Tests

```bash
# Run all tests across all packages
pnpm test

# Run unit tests only (packages)
pnpm test:unit

# Run backend tests
pnpm test:backend

# Run integration tests
pnpm test:integration

# Run with coverage
pnpm test:coverage
```

### Package-Specific Tests

```bash
# Test aphrodite-react package
cd ../aphrodite-react && pnpm test

# Test coeus-api-client package
cd ../coeus-api-client && pnpm test

# Test backend (coeus-api)
cd ../coeus-api && pytest
```

## Test Structure

### Packages

#### `@gaia-tools/aphrodite-react`

- **Test Runner**: Vitest
- **Test Files**: `src/**/__tests__/**/*.test.tsx`
- **Fixtures**: `src/test/fixtures.ts`
- **Utilities**: `src/test/utils.tsx`

**Test Coverage:**
- ChartWheel component rendering
- Utility functions (buildIndexes, helpers)
- Component interactions and callbacks

**Run Tests:**
```bash
cd ../aphrodite-react
pnpm test
pnpm test:coverage
```

#### `@gaia-tools/coeus-api-client`

- **Test Runner**: Vitest
- **Test Files**: `src/__tests__/**/*.test.ts`
- **Mocking**: Axios mocked for HTTP requests

**Test Coverage:**
- Chart API methods
- Instance API methods
- Wheel API methods
- Error handling

**Run Tests:**
```bash
cd ../coeus-api-client
pnpm test
```

### Backend

- **Test Runner**: pytest
- **Test Files**: `tests/test_*.py`
- **Integration Tests**: `tests/integration/`

**Test Coverage:**
- Service layer tests
- API endpoint tests
- Full stack integration tests

**Run Tests:**
```bash
cd backend

# All tests
pytest

# Specific test file
pytest tests/test_render_service.py

# Integration tests (requires running backend)
pytest tests/integration -m integration

# With coverage
pytest --cov=app --cov-report=html
```

## Test Types

### Unit Tests

Fast, isolated tests that test individual functions and components in isolation.

**Examples:**
- Component rendering
- Utility function behavior
- Service method logic

### Integration Tests

Tests that verify components work together, typically with mocked external dependencies.

**Examples:**
- API client with mocked Axios
- API endpoints with mocked database
- Component with mocked API calls

### Full Stack Tests

Tests that require a running backend and test complete workflows.

**Examples:**
- Complete chart creation flow
- Chart rendering with real data
- Error scenarios

**Requirements:**
- Backend must be running (`docker compose up coeus-api-backend`)
- Tests are marked with `@pytest.mark.integration`
- Can be skipped if backend is not available

## Test Fixtures

### Package Fixtures

Located in `aphrodite-react/src/test/fixtures.ts`:

- `createMockRenderResponse()` - Creates mock RenderResponse data
- `createMinimalRenderResponse()` - Creates minimal render data
- `createRenderResponseWithAspects()` - Creates render data with aspects
- `createMockIndexes()` - Creates mock IndexesDTO

### Backend Fixtures

Located in `coeus-api/tests/`:

- `mock_user` - Mock user fixture
- `mock_chart_def` - Mock chart definition
- `mock_wheel` - Mock wheel
- `mock_instance` - Mock chart instance

### Integration Test Fixtures

Located in `tests/integration/fixtures.py`:

- `create_test_chart()` - Creates chart via API
- `create_test_instance()` - Creates instance via API
- `render_test_chart()` - Renders chart via API
- `cleanup_test_data()` - Cleans up test data

## Coverage

Coverage reports are generated for:

- **Packages**: HTML reports in `coverage/` directories
- **Backend**: HTML report in `coeus-api/htmlcov/`

View coverage:
```bash
# Packages
cd ../aphrodite-react && pnpm test:coverage
open coverage/index.html

# Backend
cd ../coeus-api && pytest --cov=app --cov-report=html
open htmlcov/index.html
```

## Best Practices

1. **Write tests for new features**: Every new feature should include tests
2. **Test edge cases**: Include tests for error scenarios and boundary conditions
3. **Keep tests fast**: Unit tests should be fast, integration tests can be slower
4. **Use fixtures**: Reuse test fixtures for consistency
5. **Mock external dependencies**: Don't make real HTTP requests in unit tests
6. **Test behavior, not implementation**: Focus on what the code does, not how

## Continuous Integration

Tests should be run in CI/CD pipelines:

1. **Unit tests**: Run on every commit
2. **Integration tests**: Run on pull requests
3. **Full stack tests**: Run on main branch or scheduled

## Troubleshooting

### Tests failing due to missing dependencies

```bash
# Install all dependencies
pnpm install

# Install backend dependencies
cd ../coeus-api && pip install -r requirements.txt
```

### Backend not available for integration tests

Integration tests are automatically skipped if the backend is not running. To run them:

```bash
# Start backend
cd ../gaia-tools && docker compose up coeus-api-backend

# Run integration tests
cd ../coeus-api && pytest tests/integration -m integration
```

### D3 mocking issues in component tests

D3.js is complex to mock. The ChartWheel tests use a simplified D3 mock. For more complex scenarios, consider using `@testing-library/react` to test component behavior rather than D3 internals.

