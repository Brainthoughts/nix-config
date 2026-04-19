{
  flake.homeModules.starship =
    { pkgs, ... }:
    {
      programs.starship = {
        enable = true;
        settings = builtins.fromTOML (builtins.readFile ./_/starship.toml);
      };
    };
}
