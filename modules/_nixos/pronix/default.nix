{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../default.nix
  ];

  nixpkgs.overlays = [
    (final: prev: {
      vimPlugins = prev.vimPlugins.extend (
        final': prev': {
          neotest = (
            prev'.neotest.overrideAttrs (old: {
              doCheck = false;
            })
          );
        }
      );
    })
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  networking.hostName = "pronix"; # Define your hostname.

  # TODO: don't include in git
  hardware.asahi.peripheralFirmwareDirectory = ./firmware;

  fileSystems = {
    "/".options = [
      "compress=zstd"
      "noatime"
    ];
    "/nix".options = [
      "compress=zstd"
      "noatime"
    ];
  };

  services.tlp.enable = true;
  services.upower.enable = true;

  programs = {
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "alexn" ];
    };
  };

  # TODO: integrate with hyprland
  services.logind = {
    settings = {
      Login = {
        HandlePowerKey = "suspend";
        HandleLidSwitch = "suspend";
        HandleLidSwitchExternalPower = "ignore";
      };
    };
  };
}
