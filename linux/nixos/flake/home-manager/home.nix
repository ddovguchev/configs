{
  imports = [
    ./modules/bundle.nix
    ./bin/bundle.nix
  ];

  home = {
    username = "hika";
    homeDirectory = "/home/hika";
    stateVersion = "24.11";
  };
}