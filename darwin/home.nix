{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.home-manager.enable = true;

  home.username = "dmitriy";
  home.homeDirectory = "/Users/dmitriy";
  xdg.enable = true;

  home.stateVersion = "23.11";

  programs = {
    tmux = import ./home-manager/tmux.nix { inherit pkgs; };
    zsh = import ./home-manager/zsh.nix { inherit config pkgs lib; };
    zoxide = (import ./home-manager/zoxide.nix { inherit config pkgs; });
    fzf = import ./home-manager/fzf.nix { inherit pkgs; };
    oh-my-posh = import ./home-manager/oh-my-posh.nix { inherit pkgs; };
  };
}