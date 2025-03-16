{ config, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.systemPackages = with pkgs; [
    yabai git neovim zsh ripgrep fd bat fzf htop wireguard-tools wireguard-go coreutils air act awscli bun ffmpeg jujutsu gh gnupg go iperf lua-language-server mkalias nil opentofu pass postgresql_16 rclone rustup sqlc stylua stripe-cli tailwindcss tailwindcss-language-server qmk templ tmux zoxide kubectl kubernetes-helm terraform ranger pyenv packer spicetify-cli eza colima k9s tree hcloud talosctl kustomize curl unzip zip wget
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
      "altserver" "sony-ps-remote-play"
    ];
  };

  imports = [
    ./modules/yabai.nix
  ];

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  nix.settings.experimental-features = "nix-command flakes";

  system.stateVersion = 6;

  system.activationScripts.postActivation.text = ''
    # Инициализация NVM
    mkdir -p "$HOME/.nvm"
    echo "export NVM_DIR=\"$HOME/.nvm\"" >> "$HOME/.zshrc"
    echo "[ -s \"$(brew --prefix nvm)/nvm.sh\" ] && . \"$(brew --prefix nvm)/nvm.sh\"" >> "$HOME/.zshrc"

    # Установка и настройка SDKMAN!
    if [ ! -d "$HOME/.sdkman" ]; then
      curl -s "https://get.sdkman.io" | bash
    fi
    echo "export SDKMAN_DIR=\"$HOME/.sdkman\"" >> "$HOME/.zshrc"
    echo "[[ -s \"$HOME/.sdkman/bin/sdkman-init.sh\" ]] && source \"$HOME/.sdkman/bin/sdkman-init.sh\"" >> "$HOME/.zshrc"

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