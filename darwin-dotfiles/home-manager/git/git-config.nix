{ config, pkgs, lib, ... }:

let
  users = import modules/git-users.nix;
  user = users.dzmitry;
in
{
  enable = true;
  delta.enable = true;

  userName = user.name;
  userEmail = user.email;

  signing = {
    key = null;
    signByDefault = false;
  };

  ignores = [
    ".idea"
    ".vs"
    ".vsc"
    ".vscode"
    "node_modules"
    "npm-debug.log"
    "__pycache__"
    "*.pyc"
    ".ipynb_checkpoints"
    "__sapper__"
    ".DS_Store"
    "kls_database.db"
    ".terraform"
    ".terragrunt-cache"
  ];

  extraConfig = {
    init.defaultBranch = user.default-branch;
    pull = {
      ff = false;
      commit = false;
      rebase = true;
    };
    rebase = {
      abbreviateCommands = true;
    };
    fetch.prune = true;
    push.autoSetupRemote = true;
    delta.line-numbers = true;
  };
}
