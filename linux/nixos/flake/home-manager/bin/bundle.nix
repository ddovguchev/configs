{pkgs, ...}: let
  change_wallpaper = import ./change_wallpaper.nix pkgs;
  startup = import ./startup.nix pkgs;
  select_wallpaper = import ./select_wallpaper.nix pkgs;
in [
  nvidia_offload
  change_wallpaper
  startup
  select_wallpaper
]
