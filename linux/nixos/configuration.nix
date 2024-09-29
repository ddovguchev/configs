{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "24.05";
}