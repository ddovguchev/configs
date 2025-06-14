{ config, pkgs, ... }:

{
  # Disable X11 server
  services.xserver.enable = false;

  # Basic Wayland requirements
  security.polkit.enable = true;
  services.dbus.enable = true;

  # NVIDIA configuration (must come BEFORE hyprland config)
  hardware.nvidia = {
    enable = false;  # Set to true if you have NVIDIA GPU
    modesetting.enable = true;
  };

  # Hyprland configuration (now safe to reference nvidia settings)
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    nvidiaPatches = config.hardware.nvidia.enable or false;
  };

  # Display manager (greetd)
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.gtkgreet}/bin/gtkgreet --layer-shell";
        user = "greeter";
      };
    };
  };

  # Greeter user
  users.users.greeter = {
    isNormalUser = true;
    description = "Greeter user";
    shell = pkgs.nologin;
    home = "/var/lib/greetd";
    extraGroups = [ "video" "input" ];
  };

  # Graphics support
  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ] ++ (lib.optional config.hardware.nvidia.enable pkgs.nvidia-vaapi-driver);
  };

  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Environment variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
  };

  # Fonts
  fonts.packages = with pkgs; [
    (nerd-fonts.override { fonts = [ "FiraCode" ]; })
    noto-fonts-emoji
  ];

  # System packages
  environment.systemPackages = with pkgs; [
    # Wayland essentials
    wofi
    waybar
    swaylock
    wl-clipboard

    # Utilities
    git
    neovim
  ];

  # XDG portal
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}