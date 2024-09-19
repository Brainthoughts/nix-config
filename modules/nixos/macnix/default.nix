{ config, pkgs, ... }:

{
  imports = [
    ../default.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "macnix"; # Define your hostname.

  virtualisation.docker.enable = true;

  environment.systemPackages = [
    pkgs.docker-compose # for docker projects
  ];

  # mount synologynas
  fileSystems = {
    "/mnt/entertainment" = {
      device = "//synologynas/entertainment";
      fsType = "cifs";
      options =
        let
          # this line prevents hanging on network split
          automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,uid=1000";
        in
        [ "${automount_opts},credentials=/etc/nixos/smb-secrets" ];
    };
  };
}
