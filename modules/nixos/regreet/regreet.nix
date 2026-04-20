{
  flake.nixosModules.regreet =
    { pkgs, config, ... }:
    {
      programs.regreet = {
        enable = true;
        theme = {
          name = "Adwaita-dark";
        };
        iconTheme = {
          name = "Adwaita-dark";
        };
        cursorTheme = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Classic";
        };
        font = config.my.nerd-font;
        settings = {
          application_prefer_dark_theme = true;
        };
      };
    };
}
