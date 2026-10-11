{ self, ... }:
{
  flake.homeModules.readline =
    { pkgs, ... }:
    {
      programs = {
        readline = {
          enable = true;
          variables = {
            editing-mode = "vi";
            show-mode-in-prompt = true;
            vi-ins-mode-string = "\\1\\e[6 q\\2";
            vi-cmd-mode-string = "\\1\\e[2 q\\2";
            keyseq-timeout = 0;
            revert-all-at-newline = true;

            colored-completion-prefix = true;
            colored-stats = true;
            mark-symlinked-directories = true;
            menu-complete-display-prefix = true;
          };
        };
      };
    };
}
