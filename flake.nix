# ~/.config/nix/flake.nix

{
  description = "My system configuration";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
    }:
    let
      hm-common = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.verbose = true;
        home-manager.backupFileExtension = "bak";
      };
    in
    {
      darwinConfigurations = {
        Sweet-16 = nix-darwin.lib.darwinSystem {
          modules = [
            ./modules/darwin
            home-manager.darwinModules.home-manager
            hm-common
            {
              home-manager.users.alexn = ./modules/home-manager/darwin.nix;
            }
          ];
        };
      };
      nixosConfigurations = {
        macnix = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./modules/nixos/macnix
            home-manager.nixosModules.home-manager
            hm-common
            {
              home-manager.users.alexn = ./modules/home-manager/nixos.nix;
            }
          ];
        };
      };
    };
}
