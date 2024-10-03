{ config, lib, pkgs, ... }:

{
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];
}