{ pkgs, ... }: {

  environment = {
    systemPath = [ "/opt/homebrew/bin" ];
  };
  fonts = {
    fontDir.enable = true;
    fonts = [ (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];
  };

  homebrew = {
    enable = true;
    taps = [ "koekeishiya/formulae" ];
    brews = [ "yabai" ];
    casks = [ ];
  };

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  nixpkgs = {
  # The platform the configuration will be used on.
  # If you're on an Intel system, replace with "x86_64-darwin"
    hostPlatform = "aarch64-darwin";
    config = {
        allowUnfree = true;
      };
    };

  programs.zsh.enable = true;
  programs.fish.enable = true;

  services.nix-daemon.enable = true;

  # Used for backwards compatibility. please read the changelog
  # before changing: `darwin-rebuild changelog`.
  system.stateVersion = 4;

  # Declare the user that will be running `nix-darwin`.
  users.users.alexn = {
    name = "alexn";
    home = "/Users/alexn";
  };

}

