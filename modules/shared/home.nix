{ self, ... }:
{
  flake.homeModules.home =
    { pkgs, ... }:
    {

      imports = [
        self.homeModules.fish
        self.homeModules.starship
        self.homeModules.tmux
        self.homeModules.nvim
      ];

      # this is internal compatibility configuration
      # for home-manager, don't change this!
      home.stateVersion = "23.11";

      home.packages = with pkgs; [
        ## Commands
        _1password-cli
        file

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
        git = {
          enable = true;
          settings = {
            user = {
              email = "acniedner@gmail.com";
              name = "Alexander Niedner";
            };
          };
          # silence legacy warning
          signing.format = null;
        };
        jq = {
          enable = true;
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
        nh = {
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
        tealdeer = {
          enable = true;
        };
        thunderbird = {
          enable = true;
          profiles = { };
        };
        uv = {
          enable = true;
        };
        zoxide = {
          enable = true;
        };
      };
    };
}
