{...}: let
  themes = import theme/themes-definition.nix;
  selected = themes.jandedobbeleer;
in {
  enable = true;
  enableZshIntegration = true;
  settings = builtins.fromJSON (builtins.readFile selected.path);
}