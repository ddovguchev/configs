#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

WALLPAPERS=("$WALLPAPER_DIR"/*.{jpg,jpeg,png})

if [ ${#WALLPAPERS[@]} -eq 0 ]; then
  echo "No wallpapers found in $WALLPAPER_DIR"
  exit 1
fi

SELECTED_WALLPAPER=$(printf "%s\n" "${WALLPAPERS[@]}" | wofi --dmenu --title "Select Wallpaper" --width 300 --height 500)

if [[ -n "$SELECTED_WALLPAPER" ]]; then
  swww img "$SELECTED_WALLPAPER"
  echo "Wallpaper set to: $SELECTED_WALLPAPER"
else
  echo "No wallpaper selected."
fi