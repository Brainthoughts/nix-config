{
  self,
  ...
}:
{
  flake.homeModules.zathura =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      programs.zathura = {
        enable = true;
        options = {
          default-bg = "#161616";
          completion-group-bg = "#161616";
          statusbar-bg = "#161616";
        };
      };
      xdg.mimeApps.defaultApplicationPackages = [ pkgs.zathura ];
    };
}
