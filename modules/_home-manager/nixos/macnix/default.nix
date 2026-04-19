{ pkgs, ... }:
{
  imports = [
    ../default.nix
    # ./hyprland
  ];

  programs.ssh.matchBlocks = {
    "github.com" = {
      identityFile = "~/.ssh/gh";
    };
    "*.tum.de" = {
      identityFile = "~/.ssh/tum";
    };
    "gitlab.lrz.de" = {
      identityFile = "~/.ssh/gh";
    };
  };

}
