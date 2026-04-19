{
  description = "My system configuration";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
    import-tree = {
      url = "github:vic/import-tree";
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
    nixos-apple-silicon = {
      url = "github:nix-community/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      flake-parts,
      import-tree,
      nix-darwin,
      home-manager,
      nix-index-database,
      nixos-apple-silicon,
    }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      top@{
        self,
        config,
        withSystem,
        moduleWithSystem,
        ...
      }:
      (import-tree ./modules)
      // {
        flake =
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
                    home-manager.users.alexn = ./modules/home-manager/nixos/macnix;
                  }
                ];
              };
              pronix = nixpkgs.lib.nixosSystem {
                system = "aarch64-linux";
                modules = [
                  nixos-apple-silicon.nixosModules.default
                  ./modules/nixos/pronix
                  home-manager.nixosModules.home-manager
                  hm-common
                  {
                    home-manager.users.alexn = ./modules/home-manager/nixos/pronix;
                  }
                ];
              };
            };
          };
      }
    );
}
