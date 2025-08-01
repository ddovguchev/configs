{ config, pkgs, lib, username, ... }: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  security.pam.services.sudo_local.touchIdAuth = true;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh ];

  nix.settings.experimental-features = "nix-command flakes";

  system.stateVersion = 6;

  imports = [ ./packages.nix ./yabai.nix ./skhd.nix ];
}