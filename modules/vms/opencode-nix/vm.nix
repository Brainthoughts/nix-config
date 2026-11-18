{ self, ... }: {
  flake.nixosModules.opencode-vm =
    {
      config,
      ...
    }:
    {
      imports = [ self.inputs.microvm.nixosModules.host ];
      microvm.vms.opencode = {
        config = { pkgs, lib, ... }: {
          imports = [ self.nixosModules.vm-base ];
          networking.hostName = "opencode";

          nixpkgs.overlays = [ self.overlays.opencode-mcp ];

          security.sudo.wheelNeedsPassword = false;

          users.users.${config.my.username} = {
            extraGroups = [ "docker" ];
            openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICgBD3D29Oh5T7vNtbm/JtCeWrfSaMG5v2D0uAqOOK84"
            ];
          };

          home-manager.users.${config.my.username} = self.homeModules.opencode;

          environment.systemPackages = with pkgs; [ opencode ];

          systemd.tmpfiles.rules = [
            "d    /home/${config.my.username}/.local                0755  ${config.my.username} users  -"
            "z    /home/${config.my.username}/.local                0755  ${config.my.username} users  -"

            "d    /home/${config.my.username}/.local/share          0755  ${config.my.username} users  -"
            "z    /home/${config.my.username}/.local/share          0755  ${config.my.username} users  -"

            "d    /home/${config.my.username}/.local/share/opencode 0755  ${config.my.username} users  -"
            "z    /home/${config.my.username}/.local/share/opencode 0755  ${config.my.username} users  -"

            "d    /home/${config.my.username}/.local/share/opencode/mcp-memory 0755  ${config.my.username} users  -"
            "z    /home/${config.my.username}/.local/share/opencode/mcp-memory 0755  ${config.my.username} users  -"
          ];

          # Writable overlay over the read-only workspace share. The host export
          # is mounted read-only at /mnt/ro (staging) and merged here by overlayfs
          # whose upper lives on the persistent /var/overlay volume: projects
          # bind-mounted into the host share appear under /shared/read-only and are
          # writable in-guest (serena config, clangd index, small builds) while the
          # host stays pristine (the share is exported read-only — QEMU -drive
          # read-only=on — and writes land in the upper). The lower is a single
          # virtiofs mount, so host bind-mounts added at runtime show up here
          # transparently. Chromium's CDB deep-path is layered on separately
          # (see the serena skill).
          systemd.services.prepare-rw-overlay = {
            description = "Create workspace overlay upper/work directories";
            requires = [ "var-overlay.mount" ];
            after = [ "var-overlay.mount" ];
            serviceConfig = {
              type = "oneshot";
              umask = "022";
            };
            script = ''
              mkdir -p /var/overlay/upper /var/overlay/work
              chown ${config.my.username}:users /var/overlay/upper
              chmod 0755 /var/overlay/upper
              chmod 0700 /var/overlay/work
            '';
          };

          systemd.mounts.workspace-ro-overlay = {
            # Name the unit exactly as the escaped path so path-based
            # dependencies (RequiresMountsFor=/shared/read-only) resolve to it.
            name = "shared-read\\x2donly.mount";
            description = "Writable overlay of the read-only workspace share";
            what = "overlay";
            where = "/shared/read-only";
            type = "overlay";
            needsDirectories = true;
            options = "lowerdir=/mnt/ro,upperdir=/var/overlay/upper,workdir=/var/overlay/work";
            requires = [
              "mnt-ro.mount"
              "var-overlay.mount"
              "prepare-rw-overlay.service"
            ];
            after = [
              "mnt-ro.mount"
              "var-overlay.mount"
              "prepare-rw-overlay.service"
            ];
            wantedBy = [ "multi-user.target" ];
          };

          # The overlay-upper volume churns (clangd index rebuilds, project
          # resets); QEMU volumes get discard=unmap, so trimming punches holes
          # back into the raw image. Batched fstrim (vs online discard=async)
          # is gentler on the host's btrfs; daily keeps the 48G image from
          # holding onto freed space between resets.
          services.fstrim.interval = "daily";

          microvm = {
            vcpu = 16;
            mem = 1024 * 32; # MB

            volumes = [
              {
                image = "opencode-state.img";
                mountPoint = "/home/${config.my.username}/.local/share/opencode";
                size = 1024 * 16;
              }
              # Persistent upper layer for the read-only-workspace overlay below
              # (autoCreate formats once, so it survives reboots). Holds every
              # project's per-project writes: serena config, clangd index, small
              # builds. Keep it roomy; freed space is returned via TRIM.
              {
                image = "opencode-rw-overlay.img";
                mountPoint = "/var/overlay";
                size = 1024 * 48;
              }
            ];

            shares = [
              {
                # Staging mount for the read-only workspace; overlaid read-write
                # onto /shared/read-only below (see systemd.mounts.workspace-ro-overlay).
                source = "/home/${config.my.username}/opencode/read-only";
                mountPoint = "/mnt/ro";
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
}
