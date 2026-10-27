{ self, ... }: {
  flake.nixosModules.opencode-vm =
    {
      config,
      ...
    }:
    {
      imports = [ self.inputs.microvm.nixosModules.host ];

      microvm = {
        autostart = [ "opencode" ];
        vms.opencode = {
          config = { pkgs, lib, ... }: {
            imports = [ self.nixosModules.base ];
            networking.hostName = "opencode";

            security.sudo.wheelNeedsPassword = false;
            networking.firewall.enable = lib.mkForce false;
            nixpkgs.config = lib.mkForce { }; # already configured
            nix.optimise.automatic = lib.mkForce false;
            environment.enableAllTerminfo = true;

            users.users.${config.my.username} = {
              extraGroups = [ "docker" ];
              openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICgBD3D29Oh5T7vNtbm/JtCeWrfSaMG5v2D0uAqOOK84"
              ];
            };

            home-manager.users.${config.my.username} = self.homeModules.opencode;

            services.openssh = {
              enable = true;
              hostKeys = [
                {
                  path = "/var/lib/ssh-keys/ssh_host_ed25519_key";
                  type = "ed25519";
                }
              ];
            };

            environment.systemPackages = with pkgs; [ opencode ];

            systemd.tmpfiles.rules = [
              "d    /home/${config.my.username}/.local                0755  ${config.my.username} users  -"
              "z    /home/${config.my.username}/.local                0755  ${config.my.username} users  -"

              "d    /home/${config.my.username}/.local/share          0755  ${config.my.username} users  -"
              "z    /home/${config.my.username}/.local/share          0755  ${config.my.username} users  -"

              "d    /home/${config.my.username}/.local/share/opencode 0755  ${config.my.username} users  -"
              "z    /home/${config.my.username}/.local/share/opencode 0755  ${config.my.username} users  -"
            ];

            microvm = {
              hypervisor = "qemu";
              vcpu = 16;
              mem = 1024 * 16; # MB
              balloon = true;

              writableStoreOverlay = "/nix/.rw-store";
              volumes = [
                {
                  image = "nix-store-overlay.img";
                  mountPoint = "/nix/.rw-store";
                  size = 1024 * 16;
                }
                {
                  image = "ssh-keys.img";
                  mountPoint = "/var/lib/ssh-keys";
                  size = 64;
                }
                {
                  image = "opencode-state.img";
                  mountPoint = "/home/${config.my.username}/.local/share/opencode";
                  size = 1024 * 16;
                }
              ];

              shares = [
                {
                  source = "/home/${config.my.username}/opencode/read-only";
                  mountPoint = "/shared/read-only";
                  tag = "workspace-ro";
                  proto = "virtiofs";
                  readOnly = true;
                }
                {
                  source = "/home/${config.my.username}/opencode/writable";
                  mountPoint = "/shared/writable";
                  tag = "workspace";
                  proto = "virtiofs";
                  posixAcl = false;
                  extraArgs = [
                    "--translate-uid"
                    "squash-guest:0:1000:4294967295"

                    "--translate-gid"
                    "squash-guest:0:100:4294967295"
                  ];
                }
              ];

              interfaces = [
                {
                  type = "user";
                  id = "qemu-user-net";
                  mac = "02:00:00:00:00:01";
                }
              ];

              forwardPorts = [
                {
                  from = "host";
                  host.port = 3333;
                  guest.port = 22;
                }
              ];
            };
          };
        };
      };
    };
}
