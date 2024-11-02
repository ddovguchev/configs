{ config, pkgs, ... }:

{
  #  services.xserver.enable = true;

  #  programs.hyprland.enable = true;
  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = false;
  services.xserver.defaultSession = "hyprland";
}