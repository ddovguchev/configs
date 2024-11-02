{ config, pkgs, ... }:

{
  #  services.xserver.enable = true;

  services.xserver.enable = false;

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.defaultSession = "Hyprland";

}