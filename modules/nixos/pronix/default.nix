{ config, pkgs, ... }:

{
  imports = [
    ../default.nix
    ./hardware-configuration.nix

  ];

  networking.hostName = "pronix";
}
