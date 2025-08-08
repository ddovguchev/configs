#!/bin/bash
set -e

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

TALOS_IMG_URL="https://factory.talos.dev/image/613e1592b2da41ae5e265e8789429f22e121aab91cb4deb6bc3c0b6262961245/v1.10.3/metal-amd64-secureboot.raw.zst"
TARGET_DISK="/dev/nvme0n1"
RAW_IMG="/tmp/talos.raw"
ZST_IMG="/tmp/talos.raw.zst"

log() {
  echo -e "${CYAN}[+]${NC} $1"
}

section() {
  echo -e "\n${BOLD}${GREEN}========== $1 ==========${NC}"
}

step() {
  echo -e "${GREEN}✓${NC} $1"
}

log "Downloading Talos image..."
wget -O "$ZST_IMG" "$TALOS_IMG_URL"

log "Decompressing image..."
unzstd -f "$ZST_IMG" -o "$RAW_IMG"

log "Writing Talos image to $TARGET_DISK"
dd if="$RAW_IMG" of="$TARGET_DISK" bs=4M status=progress oflag=direct
sync
step "Image written successfully"

section "Network Interfaces (IPv4)"
ip -o -4 addr show | awk '{print " - " $2 ": " $4}'

section "Network Interfaces (IPv6)"
ip -o -6 addr show | awk '{print " - " $2 ": " $4}'

section "Default Gateway"
ip route | grep default | awk '{print " - " $0}'

section "Full Routing Table"
ip route | awk '{print " - " $0}'

section "Disk Info"
lsblk -o NAME,MAJ:MIN,RM,SIZE,RO,TYPE,MOUNTPOINT | sed 's/^/ /'

section "Talos Installation Complete"
step "Talos installed to ${TARGET_DISK}"

echo -e "\n${BOLD}${CYAN}[→] Rebooting now...${NC}"
# reboot