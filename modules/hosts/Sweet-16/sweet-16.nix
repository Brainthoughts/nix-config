{ self, inputs, ... }:
{
  flake.darwinConfigurations.Sweet-16 = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      self.darwinModules.Sweet-16
    ];
  };

  flake.darwinModules.Sweet-16 = {
    imports = [ self.darwinModules.base ];

    home-manager.users.alexn = self.homeModules.Sweet-16;
  };

  flake.homeModules.Sweet-16 = {
    imports = [
      self.homeModules.base
      self.homeModules.darwin
    ];
  };

}
