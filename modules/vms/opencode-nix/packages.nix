{ ... }:
{
  flake.overlays.opencode-mcp =
    final: prev:
    let
      inherit (final) lib python3Packages;
    in
    {
      # MCP server exposing ast-grep's structural code search tools
      # (https://github.com/ast-grep/ast-grep-mcp). Not packaged in nixpkgs,
      # so build the upstream Python server here. It shells out to the
      # ast-grep CLI, which callers pass via AST_GREP_PATH (pkgs.ast-grep).
      ast-grep-mcp = python3Packages.buildPythonApplication {
        pname = "ast-grep-mcp";
        version = "unstable-2026-10-28";
        format = "pyproject";

        src = final.fetchFromGitHub {
          owner = "ast-grep";
          repo = "ast-grep-mcp";
          rev = "1e41164726d7ead57c8aa25f74946c4badba7f8a";
          hash = "sha256-ojES2CjlN2bTEfGmZJO4gj+juuRF8808kn6YuDpqnxQ=";
        };

        # Upstream pyproject.toml is a uv app without a build-system table;
        # pin setuptools and name the single top-level module explicitly.
        # The exact-version dependency pins are relaxed to what nixpkgs
        # provides (mcp 2.3+, pydantic 2.13+ are compatible).
        postPatch = ''
          substituteInPlace pyproject.toml \
            --replace-fail '"pydantic==2.14.1"' '"pydantic>=2.11"' \
            --replace-fail '"mcp[cli]==2.2.0"' '"mcp[cli]>=2.2"'
          cat >> pyproject.toml <<EOF

          [build-system]
          requires = [ "setuptools" ]
          build-backend = "setuptools.build_meta"

          [tool.setuptools]
          py-modules = [ "main" ]
          EOF
        '';

        nativeBuildInputs = [ python3Packages.setuptools ];

        propagatedBuildInputs = with python3Packages; [
          mcp
          pydantic
          pyyaml
        ];

        meta = {
          description = "MCP server providing ast-grep structural code search tools";
          homepage = "https://github.com/ast-grep/ast-grep-mcp";
          license = lib.licenses.mit;
          mainProgram = "ast-grep-server";
        };
      };
    };
}
