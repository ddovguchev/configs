{ config, pkgs, ... }:

{
  #  services.xserver.enable = true;

  #  programs.hyprland.enable = true;
  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true; # или false, если используешь другой менеджер
  services.xserver.defaultSession = "hyprland";
}