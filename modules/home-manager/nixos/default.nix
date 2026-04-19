{ pkgs, config, ... }:
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
    eduvpn-client
    openvpn

    # Apps
    ghidra
  ];

  programs = {
    fish = {
      shellAbbrs = {
        nvnix = "nvim ~/.config/nix/**.nix";
        norb = "nh os switch ~/.config/nix";
        nort = "nh os test ~/.config/nix";
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
    # silence legacy warnings
    gtk4.theme = config.gtk.theme;
  };

  services.gnome-keyring.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplicationPackages = [ pkgs.zathura ];
  };
}
