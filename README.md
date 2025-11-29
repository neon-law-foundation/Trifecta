# Trifecta Dotfiles

Configuration files for setting up the ~/Trifecta development environment with Claude Code.

## Contents

- `CLAUDE.md` - Project instructions for full-stack Swift development
- `.claude/` - Claude Code configuration directory
  - `agents/` - Custom Claude Code agents
  - `commands/` - Custom Claude Code slash commands
  - `settings.local.json` - Local Claude Code settings
- `aliases.zsh` - Shell aliases for navigation and Swift development
- `setup.sh` - Setup script to configure a new machine
- `brewlist` - List of Homebrew packages to install

## Installation

Clone this repository to `~/.trifecta`:

```bash
git clone git@github.com:neon-law-foundation/Trifecta.git ~/.trifecta
cd ~/.trifecta
./setup.sh
```

This will:

1. Create `~/Trifecta` directory structure
2. Symlink `CLAUDE.md` from `~/.trifecta/CLAUDE.md` to `~/Trifecta/CLAUDE.md`
3. Symlink `.claude/` from `~/.trifecta/.claude` to `~/Trifecta/.claude/`
4. Clone configured repositories into organization folders
5. Install Homebrew packages from `brewlist`
6. Add alias sourcing to `~/.zshrc`

After setup, load the aliases:

```bash
source ~/.zshrc
```

## Directory Structure

The setup script creates:

```
~/Trifecta/
├── CLAUDE.md (symlink → ~/.trifecta/CLAUDE.md)
├── .claude/ (symlink → ~/.trifecta/.claude/)
├── NeonLaw/
├── NeonLawFoundation/
└── SagebrushServices/
```

## Aliases

### Navigation

- `trifecta` - Navigate to ~/Trifecta
- `neonlaw` - Navigate to ~/Trifecta/NeonLaw/Web
- `nlf-standards` - Navigate to ~/Trifecta/NeonLawFoundation/Standards
- `nlf-web` - Navigate to ~/Trifecta/NeonLawFoundation/Web
- `sagebrush-web` - Navigate to ~/Trifecta/SagebrushServices/Web
- `sagebrush-aws` - Navigate to ~/Trifecta/SagebrushServices/AWS

### Swift Development

- `st` - Run `swift test`
- `sb` - Run `swift build`
- `sr` - Run `swift run`

## Usage

The setup script automatically clones configured repositories. You can also manually clone additional repositories into their respective organization folders:

```bash
cd ~/Trifecta/NeonLawFoundation
git clone <repository-url> <ProjectName>

cd ~/Trifecta/SagebrushServices
git clone <repository-url> <ProjectName>
```

Each repository is independent with its own dependencies, tests, and deployment.
