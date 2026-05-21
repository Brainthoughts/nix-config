{
  self,
  inputs,
  ...
}:
let
  system = "aarch64-linux";
in
{
  systems = [ system ];

  flake.nixosConfigurations.pronix = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      inputs.nixos-apple-silicon.nixosModules.default
      self.nixosModules.pronix
    ];
  };

  flake.nixosModules.pronix =
    { config, ... }:
    {
      imports = [
        # Include the results of the hardware scan.
        ./_hardware-configuration.nix
        self.nixosModules.base
        self.nixosModules.regreet
        self.nixosModules.hyprland
      ];

      home-manager.users.${config.my.username} = self.homeModules.pronix;

      # nixpkgs.overlays = [
      #   (final: prev: {
      #     vimPlugins = prev.vimPlugins.extend (
      #       final': prev': {
      #         neotest = (
      #           prev'.neotest.overrideAttrs (old: {
      #             doCheck = false;
      #           })
      #         );
      #       }
      #     );
      #   })
      # ];

      # Use the systemd-boot EFI boot loader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = false;

      networking.hostName = "pronix"; # Define your hostname.

      # TODO: don't include in git
      hardware.asahi.peripheralFirmwareDirectory = ./_firmware;

      fileSystems = {
        "/".options = [
          "compress=zstd"
          "noatime"
        ];
        "/nix".options = [
          "compress=zstd"
          "noatime"
        ];
      };

      services.tlp.enable = true;
      services.upower.enable = true;

      programs = {
        _1password.enable = true;
        _1password-gui = {
          enable = true;
          polkitPolicyOwners = [ config.my.username ];
        };
      };

      # TODO: integrate with hyprland
      services.logind = {
        settings = {
          Login = {
            HandlePowerKey = "suspend";
            HandleLidSwitch = "suspend";
            HandleLidSwitchExternalPower = "ignore";
          };
        };
      };
    };

  flake.homeModules.pronix =
    { pkgs, ... }:
    {
      imports = [
        self.homeModules.nixos
      ];

      home.packages = with pkgs; [
        gramps
      ];

      programs = {
        ssh = {
          matchBlocks = {
            "*" = {
              identityAgent = "~/.1password/agent.sock";
            };
          };
        };
        vesktop = {
          enable = true;
        };
      };

      wayland.windowManager.hyprland.extraConfig =
        # lua
        ''
          hl.monitor({
            output = "eDP-1",
            mode = "3456x2160@120",
            position = "0x0",
            scale = 1.5,
          })

          hl.bind("switch:on:Apple SMC power/lid events", hl.dsp.exec_cmd("hyprctl keyword monitor \"eDP-1, disable\""), { locked = true })
          hl.bind("switch:off:Apple SMC power/lid events", hl.dsp.exec_cmd("hyprctl keyword monitor \"eDP-1, 3456x2160@120, 0x0, 1.5\""), { locked = true })
        '';
    };
}
