#!/bin/bash
# Generate changelog from git commits
# Usage: ./scripts/generate-changelog.sh [package-name] [version]

set -e

PACKAGE_NAME=${1:-all}
VERSION=${2:-}

if [ -z "$VERSION" ] && [ "$PACKAGE_NAME" != "all" ]; then
    # Try to get version from package file
    if [ -f "../$PACKAGE_NAME/package.json" ]; then
        VERSION=$(grep -E '"version"' "../$PACKAGE_NAME/package.json" | sed -E 's/.*"version"\s*:\s*"([^"]+)".*/\1/')
    elif [ -f "../$PACKAGE_NAME/pyproject.toml" ]; then
        VERSION=$(grep -E "^version\s*=" "../$PACKAGE_NAME/pyproject.toml" | sed -E 's/.*version\s*=\s*"([^"]+)".*/\1/')
    fi
fi

generate_changelog() {
    local package=$1
    local changelog_file="../$package/CHANGELOG.md"
    local date=$(date +"%Y-%m-%d")
    
    # Get last tag or commit
    local last_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "")
    local since=""
    if [ -n "$last_tag" ]; then
        since="--since=$last_tag"
    fi
    
    # Get commits for this package
    local commits=$(git log $since --oneline --grep="$package" --grep="\[$package\]" --all-match --format="%s" 2>/dev/null || true)
    
    if [ -z "$commits" ]; then
        commits=$(git log $since --oneline --format="%s" | head -20)
    fi
    
    # Create changelog entry
    local entry="## [$VERSION] - $date\n\n"
    
    # Categorize commits
    local added=""
    local changed=""
    local fixed=""
    local removed=""
    
    while IFS= read -r commit; do
        if [[ "$commit" =~ ^(feat|add|new).* ]]; then
            added="${added}- ${commit}\n"
        elif [[ "$commit" =~ ^(fix|bugfix|patch).* ]]; then
            fixed="${fixed}- ${commit}\n"
        elif [[ "$commit" =~ ^(remove|delete|deprecate).* ]]; then
            removed="${removed}- ${commit}\n"
        else
            changed="${changed}- ${commit}\n"
        fi
    done <<< "$commits"
    
    if [ -n "$added" ]; then
        entry="${entry}### Added\n${added}\n"
    fi
    if [ -n "$changed" ]; then
        entry="${entry}### Changed\n${changed}\n"
    fi
    if [ -n "$fixed" ]; then
        entry="${entry}### Fixed\n${fixed}\n"
    fi
    if [ -n "$removed" ]; then
        entry="${entry}### Removed\n${removed}\n"
    fi
    
    # Prepend to changelog
    if [ -f "$changelog_file" ]; then
        echo -e "$entry" | cat - "$changelog_file" > "${changelog_file}.tmp" && mv "${changelog_file}.tmp" "$changelog_file"
    else
        echo -e "# Changelog\n\nAll notable changes to this project will be documented in this file.\n\n$entry" > "$changelog_file"
    fi
    
    echo "Generated changelog for $package"
}

if [ "$PACKAGE_NAME" = "all" ]; then
    for package in crius-ephemeris-core crius-swiss crius-jpl coeus-api iris-core aphrodite-d3 aphrodite-shared; do
        if [ -d "../$package" ]; then
            generate_changelog "$package"
        fi
    done
else
    generate_changelog "$PACKAGE_NAME"
fi

echo "Changelog generation complete!"

