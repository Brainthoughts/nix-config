{
  flake.homeModules.kitty =
    {
      pkgs,
      lib,
      osConfig,
      ...
    }:
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
          auto_reload_config =
            assert lib.assertMsg (pkgs.kitty.version == "0.47.1") "kitty patched inotify";
            -1;
        };
      };

      xdg.terminal-exec = {
        enable = true;
        settings = {
          default = [ "kitty.desktop" ];
        };
      };
    };
}
