{ config, pkgs, ... }:

{
  services.xserver.enable = false;
  services.displayManager.sddm.enable = true;
  services.displayManager.defaultSession = "hyprland";
  services.windowManager.hyprland.enable = true;
}