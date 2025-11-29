#!/bin/bash

# Setup script for ~/Trifecta directory with Claude configuration
# This script creates the Trifecta directory structure and symlinks Claude config files from ~/.trifecta

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TRIFECTA_DIR="$HOME/Trifecta"

echo "Setting up ~/Trifecta directory structure..."

# Create main Trifecta directory if it doesn't exist
mkdir -p "$TRIFECTA_DIR"

# Create organization directories
mkdir -p "$TRIFECTA_DIR/NeonLaw"
mkdir -p "$TRIFECTA_DIR/NeonLawFoundation"
mkdir -p "$TRIFECTA_DIR/SagebrushServices"

# Create symlinks for CLAUDE.md and .claude directory
echo "Creating symlinks for CLAUDE.md and .claude..."
if [ -f "$TRIFECTA_DIR/CLAUDE.md" ] && [ ! -L "$TRIFECTA_DIR/CLAUDE.md" ]; then
    echo "  Removing existing CLAUDE.md file..."
    rm "$TRIFECTA_DIR/CLAUDE.md"
fi
if [ -d "$TRIFECTA_DIR/.claude" ] && [ ! -L "$TRIFECTA_DIR/.claude" ]; then
    echo "  Removing existing .claude directory..."
    rm -rf "$TRIFECTA_DIR/.claude"
fi
ln -sf "$SCRIPT_DIR/CLAUDE.md" "$TRIFECTA_DIR/CLAUDE.md"
ln -sf "$SCRIPT_DIR/.claude" "$TRIFECTA_DIR/.claude"
echo "✓ Symlinks created (source: ~/.trifecta)"

# Clone repositories if they don't exist
echo ""
echo "Checking repositories..."

# SagebrushServices/Web
if [ ! -d "$TRIFECTA_DIR/SagebrushServices/Web" ]; then
    echo "Cloning SagebrushServices/Web..."
    git clone git@github.com:sagebrush-services/Web.git "$TRIFECTA_DIR/SagebrushServices/Web"
else
    echo "✓ SagebrushServices/Web already exists"
fi

# SagebrushServices/AWS
if [ ! -d "$TRIFECTA_DIR/SagebrushServices/AWS" ]; then
    echo "Cloning SagebrushServices/AWS..."
    git clone git@github.com:sagebrush-services/AWS.git "$TRIFECTA_DIR/SagebrushServices/AWS"
else
    echo "✓ SagebrushServices/AWS already exists"
fi

# NeonLawFoundation/Web
if [ ! -d "$TRIFECTA_DIR/NeonLawFoundation/Web" ]; then
    echo "Cloning NeonLawFoundation/Web..."
    git clone git@github.com:neon-law-foundation/Web.git "$TRIFECTA_DIR/NeonLawFoundation/Web"
else
    echo "✓ NeonLawFoundation/Web already exists"
fi

# NeonLawFoundation/Standards
if [ ! -d "$TRIFECTA_DIR/NeonLawFoundation/Standards" ]; then
    echo "Cloning NeonLawFoundation/Standards..."
    git clone git@github.com:neon-law-foundation/Standards.git "$TRIFECTA_DIR/NeonLawFoundation/Standards"
else
    echo "✓ NeonLawFoundation/Standards already exists"
fi

# NeonLaw/Web
if [ ! -d "$TRIFECTA_DIR/NeonLaw/Web" ]; then
    echo "Cloning NeonLaw/Web..."
    git clone git@github.com:neon-law/Web.git "$TRIFECTA_DIR/NeonLaw/Web"
else
    echo "✓ NeonLaw/Web already exists"
fi

# Setup zsh aliases
echo "Setting up zsh aliases..."
ZSHRC="$HOME/.zshrc"
ALIAS_MARKER="# Trifecta directory aliases (managed by ~/.trifecta)"

if [ -f "$ZSHRC" ]; then
    # Check if aliases are already sourced
    if ! grep -q "$ALIAS_MARKER" "$ZSHRC"; then
        echo "" >> "$ZSHRC"
        echo "$ALIAS_MARKER" >> "$ZSHRC"
        echo "source $HOME/.trifecta/aliases.zsh" >> "$ZSHRC"
        echo "✓ Added aliases to ~/.zshrc"
    else
        echo "✓ Aliases already configured in ~/.zshrc"
    fi
else
    echo "⚠ ~/.zshrc not found. Create it and add: source $HOME/.trifecta/aliases.zsh"
fi

# Install Homebrew packages
echo ""
echo "Installing Homebrew packages..."
if command -v brew &> /dev/null; then
    BREWLIST="$SCRIPT_DIR/brewlist"
    if [ -f "$BREWLIST" ]; then
        # Read packages from brewlist, filtering out comments and empty lines
        PACKAGES=$(grep -v '^#' "$BREWLIST" | grep -v '^[[:space:]]*$' | awk '{print $1}')

        if [ -n "$PACKAGES" ]; then
            echo "Installing packages: $(echo $PACKAGES | tr '\n' ' ')"
            echo "$PACKAGES" | xargs brew install
            echo "✓ Homebrew packages installed"
        else
            echo "⚠ No packages found in brewlist"
        fi
    else
        echo "⚠ brewlist file not found at $BREWLIST"
    fi
else
    echo "⚠ Homebrew not installed. Install from https://brew.sh"
    echo "  Then run: brew install \$(grep -v '^#' $SCRIPT_DIR/brewlist | grep -v '^[[:space:]]*\$' | awk '{print \$1}')"
fi

echo ""
echo "✓ Setup complete!"
echo ""
echo "Directory structure created:"
echo "  ~/Trifecta/"
echo "    ├── CLAUDE.md (symlink → ~/.trifecta/CLAUDE.md)"
echo "    ├── .claude/ (symlink → ~/.trifecta/.claude/)"
echo "    ├── NeonLaw/"
echo "    ├── NeonLawFoundation/"
echo "    └── SagebrushServices/"
echo ""
echo "Configuration:"
echo "  - Aliases configured in ~/.zshrc (source ~/.trifecta/aliases.zsh)"
echo "  - Homebrew packages listed in ~/.trifecta/brewlist"
echo ""
echo "Run 'source ~/.zshrc' to load aliases, then:"
echo "  - Use 'trifecta' to navigate to ~/Trifecta"
echo "  - Use 'nlf-standards', 'nlf-web', 'neonlaw', 'sagebrush-web', 'sagebrush-aws' for repos"
echo "  - Use 'st', 'sb', 'sr' for swift test/build/run"
echo ""
echo "Repositories are automatically cloned into their respective organization folders."
