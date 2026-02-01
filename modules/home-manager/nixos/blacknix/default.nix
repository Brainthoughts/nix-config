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
    ssh = {
      matchBlocks = {
        "*" = {
          identityAgent = "~/.1password/agent.sock";
        };
      };
    };
    vesktop = {
      enable = true;
    };
    zathura = {
      enable = true;
      options = {
        default-bg = "#161616";
        completion-group-bg = "#161616";
        statusbar-bg = "#161616";
      };
    };
  };

  wayland.windowManager.hyprland.settings.monitor = [
    "DP-1, 3840x2160@144, 0x0, 1.25"
  ];
}
