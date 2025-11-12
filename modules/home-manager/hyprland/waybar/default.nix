{
  config,
  lib,
  pkgs,
  ...
}:

let

  update_interval = 5;
  uwsm_app = app: "${lib.getExe pkgs.uwsm} app -- ${app}";

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
      ""
      ""
      ""
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
          "wireplumber"
          "bluetooth"
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

        wireplumber = {
          scroll-step = 2.5;
          format = "{volume}% ${icons.volume_high}";
          format-muted = "{volume}% ${icons.volume_mute}";
          # open pavucontrol to output tab
          on-click = "${uwsm_app (lib.getExe pkgs.pavucontrol)} -t 3";
        };

        bluetooth = {
          format = "󰂯";
          format-disabled = "󰂲";
          format-connected = "󰂱 {device_alias}";
          format-connected-battery = "󰂱 {device_alias} | {device_battery_percentage}%";
          tooltip = true;
          tooltip-format = "{controller_alias} : {controller_address}\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias} : {device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias} : {device_address} : {device_battery_percentage}%";
          on-click = "${uwsm_app (lib.getExe' pkgs.blueman "blueman-manager")}";
        };

        network = {
          interval = update_interval;
          format-ethernet = "{bandwidthUpBytes} ${icons.arrow_up_left}${icons.arrow_down_right} {bandwidthDownBytes}";
          format-wifi = "{essid} ({signalStrength}%) ${icons.wifi}";
          format-disconnected = "${icons.disconnected}";
          tooltip-format = "{ifname} : {ipaddr} : {cidr}";
        };

        memory = {
          interval = update_interval;
          format = "{percentage}% {icon}";
          format-icons = icons.ram;
          states = {
            notice = 65;
            warning = 80;
            critical = 90;
          };
        };

        cpu = {
          interval = update_interval;
          format = "{usage}% {icon}";
          format-icons = icons.cpu;
          states = {
            notice = 50;
            warning = 80;
            critical = 95;
          };
        };

        temperature = {
          interval = update_interval;
          format = "{temperatureC} {icon}";
          format-icons = icons.thermometer;
          critical-threshold = 80;
        };

        battery = {
          interval = update_interval;
          states = {
            notice = 50;
            warning = 30;
            critical = 10;
          };
          format = "{capacity}% {icon}";
          format-icons = icons.battery;
          tooltip-format = "{power}\n{timeTo}";
        };

        clock = {
          interval = update_interval;
          format = "{:%H:%M}";
          tooltip-format = "{:%a %Y-%m-%d}";
        };
      };
    };
  };
}
