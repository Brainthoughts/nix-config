{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Apps
    raycast
    spotify
    soundsource
    iina
    prismlauncher
    # Commands
    zulu17
    opam
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
        shell = "/etc/profiles/per-user/alexn/bin/fish";
        editor = "/etc/profiles/per-user/alexn/bin/nvim";
        window_margin_width = 3;
        tab_bar_align = "center";
        macos_option_as_alt = "yes";
        hide_window_decorations = "titlebar-only";
        macos_show_window_title_in = "menubar";
        macos_colorspace = "default";
      };
    };
  };
}
