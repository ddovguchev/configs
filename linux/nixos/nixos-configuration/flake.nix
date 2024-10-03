{
  description = "Hika";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, home-manager, ... }@inputs:

    let
      system = "x86_64-linux";
    in {

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {
          pkgs-stable = import nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
          };
          inherit inputs system;
        };

        imports = [
          ./bundel.nix
          ./hardware-configuration.nix
        ];

        networking.hostName = "nixos";
        time.timeZone = "Europe/Minsk";
        i18n.defaultLocale = "en_US.UTF-8";

        nix.settings.experimental-features = [ "nix-command" "flakes" ];
        system.stateVersion = "24.05";

        modules = [
          # inputs.nixvim.nixosModules.nixvim  # Раскомментируйте, если нужно
        ];
      };

      homeConfigurations.amper = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [ ./home-manager/home.nix ];
      };
    };
}