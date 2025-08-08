{ pkgs, lib, ... }:
{
  enable = true;
  plugins = [
    {
      name = "ranger_devicons";
      src = pkgs.fetchFromGitHub {
        owner = "alexanderjeurissen";
        repo = "ranger_devicons";
        rev = "master";
        sha256 = "sha256-qvWqKVS4C5OO6bgETBlVDwcv4eamGlCUltjsBU3gAbA=";
        #        sha256 = lib.fakeSha256; # lifehack
      };
    }
  ];
  extraConfig = ''
    set show_hidden true
    set draw_borders true
    set column_ratios 1,2,3
    set preview_images true
    set preview_images_method kitty
    default_linemode devicons
    linemode devicons
    set preview_script ~/.config/ranger/scope.sh
  '';
}
