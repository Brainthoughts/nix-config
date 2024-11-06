{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        height = 30;
        spacing = 4;

        modules-left = [
          "hyprland/workspaces"
        ];

        modules-center = [
          "hyprland/window"
        ];

        modules-right = [
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "temperature"
          "battery"
          "clock"
          "tray"
        ];

        tray = {
          spacing = 10;
        };

        clock = {
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };

        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };
      };

    };

    style = builtins.readFile ./style.css;
  };
}
