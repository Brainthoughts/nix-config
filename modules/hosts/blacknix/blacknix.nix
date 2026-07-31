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
      };

      programs.btop.package = pkgs.btop-rocm;
    };
}
