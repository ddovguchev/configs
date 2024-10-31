{
  programs.hyprland.enable = true;
  services.xserver.enable = true;
  services.xserver.displayManager = {
    enable = true;
    greetd = {
      enable = true;
      user = "hika";
      session = "hyprland";
    };
  };
}
