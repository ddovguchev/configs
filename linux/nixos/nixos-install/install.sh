#!/usr/bin/env bash

(( EUID )) && { echo "NO root"; exit 1; }

if [ -z "$1" ]; then
  read -sp "Enter root password: " root_password
  echo
else
  root_password="$1"
fi

tmp_folder="/tmp/nixos"
disko_link="https://github.com/nix-community/disko.git"
disko_nix_link="https://raw.githubusercontent.com/ddovguchev/configs/master/linux/nixos/nixos-install/disko.nix"

rm -rf "$tmp_folder"
mkdir -p "$tmp_folder"
cd "$tmp_folder" || { echo "Error with $tmp_folder"; exit 1; }

git clone "$disko_link" . || { echo "Error clone REPO disko_link"; exit 1; }

curl -sSL "$disko_nix_link" -o disko.nix || { echo "Error load disko.nix"; exit 1; }

nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./disko.nix

nixos-generate-config --root /mnt

echo "root:$root_password" | chpasswd --root /mnt

nixos-install