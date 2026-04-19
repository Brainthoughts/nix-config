{ lib, ... }:
{

  # Teach flake-parts how to merge flake.darwinModules
  options.flake.darwinModules = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.unspecified;
    default = { };
    description = "Reusable nix-darwin modules";
  };

  # Teach flake-parts how to merge flake.darwinConfigurations
  options.flake.darwinConfigurations = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.unspecified;
    default = { };
    description = "nix-darwin host configurations";
  };

}
