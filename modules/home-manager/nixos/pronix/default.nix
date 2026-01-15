{ pkgs, ... }:
{

  imports = [
    ../default.nix
  ];

  wayland.windowManager.hyprland.settings.monitor = [
    "eDP-1, 3456x2160@60, 0x0, 2"
    "HDMI-A-1, 3840x2160@60, 1728x-1080, 1.5"
  ];

  wayland.windowManager.hyprland.settings.bindl =
    # even when locked
    [
      ", switch:on:Apple SMC power/lid events, exec, hyprctl keyword monitor \"eDP-1, disable\""
      ", switch:off:Apple SMC power/lid events, exec, hyprctl keyword monitor \"eDP-1, 3456x2160@60, 0x0, 2\""
    ];
}
