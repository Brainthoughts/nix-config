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
    discord = {
      enable = true;
    };
    fish = {
      shellAbbrs = {
        nvnix = "nvim ~/.config/nix/**.nix";
        norb = "sudo nixos-rebuild switch --flake ~/.config/nix/";
        norr = "sudo nixos-rebuild switch --flake ~/.config/nix/ --rollback";
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
        "*" = {
          identityAgent = "~/.1password/agent.sock";
        };
      };
    };
  };
  gtk = {
    enable = true;
    colorScheme = "dark";
  };

}
