{ config, pkgs, ... }:

let
  appList = import module/apps.nix;
  toNames = apps: map (a: a.name) apps;

  brews = toNames (builtins.filter (a: a.type == "brew") appList.apps);
  casks = toNames (builtins.filter (a: a.type == "cask") appList.apps);
  nixPkgs = builtins.filter (a: a.type == "nix") appList.apps;
in
{
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    brews = brews;
    casks = casks;
  };

  environment.systemPackages = with pkgs; map (a: pkgs.${a.name}) nixPkgs;
}
