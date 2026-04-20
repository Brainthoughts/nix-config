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

  config.flake.darwinModules.options =
    { lib, pkgs, ... }:
    {
      options.my = {
        username = lib.mkOption {
          type = lib.types.str;
          default = "alexn";
          description = "The username of your user";
        };
        nerd-font = {
          name = lib.mkOption {
            type = lib.types.str;
            default = "Hack Nerd Font Mono";
            description = "The name of your preferred nerd font";
          };
          package = lib.mkOption {
            type = lib.types.package;
            default = pkgs.nerd-fonts.hack;
            description = "The package containing your nerd font";
          };
        };
      };
    };
}
