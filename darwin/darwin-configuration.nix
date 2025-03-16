{ config, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.systemPackages = with pkgs; [
    yabai git neovim zsh ripgrep fd bat fzf htop wireguard-tools wireguard-go
    coreutils air act awscli bun ffmpeg jujutsu gh gnupg go iperf lua-language-server
    mkalias nil opentofu pass postgresql_16 rclone rustup sqlc stylua stripe-cli
    tailwindcss tailwindcss-language-server qmk templ tmux zoxide kubectl kubernetes-helm
    terraform ranger pyenv packer spicetify-cli eza colima k9s tree hcloud talosctl
    kustomize curl unzip zip wget
  ];

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

  users.users.dmitriy = {
    name = "dmitriy";
    home = "/Users/dmitriy";
    shell = pkgs.zsh;
  };

  imports = [
    ./modules/yabai.nix
  ];

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  nix.settings.experimental-features = "nix-command flakes";

  system.stateVersion = 6;
}
