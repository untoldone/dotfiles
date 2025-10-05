#!/usr/bin/env bash

set -e

CONTAINER_NAME="dotfiles-debian-test"
IMAGE_NAME="dotfiles-debian13"
SUDO_PASSWORD="testpassword"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}==> Building Debian 13 test environment${NC}"

# Build the Docker image
docker build -t $IMAGE_NAME -f Dockerfile.debian13 .

echo -e "${GREEN}==> Removing any existing test container${NC}"
docker rm -f $CONTAINER_NAME 2>/dev/null || true

echo -e "${GREEN}==> Starting Debian 13 container${NC}"
docker run -d \
  --name $CONTAINER_NAME \
  --privileged \
  -v "$(pwd):/host-dotfiles:ro" \
  $IMAGE_NAME \
  sleep infinity

echo -e "${GREEN}==> Installing dotfiles in container (non-interactive)${NC}"
docker exec $CONTAINER_NAME bash -c "
  cp -r /host-dotfiles /root/dotfiles && \
  cd /root/dotfiles && \
  ./init.sh $SUDO_PASSWORD
"

echo -e "${GREEN}==> Setup complete!${NC}"
echo ""
echo -e "${YELLOW}To test the environment interactively, run:${NC}"
echo -e "  ${GREEN}docker exec -it $CONTAINER_NAME zsh${NC}"
echo ""
echo -e "${YELLOW}To verify installations:${NC}"
echo -e "  ${GREEN}docker exec $CONTAINER_NAME bash -c 'ruby --version && go version && node --version && docker --version'${NC}"
echo ""
echo -e "${YELLOW}To clean up when done:${NC}"
echo -e "  ${GREEN}docker rm -f $CONTAINER_NAME${NC}"
