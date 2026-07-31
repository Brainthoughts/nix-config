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
        self.homeModules.firefox
        self.homeModules.kitty
        self.homeModules.zathura
      ];

      programs = {
        mpv.enable = true;
        vesktop.enable = true;
      };
    };
}
