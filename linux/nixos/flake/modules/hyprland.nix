{
  programs.hyprland.enable = true;
  services.xserver.enable = true;
  systemd.user.services.swww-daemon = {
    description = "swww daemon";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.swww}/bin/swww-daemon";
    };
  };
}
