#!/bin/bash
# Publish packages to npm/PyPI
# Usage: ./scripts/publish.sh [package-name]

set -e

PACKAGE_NAME=${1:-all}

publish_python() {
    local dir=$1
    local name=$(basename "$dir")
    
    echo "Publishing Python package: $name"
    cd "$dir"
    
    # Build package
    python -m build
    
    # Publish to PyPI
    twine upload dist/* --skip-existing
    
    cd - > /dev/null
    echo "Published $name to PyPI"
}

publish_npm() {
    local dir=$1
    local name=$(basename "$dir")
    
    echo "Publishing npm package: $name"
    cd "$dir"
    
    # Build if needed
    if [ -f "package.json" ] && grep -q '"build"' package.json; then
        npm run build
    fi
    
    # Publish to npm
    npm publish --access public
    
    cd - > /dev/null
    echo "Published $name to npm"
}

if [ "$PACKAGE_NAME" = "all" ]; then
    echo "Publishing all packages..."
    
    # Python packages
    for dir in ../crius-ephemeris-core ../crius-swiss ../crius-jpl; do
        if [ -d "$dir" ] && [ -f "$dir/pyproject.toml" ]; then
            publish_python "$dir"
        fi
    done
    
    # npm packages
    for dir in ../iris-core ../aphrodite-d3 ../aphrodite-shared; do
        if [ -d "$dir" ] && [ -f "$dir/package.json" ]; then
            publish_npm "$dir"
        fi
    done
else
    if [ -f "../$PACKAGE_NAME/pyproject.toml" ]; then
        publish_python "../$PACKAGE_NAME"
    elif [ -f "../$PACKAGE_NAME/package.json" ]; then
        publish_npm "../$PACKAGE_NAME"
    else
        echo "Error: Package $PACKAGE_NAME not found"
        exit 1
    fi
fi

echo "Publishing complete!"

