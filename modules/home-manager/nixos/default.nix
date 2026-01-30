{ pkgs, ... }:
{

  imports = [
    ../default.nix
    ../hyprland
  ];

  home.packages = with pkgs; [
    # Commands
    brightnessctl
    pamixer

    # Apps
    ghidra
  ];

  programs = {
    fish = {
      shellAbbrs = {
        nvnix = "nvim ~/.config/nix/**.nix";
        norb = "sudo nixos-rebuild switch --flake ~/.config/nix/";
        norr = "sudo nixos-rebuild switch --flake ~/.config/nix/ --rollback";
      };
    };
    ssh = {
      enable = true;
      enableDefaultConfig = false;
    };
  };
  gtk = {
    enable = true;
    colorScheme = "dark";
  };
  xdg.mimeApps = {
    enable = true;
    defaultApplicationPackages = [ pkgs.zathura ];
  };
}
