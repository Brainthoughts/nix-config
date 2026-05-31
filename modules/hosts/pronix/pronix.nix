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
    {
      config,
      ...
    }:
    {
      imports = [
        # Include the results of the hardware scan.
        ./_hardware-configuration.nix
        self.nixosModules.base
        self.nixosModules.regreet
        self.nixosModules.hyprland
      ];

      home-manager.users.${config.my.username} = self.homeModules.pronix;

      # so we don't have to spend 30 mins rebuilding the kernel
      nix.settings = {
        extra-substituters = [
          "https://nixos-apple-silicon.cachix.org"
        ];
        extra-trusted-public-keys = [
          "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
        ];
      };

      nixpkgs.overlays = [
        (final: prev: {
          aquamarine = prev.aquamarine.overrideAttrs (old: {
            version =
              assert prev.lib.assertMsg (
                old.version == "0.11.0"
              ) "nixpkgs has updated aquamarine, remove this overlay";
              "0.12.0";
            src = final.fetchFromGitHub {
              owner = "hyprwm";
              repo = "aquamarine";
              tag = "v0.12.0";
              hash = "sha256-TtAhxedbRAl1u6OyT+4eRxZ417G2NMJNoqEbIhjvWo0=";
            };
          });
        })
      ];

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
        vesktop = {
          enable = true;
        };
      };

      wayland.windowManager.hyprland.extraConfig =
        # lua
        ''
          function setDisplay(disabled) 
            return function()
                hl.monitor({
                  output = "eDP-1",
                  mode = "3456x2160@120",
                  position = "0x0",
                  scale = "1.5",
                  disabled = disabled,
                })
              end
          end
          setDisplay(false)()

          -- disable currently bugged, work around
          -- hl.bind("switch:on:Apple SMC power/lid events", setDisplay(true), { locked = true })
          -- hl.bind("switch:off:Apple SMC power/lid events", setDisplay(false), { locked = true })
          hl.bind("switch:on:Apple SMC power/lid events", hl.dsp.dpms({ action = "disable" }), { locked = true })
          hl.bind("switch:off:Apple SMC power/lid events", hl.dsp.dpms({ action = "enable" }), { locked = true })
        '';
    };
}
