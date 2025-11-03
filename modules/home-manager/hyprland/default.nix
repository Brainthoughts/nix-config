{ pkgs, lib, ... }:
{

  imports = [
    ./waybar
  ];

  home.packages = with pkgs; [
    # Apps
    nautilus
    webcord-vencord
    # Commands
    brightnessctl
    pamixer
  ];

  programs = {
    fish = {
      shellAbbrs = {
        nvnix = "nvim ~/.config/nix/**.nix";
        norb = "sudo nixos-rebuild switch --flake ~/.config/nix/";
      };
    };
    # TODO: consider hyprlauncher when it matures
    fuzzel = {
      enable = true;
      settings = {
        main = {
          font = "Hack";
          terminal = "${lib.getExe pkgs.kitty}";
          launch-prefix = "${lib.getExe pkgs.uwsm} app --";
        };
        colors = {
          background = "#161616ff";
          text = "#f2f4f8ff";
          prompt = "#535353ff";
          placeholder = "#282828ff";
          input = "#f2f4f8ff";
          match = "#78a9ffff";
          selection = "#484848ff";
          selection-text = "#f2f4f8ff";
          selection-match = "#78a9ffff";
          border = "#be95ffff";
        };
        border = {
          width = 2;
        };
      };
    };
    hyprlock = {
      enable = true;
      # settings = {
      #   general = {
      #     hide_cursor = true;
      #     ignore_empty_input = true;
      #   };
      # };
    };
    # TODO: check for lossless
    # https://github.com/aome510/spotify-player/issues/829
    # https://github.com/librespot-org/librespot/issues/1583
    spotify-player = {
      enable = true;
    };
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "github.com" = {
          identityFile = "~/.ssh/gh";
        };
        "*.tum.de" = {
          identityFile = "~/.ssh/tum";
        };
        "gitlab.lrz.de" = {
          identityFile = "~/.ssh/tum";
        };
      };
    };

  };

  services = {
    # hyprpaper = {
    #   enable = true;
    # };
    mako = {
      enable = true;
      settings = {
        font = "Hack";

        background-color = "#161616";
        text-color = "#f2f4f8";
        border-color = "#be95ff";
        progress-color = "#78a9ff";

        border-radius = "10";
        default-timeout = 5000;
      };
    };
  };

  wayland.windowManager.hyprland =
    let
      mainMod = "SUPER";
      uwsmApp = "${lib.getExe pkgs.uwsm} app --";
    in
    {
      enable = true;
      settings = {
        monitor = [
          "eDP-1, 3456x2160@60, 0x0, 2"
          "HDMI-A-1, 3840x2160@60, 1728x-1080, 1.5"
        ];
        # mouse
        bindm = [
          "${mainMod}, mouse:272, movewindow"
        ];
        # repeat when held
        binde = [
          ", XF86MonBrightnessUp, exec, ${lib.getExe pkgs.brightnessctl} s +5%"
          ", XF86MonBrightnessDown, exec, ${lib.getExe pkgs.brightnessctl} s 5%-"
          ", XF86AudioRaiseVolume, exec, ${lib.getExe pkgs.pamixer} -i 3"
          ", XF86AudioLowerVolume, exec, ${lib.getExe pkgs.pamixer} -d 3"
          ", XF86AudioMute, exec, ${lib.getExe pkgs.pamixer} -t"
        ];
        # on long press
        bindo = [
          "${mainMod}, Q, exec, uwsm stop"
          "${mainMod} SHIFT, Q, exit"
          "${mainMod}, D, killwindow, active"
        ];
        # once on key tap
        bind = [
          ", XF86AudioPrev, exec, ${lib.getExe pkgs.playerctl} previous"
          ", XF86AudioPlay, exec, ${lib.getExe pkgs.playerctl} play-pause"
          ", XF86AudioNext, exec, ${lib.getExe pkgs.playerctl} next"
          "${mainMod}, B, exec, ${uwsmApp} ${lib.getExe pkgs.firefox}"
          "${mainMod}, X, exec, ${uwsmApp} ${lib.getExe pkgs.kitty}"
          "${mainMod}, F, exec, ${uwsmApp} ${lib.getExe pkgs.nautilus}"
          "${mainMod}, SPACE, exec, ${uwsmApp} ${lib.getExe pkgs.fuzzel}"
          "${mainMod}, D, closewindow, active"
          "${mainMod}, M, togglefloating, active"
          "${mainMod}, N, workspace, m+1"
          "${mainMod}, P, workspace, m-1"
          "${mainMod}, C, workspace, emptym"
          "${mainMod}, Z, workspace, previous_per_monitor"
          "${mainMod}, H, movefocus, l"
          "${mainMod}, J, movefocus, d"
          "${mainMod}, K, movefocus, u"
          "${mainMod}, L, movefocus, r"
          "${mainMod} SHIFT, H, movewindow, l"
          "${mainMod} SHIFT, J, movewindow, d"
          "${mainMod} SHIFT, K, movewindow, u"
          "${mainMod} SHIFT, L, movewindow, r"
          "${mainMod}, `, togglespecialworkspace, magic"
          "${mainMod}, Escape, exec, ${lib.getExe pkgs.hyprlock}"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (
            builtins.genList (
              i:
              let
                ws = i + 1;
              in
              [
                "${mainMod}, code:1${toString i}, workspace, ${toString ws}"
                "${mainMod} SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            ) 9
          )
        );
        gesture = [ "3, horizontal, workspace" ];
        general = {
          border_size = 2;
          "col.active_border" = "rgba(be95ffee) rgba(78a9ffee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";
          resize_on_border = true;
          gaps_in = 5;
          gaps_out = 10;
        };
        decoration = {
          rounding = 10;
          inactive_opacity = 0.9;
          shadow = {
            enabled = false;
          };
        };
        animation = [
          "windows, 1, 8, default, popin"
        ];
        input = {
          follow_mouse = 2;
          touchpad = {
            tap-to-click = false;
            clickfinger_behavior = true;
            natural_scroll = true;
          };
        };
        gestures = {
          workspace_swipe_distance = 200;
        };
        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          background_color = lib.fromHexString "0x161616";
        };
      };
    };

  services = {
    hypridle = {
      enable = true;
      settings = {
        general = {
          before_sleep_cmd = "hyprlock";
        };
      };
    };
    playerctld = {
      enable = true;
    };
  };

}
