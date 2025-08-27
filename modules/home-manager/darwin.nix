{
  pkgs,
  lib,
  options,
  ...
}:
{
  imports = [
    ./default.nix
    ./sketchybar
  ];

  home.packages = with pkgs; [
    # Apps
    raycast
    iina
    prismlauncher
    # Commands
    zulu17
    nmap
    ffmpeg
    ghidra
  ];

  programs = {
    aerospace = {
      enable = true;
      launchd = {
        enable = true;
      };
      userSettings = {
        gaps = {
          outer = {
            left = 12;
            right = 12;
            top = 12;
            bottom = 12;
          };
          inner = {
            horizontal = 12;
            vertical = 12;
          };
        };
        mode.main.binding =
          let
            spaces = builtins.genList (x: x + 1) 9;
            meta = "alt-ctrl-shift";
          in
          builtins.listToAttrs (
            builtins.map (n: {
              name = "${meta}-${builtins.toString n}";
              value = "workspace ${builtins.toString n}";
            }) spaces
          )
          // builtins.listToAttrs (
            builtins.map (n: {
              name = "${meta}-cmd-${builtins.toString n}";
              value = "move-node-to-workspace ${builtins.toString n} --focus-follows-window";
            }) spaces
          )
          // {
            "${meta}-tab" = "workspace-back-and-forth";
            "${meta}-a" = "workspace prev";
            "${meta}-d" = "workspace next";
            "${meta}-cmd-a" = "move-node-to-workspace prev --focus-follows-window";
            "${meta}-cmd-d" = "move-node-to-workspace next --focus-follows-window";
          };
      };
    };
    fish = {
      shellAbbrs = {
        nvnix = "nvim ~/.config/nix/**.nix";
        ndrb = "sudo darwin-rebuild switch --flake ~/.config/nix";
      };
    };
    kitty = {
      settings = {
        window_margin_width = 3;
        macos_option_as_alt = "yes";
        hide_window_decorations = "titlebar-only";
        macos_show_window_title_in = "menubar";
        macos_colorspace = "default";
      };
    };
  };

  services = {
    jankyborders = {
      enable = true;
      settings = {
        hidpi = "on";
      };
    };
  };
}
