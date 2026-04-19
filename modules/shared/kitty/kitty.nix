{
  flake.homeModules.kitty =
    { pkgs, ... }:
    {
      programms.kitty = {
        enable = true;
        font = {
          name = "Hack Nerd Font Mono";
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
