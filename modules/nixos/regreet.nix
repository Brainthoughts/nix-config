{
  flake.nixosModules.regreet =
    { pkgs, ... }:
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
        font = {
          name = "Hack Nerd Font Mono";
          package = pkgs.nerd-fonts.hack;
        };
        settings = {
          application_prefer_dark_theme = true;
        };
      };
    };
}
