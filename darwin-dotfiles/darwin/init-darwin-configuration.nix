{ config, pkgs, lib, username, ... }: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = "aarch64-darwin";

  security.pam.services.sudo_local.touchIdAuth = true;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  environment.shells = [ pkgs.zsh ];

  nix.settings.experimental-features = "nix-command flakes";

  system.stateVersion = 6;
  system.primaryUser = username;

  imports = [
    (import ./packages.nix { inherit config lib pkgs; })
  ];
}
