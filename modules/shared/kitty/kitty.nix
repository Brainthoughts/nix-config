{
  flake.homeModules.kitty =
    { pkgs, osConfig, ... }:
    {
      programs.kitty = {
        enable = true;
        font = {
          name = osConfig.my.nerd-font.name;
          size = 14;
        };
        settings = {
          tab_bar_align = "center";
          include = "${pkgs.writeText "carbonfox.conf" (builtins.readFile ./_/themes/carbonfox.conf)}";
          window_alert_on_bell = false;
        };
      };
    };
}
