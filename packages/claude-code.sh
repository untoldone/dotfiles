#!/usr/bin/env bash

set -e

if [[ $(which claude) ]]; then
  echo "Claude Code already installed"
  exit 0
fi

case $OS_TYPE in
  debian)
    # Install Claude Code CLI via npm (requires Node.js/fnm to be installed first)
    # Load FNM if it's installed but not in PATH yet
    if ! command -v npm &> /dev/null; then
      if [[ -d ~/.local/share/fnm ]] || [[ -d ~/.fnm ]]; then
        export PATH="$HOME/.local/share/fnm:$HOME/.fnm:$PATH"
        eval "$(fnm env --use-on-cd 2>/dev/null)" || true
      fi
    fi

    if ! command -v npm &> /dev/null; then
      echo "Warning: npm not found. Skipping Claude Code installation."
      echo "Install Node.js/fnm first, then run this script again."
      exit 0
    fi

    # Install to the default Node version
    fnm use default
    npm install -g @anthropic-ai/claude-code

    # Create ~/.local/bin if it doesn't exist
    mkdir -p ~/.local/bin

    # Create shim script that always uses default Node version
    # Using exec preserves all arguments, options, stdin/stdout/stderr, and exit codes
    cat > ~/.local/bin/claude << 'EOF'
#!/usr/bin/env bash
eval "$(fnm env)"
fnm use default --silent-if-unchanged 2>/dev/null
exec "$(fnm current | xargs -I {} echo "$HOME/.local/share/fnm/node-versions/{}/installation/bin/claude")" "$@"
EOF
    chmod +x ~/.local/bin/claude

    # Add ~/.local/bin to PATH in zshrc if not already present
    if ! grep -q '.local/bin' ~/.zshrc 2>/dev/null; then
      echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
    fi
    ;;
  darwin)
    # Install Claude Code CLI for macOS
    if command -v brew &> /dev/null; then
      brew install --cask claude-code
    else
      echo "Warning: Homebrew not found. Skipping Claude Code installation."
      exit 0
    fi
    ;;
  *)
    echo "Unsupported OS $OS_TYPE"
    exit 1
esac
