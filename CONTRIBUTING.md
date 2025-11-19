# Contributing to Gaia Tools

Thank you for your interest in contributing to Gaia Tools! This document provides guidelines and instructions for contributing.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/your-username/gaia-tools.git`
3. Set up the development environment (see [README.md](./README.md))
4. Create a new branch: `git checkout -b feature/your-feature-name`

## Development Workflow

### Running Tests

```bash
# Run all tests
pnpm test

# Run backend tests only
pnpm test:backend

# Run integration tests
pnpm test:integration

# Run with coverage
pnpm test:coverage
```

### Code Style

- **Python**: We use `black` for formatting and `ruff` for linting
- **TypeScript**: We use `prettier` for formatting and `eslint` for linting
- Run `pnpm lint` to check all packages

### Pre-commit Hooks

We use Husky to run pre-commit checks. These will automatically:
- Run linting
- Run type checking
- Run tests

## Pull Request Process

1. Ensure all tests pass locally
2. Update documentation if needed
3. Follow the commit message conventions (see below)
4. Create a pull request with a clear description
5. Ensure CI checks pass

## Commit Message Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes (formatting, etc.)
- `refactor:` Code refactoring
- `test:` Adding or updating tests
- `chore:` Maintenance tasks

Examples:
- `feat(coeus-api): add rate limiting middleware`
- `fix(iris-core): correct ephemeris calculation`
- `docs: update README with new endpoints`

## Code Review

All contributions require code review. Please:
- Address review comments promptly
- Keep PRs focused and reasonably sized
- Update documentation as needed

## Questions?

Feel free to open an issue for questions or discussions.

