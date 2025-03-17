{ config, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.systemPackages = with pkgs; [
    # Базовые системные утилиты
    coreutils curl unzip zip wget tree eza

    # Разработка
    git neovim zsh fzf htop ripgrep fd bat lua-language-server mkalias nil templ tmux zoxide ranger pyenv

    # Языки программирования и инструменты
    go rustup stylua sqlc stripe-cli bun

    # DevOps и контейнеризация
    kubectl kubernetes-helm opentofu packer qmk colima k9s hcloud talosctl kustomize tenv

    # Сетевые утилиты
    wireguard-tools wireguard-go iperf rclone pass awscli

    # CI/CD и инфраструктура
    act air

    # Мультимедиа и графика
    ffmpeg spicetify-cli

    # Базы данных
    postgresql_16
  ];

  users.users.dmitriy = {
    name = "dmitriy";
    home = "/Users/dmitriy";
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    brews = [ "mas" "nvm" ];
    casks = [
      "hammerspoon" "notion" "iina" "arc" "chatgpt" "intellij-idea" "telegram"
      "discord" "firefox" "visual-studio-code" "spotify" "gns3" "virtualbox"
      "altserver" "sony-ps-remote-play" "goenv"
    ];
  };

  imports = [
    ./modules/yabai.nix
  ];

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  environment.variables = {
    PATH = "/opt/homebrew/bin:$PATH";
  };

  nix.settings.experimental-features = "nix-command flakes";

  system.stateVersion = 6;

  system.activationScripts.postActivation.text = ''
    USER_HOME="/Users/dmitriy"

    {
      # Инициализация NVM
      echo 'export NVM_DIR="$USER_HOME/.nvm"'
      echo '[ -s "$(brew --prefix nvm)/nvm.sh" ] && . "$(brew --prefix nvm)/nvm.sh"'

      # Установка и настройка SDKMAN!
      echo 'export SDKMAN_DIR="$USER_HOME/.sdkman"'
      echo '[[ -s "$USER_HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$USER_HOME/.sdkman/bin/sdkman-init.sh"'

      # Инициализация Tenv
      echo 'export PATH="$USER_HOME/.tenv/bin:$PATH"'
      echo 'eval "$(tenv init -)"'

      # Подключение JetBrains VM options
      echo '___MY_VMOPTIONS_SHELL_FILE="$USER_HOME/.jetbrains.vmoptions.sh"; if [ -f "$___MY_VMOPTIONS_SHELL_FILE" ]; then . "$___MY_VMOPTIONS_SHELL_FILE"; fi'
    } >> "$USER_HOME/.zshrc"

    # Настройки системы
    sudo chsh -s /run/current-system/sw/bin/zsh dmitriy
    sudo sysctl -w net.inet.ip.ttl=65
    sudo networksetup -setv6off Wi-Fi
    sudo systemsetup -settimezone "Europe/Moscow"
    sudo systemsetup -setusingnetworktime on

    # Перезапуск сервисов
    brew services restart yabai || true
  '';
}