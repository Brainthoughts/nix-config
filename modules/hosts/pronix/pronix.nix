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
        self.homeModules.base
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

      wayland.windowManager.hyprland.settings.monitor = [
        "eDP-1, 3456x2160@60, 0x0, 1.5"
      ];

      wayland.windowManager.hyprland.settings.bindl =
        # even when locked
        [
          ", switch:on:Apple SMC power/lid events, exec, hyprctl keyword monitor \"eDP-1, disable\""
          ", switch:off:Apple SMC power/lid events, exec, hyprctl keyword monitor \"eDP-1, 3456x2160@60, 0x0, 1.5\""
        ];
    };
}
