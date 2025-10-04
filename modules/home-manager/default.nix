{ pkgs, ... }:
{
  # this is internal compatibility configuration
  # for home-manager, don't change this!
  home.stateVersion = "23.11";

  imports = [ ./nvim ];

  home.packages = with pkgs; [
    # Apps

    ## Commands
    _1password-cli

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
    tshark
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
    fastfetch = {
      enable = true;
      settings = {
        display = {
          # stat = true;
        };
        modules = [
          "title"
          "separator"
          "os"
          "host"
          "kernel"
          "datetime"
          "uptime"
          "shell"
          "display"
          "terminal"
          "editor"
          {
            type = "cpu";
            temp = true;
          }
          "gpu"
          "memory"
          "swap"
          "disk"
          "localip"
          "locale"
          "break"
          "colors"
        ];
      };
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
        fish_greeting = pkgs.lib.getExe pkgs.fastfetch;
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
        shell = pkgs.lib.getExe pkgs.fish;
        editor = pkgs.lib.getExe pkgs.neovim;
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
      enable = false;
    };
    nix-index-database = {
      comma = {
        enable = true;
      };
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
      historyLimit = 10000;
      keyMode = "vi";
      mouse = true;
      shell = pkgs.lib.getExe pkgs.fish;
      plugins = with pkgs.tmuxPlugins; [ ];
      extraConfig = builtins.readFile ./tmux/tmux.conf;
    };
    uv = {
      enable = true;
    };
    zoxide = {
      enable = true;
    };
  };
}
