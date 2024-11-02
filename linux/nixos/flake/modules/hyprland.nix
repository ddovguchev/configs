{ config, pkgs, ... }:

{
  #  services.xserver.enable = true;

  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true; # или другой менеджер
  services.xserver.windowManager.hyprland.enable = true;

  # Опции для Wayland
  services.xserver.displayManager.defaultSession = "hyprland";
}