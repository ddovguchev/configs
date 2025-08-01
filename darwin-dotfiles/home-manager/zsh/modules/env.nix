{ config, pkgs, ... }:
{
  EDITOR = "vim";
  ZSH_DISABLE_COMPFIX = "true";
  BUN_INSTALL = "${config.home.homeDirectory}/.bun";
  SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
  GPG_TTY = "$TTY";

  NVM_DIR = "${config.home.homeDirectory}/.nvm";
  GNUPGHOME = "${config.home.homeDirectory}/.gnupg";
  PYENV_ROOT = "${config.home.homeDirectory}/.pyenv";
  SDKMAN_DIR = "${config.home.homeDirectory}/.sdkman";

  PATH =
    "/opt/homebrew/bin:" +
    "${config.home.homeDirectory}/.tenv/bin:" +
    "${config.home.homeDirectory}/go/bin:" +
    "${config.home.homeDirectory}/.bun/bin:" +
    "${config.home.homeDirectory}/.pyenv/bin:" +
    "$PATH";
}