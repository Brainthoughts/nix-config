{ pkgs, ... }:
{

  imports = [
    ../default.nix
  ];

  home.packages = with pkgs; [
    # minecraft
    prismlauncher
    zulu25
  ];

  programs = {
    discord = {
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

  wayland.windowManager.hyprland.settings.monitor = [
    "DP-1, 3840x2160@144, 0x0, 1.5"
  ];
}
