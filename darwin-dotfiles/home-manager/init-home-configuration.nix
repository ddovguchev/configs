{ config, pkgs, lib, ... }: {
  programs.home-manager.enable = true;

  home.username = "dmitriy";
  home.homeDirectory = "/Users/dmitriy";
  xdg.enable = true;

  home.file.".zshrc".force = true;
  home.stateVersion = "23.11";

  programs = {
    tmux = import ./tmux.nix { inherit pkgs; };
    zsh = import ./zsh/zsh-config.nix { inherit config pkgs lib; };
    fzf = import ./fzf.nix { inherit pkgs; };
    k9s = import ./k9s.nix { inherit pkgs; };
    oh-my-posh = import ./oh-my-posh.nix { inherit pkgs; };
    git = import ./git.nix { inherit config pkgs lib; };
  };
}