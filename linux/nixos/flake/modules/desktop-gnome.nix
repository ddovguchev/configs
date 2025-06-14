{ config, pkgs, ... }:

{
  # Disable X11 server (not needed for pure Wayland)
  services.xserver.enable = false;

  # Hyprland configuration
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;  # X11 app support

    # Only apply NVIDIA patches if NVIDIA is enabled
    nvidiaPatches = config.hardware.nvidia.enable or false;
  };

  # Required services for Wayland
  security.polkit.enable = true;
  services.dbus.enable = true;

  # Greetd configuration with gtkgreet
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.gtkgreet}/bin/gtkgreet --layer-shell";
        user = "greeter";
      };
    };
  };

  # Greeter user account
  users.users.greeter = {
    isNormalUser = true;
    description = "Greeter user";
    shell = pkgs.nologin;
    home = "/var/lib/greetd";
    extraGroups = [ "video" "input" ];
  };

  # NVIDIA configuration (if needed)
  hardware.nvidia = {
    # Only enable if you have NVIDIA hardware
    enable = false;  # Change to true if using NVIDIA GPU
    modesetting.enable = true;
    powerManagement.enable = true;
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
    ] ++ lib.optional config.hardware.nvidia.enable pkgs.linuxPackages.nvidia_x11;
  };

  # Audio configuration
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Environment variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    GDK_BACKEND = "wayland";
    XDG_SESSION_TYPE = "wayland";
    EDITOR = "nvim";
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };

  # Fonts
  fonts.packages = with pkgs; [
    jetbrains-mono
    noto-fonts
    noto-fonts-emoji
    font-awesome
    (nerd-fonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  # System packages
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
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # XDG portal integration
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}