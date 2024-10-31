{ config, pkgs, ... }:

{
  # Включаем поддержку X11
  services.xserver.enable = true;

  # Включаем Hyprland как оконный менеджер
  programs.hyprland.enable = true;

  # Устанавливаем Hyprland в качестве менеджера сеансов по умолчанию
  services.xserver.displayManager.defaultSession = "hyprland";


  systemd.user.services.swww-daemon = {
    description = "swww daemon";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.swww}/bin/swww-daemon";
    };
  };
}