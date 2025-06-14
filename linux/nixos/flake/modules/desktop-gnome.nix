{ config, pkgs, ... }:

{
  # Отключение X11 сервера (не нужен для Wayland)
  services.xserver.enable = false;

  # Настройки Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;  # Поддержка X11 приложений
    nvidiaPatches = config.hardware.nvidia.enable;  # Автоматические патчи для NVIDIA
  };

  # Необходимые сервисы для Wayland
  security.polkit.enable = true;
  services.dbus.enable = true;

  # Экранный менеджер (greetd с gtkgreet)
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.gtkgreet}/bin/gtkgreet --layer-shell";
        user = "greeter";
      };
    };
  };

  # Пользователь для greetd
  users.users.greeter = {
    isNormalUser = true;
    description = "Greeter user";
    shell = pkgs.nologin;
    home = "/var/lib/greetd";
    extraGroups = [ "video" "input" ];
  };

  # Аудио (PipeWire заменяет PulseAudio)
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Графика
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
      vulkan-tools
    ];
  };

  # Переменные окружения
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    GDK_BACKEND = "wayland";
    XDG_SESSION_TYPE = "wayland";
    EDITOR = "nvim";
    RANGER_LOAD_DEFAULT_RC = "FALSE";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    GSETTINGS_BACKEND = "keyfile";
  };

  # Шрифты
  fonts.packages = with pkgs; [
    jetbrains-mono
    noto-fonts
    noto-fonts-emoji
    font-awesome
    (nerd-fonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  # Системные пакеты
  environment.systemPackages = with pkgs; [
    # Основные утилиты
    git
    neovim
    wget
    htop
    zsh

    # Wayland окружение
    wofi
    waybar
    swaylock
    swayidle
    grim
    slurp
    wl-clipboard

    # Графические приложения
    firefox-wayland
    dconf-editor

    # Разработка
    gcc
    clang
    python3
    nodejs
    rustup
  ];

  # Разрешение несвободных пакетов
  nixpkgs.config.allowUnfree = true;

  # Дополнительные настройки
  programs.sway.enable = true;  # Совместимость с Sway утилитами
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}