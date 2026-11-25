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
          #
          # fileSystems (not systemd.mounts): the mountpoint is auto-created and
          # `depends` orders it after the staging share and the upper volume by
          # path, instead of hardcoding microvm's generated unit names. This is
          # how microvm builds its own store overlay.
          fileSystems."/shared/read-only" = {
            fsType = "overlay";
            overlay = {
              lowerdir = [ "/mnt/ro" ];
              upperdir = "/var/overlay/upper";
              workdir = "/var/overlay/work";
            };
            depends = [
              "/mnt/ro"
              "/var/overlay"
            ];
          };

          # Expose the same writable overlay under the literal ~/Projects path.
          # The host bind-mounts a project into the export at a path that mirrors
          # ~/Projects/..., so it then appears here at the *exact* absolute path
          # the project's compile_commands.json / clangd index were generated with.
          # This must be a bind, not a symlink: clangd canonicalizes paths with
          # realpath(), and a symlink would resolve away from ~/Projects/... and
          # break CDB/index matching, whereas a bind keeps the path canonical.
          # Writable: edits and index writes land in the overlay upper, host
          # untouched. (Caveat: writing a new clangd index shard into an existing
          # lower .cache/clangd dir copy-ups that dir to the upper.)
          fileSystems."/home/${config.my.username}/Projects" = {
            device = "/shared/read-only";
            fsType = "none";
            options = [ "bind" ];
            depends = [ "/shared/read-only" ];
          };

          # overlayfs needs upper/work to already exist on the volume; the user
          # owns upper so they can create new top-level entries in the merged view.
          # DefaultDependencies=false keeps this a low-level unit: as a normal
          # service it is After=basic.target, which (with it Before the overlay
          # mount, a local-fs.target mount) closes a boot ordering cycle
          # overlay->prep->basic->...->local-fs->overlay. Same trick as NixOS
          # swap.nix ("needed to prevent a cycle").
          systemd.services.prepare-rw-overlay = {
            description = "Create workspace overlay upper/work + persistence directories";
            unitConfig.DefaultDependencies = false;
            unitConfig.RequiresMountsFor = "/var/overlay";
            requiredBy = [ "shared-read\\x2donly.mount" ];
            before = [ "shared-read\\x2donly.mount" ];
            serviceConfig = {
              Type = "oneshot";
              UMask = "0022";
            };
            script = ''
              mkdir -p /var/overlay/upper /var/overlay/work /var/overlay/persist/zoxide
              chown ${config.my.username}:users /var/overlay/upper /var/overlay/persist /var/overlay/persist/zoxide
              chmod 0755 /var/overlay/upper /var/overlay/persist /var/overlay/persist/zoxide
              chmod 0700 /var/overlay/work
            '';
          };

          # Persistence on the overlay volume: bind a tool's default data path
          # onto a reusable /var/overlay/persist dir so it survives rebuilds and
          # reboots (the tmpfs root wipes everything under ~ otherwise). This is
          # transparent — the tool still sees its normal path, no env needed.
          # Source dirs are created by prepare-rw-overlay before these bind; add
          # a dir there plus a bind here for any other cache worth persisting.
          systemd.mounts = [
            {
              what = "/var/overlay/persist/zoxide";
              where = "/home/${config.my.username}/.local/share/zoxide";
              type = "none";
              options = "bind";
              requires = [
                "var-overlay.mount"
                "prepare-rw-overlay.service"
              ];
              after = [
                "var-overlay.mount"
                "prepare-rw-overlay.service"
              ];
              wantedBy = [ "local-fs.target" ];
            }
          ];

          # The overlay-upper volume churns (clangd index rebuilds, project
          # resets); QEMU volumes get discard=unmap, so trimming punches holes
          # back into the raw image. Batched fstrim (vs online discard=async)
          # is gentler on the host's btrfs; daily keeps the 48G image from
          # holding onto freed space between resets.
          services.fstrim.interval = "daily";

          microvm = {
            vcpu = 16;
            mem = 1024 * 32; # MB

            virtiofsd.extraArgs = [ "--no-announce-submounts" ];

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
