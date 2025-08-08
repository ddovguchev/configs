{ config, lib, pkgs, ... }: {
  enable = true;

  history = {
    size = 10000;
    path = "${config.xdg.dataHome}/zsh/history";
  };

  shellAliases = import modules/aliases.nix;

  initContent = builtins.concatStringsSep "\n" [
    (builtins.readFile scripts/init-extra.sh)
    (builtins.readFile scripts/sdkman-init.sh)
  ];

  oh-my-zsh = {
    enable = true;
    plugins = import modules/oh-my-zsh-plugins.nix;
  };

  sessionVariables = import modules/env.nix { inherit config; };

  plugins = import modules/plugins.nix { inherit pkgs; };
}
