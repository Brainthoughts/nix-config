{ config, pkgs, ... }:

{
  imports = [
    ../default.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "blacknix"; # Define your hostname.

  boot.kernelPackages = pkgs.linuxPackages_latest;

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

  # thunderbolt
  services.hardware.bolt.enable = true;

  virtualisation.docker = {
    enable = true;
    # seems to hang on restart sometimes
    liveRestore = false;
    daemon.settings = {
      dns = [ "8.8.8.8" ];
    };
  };
}
