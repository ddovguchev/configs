{
  description = "MacOS Configuration with nix-darwin and Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nix-darwin, nixpkgs, home-manager, ... } @ inputs: let
    username = "dmitriy";
    hostname = "Dovguchevs-MacBook-Pro";
    system = "aarch64-darwin";

    darwinConfig = import ./darwin/1darwin-configuration.nix;
    homeConfig = import ./home-manager/1home-configuration.nix;
  in {
    darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
      modules = [
        darwinConfig
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = homeConfig;
        }
      ];
    };
  };
}