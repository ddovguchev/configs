{ config, lib, pkgs, ... }:

{

  # Включаем поддержку X11
  services.xserver.enable = true;

  # Включаем Hyprland как оконный менеджер
  services.xserver.windowManager.hyprland.enable = true;

  # Устанавливаем Hyprland в качестве менеджера сеансов по умолчанию
  services.xserver.displayManager.defaultSession = "Hyprland";


  systemd.user.services.swww-daemon = {
    description = "swww daemon";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.swww}/bin/swww";
    };
  };

#  systemd.user.services.hyperland-daemon = {
#    description = "Hyperland daemon";
#    wantedBy = [ "default.target" ];
#    serviceConfig = {
#      ExecStart = "${pkgs.swww}/bin/Hyperland";
#    };
#  };
}
