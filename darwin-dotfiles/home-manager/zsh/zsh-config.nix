{ config, lib, ... }: {
  enable = true;

  history = {
    size = 10000;
    path = "${config.xdg.dataHome}/zsh/history";
  };

  shellAliases = import ./modules/aliases.nix;
  initExtra = builtins.readFile ./modules/init-extra.sh;

  oh-my-zsh = {
    enable = true;
    theme = "awesomepanda";
    custom = "${config.home.homeDirectory}/.config/zsh/awesomepanda.zsh-theme";
    plugins = import ./modules/oh-my-zsh-plugins.nix;
  };

  sessionVariables = import ./modules/env.nix;
  plugins = import ./modules/plugins.nix;
}