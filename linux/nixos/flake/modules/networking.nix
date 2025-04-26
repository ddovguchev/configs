{ config, pkgs, ... }: {
  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "yes";
  };

  networking = {
    networkmanager.enable = true;
    useDHCP = false;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
  };

  systemd.services.load-firmware = {
    description = "Load T2 network firmware";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.bash}/bin/bash -c 'yes 1 | /etc/nixos/firmware.sh'";
      Type = "oneshot";
      RemainAfterExit = true;
      StandardOutput = "journal";
      StandardError = "journal";
    };
  };
}