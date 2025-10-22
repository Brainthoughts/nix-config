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
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-treesitter-main = {
      url = "github:iofq/nvim-treesitter-main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      nix-index-database,
      nvim-treesitter-main,
      nixos-apple-silicon,
    }:
    let
      hm-common = {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          verbose = true;
          backupFileExtension = "bak";
          sharedModules = [
            nix-index-database.homeModules.nix-index
          ];
        };
      };
      ts-main-overlay = {
        nixpkgs.overlays = [
          nvim-treesitter-main.overlays.default
        ];
      };
    in
    {
      darwinConfigurations = {
        Sweet-16 = nix-darwin.lib.darwinSystem {
          modules = [
            ts-main-overlay
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
            ts-main-overlay
            ./modules/nixos/macnix
            home-manager.nixosModules.home-manager
            hm-common
            {
              home-manager.users.alexn = ./modules/home-manager/nixos.nix;
            }
          ];
        };
        pronix = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = [
            nixos-apple-silicon.nixosModules.default
            ts-main-overlay
            ./modules/nixos/pronix
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
