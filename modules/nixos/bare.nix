{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.bare =
    {
      pkgs,
      config,
      lib,
      options,
      ...
    }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
        self.nixosModules.options
      ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        verbose = true;
        backupFileExtension = "bak";
        sharedModules = [
          inputs.nix-index-database.homeModules.nix-index
        ];
      };

      environment.enableAllTerminfo = true;

      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      # Set your time zone.
      time.timeZone = "Europe/Berlin";

      # Select internationalisation properties.
      i18n.defaultLocale = "en_US.UTF-8";

      i18n.extraLocaleSettings = {
        LC_ADDRESS = "de_DE.UTF-8";
        LC_IDENTIFICATION = "de_DE.UTF-8";
        LC_MEASUREMENT = "de_DE.UTF-8";
        LC_MONETARY = "de_DE.UTF-8";
        LC_NAME = "de_DE.UTF-8";
        LC_NUMERIC = "de_DE.UTF-8";
        LC_PAPER = "de_DE.UTF-8";
        LC_TELEPHONE = "de_DE.UTF-8";
        LC_TIME = "de_DE.UTF-8";
      };

      # Configure console keymap
      console.keyMap = "us";

      # Allow unfree packages
      nixpkgs.config = lib.mkIf (!options.nixpkgs.pkgs.isDefined) {
        allowUnfree = true;
      };

      # automatically collect garbage
      nix = {
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
        };
        gc = {
          automatic = true;
          options = "--delete-older-than 7d";
        };
      };

      programs.zsh.enable = true;

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users = {
        defaultUserShell = pkgs.zsh;
        users.${config.my.username} = {
          isNormalUser = true;
          extraGroups = [
            "wheel"
            "kvm"
          ];
        };
      };

      # List packages installed in system profile. To search, run:
      # $ nix search wget
      environment.systemPackages = with pkgs; [
        curl
        neovim
        git
        gcc
        fish
        man-pages
      ];

      virtualisation.docker = {
        enable = true;
      };

      # Enable the OpenSSH daemon.
      services.openssh.enable = true;

      networking.firewall.enable = true;

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "23.11"; # Did you read the comment?
    };
}
