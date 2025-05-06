{ pkgs, ... }:
{

  imports = [
    ./default.nix
    ./waybar
  ];

  home.packages = with pkgs; [
    # Apps
    discord
    # Commands
  ];

  programs = {
    fish = {
      shellAbbrs = {
        nvnix = "nvim ~/.config/nix/**.nix";
        norb = "sudo nixos-rebuild switch --flake ~/.config/nix/";
      };
    };
    kitty = {
      settings = {
        # window_margin_width = 3;
        # macos_option_as_alt = "yes";
        # hide_window_decorations = "titlebar-only";
        # macos_show_window_title_in = "menubar";
        # macos_colorspace = "default";
      };
    };
    ssh = {
      enable = true;
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
    };
  };

  wayland.windowManager.hyprland =
    let
      mainMod = "SUPER";
    in
    {
      enable = true;
      settings = {
        exec-once = [
          "waybar"
        ];
        bind =
          [
            "${mainMod}, F, exec, ${pkgs.firefox}/bin/firefox"
            "${mainMod}, X, exec, ${pkgs.kitty}/bin/kitty"
            "${mainMod}, C, closewindow, activewindow"
            "${mainMod}, H, movefocus, l"
            "${mainMod}, J, movefocus, d"
            "${mainMod}, K, movefocus, u"
            "${mainMod}, L, movefocus, r"
            "${mainMod} SHIFT, H, movewindow, l"
            "${mainMod} SHIFT, J, movewindow, d"
            "${mainMod} SHIFT, K, movewindow, u"
            "${mainMod} SHIFT, L, movewindow, r"
            "${mainMod}, Escape, togglespecialworkspace, magic"
            "${mainMod}, Q, exit"
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
        general = {
          border_size = 2;
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";
          resize_on_border = true;
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
        };
      };
    };
}
