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

  ignores = import modules/gitignore.nix;

  extraConfig = {
    init.defaultBranch = user.default-branch;
    pull = {
      ff = false;
      commit = false;
      rebase = true;
    };
    fetch.prune = true;
    push.autoSetupRemote = true;
    delta.line-numbers = true;
  };
}