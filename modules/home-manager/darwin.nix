{ pkgs, ... }:
{
  imports = [
    ./default.nix
  ];

  home.packages = with pkgs; [
    # Apps
    raycast
    spotify
    # soundsource # outdated, doesn't work on macos 15
    iina
    prismlauncher
    # Commands
    zulu17
    nmap
    ffmpeg
  ];

  programs = {
    aerospace = {
      enable = true;
      userSettings = {
        start-at-login = true;
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
          in
          builtins.listToAttrs (
            builtins.map (n: {
              name = "alt-${builtins.toString n}";
              value = "workspace ${builtins.toString n}";
            }) spaces
          )
          // builtins.listToAttrs (
            builtins.map (n: {
              name = "alt-shift-${builtins.toString n}";
              value = "move-node-to-workspace ${builtins.toString n}";
            }) spaces
          )
          // {
            alt-tab = "workspace-back-and-forth";
          };
      };
    };
    fish = {
      shellAbbrs = {
        nvnix = "nvim ~/.config/nix/**.nix";
        ndrb = "darwin-rebuild switch --flake ~/.config/nix";
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
    };
  };
}
