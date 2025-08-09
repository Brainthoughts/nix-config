{ pkgs, lib, ... }:

{
  programs.aerospace.userSettings = {
    after-startup-command = [ "exec-and-forget sketchybar" ];
    on-focus-changed = [ "exec-and-forget sketchybar --trigger aerospace_focus_changed" ];
    exec-on-workspace-change = [
      "/bin/bash"
      "-c"
      "sketchybar --trigger aerospace_workspace_change FOCUSED=$AEROSPACE_FOCUSED_WORKSPACE"
    ];
    gaps = {
      outer = {
        top = [
          { monitor."built-in" = 12; }
          38
        ];
      };
    };
  };

  xdg.configFile."sketchybar".source = pkgs.replaceVars ./config {
    sbarlua-path = pkgs.sbarlua.outPath;
  };
  # xdg.configFile."sketchybar".source = ./config;
}
