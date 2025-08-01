{
  EDITOR = "vim";
  ZSH_DISABLE_COMPFIX = "true";
  BUN_INSTALL = "$HOME/.bun";
  PATH = "$HOME/go/bin:$HOME/.bun/bin:$PATH";
  SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
  GPG_TTY = "$TTY";
}