{
  self,
  inputs,
  ...
}:
let
  system = "aarch64-darwin";
in
{
  systems = [ system ];

  flake.darwinConfigurations.Sweet-16 = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      self.darwinModules.Sweet-16
    ];
  };

  flake.darwinModules.Sweet-16 =
    { config, ... }:
    {
      imports = [ self.darwinModules.base ];

      home-manager.users.${config.my.username} = self.homeModules.Sweet-16;
    };

  flake.homeModules.Sweet-16 = {
    imports = [
      self.homeModules.base
      self.homeModules.darwin
    ];
  };

}
