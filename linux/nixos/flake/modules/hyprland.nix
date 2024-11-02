{ config, pkgs, ... }:

{
  #  services.xserver.enable = true;

  #  programs.hyprland.enable = true;
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true; # или sddm.enable = true;
  services.xserver.windowManager.hyprland.enable = true;

  services.displayManager.defaultSession = "hyprland";
}