{ config, lib, pkgs, ... }:

{
  services.openssh.enable = true;

  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
}