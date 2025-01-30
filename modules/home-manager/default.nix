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
        shell = "${pkgs.fish}/bin/fish";
        editor = "${pkgs.neovim}/bin/nvim";
        tab_bar_align = "center";
        themeFile = "Carbonfox";
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
