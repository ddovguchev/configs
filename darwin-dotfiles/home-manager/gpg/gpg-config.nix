{ home, pkgs, ... }: {
  enable = true;
  homedir = "${home.homeDirectory}/.gnupg";
}
