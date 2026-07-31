{
  self,
  ...
}:
{
  flake.homeModules.apps =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      imports = [
        self.homeModules.zathura
        self.homeModules.kitty
      ];
    };
}
