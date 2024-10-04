{
  description = "Hika";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    polymc.url = "github:PolyMC/PolyMC";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, nixos-hardware, home-manager, ... }@inputs:

  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {
        pkgs-stable = import nixpkgs-stable {
          inherit system;
          config.allowUnfree = true;
        };
        inherit inputs system nixos-hardware;
      };
      modules = [
        ./configuration.nix
        ./hardware-configuration.nix
        inputs.nixos-hardware.nixosModules.apple-t2
      ];
    };

    homeConfigurations.amper = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = [ ./home-manager/home.nix ];
    };
  };
}