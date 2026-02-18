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
    gcr

    # Apps
    ghidra
  ];

  programs = {
    fish = {
      shellAbbrs = {
        nvnix = "nvim ~/.config/nix/**.nix";
        norb = "nh os switch ~/.config/nix";
        norr = "nh os rollback";
      };
    };
    nh = {
      enable = true;
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

  services.gnome-keyring.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplicationPackages = [ pkgs.zathura ];
  };
}
