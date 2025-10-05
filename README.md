dotfiles
========

More of new machines setup script than a dotfiles project. Setup on Debian 13 or MacOSX:

**Prerequisites:**
- Debian 13: curl (sudo will be auto-installed if needed, prompting for root password via `su`)
- MacOSX: curl (built-in)

**Installation:**
```bash
# Will prompt for sudo password interactively
curl -fsSL https://raw.githubusercontent.com/untoldone/dotfiles/master/bootstrap.sh | bash
```

## Testing

Test the Debian setup in Docker without affecting your system:

```bash
# Build and setup the test environment (non-interactive)
./test-debian.sh

# Then test interactively
docker exec -it dotfiles-debian-test zsh

# Verify installations
docker exec dotfiles-debian-test bash -c 'ruby --version && go version && node --version'

# Clean up when done
docker rm -f dotfiles-debian-test
```

## Installed Software

- **Shell**: zsh with oh-my-zsh
- **Ruby**: 3.4.6 (via RVM)
- **Node.js**: Latest LTS (via FNM - Fast Node Manager)
- **Go**: 1.25.1
- **Docker**: Latest with Compose V2
- **PostgreSQL**: 18
- **Claude Code**: AI-powered CLI
- **Android SDK**: Build tools (optional)

Todo
====

* Syncthing between machines?
* authorized_keys
* ssh configuration (agent, ssh-key, other?)
* gcloud, aws, heroku, dokku command line
* ngrok