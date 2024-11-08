{ config, pkgs, ... }:

{
  imports = [
    ../default.nix
    ./hardware-configuration.nix

  ];

  networking.hostName = "pronix";

  networking.wireless.iwd = {
    enable = true;
    settings.General.EnableNetworkConfiguration = true;
  };

}
