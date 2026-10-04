{
  self,
  ...
}:
{
  flake.homeModules.zathura =
    {
      pkgs,
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
      xdg.mimeApps.defaultApplicationPackages = [ config.programs.zathura.package ];
    };
}
