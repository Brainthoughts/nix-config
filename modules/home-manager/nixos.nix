{ pkgs, ... }:
{

  imports = [
    ./default.nix
    ./hyprland
  ];

  home.packages = with pkgs; [
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

}
