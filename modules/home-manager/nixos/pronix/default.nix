{ pkgs, ... }:
{

  imports = [
    ../default.nix
  ];

  programs = {
    ssh = {
      matchBlocks = {
        "*" = {
          identityAgent = "~/.1password/agent.sock";
        };
      };
    };
  };

  wayland.windowManager.hyprland.settings.monitor = [
    "eDP-1, 3456x2160@60, 0x0, 1.5"
  ];

  wayland.windowManager.hyprland.settings.bindl =
    # even when locked
    [
      ", switch:on:Apple SMC power/lid events, exec, hyprctl keyword monitor \"eDP-1, disable\""
      ", switch:off:Apple SMC power/lid events, exec, hyprctl keyword monitor \"eDP-1, 3456x2160@60, 0x0, 2\""
    ];
}
