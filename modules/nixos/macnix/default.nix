{ config, pkgs, ... }:

{
  imports = [
    ../default.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "macnix"; # Define your hostname.

  virtualisation.docker = {
    enable = true;
    # seems to hang on restart sometimes
    liveRestore = false;
    daemon.settings = {
      dns = [ "8.8.8.8" ];
    };
  };

  environment.systemPackages = with pkgs; [
    samba
    cifs-utils
    docker-compose # for docker projects
  ];

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    9090
    9999
  ];

  power.ups = {
    enable = true;

    mode = "netserver";
    openFirewall = true;

    ups."ups" = {
      driver = "usbhid-ups";
      port = "auto";
      directives = [
      ];
    };

    upsd = {
      listen = [
        { address = "0.0.0.0"; }
      ];
    };

    upsmon = {
      monitor = {
        "ups" = {
          user = "upsmon";
          type = "primary";
        };
      };
      settings = {
        SHUTDOWNCMD = "“${pkgs.lib.getExe' pkgs.systemd "shutdown"}”";
      };
    };

    users = {
      upsmon = {
        passwordFile = "/etc/ups/upsmon.passwd";
        upsmon = "primary";
      };

      monuser = {
        passwordFile = "/etc/ups/monuser.passwd"; # synology needs this
        upsmon = "secondary";
      };
    };
  };

  # zfs support
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "b86edab7";
  services.zfs.autoScrub.enable = true;

  fileSystems = {
    # don't have a good method for this yet so it will stay manual for now
    # "/mnt/media" = {
    #   device = "silver/media";
    #   fsType = "zfs";
    #   options = [
    #     "nofail" # needed to get past boot as bolt is not avaliable yet
    #     "noauto"
    #     "X-mount.owner=alexn"
    #   ];
    # };
  };

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "macnix";
        "security" = "user";
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

  # thunderbolt
  services.hardware.bolt.enable = true;
}
