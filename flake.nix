# ~/.config/nix/flake.nix

{
  description = "My system configuration";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
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
    {
      darwinConfigurations = {
        Sweet-16 = nix-darwin.lib.darwinSystem {
          modules = [
            ./modules/darwin
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.verbose = true;
              home-manager.users.alexn.imports = [
                ./modules/home-manager/default.nix
                ./modules/home-manager/darwin.nix
              ];
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
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.verbose = true;
              home-manager.backupFileExtension = "bak";
              home-manager.users.alexn.imports = [
                ./modules/home-manager/default.nix
                ./modules/home-manager/nixos.nix
                ./modules/home-manager/nvim
              ];
            }
          ];
        };
      };
    };
}
