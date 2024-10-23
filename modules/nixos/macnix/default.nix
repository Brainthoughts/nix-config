{ config, pkgs, ... }:

{
  imports = [
    ../default.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "macnix"; # Define your hostname.

  virtualisation.docker.enable = true;

  environment.systemPackages = [
    pkgs.cifs-utils
    pkgs.docker-compose # for docker projects
  ];

  # mount synologynas
  fileSystems = {
    "/mnt/entertainment" = {
      device = "synologynas.fritz.box:/volume1/entertainment";
      fsType = "nfs";
      options = [
        "nfsvers=4.1"
        "x-systemd.automount"
        "noauto"
        "x-systemd.idle-timeout=600"
      ];
    };
  };

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "macnix";
        # "netbios name" = "smbnix";
        "security" = "user";
        #"use sendfile" = "yes";
        #"max protocol" = "smb2";
        # note: localhost is the ipv6 localhost ::1
        # "hosts allow" = "192.168.188. 127.0.0.1 localhost";
        # "hosts deny" = "0.0.0.0/0";
        # "guest account" = "nobody";
        # "map to guest" = "bad user";
      };
      "TUM" = {
        "path" = "/home/alexn/TUM";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "alexn";
      };
    };
  };
}
