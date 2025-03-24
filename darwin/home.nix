{ config, pkgs, lib, ... }: {
  programs.home-manager.enable = true;

  home.username = "dmitriy";
  home.homeDirectory = "/Users/dmitriy";
  home.stateVersion = "23.11";

  xdg.enable = true;

  programs.tmux = import ./home-manager/tmux.nix { inherit pkgs; };
  programs.zsh = import ./home-manager/zsh.nix { inherit config pkgs lib; };
  programs.fzf = import ./home-manager/fzf.nix { inherit pkgs; };
  programs.oh-my-posh = import ./home-manager/oh-my-posh.nix { inherit pkgs; };

  programs.git = {
    enable = true;
    delta.enable = true;
    userName  = "dovguchev dmitriy";
    userEmail = "dzmitry.douhushau@softnetix.io";
    signing.signByDefault = false;
    ignores = [
      ".idea" ".vs" ".vsc" ".vscode" "node_modules" "npm-debug.log"
      "__pycache__" "*.pyc" ".ipynb_checkpoints" "__sapper__"
      ".DS_Store" "kls_database.db" ".terraform" ".terragrunt-cache"
    ];
    extraConfig = {
      init.defaultBranch = "main";
      pull = {
        ff = "false";
        commit = "false";
        rebase = true;
      };
      fetch.prune = true;
      push.autoSetupRemote = true;
      delta.line-numbers = true;
    };
  };
}