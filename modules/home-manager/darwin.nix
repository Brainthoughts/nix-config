{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Apps
    raycast
    spotify
    # soundsource # outdated, doesn't work on macos 15
    iina
    prismlauncher
    zoom-us
    # yabai # not working
    # skhd
    # Commands
    zulu17
    opam
    nmap
    clang
    clang-tools
    clang-analyzer
    ffmpeg
  ];

  programs = {
    fish = {
      shellAbbrs = {
        nvnix = "nvim ~/.config/nix/**.nix";
        ndrb = "darwin-rebuild switch --flake ~/.config/nix";
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
}
