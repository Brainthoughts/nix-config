{ self, inputs, ... }:
{

  flake.nixosConfigurations.blacknix = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.blacknix
    ];
  };

  flake.nixosModules.blacknix =
    { pkgs, ... }:
    {
      imports = [
        ./_hardware-configuration.nix
        self.nixosModules.base
      ];

      home-manager.users.alexn = self.homeModules.blacknix;

      networking.hostName = "blacknix"; # Define your hostname.

      boot.kernelPackages = pkgs.linuxPackages_latest;

      # bluetooth has a stroke otherwise
      boot.kernelParams = [ "btusb.enable_autosuspend=0" ];

      environment.systemPackages = with pkgs; [
        docker-compose # for docker projects
      ];

      # Open ports in the firewall.
      networking.firewall.allowedTCPPorts = [
      ];

      hardware.amdgpu = {
        initrd.enable = true;
        opencl.enable = true;
        # overdrive.enable = true;
      };

      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };

      programs = {
        _1password.enable = true;
        _1password-gui = {
          enable = true;
          polkitPolicyOwners = [ "alexn" ];
        };
        gamemode.enable = true;
        steam = {
          enable = true; # Master switch, already covered in installation
          remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
          dedicatedServer.openFirewall = true; # Open ports for Source Dedicated Server hosting
          # Other general flags if available can be set here.
        };
      };

      nixpkgs.overlays = [
        (final: prev: {
          openrgb = prev.openrgb.overrideAttrs (old: {
            version =
              assert prev.lib.assertMsg (
                old.version == "1.0rc2"
              ) "nixpkgs has updated OpenRGB, remove this overlay";
              "pipeline-2025-01-21"; # Use current date or commit hash
            src = final.fetchFromGitLab {
              owner = "CalcProgrammer1";
              repo = "OpenRGB";
              rev = "e48908573a1f67943912591dcfb121d4bc79b0e8";
              hash = "sha256-TOtUUl+fmkHN4FWgr2FjraDtfASNE0XLaKZXCYj2/t4="; # Set to correct hash
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
        self.homeModules.base
        self.homeModules.nixos
        self.homeModules.hyprland
      ];

      home.packages = with pkgs; [
        # music
        tidal-hifi
        # minecraft
        prismlauncher
        zulu25
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

      wayland.windowManager.hyprland.settings.monitor = [
        "DP-1, 3840x2160@144, 0x0, 1"
      ];
    };
}
