{ self, ... }:
{

  flake.nixosModules.hyprland =
    { config, ... }:
    {
      programs.hyprland = {
        enable = true;
        withUWSM = true;
      };
      programs.hyprlock.enable = true;

      home-manager.users.${config.my.username}.imports = [ self.homeModules.hyprland ];

    };

  flake.homeModules.hyprland =
    {
      pkgs,
      lib,
      osConfig,
      ...
    }:
    {

      imports = [
        ./_/waybar
        self.homeModules.kitty
      ];

      home.packages = with pkgs; [
        # Apps
        nautilus
        pavucontrol
        libreoffice-fresh
        # Commands
        brightnessctl
        pamixer
      ];

      home.pointerCursor = {
        enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 20;
        hyprcursor = {
          enable = true;
        };
      };

      programs = {
        # TODO: consider hyprlauncher when it matures
        fuzzel = {
          enable = true;
          settings = {
            main = {
              font = osConfig.my.nerd-font.name;
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
      };

      services = {
        # hyprpaper = {
        #   enable = true;
        # };
        hyprpolkitagent = {
          enable = true;
        };
        mako = {
          enable = true;
          settings = {
            font = osConfig.my.nerd-font.name;

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
          screenShotFolder = "~/Documents/Screenshots";
        in
        {
          enable = true;
          configType = "lua";
          systemd.enable = false;
          extraConfig =
            # lua
            ''
              -- mouse
              hl.bind("${mainMod} + mouse:272", hl.dsp.window.drag(), { mouse = true })

              -- repeat
              hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("${lib.getExe pkgs.brightnessctl} s +5%"), { repeating = true })
              hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("${lib.getExe pkgs.brightnessctl} s 5%-"), { repeating = true })
              hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("${lib.getExe pkgs.pamixer} -i 3"), { repeating = true })
              hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("${lib.getExe pkgs.pamixer} -d 3"), { repeating = true })
              hl.bind("XF86AudioMute", hl.dsp.exec_cmd("${lib.getExe pkgs.pamixer} -t"), { repeating = true })

              -- hold
              hl.bind("${mainMod} + Q", hl.dsp.exec_cmd("${lib.getExe pkgs.uwsm} stop"), {long_press = true})
              hl.bind("${mainMod} + SHIFT + Q", hl.dsp.exec_cmd("${lib.getExe pkgs.uwsm} exit"), {long_press = true})
              hl.bind("${mainMod} + D", hl.dsp.window.kill(), {long_press = true})

              -- single
              hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("${lib.getExe pkgs.playerctl} previous"))
              hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("${lib.getExe pkgs.playerctl} play-pause"))
              hl.bind("XF86AudioNext", hl.dsp.exec_cmd("${lib.getExe pkgs.playerctl} next"))

              hl.bind("${mainMod} + backslash", hl.dsp.exec_cmd("${lib.getExe pkgs.hyprshot} -o ${screenShotFolder} -m region"))
              hl.bind("${mainMod} + SHIFT + backslash", hl.dsp.exec_cmd("${lib.getExe pkgs.hyprshot} -o ${screenShotFolder} -m window"))
              hl.bind("${mainMod} + CTRL + backslash", hl.dsp.exec_cmd("${lib.getExe pkgs.hyprshot} -o ${screenShotFolder} -m region --clipboard-only"))
              hl.bind("${mainMod} + CTRL + SHIFT + backslash", hl.dsp.exec_cmd("${lib.getExe pkgs.hyprshot} -o ${screenShotFolder} -m window --clipboard-only"))
              hl.bind("${mainMod} + period", hl.dsp.exec_cmd("${lib.getExe pkgs.hyprpicker} -a"))

              hl.bind("${mainMod} + B", hl.dsp.exec_cmd("${uwsmApp} ${lib.getExe pkgs.firefox}"))
              hl.bind("${mainMod} + X", hl.dsp.exec_cmd("${uwsmApp} ${lib.getExe pkgs.kitty}"))
              hl.bind("${mainMod} + F", hl.dsp.exec_cmd("${uwsmApp} ${lib.getExe pkgs.nautilus}"))

              hl.bind("${mainMod} + space", hl.dsp.exec_cmd("${uwsmApp} ${lib.getExe pkgs.fuzzel}"))

              hl.bind("${mainMod} + D", hl.dsp.window.close())
              hl.bind("${mainMod} + M", hl.dsp.window.float())
              hl.bind("${mainMod} + A", hl.dsp.window.fullscreen({"maximized", "toggle"}))
              hl.bind("${mainMod} + SHIFT + A", hl.dsp.window.fullscreen({"fullscreen", "toggle"}))

              hl.bind("${mainMod} + N", hl.dsp.focus({ workspace = "m+1" }))
              hl.bind("${mainMod} + P", hl.dsp.focus({ workspace = "m-1" }))
              hl.bind("${mainMod} + C", hl.dsp.focus({ workspace = "emptym" }))
              hl.bind("${mainMod} + Z", hl.dsp.focus({ workspace = "previous_per_monitor" }))

              hl.bind("${mainMod} + H", hl.dsp.focus({ direction = "l" }))
              hl.bind("${mainMod} + L", hl.dsp.focus({ direction = "r" }))
              hl.bind("${mainMod} + J", hl.dsp.focus({ direction = "d" }))
              hl.bind("${mainMod} + K", hl.dsp.focus({ direction = "u" }))
              hl.bind("${mainMod} + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
              hl.bind("${mainMod} + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
              hl.bind("${mainMod} + SHIFT + J", hl.dsp.window.move({ direction = "d" }))
              hl.bind("${mainMod} + SHIFT + K", hl.dsp.window.move({ direction = "u" }))

              for i = 0,9,1 do 
                hl.bind("${mainMod} + code:1" .. i, hl.dsp.focus({ workspace = i+1 }))
                hl.bind("${mainMod} + SHIFT + code:1" .. i, hl.dsp.window.move({ workspace = i+1, true }))
              end

              hl.bind("${mainMod} + grave", hl.dsp.workspace.toggle_special("magic"))
              hl.bind("${mainMod} + SHIFT + grave", hl.dsp.window.move({ workspace = "special:magic", true}))

              hl.bind("${mainMod} + Escape", hl.dsp.exec_cmd("${lib.getExe pkgs.hyprlock}"))

              -- device specific input settings
              hl.device(
                {
                  name = "logitech-g903-ls-1",
                  sensitivity = -0.6,
                }
              )

              hl.config({
                gesture = { 
                  "3, horizontal, workspace",
                },

                -- window rules
                windowrule = {
                  "match:float true, border_color rgb(33b1ff)",
                  "match:modal true, border_color rgb(be95ff)",
                  "match:fullscreen true, border_color rgb(ee5396)",
                },

                -- variables
                general = {
                  border_size = 1,
                  ["col.active_border"] = "rgb(78a9ff)",
                  ["col.inactive_border"] = "rgba(53535380)",
                  resize_on_border = true,
                  gaps_in = 4,
                  gaps_out = 8,
                },
                binds = {
                  hide_special_on_workspace_change = true,
                },
                decoration = {
                  rounding = 10,
                  inactive_opacity = 0.9,
                  shadow = {
                    enabled = false,
                  }
                },
                animation = {
                  "windows, 1, 8, default, popin",
                },
                input = {
                  -- keyboard, altgr for umlaut
                  kb_options = "lv3:ralt_switch",
                  kb_variant = "altgr-intl",
                  follow_mouse = 2,
                  touchpad = {
                    tap_to_click = false,
                    clickfinger_behavior = true,
                    natural_scroll = true,
                  }
                },
                gestures = {
                  workspace_swipe_distance = 200,
                },
                misc = {
                  disable_hyprland_logo = true,
                  disable_splash_rendering = true,
                  background_color = "#161616",
                  focus_on_activate = true,
                },
              })
            '';
        };

      services = {
        hypridle = {
          enable = true;
          settings = {
            general = {
              lock_cmd = "pidof hyprlock || hyprlock";
              before_sleep_cmd = "loginctl lock-session";
              after_sleep_cmd = "hyprlctl dispatch dpms on";
            };
            listener = [
              {
                timeout = 60 * 10;
                on-timeout = "${pkgs.lib.getExe pkgs.libnotify} \"Display going to sleep soon...\"";
              }
              {
                timeout = 60 * 14;
                on-timeout = "${pkgs.lib.getExe pkgs.libnotify} \"Display going to sleep very soon...\"";
              }
              {
                timeout = 60 * 15;
                on-timeout = "hyprctl dispatch dpms off && loginctl lock-session";
                on-resume = "hyprctl dispatch dpms on";
              }
            ];
          };
        };
        playerctld = {
          enable = true;
        };
      };

    };
}
