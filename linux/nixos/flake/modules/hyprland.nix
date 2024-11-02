{ config, pkgs, ... }:

{
  # Включаем поддержку X11
  #  services.xserver.enable = true;

  # Включаем Hyprland как оконный менеджер
  #  programs.hyprland.enable = true;

  # Устанавливаем Hyprland в качестве менеджера сеансов по умолчанию
  #  services.xserver.displayManager.defaultSession = "hyprland";


  systemd.services.swww-daemon = {
    description = "SWWW Daemon";
    serviceConfig = {
      ExecStart = "/run/current-system/sw/bin/swww-daemon";
      Restart = "always";
    };
    wantedBy = [ "multi-user.target" ];
  };
}