#!/bin/bash
# Version bumping script for monorepo packages
# Usage: ./scripts/version-bump.sh [major|minor|patch] [package-name]

set -e

VERSION_TYPE=${1:-patch}
PACKAGE_NAME=${2:-all}

if [[ ! "$VERSION_TYPE" =~ ^(major|minor|patch)$ ]]; then
    echo "Error: Version type must be major, minor, or patch"
    exit 1
fi

bump_python_version() {
    local dir=$1
    local file="$dir/pyproject.toml"
    
    if [ ! -f "$file" ]; then
        echo "Skipping $dir: pyproject.toml not found"
        return
    fi
    
    local current_version=$(grep -E "^version\s*=" "$file" | sed -E 's/.*version\s*=\s*"([^"]+)".*/\1/')
    if [ -z "$current_version" ]; then
        echo "Warning: Could not find version in $file"
        return
    fi
    
    IFS='.' read -ra VERSION_PARTS <<< "$current_version"
    local major=${VERSION_PARTS[0]}
    local minor=${VERSION_PARTS[1]}
    local patch=${VERSION_PARTS[2]}
    
    case $VERSION_TYPE in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
    esac
    
    local new_version="$major.$minor.$patch"
    
    # Update version in pyproject.toml
    if [[ "$OSTYPE" == "darwin"* ]]; then
        sed -i '' "s/^version\s*=\s*\".*\"/version = \"$new_version\"/" "$file"
    else
        sed -i "s/^version\s*=\s*\".*\"/version = \"$new_version\"/" "$file"
    fi
    
    echo "Bumped $dir from $current_version to $new_version"
}

bump_npm_version() {
    local dir=$1
    local file="$dir/package.json"
    
    if [ ! -f "$file" ]; then
        echo "Skipping $dir: package.json not found"
        return
    fi
    
    cd "$dir"
    npm version "$VERSION_TYPE" --no-git-tag-version
    cd - > /dev/null
    
    local new_version=$(grep -E '"version"' "$file" | sed -E 's/.*"version"\s*:\s*"([^"]+)".*/\1/')
    echo "Bumped $dir to $new_version"
}

if [ "$PACKAGE_NAME" = "all" ]; then
    # Bump all packages
    echo "Bumping all packages ($VERSION_TYPE)..."
    
    # Python packages
    for dir in ../crius-ephemeris-core ../crius-swiss ../crius-jpl ../coeus-api; do
        if [ -d "$dir" ]; then
            bump_python_version "$dir"
        fi
    done
    
    # npm packages
    for dir in ../iris-core ../aphrodite-d3 ../aphrodite-shared; do
        if [ -d "$dir" ]; then
            bump_npm_version "$dir"
        fi
    done
else
    # Bump specific package
    if [ -f "../$PACKAGE_NAME/pyproject.toml" ]; then
        bump_python_version "../$PACKAGE_NAME"
    elif [ -f "../$PACKAGE_NAME/package.json" ]; then
        bump_npm_version "../$PACKAGE_NAME"
    else
        echo "Error: Package $PACKAGE_NAME not found"
        exit 1
    fi
fi

echo "Version bump complete!"

