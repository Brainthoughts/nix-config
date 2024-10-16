{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Apps
    # Commands
    openvpn
    rustup
    nodejs
    _1password
    fastfetch
    # Python
    pdm
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
        # pkgs.fishPlugins.tide
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
    tmux = {
      enable = true;
      clock24 = true;
      escapeTime = 0;
      keyMode = "vi";
      mouse = true;
      shell = "${pkgs.fish}/bin/fish";
      plugins = with pkgs.tmuxPlugins; [ ];
      extraConfig = ''
        # undo the mac fix from sensible.tmux
        set -g default-command ""

        # Nightfox colors for Tmux
        # Style: carbonfox
        # Upstream: https://github.com/edeneast/nightfox.nvim/raw/main/extra/carbonfox/carbonfox.tmux
        set -g mode-style "fg=#0c0c0c,bg=#b6b8bb"
        set -g message-style "fg=#0c0c0c,bg=#b6b8bb"
        set -g message-command-style "fg=#0c0c0c,bg=#b6b8bb"
        set -g pane-border-style "fg=#b6b8bb"
        set -g pane-active-border-style "fg=#78a9ff"
        set -g status "on"
        set -g status-justify "left"
        set -g status-style "fg=#b6b8bb,bg=#0c0c0c"
        set -g status-left-length "100"
        set -g status-right-length "100"
        set -g status-left-style NONE
        set -g status-right-style NONE
        set -g status-left "#[fg=#0c0c0c,bg=#78a9ff,bold] #S #[fg=#78a9ff,bg=#0c0c0c,nobold,nounderscore,noitalics]"
        set -g status-right "#[fg=#0c0c0c,bg=#0c0c0c,nobold,nounderscore,noitalics]#[fg=#78a9ff,bg=#0c0c0c] #{prefix_highlight} #[fg=#b6b8bb,bg=#0c0c0c,nobold,nounderscore,noitalics]#[fg=#0c0c0c,bg=#b6b8bb] %Y-%m-%d  %H:%M #[fg=#78a9ff,bg=#b6b8bb,nobold,nounderscore,noitalics]#[fg=#0c0c0c,bg=#78a9ff,bold] #h "
        setw -g window-status-activity-style "underscore,fg=#7b7c7e,bg=#0c0c0c"
        setw -g window-status-separator ""
        setw -g window-status-style "NONE,fg=#7b7c7e,bg=#0c0c0c"
        setw -g window-status-format "#[fg=#0c0c0c,bg=#0c0c0c,nobold,nounderscore,noitalics]#[default] #I  #W #F #[fg=#0c0c0c,bg=#0c0c0c,nobold,nounderscore,noitalics]"
        setw -g window-status-current-format "#[fg=#0c0c0c,bg=#b6b8bb,nobold,nounderscore,noitalics]#[fg=#0c0c0c,bg=#b6b8bb,bold] #I  #W #F #[fg=#b6b8bb,bg=#0c0c0c,nobold,nounderscore,noitalics]"
      '';
    };
    zoxide = {
      enable = true;
    };
  };
}
