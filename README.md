# Dotfiles

Configuration files for setting up the ~/Code development environment with Claude Code.

## Contents

- `CLAUDE.md` - Project instructions for full-stack Swift development
- `.claude/` - Claude Code configuration directory
  - `agents/` - Custom Claude Code agents
  - `commands/` - Custom Claude Code slash commands
  - `settings.local.json` - Local Claude Code settings
- `aliases.zsh` - Shell aliases for navigation and Swift development
- `setup.sh` - Setup script to configure a new machine

## Installation

Run the setup script from this directory:

```bash
cd ~/dotfiles
./setup.sh
```

This will:

1. Create `~/Code` directory structure
2. Copy `CLAUDE.md` to `~/Code/`
3. Copy `.claude/` configuration to `~/Code/.claude/`
4. Add alias sourcing to `~/.zshrc`

After setup, load the aliases:

```bash
source ~/.zshrc
```

## Directory Structure

The setup script creates:

```
~/Code/
├── CLAUDE.md
├── .claude/
├── NLF/
├── Sagebrush/
├── ShookFamily/
└── TarotSwift/
```

## Aliases

### Navigation

- `code` - Navigate to ~/Code
- `nlf-standards` - Navigate to ~/Code/NLF/Standards
- `nlf-web` - Navigate to ~/Code/NLF/Web
- `sagebrush` - Navigate to ~/Code/Sagebrush/Web
- `shook` - Navigate to ~/Code/ShookFamily/Web
- `tarot` - Navigate to ~/Code/TarotSwift/Stardust

### Swift Development

- `st` - Run `swift test`
- `sb` - Run `swift build`
- `sr` - Run `swift run`

## Usage

Clone repositories into their respective organization folders:

```bash
cd ~/Code/NLF
git clone <repository-url> Standards

cd ~/Code/Sagebrush
git clone <repository-url> Web
```

Each repository is independent with its own dependencies, tests, and deployment.
