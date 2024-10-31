#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

WALLPAPERS=("$WALLPAPER_DIR"/*.{jpg,jpeg,png,webp})

if [ ${#WALLPAPERS[@]} -eq 0 ]; then
  echo "No wallpapers found in $WALLPAPER_DIR"
  exit 1
fi

SELECTED_WALLPAPER=$(printf "%s\n" "${WALLPAPERS[@]}" | wofi --dmenu --width 300 --height 500)

if [[ -n "$SELECTED_WALLPAPER" ]]; then
  swww img "$SELECTED_WALLPAPER"
  echo "Wallpaper set to: $SELECTED_WALLPAPER"
else
  echo "No wallpaper selected."
fi
