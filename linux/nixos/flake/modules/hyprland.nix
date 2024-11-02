{ config, pkgs, ... }:

{
  services.xserver.enable = false;

  services.displayManager.sddm.enable = true;
  services.displayManager.defaultSession = "hyprland";

  services.hyprland.enable = true;
}