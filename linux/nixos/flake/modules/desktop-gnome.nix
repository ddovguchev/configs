{ config, pkgs, lib, ... }:

{
  # Disable X11 server
  services.xserver.enable = false;

  # Basic Wayland requirements
  security.polkit.enable = true;
  services.dbus.enable = true;

  # Hyprland configuration (without NVIDIA patches for now)
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
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
    ];
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