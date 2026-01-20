# Trifecta Dotfiles

Configuration files for setting up the ~/Trifecta development environment with Claude Code.

**Open Source by Design**: This configuration repository can be made open source because it
contains only development environment setup, tooling configuration, and documentation. It doesn't
contain proprietary code, secrets, or business logic—just the structure and conventions for
organizing Swift projects with Claude Code. Anyone can use these patterns for their own
multi-repository Swift development workflow.

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

Clone this repository to `~/Trifecta/NLF/Trifecta`:

```bash
git clone git@github.com:neon-law-foundation/Trifecta.git ~/Trifecta/NLF/Trifecta
cd ~/Trifecta/NLF/Trifecta
./setup.sh
```

This will:

1. Create `~/Trifecta` directory structure
2. Symlink `CLAUDE.md` from `~/Trifecta/NLF/Trifecta/CLAUDE.md` to `~/Trifecta/CLAUDE.md`
3. Symlink `.claude/` from `~/Trifecta/NLF/Trifecta/.claude` to `~/Trifecta/.claude/`
4. Clone configured repositories into organization folders
5. Install Homebrew packages from `brewlist`
6. Add alias sourcing to `~/.zshrc`

After setup, load the aliases:

```bash
source ~/.zshrc
```

## Directory Structure

The setup script creates:

```text
~/Trifecta/
├── CLAUDE.md (symlink → ~/Trifecta/NLF/Trifecta/CLAUDE.md)
├── .claude/ (symlink → ~/Trifecta/NLF/Trifecta/.claude/)
├── NeonLaw/
├── NLF/
│   └── Trifecta/ (configuration git repository)
└── Sagebrush/
```

## Repositories

Seven Swift repositories across three legal entities:

### Neon Law Foundation (Open Source)

- **Standards** - Legal standards CLI with questionnaires, workflows, and computable contracts
- **Web** - Foundation website (Hummingbird + Elementary)

### Neon Law (Law Firm)

- **Web** - Attorney directory service for client referrals

### Sagebrush Services (SRE)

- **Web** - Marketing site (Toucan static generator)
- **Operations** - Business materials and AppleScript presentations
- **Reporting** - Lambda functions for scheduled tasks and billing

**Unified by Swift** - All repos share data models, Swift Testing, architectural patterns, and
centralized infrastructure management. SRE is intentionally separated from legal operations.

## Usage

The setup script automatically clones configured repositories. You can also manually clone
additional repositories into their respective organization folders:

```bash
cd ~/Trifecta/NLF
git clone <repository-url> <ProjectName>

cd ~/Trifecta/SagebrushServices
git clone <repository-url> <ProjectName>
```

Each repository is independent with its own dependencies, tests, and deployment.

## Development Tools

### LocalStack - AWS Local Development

We use LocalStack for local AWS development, enabling you to test AWS services locally
without incurring cloud costs or requiring internet connectivity.

#### Starting LocalStack

```bash
localstack start
```

LocalStack runs on port **4566** by default and is accessible at:

```text
http://localhost.localstack.cloud:4566
```

[LocalStack Documentation](https://docs.localstack.cloud/)

#### Configure AWS Credentials

For local development, use test credentials:

```bash
export AWS_ACCESS_KEY_ID="test"
export AWS_SECRET_ACCESS_KEY="test"
export AWS_DEFAULT_REGION="us-east-1"
```

**Note:** If you already have AWS credentials configured, you can skip this step.
For permanent setup, configure these in your AWS CLI configuration.

#### Example: Deploy an S3 Bucket

```bash
aws s3 mb s3://bucket1 --endpoint-url=http://localhost.localstack.cloud:4566
```

#### Benefits of LocalStack

- **Fast iteration** - Test AWS services without cloud deployment delays
- **Cost-free** - No AWS charges for local development
- **Offline capable** - Develop without internet connectivity
- **Reproducible** - Consistent environment across team members
