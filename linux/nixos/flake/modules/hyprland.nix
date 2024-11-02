{ config, pkgs, ... }:

{
  #  services.xserver.enable = true;

  #  programs.hyprland.enable = true;
  services.xserver.enable = true;
  services.xserver.displayManager.defaultSession = "hyprland";
  services.xserver.displayManager.startx.enable = false;
}