{ config, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  environment.systemPackages = with pkgs; [
    yabai git neovim zsh ripgrep fd bat fzf htop
  ];

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