{ config, pkgs, lib, username, system, ... }: {
  nixpkgs.config.allowUnfree = true;
  nixpkgs.hostPlatform = system;

  system.primaryUser = username;

  security.pam.services.sudo_local.touchIdAuth = true;

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  environment.shells = [ pkgs.zsh ];

  nix.settings.experimental-features = "nix-command flakes";
  nix.gc.interval.Day = 7;
  nix.settings.extra-nix-path = "nixpkgs=flake:nixpkgs";
  nix.settings.warn-dirty = false;
  nix.settings.show-trace = false;

  imports = [
    (import ./module/system.nix { inherit pkgs username; })

    (import ./packages.nix { inherit config lib pkgs; })
    (import ./module/yabai.nix { inherit config lib pkgs; })
  ];
}
