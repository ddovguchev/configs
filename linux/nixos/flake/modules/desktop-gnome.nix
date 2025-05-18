{ config, pkgs, ... }: {
  services.xserver.enable = false;
  programs.hyprland.enable = true;
  services.dbus.enable = true;

  services.greetd.enable = true;
  services.greetd.settings.default_session = {
    command = ''
      env HOME=/home/hika XDG_SESSION_TYPE=wayland Hyprland
    '';
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
    tuigreet
  ];
}