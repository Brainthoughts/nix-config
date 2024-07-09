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
      interactiveShellInit = ''
        # Nightfox Color Palette
        # Style: carbonfox
        # Upstream: https://github.com/edeneast/nightfox.nvim/raw/main/extra/carbonfox/carbonfox.fish
        set -l foreground f2f4f8
        set -l selection 2a2a2a
        set -l comment 6e6f70
        set -l red ee5396
        set -l orange 3ddbd9
        set -l yellow 08bdba
        set -l green 25be6a
        set -l purple be95ff
        set -l cyan 33b1ff
        set -l pink ff7eb6

        # Syntax Highlighting Colors
        set -g fish_color_normal $foreground
        set -g fish_color_command $cyan
        set -g fish_color_keyword $pink
        set -g fish_color_quote $yellow
        set -g fish_color_redirection $foreground
        set -g fish_color_end $orange
        set -g fish_color_error $red
        set -g fish_color_param $purple
        set -g fish_color_comment $comment
        set -g fish_color_selection --background=$selection
        set -g fish_color_search_match --background=$selection
        set -g fish_color_operator $green
        set -g fish_color_escape $pink
        set -g fish_color_autosuggestion $comment

        # Completion Pager Colors
        set -g fish_pager_color_progress $comment
        set -g fish_pager_color_prefix $cyan
        set -g fish_pager_color_completion $foreground
        set -g fish_pager_color_description $comment
      '';
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
      # theme = "Tokyo Night";
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
