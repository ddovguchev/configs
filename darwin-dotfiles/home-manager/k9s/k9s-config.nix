{ pkgs, ... }: {
  enable = true;

  settings.k9s = {
    ui = {
      headless = false;
      logoless = true;
      noIcons = true;
      skin = "catppuccin-mocha";
    };
    skipLatestRevCheck = true;
  };

  skins = {
    catppuccin-mocha = theme/k9s-catppuccin-mocha.yaml;
  };

  plugins = import modules/k9s-plugin.nix { inherit pkgs; };
}
