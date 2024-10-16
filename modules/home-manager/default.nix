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
      interactiveShellInit = builtins.readFile ./fish/config.fish;
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
      extraConfig = builtins.readFile ./tmux/tmux.conf;
    };
    zoxide = {
      enable = true;
    };
  };
}
