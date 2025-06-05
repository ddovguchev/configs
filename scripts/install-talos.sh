#!/bin/bash
set -e

TALOS_IMG_URL="https://factory.talos.dev/image/613e1592b2da41ae5e265e8789429f22e121aab91cb4deb6bc3c0b6262961245/v1.10.3/metal-amd64-secureboot.raw.zst"
TARGET_DISK="/dev/nvme0n1"
RAW_IMG="/tmp/talos.raw"
ZST_IMG="/tmp/talos.raw.zst"

echo "[+] Downloading Talos image..."
wget -O "$ZST_IMG" "$TALOS_IMG_URL"

echo "[+] Decompressing image..."
unzstd -f "$ZST_IMG" -o "$RAW_IMG"

echo "[+] Writing Talos image to $TARGET_DISK"
dd if="$RAW_IMG" of="$TARGET_DISK" bs=4M status=progress oflag=direct
sync

echo "-=== host info ===-"
ip route
ip a
lsblk

echo "[✓] Talos installed to $TARGET_DISK"
reboot
echo "[→] Now reboot and configure via talosctl"