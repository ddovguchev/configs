{ config, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.systemPackages = with pkgs; [
    # Системные утилиты
    coreutils curl unzip zip wget tree eza jq

    # Разработка
    git neovim zsh fzf htop ripgrep fd bat lua-language-server mkalias nil templ tmux zoxide ranger pyenv

    # Языки программирования и инструменты
    go rustup stylua sqlc stripe-cli bun

    # DevOps и контейнеризация
    kubectl kubernetes-helm opentofu packer qmk colima k9s hcloud talosctl kustomize tenv

    # Сетевые утилиты
    wireguard-tools wireguard-go iperf rclone pass awscli

    # CI/CD и инфраструктура
    act air argocd

    # Мультимедиа и графика
    ffmpeg spicetify-cli

    # Базы данных
    postgresql_16
  ];

  # Конфигурация пользователя
  users.users.dmitriy = {
    name = "dmitriy";
    home = "/Users/dmitriy";
    shell = pkgs.zsh;
  };

  # Homebrew: CLI и GUI-пакеты
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    brews = [ "mas" "nvm" "goenv" ];
    casks = [
      "hammerspoon" "notion" "iina" "arc" "chatgpt" "intellij-idea" "telegram"
      "discord" "firefox" "visual-studio-code" "spotify" "gns3" "virtualbox"
      "altserver" "sony-ps-remote-play"
    ];
  };

  imports = [
    ./modules/yabai.nix
  ];

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  # Переменные окружения
  environment.variables = {
    PATH = "/opt/homebrew/bin:$PATH";
  };

  # Включение flakes и новых возможностей nix
  nix.settings.experimental-features = "nix-command flakes";

  # Версия состояния системы
  system.stateVersion = 6;

  # Скрипт, выполняемый после активации
  system.activationScripts.postActivation.text = ''
    # Безопасная смена shell
    sudo chsh -s /run/current-system/sw/bin/zsh dmitriy || true

    # Сетевые и временные настройки (с защитой от сбоев)
    sudo sysctl -w net.inet.ip.ttl=65 || true
    sudo networksetup -setv6off Wi-Fi || true
    sudo systemsetup -settimezone "Europe/Moscow" 2>/dev/null || true
    sudo systemsetup -setusingnetworktime on 2>/dev/null || true

    # Перезапуск yabai (если установлен)
    if command -v brew >/dev/null 2>&1; then
      brew services restart yabai || true
    fi
  '';
}