{ pkgs, ... }:
{
  # this is internal compatibility configuration
  # for home-manager, don't change this!
  home.stateVersion = "23.11";

  imports = [ ./nvim ];

  home.packages = with pkgs; [
    # Apps

    ## Commands
    openvpn
    _1password-cli
    fastfetch

    # javascript
    nodejs

    # Python
    python3
    pdm
    pre-commit

    # rust
    rustc # needed for tide

    # clang
    lldb

    # low-level misc
    gdb
  ];

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
      interactiveShellInit = builtins.readFile ./fish/config.fish;
      functions = {
        fish_greeting = "fastfetch";
      };
      shellAliases = {
        ff = "fastfetch";
      };
    };
    git = {
      enable = true;
      userEmail = "acniedner@gmail.com";
      userName = "Alexander Niedner";
    };
    ghostty = {
      enable = true;
      enableFishIntegration = true;
      package = if pkgs.stdenv.isDarwin then null else pkgs.ghostty;
      themes = {
        carbonfox = {
          background = "#161616";
          foreground = "#f2f4f8";
          selection-background = "#2a2a2a";
          selection-foreground = "#f2f4f8";
          cursor-color = "#f2f4f8";

          palette = [
            # normal
            "0=#282828"
            "1=#ee5396"
            "2=#25be6a"
            "3=#08bdba"
            "4=#78a9ff"
            "5=#be95ff"
            "6=#33b1ff"
            "7=#dfdfe0"

            # bright
            "8=#484848"
            "9=#f16da6"
            "10=#46c880"
            "11=#2dc7c4"
            "12=#8cb6ff"
            "13=#c8a5ff"
            "14=#52bdff"
            "15=#e4e4e5"

            # extended colors
            "16=#3ddbd9"
          ];
        };
      };
      settings = {
        font-family = "Hack Nerd Font Mono";
        font-size = 14;
        theme = "carbonfox";

        command = "${pkgs.fish}/bin/fish";
        # macos-titlebar-style = "hidden";
        macos-option-as-alt = true;
      };
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
        name = "Hack Nerd Font Mono";
        size = 14;
      };
      settings = {
        shell = "${pkgs.fish}/bin/fish";
        editor = "${pkgs.neovim}/bin/nvim";
        tab_bar_align = "center";
        include = "themes/carbonfox.conf";
      };
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
    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
    ripgrep = {
      enable = true;
    };
    starship = {
      enable = true;
      settings = builtins.fromTOML (builtins.readFile ./starship/starship.toml);
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
      extraConfig = builtins.readFile ./tmux/tmux.conf;
    };
    zoxide = {
      enable = true;
    };
  };
}
