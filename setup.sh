#!/bin/bash

# Setup script for ~/Code directory with Claude configuration
# This script creates the Code directory structure and copies Claude config files

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CODE_DIR="$HOME/Code"

echo "Setting up ~/Code directory structure..."

# Create main Code directory if it doesn't exist
mkdir -p "$CODE_DIR"

# Create organization directories
mkdir -p "$CODE_DIR/NLF"
mkdir -p "$CODE_DIR/NeonLaw"
mkdir -p "$CODE_DIR/Sagebrush"
mkdir -p "$CODE_DIR/TarotSwift"

# Create symlinks for CLAUDE.md and .claude directory
echo "Creating symlinks for CLAUDE.md and .claude..."
if [ -f "$CODE_DIR/CLAUDE.md" ] && [ ! -L "$CODE_DIR/CLAUDE.md" ]; then
    echo "  Removing existing CLAUDE.md file..."
    rm "$CODE_DIR/CLAUDE.md"
fi
if [ -d "$CODE_DIR/.claude" ] && [ ! -L "$CODE_DIR/.claude" ]; then
    echo "  Removing existing .claude directory..."
    rm -rf "$CODE_DIR/.claude"
fi
ln -sf "$SCRIPT_DIR/CLAUDE.md" "$CODE_DIR/CLAUDE.md"
ln -sf "$SCRIPT_DIR/.claude" "$CODE_DIR/.claude"
echo "✓ Symlinks created (source: ~/dotfiles)"

# Clone repositories if they don't exist
echo ""
echo "Checking repositories..."

# Sagebrush/Web
if [ ! -d "$CODE_DIR/Sagebrush/Web" ]; then
    echo "Cloning Sagebrush/Web..."
    git clone git@github.com:sagebrush-services/Web.git "$CODE_DIR/Sagebrush/Web"
else
    echo "✓ Sagebrush/Web already exists"
fi

# Sagebrush/AWS
if [ ! -d "$CODE_DIR/Sagebrush/AWS" ]; then
    echo "Cloning Sagebrush/AWS..."
    git clone git@github.com:sagebrush-services/AWS.git "$CODE_DIR/Sagebrush/AWS"
else
    echo "✓ Sagebrush/AWS already exists"
fi

# NLF/Web
if [ ! -d "$CODE_DIR/NLF/Web" ]; then
    echo "Cloning NLF/Web..."
    git clone git@github.com:Neon-Law-Foundation/Web.git "$CODE_DIR/NLF/Web"
else
    echo "✓ NLF/Web already exists"
fi

# NLF/Standards
if [ ! -d "$CODE_DIR/NLF/Standards" ]; then
    echo "Cloning NLF/Standards..."
    git clone git@github.com:neon-law-foundation/Standards.git "$CODE_DIR/NLF/Standards"
else
    echo "✓ NLF/Standards already exists"
fi

# NeonLaw/Web
if [ ! -d "$CODE_DIR/NeonLaw/Web" ]; then
    echo "Cloning NeonLaw/Web..."
    git clone git@github.com:Neon-Law/Web.git "$CODE_DIR/NeonLaw/Web"
else
    echo "✓ NeonLaw/Web already exists"
fi

# TarotSwift/Stardust
if [ ! -d "$CODE_DIR/TarotSwift/Stardust" ]; then
    echo "Cloning TarotSwift/Stardust..."
    git clone git@github.com:tarot-swift/Stardust.git "$CODE_DIR/TarotSwift/Stardust"
else
    echo "✓ TarotSwift/Stardust already exists"
fi

# Setup zsh aliases
echo "Setting up zsh aliases..."
ZSHRC="$HOME/.zshrc"
ALIAS_MARKER="# Code directory aliases (managed by dotfiles)"

if [ -f "$ZSHRC" ]; then
    # Check if aliases are already sourced
    if ! grep -q "$ALIAS_MARKER" "$ZSHRC"; then
        echo "" >> "$ZSHRC"
        echo "$ALIAS_MARKER" >> "$ZSHRC"
        echo "source $HOME/dotfiles/aliases.zsh" >> "$ZSHRC"
        echo "✓ Added aliases to ~/.zshrc"
    else
        echo "✓ Aliases already configured in ~/.zshrc"
    fi
else
    echo "⚠ ~/.zshrc not found. Create it and add: source $HOME/dotfiles/aliases.zsh"
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
echo "  ~/Code/"
echo "    ├── CLAUDE.md"
echo "    ├── .claude/"
echo "    ├── NLF/"
echo "    ├── NeonLaw/"
echo "    ├── Sagebrush/"
echo "    └── TarotSwift/"
echo ""
echo "Configuration:"
echo "  - Aliases configured in ~/.zshrc (source ~/dotfiles/aliases.zsh)"
echo "  - Homebrew packages listed in ~/dotfiles/brewlist"
echo ""
echo "Run 'source ~/.zshrc' to load aliases, then:"
echo "  - Use 'code' to navigate to ~/Code"
echo "  - Use 'nlf-standards', 'nlf-web', 'neonlaw', 'sagebrush', 'tarot' for repos"
echo "  - Use 'st', 'sb', 'sr' for swift test/build/run"
echo ""
echo "You can now clone repositories into their respective organization folders."
