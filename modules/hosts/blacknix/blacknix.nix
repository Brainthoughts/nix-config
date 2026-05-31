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

  flake.nixosConfigurations.blacknix = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      self.nixosModules.blacknix
    ];
  };

  flake.nixosModules.blacknix =
    { pkgs, config, ... }:
    {
      imports = [
        ./_hardware-configuration.nix
        self.nixosModules.base
        self.nixosModules.regreet
        self.nixosModules.hyprland
      ];

      home-manager.users.${config.my.username} = self.homeModules.blacknix;

      networking.hostName = "blacknix";

      # bluetooth has a stroke otherwise
      boot.kernelParams = [ "btusb.enable_autosuspend=0" ];

      hardware.amdgpu = {
        initrd.enable = true;
        opencl.enable = true;
        # overdrive.enable = true;
      };

      programs = {
        _1password.enable = true;
        _1password-gui = {
          enable = true;
          polkitPolicyOwners = [ config.my.username ];
        };
        gamemode.enable = true;
        steam = {
          enable = true;
          remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
          dedicatedServer.openFirewall = true; # Open ports for Source Dedicated Server hosting
        };
      };

      nixpkgs.overlays = [
        (final: prev: {
          openrgb = prev.openrgb.overrideAttrs (old: {
            version =
              assert prev.lib.assertMsg (
                old.version == "1.0rc2"
              ) "nixpkgs has updated OpenRGB, remove this overlay";
              "pipeline-2026-5-31";
            src = final.fetchFromGitLab {
              owner = "CalcProgrammer1";
              repo = "OpenRGB";
              rev = "8afad91b33f5fc61f632fe67b6ca98fe2299613d";
              hash = "sha256-A/zp8XTtwBJtof2UTrxA2zc87biQ4eXAImWjWHWapik=";
            };
            patches = [
              (builtins.elemAt old.patches 0)
            ];
          });
        })
      ];

      services = {
        hardware = {
          # thunderbolt
          bolt.enable = true;
          openrgb = {
            enable = true;
            package = pkgs.openrgb-with-all-plugins;
            startupProfile = "main";
          };
        };
      };

      virtualisation.docker = {
        enable = true;
        # seems to hang on restart sometimes
        liveRestore = false;
        daemon.settings = {
          dns = [ "8.8.8.8" ];
        };
      };
    };

  flake.homeModules.blacknix =
    { pkgs, ... }:
    {
      imports = [
        self.homeModules.nixos
      ];

      home.packages = with pkgs; [
        # music
        tidal-hifi
        # minecraft
        prismlauncher
        zulu25
      ];

      programs = {
        vesktop = {
          enable = true;
        };
        zathura = {
          enable = true;
          options = {
            default-bg = "#161616";
            completion-group-bg = "#161616";
            statusbar-bg = "#161616";
          };
        };
      };

      programs.btop.package = pkgs.btop-rocm;
    };
}
