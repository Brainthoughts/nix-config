{ self, ... }: {
  flake.nixosModules.vm-base =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      imports = [ self.nixosModules.bare ];

      security.sudo.wheelNeedsPassword = false;

      services.openssh = {
        enable = true;
        hostKeys = [
          {
            path = "/var/lib/ssh-keys/ssh_host_ed25519_key";
            type = "ed25519";
          }
        ];
      };

      fileSystems."/nix/.rw-store" = {
        fsType = "tmpfs";
        options = [
          "mode=0755"
          "size=8G"
        ];
        neededForBoot = true;
      };

      microvm = {
        balloon = lib.mkDefault true;
        writableStoreOverlay = lib.mkDefault "/nix/.rw-store";

        shares = [
          {
            source = "/nix/store";
            mountPoint = "/nix/.ro-store";
            tag = "ro-store";
            proto = "virtiofs";
            readOnly = true;
          }
        ];

        volumes = [
          {
            image = "ssh-keys.img";
            mountPoint = "/var/lib/ssh-keys";
            size = 64;
          }
        ];

        interfaces = lib.mkDefault [
          {
            type = "user";
            id = "qemu-user-net";
            mac = "02:00:00:00:00:01";
          }
        ];
      };
    };
}
