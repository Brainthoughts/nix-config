{
  flake.nixosModules.options =
    { lib, pkgs, ... }:
    {
      options.my = {
        username = lib.mkOption {
          type = lib.types.str;
          default = "user";
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
