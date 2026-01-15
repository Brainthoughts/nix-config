{ config, pkgs, ... }:

{
  imports = [
    ../default.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "blacknix"; # Define your hostname.

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # bluetooth has a stroke otherwise
  boot.kernelParams = [ "btusb.enable_autosuspend=0" ];

  environment.systemPackages = with pkgs; [
    docker-compose # for docker projects
  ];

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
  ];

  hardware.amdgpu = {
    initrd.enable = true;
    opencl.enable = true;
    # overdrive.enable = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs = {
    _1password.enable = true;
    _1password-gui = {
      enable = true;
      polkitPolicyOwners = [ "alexn" ];
    };
    gamemode.enable = true;
    steam = {
      enable = true; # Master switch, already covered in installation
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports for Source Dedicated Server hosting
      # Other general flags if available can be set here.
    };
  };

  # thunderbolt
  services.hardware = {
    bolt.enable = true;
    openrgb.enable = true;
  };

  virtualisation.docker = {
    enable = true;
    # seems to hang on restart sometimes
    liveRestore = false;
    daemon.settings = {
      dns = [ "8.8.8.8" ];
    };
  };
}
