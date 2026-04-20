{
  self,
  inputs,
  ...
}:
{
  flake.darwinModules.base =
    { pkgs, config, ... }:
    {
      imports = [ inputs.home-manager.darwinModules.home-manager ];
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        verbose = true;
        backupFileExtension = "bak";
        sharedModules = [
          inputs.nix-index-database.homeModules.nix-index
        ];
      };

      environment = {
        systemPath = [ "/opt/homebrew/bin" ];
      };

      fonts = {
        packages = with pkgs; [
          config.my.nerd-font.package
        ];
      };

      # needed temporarily while migration to multi-user support ongoing
      system.primaryUser = config.my.username;

      homebrew = {
        enable = true;
        onActivation = {
          autoUpdate = true;
          cleanup = "zap";
          upgrade = false;
        };
        taps = [
        ];
        brews = [
          "sqlite" # needed for nvim yanky, doesn't accept nix version
        ];
        casks = [
          "lulu" # not on nixpkgs
          "knockknock" # not on nixpkgs
          "crossover"
          "anki" # broken on nixpkgs
          "font-sf-pro"
          "font-sf-mono"
          "sf-symbols"
        ];
      };

      # automatically collect garbage
      nix = {
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
        };
        gc = {
          automatic = true;
          options = "--delete-older-than 30d";
        };
        optimise = {
          automatic = true;
        };
      };

      # newer version wants 30000, cant read from stateVersion that it should be 350 for some reason
      ids.gids.nixbld = 350;

      nixpkgs = {
        # The platform the configuration will be used on.
        # If you're on an Intel system, replace with "x86_64-darwin"
        hostPlatform = "aarch64-darwin";
        config = {
          allowUnfree = true;
          # it's probably fine, if not i'll find out
          allowUnsupportedSystem = true;
        };
      };

      programs.zsh.enable = true;
      programs.fish.enable = true;

      # Used for backwards compatibility. please read the changelog
      # before changing: `darwin-rebuild changelog`.
      system.stateVersion = 4;

      # Declare the user that will be running `nix-darwin`.
      users.users.${config.my.username} = {
        name = config.my.username;
        home = "/Users/${config.my.username}";
      };
    };

  flake.homeModules.darwin =
    {
      pkgs,
      ...
    }:
    {
      imports = [
        ./_sketchybar
      ];

      home.packages = with pkgs; [
        # Apps
        raycast
        iina
        prismlauncher
        utm
        # Commands
        zulu17
        nmap
        ffmpeg
        ghidra
      ];

      programs = {
        aerospace = {
          enable = true;
          launchd = {
            enable = true;
          };
          settings = {
            gaps = {
              outer = {
                left = 12;
                right = 12;
                top = 12;
                bottom = 12;
              };
              inner = {
                horizontal = 12;
                vertical = 12;
              };
            };
            mode.main.binding =
              let
                spaces = builtins.genList (x: x + 1) 9;
                meta = "alt-ctrl-shift";
              in
              builtins.listToAttrs (
                builtins.map (n: {
                  name = "${meta}-${builtins.toString n}";
                  value = "workspace ${builtins.toString n}";
                }) spaces
              )
              // builtins.listToAttrs (
                builtins.map (n: {
                  name = "${meta}-cmd-${builtins.toString n}";
                  value = "move-node-to-workspace ${builtins.toString n} --focus-follows-window";
                }) spaces
              )
              // {
                "${meta}-tab" = "workspace-back-and-forth";
                "${meta}-a" = "workspace prev";
                "${meta}-d" = "workspace next";
                "${meta}-cmd-a" = "move-node-to-workspace prev --focus-follows-window";
                "${meta}-cmd-d" = "move-node-to-workspace next --focus-follows-window";
              };
          };
        };
        kitty = {
          settings = {
            window_margin_width = 3;
            macos_option_as_alt = "yes";
            hide_window_decorations = "titlebar-only";
            macos_show_window_title_in = "menubar";
            macos_colorspace = "default";
          };
        };
      };

      services = {
        jankyborders = {
          enable = true;
          settings = {
            hidpi = "on";
          };
        };
      };
    };
}
