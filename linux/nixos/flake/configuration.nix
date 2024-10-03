{ config, lib, pkgs, ... }:

{
  imports = [
    ./modules/bundel.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos";
  time.timeZone = "Europe/Minsk";
  i18n.defaultLocale = "en_US.UTF-8";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "24.11";
}
