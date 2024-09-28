#!/usr/bin/env bash

(( EUID )) && { echo "NO root"; exit 1; }

tmp_folder="/tmp/nixos"
disko_link="https://github.com/nix-community/disko.git"
disko_nix_link="https://raw.githubusercontent.com/ddovguchev/configs/master/linux/nixos/disko/disko.nix"

rm -rf "$tmp_folder"
mkdir -p "$tmp_folder"
cd "$tmp_folder" || { echo "Не удалось перейти в $tmp_folder"; exit 1; }

git clone "$disko_link" . || { echo "Ошибка при клонировании репозитория"; exit 1; }
curl -sSL "$disko_nix_link" -o disko.nix || { echo "Ошибка при загрузке disko.nix"; exit 1; }

nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./disko.nix

nixos-generate-config --root /mnt
nixos-install