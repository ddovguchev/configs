{ config, pkgs, ... }: {
  programs.zsh.enable = true;

  users = {
    defaultUserShell = pkgs.zsh;
    users.hika = {
      isNormalUser = true;
      description = "Hika";
      extraGroups = [ "networkmanager" "wheel" "input" "libvirtd" ];
      packages = with pkgs; [ ];
    };
  };

  services.getty.autologinUser = "hika";
}