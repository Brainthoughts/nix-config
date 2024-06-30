{ pkgs, ... }: {
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
    raycast
    spotify
    soundsource
    iina
    prismlauncher
    # Commands
    rustup
    wget
    nodejs
    _1password
    zulu17
    pdm
    opam
    btop
    gcc
    pre-commit
  ];
  #todo: spotify player


  # this is internal compatibility configuration 
  # for home-manager, don't change this!
  home.stateVersion = "23.11";


  home.sessionVariables = {
    VISUAL = "nvim";
    EDITOR = "nvim";
  };

  programs = {
    bat = {
      enable = true;
    };
    #   btop = {
    #     enable = true;
    #     settings = {
    #       vim_keys = true;
    #     };
    #   };
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
      shellAbbrs = {
        nvnix = "nvim ~/.config/nix/**.nix";
        ndrb = "darwin-rebuild switch --flake ~/.config/nix";
      };
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
      settings = {
        shell = "/etc/profiles/per-user/alexn/bin/fish";
        editor = "/etc/profiles/per-user/alexn/bin/nvim";
        window_margin_width = 3;
        tab_bar_align = "center";
        macos_option_as_alt = "yes";
        hide_window_decorations = "titlebar-only";
        macos_show_window_title_in = "menubar";
        macos_colorspace = "default";
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
    };
    ripgrep = {
      enable = true;
    };
    #   starship = {
    #     enable = true;
    #     };
    tealdeer = {
      enable = true;
    };

    zoxide = {
      enable = true;
    };
  };


  #  targets = {
  #   darwin = {
  #     defaults = {

  #       };
  #     };
  #   };
}

