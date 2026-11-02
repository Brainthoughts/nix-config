{ self, ... }:
{
  flake.homeModules.opencode =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      serena = self.inputs.serena.packages.${pkgs.system}.serena;
      serenaHome = "${config.xdg.dataHome}/opencode/serena";

      # Serena writes runtime state (project registry, auth secret, logs) into
      # SERENA_HOME and rewrites this file itself, so it is seeded by
      # home.activation rather than managed as a symlinked xdg file.
      # The ls_path pins bypass Serena's managed language-server downloads
      # and make it use store binaries instead (required on NixOS);
      # languages without a pin keep Serena's PATH/managed discovery.
      serenaConfig = pkgs.writeText "serena-config.yml" ''
        language_backend: LSP
        agent_interface: tools
        line_ending: lf
        web_dashboard: False
        web_dashboard_open_on_launch: False
        gui_log_window: False
        ls_specific_settings:
          nix:
            ls_path: ${lib.getExe pkgs.nixd}
          python:
            ls_path: ${pkgs.basedpyright}/bin/basedpyright-langserver
          rust:
            ls_path: ${lib.getExe pkgs.rust-analyzer}
          typescript:
            ls_path: ${lib.getExe pkgs.vtsls}
          markdown:
            ls_path: ${lib.getExe pkgs.marksman}
          yaml:
            ls_path: ${pkgs.vscode-langservers-extracted}/bin/yaml-language-server
        # lua-language-server resolves via PATH (home.packages), not ls_path
        trusted_project_path_patterns:
          - ${config.home.homeDirectory}
          - ${config.home.homeDirectory}/**
          - /shared/**
        base_modes:
          - interactive
          - editing
        auth_secret:
        projects: []
      '';
    in
    {
      imports = [
        self.homeModules.nixos
      ];

      # MCP server binaries are only referenced as strings in the generated
      # opencode.json, so they must be part of the home closure explicitly.
      home.packages = [
        pkgs.ast-grep
        pkgs.ast-grep-mcp
        pkgs.mcp-server-memory
        # Serena's lua support finds its language server via PATH lookup
        pkgs.lua-language-server
        serena
      ];

      # the seed config is only referenced by the activation script; keep it
      # in the generation's dependencies so it is realised on switch
      home.extraDependencies = [ serenaConfig ];

      # Serena rewrites serena_config.yml (project registry, auth secret),
      # so only seed it when absent instead of managing the file.
      home.activation.seedSerenaConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p ${lib.escapeShellArg serenaHome}
        if [ ! -e ${lib.escapeShellArg (serenaHome + "/serena_config.yml")} ]; then
          cp ${serenaConfig} ${lib.escapeShellArg (serenaHome + "/serena_config.yml")}
        fi
      '';

      # opencode keeps its plan notes (and other mutable per-user state) in
      # ~/.opencode; the VM's root filesystem is tmpfs, so anchor the whole
      # directory inside the persistent state volume.
      home.activation.persistOpencodeHome = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        _oc_link=${lib.escapeShellArg (config.home.homeDirectory + "/.opencode")}
        _oc_dir=${lib.escapeShellArg (config.xdg.dataHome + "/opencode/dot-opencode")}
        mkdir -p "$_oc_dir"
        if [ -e "$_oc_link" ] && [ ! -L "$_oc_link" ]; then
          # only ever an empty dir opencode created before activation ran
          rm -rf "$_oc_link"
        fi
        if [ "$(readlink -f "$_oc_link")" != "$_oc_dir" ]; then
          ln -sfn "$_oc_dir" "$_oc_link"
        fi
      '';

      # nixd needs a nixpkgs provider that isn't based on NIX_PATH (flakes-only system)
      xdg.configFile."nixd/config.json".text = builtins.toJSON {
        eval.nixpkgs.expr = ''builtins.getFlake "${toString self.inputs.nixpkgs}"'';
      };

      programs.mcp = {
        enable = true;

        servers = {
          # `ide` context = single-project tool set; --project-from-cwd
          # binds the session to the directory opencode spawns this from.
          serena = {
            command = lib.getExe serena;
            args = [
              "start-mcp-server"
              "--transport"
              "stdio"
              "--context"
              "ide"
              "--project-from-cwd"
            ];
            env.SERENA_HOME = serenaHome;
          };

          ast-grep = {
            command = lib.getExe pkgs.ast-grep-mcp;
            env.AST_GREP_PATH = lib.getExe pkgs.ast-grep;
          };

          memory = {
            command = lib.getExe pkgs.mcp-server-memory;
            # lives on the persistent opencode state volume
            env.MEMORY_FILE_PATH = "${config.xdg.dataHome}/opencode/mcp-memory/knowledge-graph.json";
          };
        };
      };

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
          model = "morpheus/cyankiwi/Qwen3.8-Flash-Next-AWQ-INT4";
          providers = {
            morpheus = builtins.fromJSON (builtins.readFile ./_/morpheus.json);
          };
        };
        cli = {
          theme.name = "system";
          keybinds = {
            leader = "alt+space";
          };
          session = {
            thinking = "show";
          };

        };
        skills = {
          ast-grep = ./skills/ast-grep;
          memory = ./skills/memory;
          serena = ./skills/serena;
        };
      };
    };
}
