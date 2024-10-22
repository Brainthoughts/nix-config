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
}
