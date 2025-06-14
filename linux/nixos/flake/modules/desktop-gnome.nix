{ config, pkgs, lib, ... }:

let
  # Helper to safely check if NVIDIA is enabled
  nvidiaEnabled = config.hardware.nvidia.enable or false;
in
{
  # Disable X11 server (not needed for pure Wayland)
  services.xserver.enable = false;

  # Hyprland configuration
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;  # X11 app support
    nvidiaPatches = nvidiaEnabled;  # Only apply NVIDIA patches if NVIDIA is enabled
  };

  # Basic Wayland requirements
  security.polkit.enable = true;
  services.dbus.enable = true;

  # Display manager (greetd with gtkgreet)
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

  # NVIDIA configuration (optional - enable only if you have NVIDIA GPU)
  hardware.nvidia = {
    enable = false;  # Change to true if using NVIDIA
    modesetting.enable = true;
    powerManagement.enable = false;  # Set to true if you want power management
    open = false;  # Set to true if using open-source drivers
  };

  # Graphics support
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
      vulkan-tools
    ] ++ lib.optionals nvidiaEnabled [
      nvidia-vaapi-driver
    ];
  };

  # Audio configuration
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = false;  # Enable if you need JACK support
  };

  # Environment variables
  environment.sessionVariables = rec {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    GDK_BACKEND = "wayland";
    XDG_SESSION_TYPE = "wayland";
    EDITOR = "nvim";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    MOZ_ENABLE_WAYLAND = "1";
  };

  # Fonts
  fonts.packages = with pkgs; [
    jetbrains-mono
    noto-fonts
    noto-fonts-emoji
    font-awesome
    (nerd-fonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  # Essential system packages
  environment.systemPackages = with pkgs; [
    # Core utilities
    git
    neovim
    wget
    htop
    zsh

    # Wayland environment
    wofi
    waybar
    swaylock
    swayidle
    grim
    slurp
    wl-clipboard

    # Applications
    firefox-wayland
    dconf-editor

    # Development tools
    gcc
    clang
    python3
  ];

  # Allow unfree packages (required for some drivers)
  nixpkgs.config.allowUnfree = true;

  # XDG portal integration
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}