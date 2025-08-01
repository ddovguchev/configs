{ config, lib, pkgs, ... }: {
  enable = true;

  history = {
    size = 10000;
    path = "${config.xdg.dataHome}/zsh/history";
  };

  shellAliases = import modules/aliases.nix;
  initExtra = builtins.readFile modules/init-extra.sh;

  oh-my-zsh = {
    enable = true;
    plugins = import modules/oh-my-zsh-plugins.nix;
  };

  sessionVariables = import modules/env.nix;
  plugins = import modules/plugins.nix { inherit pkgs; };
}