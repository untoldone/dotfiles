# Dotfiles Documentation

## Overview

This repository contains automated setup scripts for configuring development environments on **macOS (Darwin)** and **Debian 13 (Trixie)** systems. The scripts install and configure a comprehensive development stack with popular programming languages, tools, and utilities.

## Project Structure

```
dotfiles/
├── init.sh                 # Main entry point - detects OS and orchestrates setup
├── bootstrap.sh            # Remote bootstrap script for initial curl-based setup
├── gitconfig              # Git configuration template
│
├── darwin/                # macOS-specific configuration
│   └── init.sh           # macOS package installation via Homebrew
│
├── debian/               # Debian-specific configuration
│   ├── init.sh          # Debian package installation via apt
│   └── apt-10periodic   # APT auto-update configuration
│
├── packages/            # Cross-platform package installers
│   ├── fnm.sh          # Fast Node Manager + Node.js LTS
│   ├── rvm.sh          # Ruby Version Manager + Ruby 3.4.6
│   ├── go.sh           # Go 1.25.1
│   ├── docker.sh       # Docker Engine + Compose V2
│   ├── postgres.sh     # PostgreSQL 18
│   ├── android.sh      # Android SDK
│   └── claude-code.sh  # Claude Code CLI
│
└── test-debian.sh       # Docker-based testing for Debian
    └── Dockerfile.debian13  # Test container definition
```

## What Gets Installed

### Core Tools (All Platforms)
- **Shell**: Zsh with Oh My Zsh framework
- **Git**: Latest version with configured user settings
- **Build Tools**: gcc, g++, make, and essential build dependencies

### Language Runtimes

#### Node.js (via FNM)
- **Version**: Latest LTS (v22.20.0 as of 2025)
- **Manager**: Fast Node Manager (FNM) 1.38.1
- **Location**:
  - macOS: Installed via Homebrew
  - Debian: `~/.local/share/fnm` or `~/.fnm`
- **Shell Integration**: Auto-switches Node versions based on `.node-version` or `.nvmrc` files

#### Ruby (via RVM)
- **Version**: 3.4.6
- **Manager**: Ruby Version Manager (RVM)
- **Location**:
  - Multi-location detection: `/usr/local/rvm`, `~/.rvm`, or `/etc/profile.d/rvm.sh`
- **Installation Mode**: `--autolibs=disable` (pre-installs all dependencies via apt/brew)

#### Go
- **Version**: 1.25.1
- **Location**:
  - macOS: `/usr/local/go`
  - Debian: `/usr/local/go`
- **GOPATH**: `~/go`

### Databases

#### PostgreSQL
- **Version**: 18
- **macOS**: Installed via Homebrew
- **Debian**: Installed from official PostgreSQL APT repository

### Development Tools

#### Docker
- **Engine**: Latest stable
- **Compose**: V2 (plugin-based)
- **macOS**: Docker Desktop via Homebrew Cask
- **Debian**: Docker Engine from official Docker repository

#### Android SDK
- **Components**: Command-line tools and SDK manager
- **Platform**: Configured for Android development

#### Claude Code
- **Type**: CLI tool for AI-assisted development
- **macOS**: Installed via Homebrew Cask
- **Debian**: Installed via official installer script

### System Utilities (Debian)
- **Time Sync**: ntpsec for network time synchronization
- **Timezone**: US/Pacific
- **Auto-Updates**: Configured via apt-10periodic
- **Java**: OpenJDK 21

## How It Works

### Installation Flow

1. **Entry Point** (`init.sh`)
   - Requests sudo password upfront
   - Keeps sudo alive throughout installation
   - Detects operating system:
     - macOS: Checks for Darwin in `uname -s`
     - Debian: Checks for `/etc/debian_version` file
   - Sources OS-specific initialization script
   - Creates standard directories (`~/Source`, `~/.ssh`)
   - Copies gitconfig template if not present
   - Installs Oh My Zsh
   - Executes all package installers in sequence

2. **OS-Specific Setup**
   - **macOS** (`darwin/init.sh`):
     - Installs/updates Homebrew
     - Installs base packages via `brew install`
     - Installs cask applications via `brew install --cask`

   - **Debian** (`debian/init.sh`):
     - Updates package lists
     - Performs full system upgrade
     - Installs base packages (zsh, curl, git, build tools, Java)
     - Installs RVM dependencies (autoconf, automake, bison, etc.)
     - Configures zsh as default shell
     - Configures timezone and auto-updates

3. **Package Installation** (`packages/*.sh`)
   Each package script follows this pattern:
   - **Idempotency Check**: Skip if already installed
   - **OS-Specific Installation**: Use appropriate package manager
   - **Shell Configuration**: Add to `~/.zshrc` if not already present
   - **Immediate Setup**: Configure for current session
   - **Post-Install**: Install default versions/components

### Shell Configuration

All tools automatically add their initialization to `~/.zshrc`:

```bash
# FNM
export PATH="$HOME/.local/share/fnm:$HOME/.fnm:$PATH"
eval "$(fnm env --use-on-cd)"

# RVM
source /usr/local/rvm/scripts/rvm  # or ~/.rvm/scripts/rvm

# Go
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
```

### Idempotency

All scripts are designed to be **idempotent** - they can be run multiple times safely:
- Check if tools are already installed before attempting installation
- Check if configuration lines already exist in `~/.zshrc` before adding
- Skip operations that have already been completed

## Testing

### Automated Testing (Debian)

The repository includes a Docker-based test suite for validating the Debian installation:

```bash
./test-debian.sh
```

This script:
1. Builds a Debian 13 (Trixie) container
2. Copies dotfiles into the container
3. Runs the full installation non-interactively
4. Verifies all tools are installed correctly

**Test Container Details**:
- Base: `debian:trixie`
- Includes: sudo, curl, unzip (pre-installed for bootstrap)
- Password: `testpassword` (for sudo operations)
- Mode: Privileged (required for some system operations)

**Interactive Testing**:
After running the test script, you can access the container:
```bash
docker exec -it dotfiles-debian-test zsh
```

### Manual Testing

To test on a fresh system:

1. **Quick Bootstrap** (recommended):
   ```bash
   curl -fsSL https://raw.githubusercontent.com/untoldone/dotfiles/master/bootstrap.sh | bash -s YOUR_PASSWORD
   ```

2. **Manual Clone**:
   ```bash
   git clone https://github.com/untoldone/dotfiles.git
   cd dotfiles
   ./init.sh YOUR_PASSWORD
   ```

## Customization

### Adding New Packages

1. Create a new script in `packages/your-tool.sh`
2. Follow the template:
   ```bash
   #!/usr/bin/env bash
   set -e

   if [[ $(which your-tool) ]]; then
     echo "Your Tool already installed"
     exit 0
   fi

   case $OS_TYPE in
     debian)
       # Debian installation commands
       ;;
     darwin)
       # macOS installation commands
       ;;
     *)
       echo "Unsupported OS $OS_TYPE"
       exit 1
   esac

   # Shell configuration
   if ! grep -q "your-tool" ~/.zshrc 2>/dev/null; then
     echo 'export PATH="$HOME/.your-tool/bin:$PATH"' >> ~/.zshrc
   fi
   ```

3. Add to `init.sh`:
   ```bash
   $SCRIPT_PATH/packages/your-tool.sh
   ```

### Modifying Versions

To update software versions:
- **Ruby**: Edit `packages/rvm.sh` → change `rvm install 3.4.6`
- **Go**: Edit `packages/go.sh` → change `GO_VERSION="1.25.1"`
- **PostgreSQL**: Edit `packages/postgres.sh` → change version in repository URL
- **Node.js**: Uses latest LTS automatically, or specify version in `packages/fnm.sh`

### Git Configuration

Edit `gitconfig` before running setup:
```ini
[user]
    name = your-name
    email = your-email@example.com

[pull]
    rebase = true
```

## Troubleshooting

### RVM Installation Fails
- **Issue**: Missing dependencies
- **Solution**: RVM dependencies are pre-installed in `debian/init.sh`. If using `--autolibs=read-fail`, switch to `--autolibs=disable`

### FNM/Node Not in PATH
- **Issue**: Commands not found in new shell
- **Solution**: Ensure both PATH export and `fnm env` eval are in `~/.zshrc`:
  ```bash
  export PATH="$HOME/.local/share/fnm:$HOME/.fnm:$PATH"
  eval "$(fnm env --use-on-cd)"
  ```

### Docker Permission Denied
- **Issue**: Cannot connect to Docker daemon
- **Solution**:
  - Add user to docker group: `sudo usermod -aG docker $USER`
  - Log out and back in for group changes to take effect

### PostgreSQL Connection Refused
- **Issue**: Can't connect to database
- **Solution**:
  - macOS: Start service with `brew services start postgresql@18`
  - Debian: Start service with `sudo systemctl start postgresql`

## Platform-Specific Notes

### macOS (Darwin)
- Requires Homebrew (installed automatically if not present)
- Uses Homebrew Cask for GUI applications (Docker Desktop, Claude Code)
- Some tools may require Xcode Command Line Tools

### Debian 13 (Trixie)
- Requires root/sudo access for package installation
- Modifies `/etc/pam.d/chsh` temporarily to switch default shell
- Configures automatic security updates via `apt-10periodic`
- Uses official third-party repositories for Docker and PostgreSQL

## Security Considerations

- Password is passed as argument to `init.sh` for non-interactive sudo
- Scripts keep sudo alive with background process during installation
- Third-party repositories use GPG key verification
- No sensitive data is stored in the repository

## Maintenance

### Updating Dependencies
Run the installers again - they're idempotent and will update to newer versions:
```bash
cd ~/dotfiles
git pull
./init.sh YOUR_PASSWORD
```

### Clean Installation
To start fresh:
1. Remove installed tools manually or use package manager
2. Delete `~/.zshrc` modifications
3. Re-run `./init.sh`

## Requirements

### Minimum System Requirements
- **OS**: macOS 10.14+ or Debian 13+
- **RAM**: 4GB minimum (8GB recommended)
- **Disk**: 10GB free space
- **Network**: Internet connection for package downloads

### Prerequisites
- **macOS**: Xcode Command Line Tools (prompted during installation)
- **Debian**: sudo access and apt package manager
