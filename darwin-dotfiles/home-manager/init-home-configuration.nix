{ config, pkgs, lib, ... }: {
  programs.home-manager.enable = true;

  home.username = "dzmitriy";
  home.homeDirectory = "/Users/dzmitriy";
  xdg.enable = true;

  home.stateVersion = "23.11";

  programs = {
    zsh = import zsh/zsh-config.nix { inherit config lib pkgs; };
    oh-my-posh = import zsh/oh-my-posh.nix { inherit pkgs; };
    git = import git/git-config.nix { inherit config pkgs lib; };
    k9s = import k9s/k9s-config.nix { inherit pkgs; };
    ranger = import ./ranger/ranger-config.nix { inherit pkgs lib; };

    tmux = import ./tmux.nix { inherit pkgs; };
    fzf = import ./fzf.nix { inherit pkgs; };
    gpg = import ./gpg.nix {
      inherit pkgs;
      home = config.home;
    };
  };

#  imports = [
#    ./yabai/yabai.nix
#    ./skhd/skhd.nix
#  ];
}
