{ inputs, ... }:
{
  flake.nixosModules.home-manager = {
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.verbose = true;
    home-manager.backupFileExtension = "bak";
    home-manager.sharedModules = [
      inputs.nix-index-database.homeModules.nix-index
    ];
  };
}
