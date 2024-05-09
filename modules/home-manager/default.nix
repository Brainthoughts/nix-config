{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Apps
    raycast
    discord
    spotify
    soundsource
    # Commands
    rustup
    wget
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
      shellAbbrs = {
        nvnix = "nvim ~/.config/nix/**.nix";
        ndrb = "darwin-rebuild switch --flake ~/.config/nix";
      };
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
      environment = {
        VISUAL = "nvim";
        EDITOR = "nvim";
      };
      font = {
        name = "JetBrainsMono Nerd Font";
        size = 14;
      };
      settings = {
        shell = "/etc/profiles/per-user/alexn/bin/fish";
        window_margin_width = 3;
        tab_bar_align = "center";
        macos_option_as_alt = "yes";
        hide_window_decorations = "titlebar-only";
        #macos_show_window_title_in = "menubar";
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
    tealdeer = {
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

