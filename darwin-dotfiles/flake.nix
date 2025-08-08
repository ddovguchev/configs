{
  description = "MacOS Configuration with nix-darwin and Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nix-darwin, nixpkgs, home-manager, ... } @ inputs:
    let
      username = "dzmitriy";
      hostname = "dzmitriys-MacBook-Pro";
      system = "aarch64-darwin";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.warnUndeclaredOptions = false;
      };

      lib = pkgs.lib;

      darwinConfig = import ./darwin/init-darwin-configuration.nix {
        inherit pkgs lib username system;
        config = { };
      };

      homeConfig = import ./home-manager/init-home-configuration.nix;
    in
    {
      darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
        system = system;
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
