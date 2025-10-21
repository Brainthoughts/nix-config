{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../default.nix
    ];

  nixpkgs.overlays = [
    ( final: prev: {
        vimPlugins = prev.vimPlugins.extend (
	  final': prev': {
	    neotest = (
	      prev'.neotest.overrideAttrs ( old: {
	        doCheck = false;
	      }
	    )
	  );
        }
      );
    }
    )
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "pronix"; # Define your hostname.

  hardware.asahi.peripheralFirmwareDirectory = ./firmware;

  fileSystems = {
    "/".options = [ "compress=zstd" "noatime" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
  };   
}

