{
  self,
  inputs,
  ...
}:
let
  system = "x86_64-linux";
in
{
  systems = [ system ];

  flake.nixosConfigurations.anywhere = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      self.nixosModules.anywhere
    ];
  };

  flake.nixosModules.anywhere =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      imports = [
        ./_hardware-configuration.nix
        self.nixosModules.base
        self.nixosModules.anywhere-diskio
      ];

      boot.loader.systemd-boot.enable = lib.mkForce false;
      boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
      boot.loader.grub = {
        enable = true;
        # no need to set devices, disko will add all devices that have a EF02 partition to the list already
        # devices = [ ];
        efiSupport = true;
        efiInstallAsRemovable = true;
      };

      home-manager.users.${config.my.username} = self.homeModules.anywhere;

      networking.hostName = "anywhere";

      users.users.${config.my.username}.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKJ9X1RHVF5zmN5X2kEmCoFQMeFpKzu0AlAORaKxRmgq"
      ];
    };

  flake.homeModules.anywhere =
    { pkgs, ... }:
    {
      imports = [
        self.homeModules.nixos
      ];
    };

  flake.nixosModules.anywhere-diskio =
    { lib, ... }:
    {
      imports = [ inputs.disko.nixosModules.disko ];

      disko.devices = {
        disk.disk1 = {
          device = lib.mkDefault "/dev/sda";
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              boot = {
                name = "boot";
                size = "1M";
                type = "EF02";
              };
              esp = {
                name = "ESP";
                size = "500M";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                };
              };
              root = {
                name = "root";
                size = "100%";
                content = {
                  type = "lvm_pv";
                  vg = "pool";
                };
              };
            };
          };
        };
        lvm_vg = {
          pool = {
            type = "lvm_vg";
            lvs = {
              root = {
                size = "100%FREE";
                content = {
                  type = "filesystem";
                  format = "ext4";
                  mountpoint = "/";
                  mountOptions = [
                    "defaults"
                  ];
                };
              };
            };
          };
        };
      };
    };
}
