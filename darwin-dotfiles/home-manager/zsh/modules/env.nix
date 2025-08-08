{ config, ... }:
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

  NIXPKGS_ALLOW_UNFREE = "1";
  NIXPKGS_ALLOW_INSECURE = "1";

  PATH =
    "/opt/homebrew/bin:" +
    "/opt/homebrew/sbin:" +
    "${config.home.homeDirectory}/.tenv/bin:" +
    "${config.home.homeDirectory}/go/bin:" +
    "${config.home.homeDirectory}/.bun/bin:" +
    "${config.home.homeDirectory}/.pyenv/bin:" +
    "${config.home.homeDirectory}/Library/Python/3.9/bin:" +
    "$PATH";
}
