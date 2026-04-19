{
  flake.homeModules.fish =
    { pkgs, ... }:
    {
      programs.fish = {
        enable = true;
        interactiveShellInit = builtins.readFile ./_/config.fish;
        functions = {
          fish_greeting = pkgs.lib.getExe pkgs.fastfetch;
          fish_title = builtins.readFile ./_/fish_title.fish;
        };
        shellAliases = {
          ff = "fastfetch";
        };
        shellAbbrs = {
          nvnix = "nvim ~/.config/nix/**.nix";
          norb = "nh os switch ~/.config/nix";
          nort = "nh os test ~/.config/nix";
          norr = "nh os rollback";
        };
      };
      programs.tmux.shell = pkgs.lib.getExe pkgs.fish;
    };
}
