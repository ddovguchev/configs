{
  imports = [
    ./zsh.nix
    ./modules/bundle.nix
  ];

  home = {
    username = "hika";
    homeDirectory = "/home/hika";
    stateVersion = "24.11";
  };
}