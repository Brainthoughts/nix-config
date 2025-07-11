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
        SHUTDOWNCMD = "“${pkgs.systemd}/bin/shutdown”";
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

  # mount synologynas
  fileSystems = {
    "/mnt/entertainment" = {
      device = "//synologynas.fritz.box/entertainment";
      fsType = "cifs";
      options =
        let
          # this line prevents hanging on network split
          automount_opts = "x-systemd.automount,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";
        in
        [ "${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,posixpaths" ];
    };
    "/mnt/silver" = {
      device = "/dev/md/silver";
      options = [
        "nofail" # needed to get past boot as bolt is not avaliable yet
        "X-mount.owner=alexn"
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

  # raid support
  boot.swraid = {
    enable = true;
    mdadmConf = "MAILADDR none";
  };
}
