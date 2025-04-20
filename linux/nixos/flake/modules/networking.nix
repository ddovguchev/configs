{ config, pkgs, ... }: {
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";

  networking = {
    networkmanager.enable = true;
    useDHCP = false;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
  };
}