{ pkgs, ... }:
{
  # nixpkgs.overlays = [
  #   (self: super: {
  #     extra-cmake-modules = super.extra-cmake-modules.overrideAttrs (oldAttrs: rec {
  #       meta = oldAttrs.meta {
  #         platforms = super.lib.platforms.all; # Allow all platforms
  #       };
  #     });
  #   })
  # ];
  home.packages = with pkgs; [
    # Apps
    # Commands
    rustup
    wget
    nodejs
    _1password
    _1password-gui
    pdm
    gcc
    pre-commit
  ];

  # this is internal compatibility configuration 
  # for home-manager, don't change this!
  home.stateVersion = "23.11";

  home.sessionVariables = {
    VISUAL = "nvim";
  };

  programs = {
    bat = {
      enable = true;
    };
    btop = {
      enable = true;
      settings = {
        vim_keys = true;
      };
    };
    eza = {
      enable = true;
    };
    fd = {
      enable = true;

    };
    fzf = {
      enable = true;
    };
    fish = {
      enable = true;
      plugins = [
        {
          name = "tide";
          src = pkgs.fetchFromGitHub {
            owner = "IlanCosman";
            repo = "tide";
            rev = "v6.1.1";
            hash = "sha256-ZyEk/WoxdX5Fr2kXRERQS1U1QHH3oVSyBQvlwYnEYyc=";
          };
        }
      ];
    };
    git = {
      enable = true;
      userEmail = "acniedner@gmail.com";
      userName = "Alexander Niedner";
    };
    home-manager = {
      enable = true;
    };
    jq = {
      enable = true;
    };
    kitty = {
      enable = true;
      font = {
        name = "JetBrainsMono Nerd Font";
        size = 14;
      };
      theme = "Tokyo Night";
    };
    lazygit = {
      enable = true;
    };
    less = {
      enable = true;
    };
    navi = {
      enable = true;
    };
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    ripgrep = {
      enable = true;
    };
    tealdeer = {
      enable = true;
    };
    zoxide = {
      enable = true;
    };
  };
}
