{ ... }:
let
  themes = import theme/themes-definition.nix;
  selected = themes.dd;
in
{
  enable = true;
  enableZshIntegration = true;
  settings = builtins.fromJSON (builtins.readFile selected.path);
}
