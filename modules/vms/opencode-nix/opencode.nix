{ self, ... }:
{
  flake.homeModules.opencode =
    { config, ... }:
    {
      imports = [
        self.homeModules.nixos
      ];

      programs.opencode = {
        enable = true;
        enableMcpIntegration = true;
        context = ./_/context.md;
        validateFiles = {
          cli = true;
          config = true;
        };
        settings = {
          shell = "fish";
          default_agent = "plan";
          snapshot = false;
          autoupdate = false;
          lsp = true;
          providers = {
            morpheus = builtins.fromJSON (builtins.readFile ./_/morpheus.json);
          };
        };
        cli = {
          theme.name = "system";
          keybinds = {
            leader = "alt+space";
          };
        };
      };
    };
}
