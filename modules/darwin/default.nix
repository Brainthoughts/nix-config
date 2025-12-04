{ pkgs, ... }:
{

  environment = {
    systemPath = [ "/opt/homebrew/bin" ];
  };

  fonts = {
    packages = with pkgs; [
      nerd-fonts.hack
    ];
  };

  # needed temporarily while migration to multi-user support ongoing
  system.primaryUser = "alexn";

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = false;
    };
    taps = [
    ];
    brews = [
      "sqlite" # needed for nvim yanky, doesn't accept nix version
    ];
    casks = [
      "lulu" # not on nixpkgs
      "knockknock" # not on nixpkgs
      "crossover"
      "anki" # broken on nixpkgs
      "font-sf-pro"
      "font-sf-mono"
      "sf-symbols"
    ];
  };

  # automatically collect garbage
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };

  # newer version wants 30000, cant read from stateVersion that it should be 350 for some reason
  ids.gids.nixbld = 350;

  nixpkgs = {
    # The platform the configuration will be used on.
    # If you're on an Intel system, replace with "x86_64-darwin"
    hostPlatform = "aarch64-darwin";
    config = {
      allowUnfree = true;
      # it's probably fine, if not i'll find out
      allowUnsupportedSystem = true;
    };
  };

  programs.zsh.enable = true;
  programs.fish.enable = true;

  # Used for backwards compatibility. please read the changelog
  # before changing: `darwin-rebuild changelog`.
  system.stateVersion = 4;

  # Declare the user that will be running `nix-darwin`.
  users.users.alexn = {
    name = "alexn";
    home = "/Users/alexn";
  };
}
