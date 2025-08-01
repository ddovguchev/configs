{ config, ... }: {
  programs.zsh = {
    enable = true;

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

#    shellAliases = import ./modules/aliases.nix {inherit ;};
#    initExtra = ./modules/init-extra.nix;

    oh-my-zsh = {
      enable = true;
      plugins = import ./modules/oh-my-zsh-plugins.nix {inherit ;};
    };

#    sessionVariables = import ./modules/env.nix {inherit ;};
  };
}