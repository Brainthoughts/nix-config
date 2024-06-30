{ pkgs, ... }: {

  environment = {
    systemPath = [ "/opt/homebrew/bin" ];
  };
  fonts = {
    packages = [ (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];
  };

  homebrew = {
    enable = true;
    taps = [ "koekeishiya/formulae" ];
    brews = [
      "yabai" #not on nixpkgs
      "skhd" #not on nixpkgs
      "sqlite" #needed for nvim yanky, doesn't accept nix version
    ];
    casks = [
      "lulu" #not on nixpkgs
      "surfshark" #not on nixpkgs
      "citrix-workspace" #broken dep on macos
    ];
  };

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  nixpkgs = {
    # The platform the configuration will be used on.
    # If you're on an Intel system, replace with "x86_64-darwin"
    hostPlatform = "aarch64-darwin";
    # overlays = [
    #   (self: super: {
    #     extra-cmake-modules = super.extra-cmake-modules.overrideAttrs (oldAttrs: rec {
    #       meta = oldAttrs.meta {
    #         platforms = super.lib.platforms.all; # Allow all platforms
    #       };
    #     });
    #   })
    # ];
    config = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
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

