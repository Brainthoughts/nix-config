{ pkgs, ... }:
{

  home.packages = with pkgs; [
    # Apps
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
      };
    };
  };

  wayland.windowManager.hyprland =
    let
      mainMod = "SUPER";
    in
    {
      enable = true;
      settings = {
        bind =
          [
            "${mainMod}, F, exec, ${pkgs.firefox}/bin/firefox"
            "${mainMod}, X, exec, ${pkgs.kitty}/bin/kitty"
            "${mainMod}, C, killactive"
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
      };
    };
}
