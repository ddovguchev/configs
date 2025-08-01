{ config, pkgs, lib, ... }: {
  services.skhd = {
    enable = true;
    skhdConfig = ''
      alt - h : yabai -m window --focus west
    '';
  };
}