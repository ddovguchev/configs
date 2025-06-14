{ config, pkgs, ... }:

{
  # Базовые настройки системы
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Сетевая конфигурация
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Локализация
  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "en_US.UTF-8";

  # Пользователи
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "password";  # Не забудьте изменить после установки
  };

  # Настройка Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Графический стек (универсальный)
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # Аудио
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = false;
  };

  # Переменные окружения Wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    GDK_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
  };

  # Шрифты
  fonts.packages = with pkgs; [
    (nerd-fonts.override { fonts = [ "FiraCode" ]; })
    noto-fonts-emoji
    font-awesome
  ];

  # Системные пакеты
  environment.systemPackages = with pkgs; [
    # Основные утилиты
    git
    neovim
    wget
    htop

    # Wayland окружение
    wofi
    waybar
    swaylock
    swayidle
    grim
    slurp
    wl-clipboard

    # Приложения
    firefox-wayland
  ];

  # Разрешить несвободные пакеты
  nixpkgs.config.allowUnfree = true;

  # Включить flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # XDG портал
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Включить zsh
  programs.zsh.enable = true;
}