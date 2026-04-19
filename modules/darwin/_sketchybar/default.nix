{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    sketchybar
    sbarlua
    lua5_4_compat
  ];

  programs.aerospace.settings = {
    after-startup-command = [ "exec-and-forget ${lib.getExe pkgs.sketchybar}" ];
    on-focus-changed = [
      "exec-and-forget ${lib.getExe pkgs.sketchybar} --trigger aerospace_focus_changed"
    ];
    exec-on-workspace-change = [
      "/bin/bash"
      "-c"
      "${lib.getExe pkgs.sketchybar} --trigger aerospace_workspace_change FOCUSED=$AEROSPACE_FOCUSED_WORKSPACE"
    ];
    gaps = {
      outer = {
        top = lib.mkForce [
          { monitor."built-in" = 12; }
          38
        ];
      };
    };
  };

  xdg.configFile."sketchybar".source = pkgs.stdenv.mkDerivation {
    name = "sketchybar-config";
    src = ./config;
    buildPhase = ''
      substituteInPlace init.lua --subst-var-by sbarlua-path ${pkgs.sbarlua}
      substituteInPlace sketchybarrc --subst-var-by lua5_4_compat ${lib.getExe pkgs.lua5_4_compat}
      substituteInPlace helpers/aerospace.lua --subst-var-by aerospace ${lib.getExe pkgs.aerospace}
      make
    '';
    installPhase = ''
      cp -r . $out
    '';
  };
}
