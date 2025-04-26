{ config, lib, pkgs, ... }:

{
  imports = [
    ./modules/bluetooth.nix
    ./modules/desktop-gnome.nix
    ./modules/networking.nix
    ./modules/user.nix
    ./modules/virt.nix
  ];

  networking.hostName = "nixos";
  time.timeZone = "Europe/Minsk";
  i18n.defaultLocale = "en_US.UTF-8";

  services.timesyncd.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "24.11";

  systemd.services.display-manager.after = [ "systemd-udev-settle.service" "graphical.target" ];
}