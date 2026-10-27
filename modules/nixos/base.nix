{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.base =
    {
      pkgs,
      config,
      ...
    }:
    {
      imports = [
        self.nixosModules.bare
      ];

      # Enable networking
      networking.wireless.iwd = {
        enable = true;
        settings.General.EnableNetworkConfiguration = true;
      };

      networking.networkmanager = {
        enable = true;
        wifi.backend = "iwd";
      };

      networking.wireguard.enable = true;
      networking.networkmanager.plugins = with pkgs; [ networkmanager-openvpn ];

      # bluetooth
      hardware.bluetooth.enable = true;
      hardware.bluetooth.powerOnBoot = true;
      services.blueman.enable = true;

      # Enable CUPS to print documents.
      services.printing.enable = true;

      # real-time scheduling for user processes
      # used by pipewire
      security.rtkit.enable = true;

      # Enable sound with pipewire.
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        raopOpenFirewall = true;
      };

      services.tailscale.enable = true;

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users = {
        users.${config.my.username} = {
          extraGroups = [
            "networkmanager"
            "dialout"
          ];
          packages = with pkgs; [
          ];
        };
      };

      fonts = {
        packages = with pkgs; [
          config.my.nerd-font.package
        ];
      };

      services.earlyoom = {
        enable = true;
        freeMemThreshold = 5;
        freeSwapThreshold = 100; # otherwise zram causes problems (probably)
        freeSwapKillThreshold = 100;
      };

      zramSwap = {
        enable = true;
        memoryPercent = 100; # godspeed earlyoom
      };
    };

  flake.homeModules.nixos =

    { pkgs, config, ... }:
    {
      imports = [ self.homeModules.base ];

      home.packages = with pkgs; [
        # Commands
        # Apps
      ];

      programs = {
        ssh = {
          enable = true;
          enableDefaultConfig = false;
        };
        zsh.enable = true;
      };
    };
}
