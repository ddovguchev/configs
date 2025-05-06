{ config, pkgs, lib, ... }: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.systemPackages = with pkgs; [
    coreutils curl unzip zip wget tree eza jq nmap neofetch gnupg
    git neovim zsh fzf htop ripgrep fd bat lua-language-server mkalias nil templ tmux zoxide ranger pyenv
    go rustup stylua sqlc stripe-cli bun
    kubectl kubernetes-helm opentofu packer qmk colima k9s hcloud talosctl kustomize tenv
    wireguard-tools wireguard-go iperf rclone pass awscli
    act air argocd vault sops
    ffmpeg spicetify-cli
    postgresql_16 yabai
  ];
  security.pam.services.sudo_local.touchIdAuth = true;

  users.users.dmitriy = {
    name = "dmitriy";
    home = "/Users/dmitriy";
    shell = pkgs.zsh;
  };

  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    brews = [ "mas" "nvm" "goenv" "tetra" ];
    casks = [
      "hammerspoon" "notion" "arc" "chatgpt" "intellij-idea" "telegram"
      "discord" "firefox" "visual-studio-code" "spotify" "gns3" "virtualbox"
      "altserver" "steam"
    ];
  };

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  environment.variables = {
    PATH = "/opt/homebrew/bin:$PATH";
  };

  nix.settings.experimental-features = "nix-command flakes";

  system.stateVersion = 6;

  imports = [ ./yabai.nix ./skhd.nix ];

  home-manager.users.dmitriy = { config, pkgs, ... }: {
    home.username = "dmitriy";
    home.homeDirectory = "/Users/dmitriy";
    home.stateVersion = "23.11";

    home.packages = with pkgs; [
      tenv gnupg
    ];

    home.sessionVariables = {
      NVM_DIR = "${config.home.homeDirectory}/.nvm";
      GNUPGHOME = "${config.home.homeDirectory}/.gnupg";
      PATH = "${config.home.homeDirectory}/.tenv/bin:$PATH";
    };

    programs.zsh.enable = true;

    home.file.".zshrc".force = true;
    home.file.".zshrc".text = ''
      export NVM_DIR="$HOME/.nvm"
      [ -s "$(brew --prefix nvm)/nvm.sh" ] && \. "$(brew --prefix nvm)/nvm.sh"
      export PATH="$HOME/.tenv/bin:$PATH"
      export GNUPGHOME="$HOME/.gnupg"
    '';
  };
}