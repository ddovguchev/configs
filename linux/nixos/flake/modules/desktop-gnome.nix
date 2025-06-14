{ config, pkgs, ... }: {
  services.xserver.enable = false;
  programs.hyprland.enable = true;
  services.dbus.enable = true;


  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
  ]) ++ (with pkgs.gnome; [
    cheese
    epiphany
  ]);

  users.users.greeter = {
    isNormalUser = true;
    description = "Greeter user";
    shell = pkgs.nologin;
    home = "/var/lib/greetd";
    extraGroups = [ "video" "input" ];
  };

  environment.variables = {
    EDITOR = "nvim";
    RANGER_LOAD_DEFAULT_RC = "FALSE";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    GSETTINGS_BACKEND = "keyfile";
    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland";
    CLUTTER_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ vulkan-tools ];
  };

  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    jetbrains-mono
    noto-fonts
    noto-fonts-emoji
    twemoji-color-font
    font-awesome
    powerline-fonts
    powerline-symbols
    nerd-fonts.symbols-only
  ];

  environment.systemPackages = with pkgs; [
    dconf-editor
    firefox-wayland
    neovim
    zsh
    git
    htop
    wget
    unzip
    pyenv
    nodenv
    gcc
    clang
    zlib
    bzip2
    openssl
    sqlite
    libffi
    gnumake
    pkg-config
    libnsl
    xz
    cacert
    python3
    python3Packages.pip
    dmg2img


    # greetd GUI login + deps
    greetd.gtkgreet
    gtk3
    gtk4
    glib
    gsettings-desktop-schemas
    libsoup
    libadwaita
    qt5.qtwayland
    qt6.qtwayland
  ];
}