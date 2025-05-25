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
      "crossover"
    ];
  };

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # newer version wants 30000, cant read from stateVersion that it should be 350 for some reason
  ids.gids.nixbld = 350;

  nixpkgs = {
    # The platform the configuration will be used on.
    # If you're on an Intel system, replace with "x86_64-darwin"
    hostPlatform = "aarch64-darwin";
    config = {
      allowUnfree = true;
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
