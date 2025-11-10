{
  config,
  lib,
  pkgs,
  ...
}:

let

  update_interval = 5;
  uwsm_app = app: "${lib.getExe pkgs.uwsm} app -- ${app}";

  divContentWithClass = class: icon: "<div class=\"${class}\">${icon}</div>";
  inactive = divContentWithClass "inactive";
  info = divContentWithClass "info";
  notice = divContentWithClass "notice";
  warn = divContentWithClass "warn";
  critical = divContentWithClass "critical";

  icons = {
    volume_high = "";
    volume_mute = "";
    arrow_up_left = "󱞽";
    arrow_down_right = "󱞣";
    disconnected = "󰌙";
    wifi = "";
    ram = "";
    cpu = "";
    thermometer = [
      ""
      ""
      (notice "")
      (warn "")
      (critical "")
    ];
    battery = [
      ""
      ""
      ""
      ""
      ""
    ];
  };
in
{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      # enableInspect = true;
    };
    style = ./style.css;
    settings = {
      mainBar = {

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
          # open pavucontrol to output tab
          on-click = "${uwsm_app (lib.getExe pkgs.pavucontrol)} -t 3";
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
          format-disconnected = "${warn icons.disconnected}";
          tooltip-format = "{ifname} : {ipaddr} : {cidr}";
        };

        memory = {
          interval = update_interval;
          format = "{percentage}% {icon}";
          format-icons = icons.ram;
        };

        cpu = {
          interval = update_interval;
          format = "{usage}% {icon}";
          format-icons = icons.cpu;
        };

        temperature = {
          interval = update_interval;
          format = "{temperatureC} {icon}";
          format-icons = icons.thermometer;
        };

        clock = {
          interval = update_interval;
          format = "{:%H:%M}";
        };
      };
    };
  };
}
