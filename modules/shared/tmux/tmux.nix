{
  flake.homeModules.tmux =
    { pkgs, ... }:
    {
      programs.tmux = {
        enable = true;
        prefix = "C-Space";
        secureSocket = true;
        terminal = "tmux";
        clock24 = true;
        escapeTime = 0;
        historyLimit = 10000;
        keyMode = "vi";
        mouse = true;
        plugins = with pkgs.tmuxPlugins; [
          vim-tmux-navigator
          fuzzback
        ];
        extraConfig = builtins.readFile ./_/tmux.conf;
      };
    };
}
