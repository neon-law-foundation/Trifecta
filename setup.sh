#!/bin/bash

# Setup script for ~/Trifecta directory with Claude configuration
# This script creates the Trifecta directory structure and symlinks Claude config files from ~/Trifecta/NLF/Trifecta

set -e

SCRIPT_DIR="$HOME/Trifecta/NLF/Trifecta"
TRIFECTA_DIR="$HOME/Trifecta"
OS_TYPE="$(uname -s)"

echo "Setting up ~/Trifecta directory structure..."
echo "Detected OS: $OS_TYPE"

# Create main Trifecta directory if it doesn't exist
mkdir -p "$TRIFECTA_DIR"

# Create organization directories
mkdir -p "$TRIFECTA_DIR/NeonLaw"
mkdir -p "$TRIFECTA_DIR/NLF"
mkdir -p "$TRIFECTA_DIR/Sagebrush"

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
echo "✓ Symlinks created (source: ~/Trifecta/NLF/Trifecta)"

# Clone repositories if they don't exist
echo ""
echo "Checking repositories..."

# Sagebrush/Apple
if [ ! -d "$TRIFECTA_DIR/Sagebrush/Apple" ]; then
    echo "Cloning Sagebrush/Apple..."
    git clone git@github.com:sagebrush-services/Apple.git "$TRIFECTA_DIR/Sagebrush/Apple"
else
    echo "✓ Sagebrush/Apple already exists"
fi

# Sagebrush/Reporting
if [ ! -d "$TRIFECTA_DIR/Sagebrush/Reporting" ]; then
    echo "Cloning Sagebrush/Reporting..."
    git clone git@github.com:sagebrush-services/Reporting.git "$TRIFECTA_DIR/Sagebrush/Reporting"
else
    echo "✓ Sagebrush/Reporting already exists"
fi

# Sagebrush/Web
if [ ! -d "$TRIFECTA_DIR/Sagebrush/Web" ]; then
    echo "Cloning Sagebrush/Web..."
    git clone git@github.com:sagebrush-services/Web.git "$TRIFECTA_DIR/Sagebrush/Web"
else
    echo "✓ Sagebrush/Web already exists"
fi

# Sagebrush/AWS
if [ ! -d "$TRIFECTA_DIR/Sagebrush/AWS" ]; then
    echo "Cloning Sagebrush/AWS..."
    git clone git@github.com:sagebrush-services/AWS.git "$TRIFECTA_DIR/Sagebrush/AWS"
else
    echo "✓ Sagebrush/AWS already exists"
fi

# NLF/Web
if [ ! -d "$TRIFECTA_DIR/NLF/Web" ]; then
    echo "Cloning NLF/Web..."
    git clone git@github.com:neon-law-foundation/Web.git "$TRIFECTA_DIR/NLF/Web"
else
    echo "✓ NLF/Web already exists"
fi

# NLF/SagebrushStandards
if [ ! -d "$TRIFECTA_DIR/NLF/SagebrushStandards" ]; then
    echo "Cloning NLF/SagebrushStandards..."
    git clone git@github.com:neon-law-foundation/SagebrushStandards.git "$TRIFECTA_DIR/NLF/SagebrushStandards"
else
    echo "✓ NLF/SagebrushStandards already exists"
fi

# NeonLaw/Web
if [ ! -d "$TRIFECTA_DIR/NeonLaw/Web" ]; then
    echo "Cloning NeonLaw/Web..."
    git clone git@github.com:neon-law/Web.git "$TRIFECTA_DIR/NeonLaw/Web"
else
    echo "✓ NeonLaw/Web already exists"
fi

# Setup shell aliases
ALIAS_MARKER="# Trifecta directory aliases (managed by ~/Trifecta/NLF/Trifecta)"

if [ "$OS_TYPE" = "Darwin" ]; then
    echo "Setting up zsh aliases..."
    ZSHRC="$HOME/.zshrc"

    if [ -f "$ZSHRC" ]; then
        # Check if aliases are already sourced
        if ! grep -q "$ALIAS_MARKER" "$ZSHRC"; then
            echo "" >> "$ZSHRC"
            echo "$ALIAS_MARKER" >> "$ZSHRC"
            echo "source $HOME/Trifecta/NLF/Trifecta/aliases.zsh" >> "$ZSHRC"
            echo "✓ Added aliases to ~/.zshrc"
        else
            echo "✓ Aliases already configured in ~/.zshrc"
        fi
    else
        echo "⚠ ~/.zshrc not found. Create it and add: source $HOME/Trifecta/NLF/Trifecta/aliases.zsh"
    fi
else
    echo "Setting up bash aliases..."
    BASHRC="$HOME/.bashrc"

    if [ -f "$BASHRC" ]; then
        # Check if aliases are already sourced
        if ! grep -q "$ALIAS_MARKER" "$BASHRC"; then
            echo "" >> "$BASHRC"
            echo "$ALIAS_MARKER" >> "$BASHRC"
            echo "source $HOME/Trifecta/NLF/Trifecta/aliases.zsh" >> "$BASHRC"
            echo "✓ Added aliases to ~/.bashrc"
        else
            echo "✓ Aliases already configured in ~/.bashrc"
        fi
    else
        echo "⚠ ~/.bashrc not found. Create it and add: source $HOME/Trifecta/NLF/Trifecta/aliases.zsh"
    fi
fi

# Install packages
echo ""
if [ "$OS_TYPE" = "Darwin" ]; then
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
else
    echo "Installing apt packages..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get -y install git
        echo "✓ apt packages installed"
    else
        echo "⚠ apt-get not found. Install git manually."
    fi
fi

echo ""
echo "✓ Setup complete!"
echo ""
echo "Directory structure created:"
echo "  ~/Trifecta/"
echo "    ├── CLAUDE.md (symlink → ~/Trifecta/NLF/Trifecta/CLAUDE.md)"
echo "    ├── .claude/ (symlink → ~/Trifecta/NLF/Trifecta/.claude/)"
echo "    ├── NeonLaw/"
echo "    │   └── Web/"
echo "    ├── NLF/"
echo "    │   ├── SagebrushStandards/"
echo "    │   ├── Trifecta/ (configuration git repository)"
echo "    │   └── Web/"
echo "    └── Sagebrush/"
echo "        ├── Apple/"
echo "        ├── AWS/"
echo "        ├── Reporting/"
echo "        └── Web/"
echo ""
echo "Configuration:"
if [ "$OS_TYPE" = "Darwin" ]; then
    echo "  - Aliases configured in ~/.zshrc (source ~/Trifecta/NLF/Trifecta/aliases.zsh)"
    echo "  - Homebrew packages listed in ~/Trifecta/NLF/Trifecta/brewlist"
    echo ""
    echo "Run 'source ~/.zshrc' to load aliases, then:"
else
    echo "  - Aliases configured in ~/.bashrc (source ~/Trifecta/NLF/Trifecta/aliases.zsh)"
    echo "  - apt packages: git"
    echo ""
    echo "Run 'source ~/.bashrc' to load aliases, then:"
fi
echo "  - Use 'trifecta' to navigate to ~/Trifecta"
echo "  - Use 'nlf-standards', 'nlf-web' for NLF repositories"
echo "  - Use 'neonlaw-web' for NeonLaw repositories"
echo "  - Use 'sagebrush-apple', 'sagebrush-reporting', 'sagebrush-web' for Sagebrush repositories"
echo "  - Use 'st', 'sb', 'sr' for swift test/build/run"
echo ""
echo "Repositories are automatically cloned into their respective organization folders."
