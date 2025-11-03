{
  config,
  lib,
  pkgs,
  ...
}:

let

  update_interval = 5;
  colors = {
    white = "#f8f8f2";
    black = "#ffffff";

    red = "#dd532e";
    orange = "#ff9977";
    yellow = "#fcfc53";
    green = "#69ff94";
    blue = "#2aa9ff";
  };

  common_icon_colorscheme = icon: [
    "<span color='${colors.white}'>${icon}</span>"
    "<span color='${colors.white}'>${icon}</span>"
    "<span color='${colors.blue}'>${icon}</span>"
    "<span color='${colors.blue}'>${icon}</span>"
    "<span color='${colors.green}'>${icon}</span>"
    "<span color='${colors.green}'>${icon}</span>"
    "<span color='${colors.yellow}'>${icon}</span>"
    "<span color='${colors.yellow}'>${icon}</span>"
    "<span color='${colors.orange}'>${icon}</span>"
    "<span color='${colors.red}'>${icon}</span>"
  ];

  icons = builtins.fromJSON (builtins.readFile ./icons.json);
in
{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        # height = 30;
        spacing = 0; # deal with this in css
        position = "bottom";

        modules-left = [
          "hyprland/workspaces"
        ];

        modules-center = [
          "hyprland/window"
        ];

        modules-right = [
          "pulseaudio"
          # "bluetooth"
          "network"
          "memory"
          "cpu"
          "temperature"
        ]
        # TODO: only include on devices with battery
        ++ lib.lists.optional (true) "battery"
        ++ [
          "clock"
        ];

        pulseaudio = {
          scroll-step = 2.5;
          format = "{volume}% ${icons.volume_high}";
          format-muted = "{volume}% ${icons.volume_mute}";
        };

        bluetooth = {

        };

        battery = {
          interval = update_interval;
          states = {
            warning = 30;
            critical = 10;
          };
          format = "{capacity}% {icon}";
          format-icons = icons.battery;
          tooltip-format = "{power}\n{timeTo}";
        };

        network = {
          interval = update_interval;
          format-ethernet = "{bandwidthUpBytes} ${icons.arrow_up_left}${icons.arrow_down_right} {bandwidthDownBytes}";
          format-wifi = "{essid} ({signalStrength}%) ${icons.wifi}";
          format-disconnected = "<span color='${colors.yellow}'>${icons.disconnected}</span>";
          tooltip-format = "{ifname} : {ipaddr} : {cidr}";
        };

        memory = {
          interval = update_interval;
          format = "{percentage}% {icon}";
          format-icons = common_icon_colorscheme icons.ram;
        };

        cpu = {
          interval = update_interval;
          format = "{usage}% {icon}";
          format-icons = common_icon_colorscheme icons.cpu;
        };

        temperature = {
          interval = update_interval;
          format = "{temperatureC} {icon}";
          format-icons = common_icon_colorscheme icons.thermometer;
        };

        clock = {
          interval = update_interval;
          format = "{:%H:%M}";
        };

      };

    };

    style = ./style.css;
  };
}
