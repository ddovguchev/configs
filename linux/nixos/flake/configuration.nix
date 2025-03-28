{ config, lib, pkgs, ... }:

{
  imports = [
    ./modules/bundel.nix
  ];

  networking.hostName = "nixos";
  time.timeZone = "Europe/Minsk";
  i18n.defaultLocale = "en_US.UTF-8";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "24.11";

  systemd.services.display-manager.after = [ "systemd-udev-settle.service" "graphical.target" ];
}