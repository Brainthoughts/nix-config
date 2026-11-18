---
name: serena
description: IDE-grade semantic code navigation and symbol-level editing via the "serena" MCP tools (find_symbol, find_referencing_symbols, get_symbols_overview, replace_symbol_body, rename_symbol, diagnostics). Use when exploring code structure, finding definitions or usages of a symbol, or editing at symbol granularity — i.e. almost any code task, instead of grepping the whole repo.
---

# Serena — Semantic Code Toolkit

Serena runs language servers for the active project (Nix, Python, Rust,
TypeScript, C++, Java, Markdown and YAML are pinned to store binaries in the
global config; others auto-detect) and exposes symbol-level tools. It is
stateful: exactly one project is active per session.

## Startup

The server is started with `--project-from-cwd`, so the repo you are working
in is usually already active and you can go straight to symbol queries.
The project's languages come from `.serena/project.yml` in the project root
(auto-generated with background detection when missing). If a tool reports no
active project or an unusable language server set, say so and fix
`.serena/project.yml` (`language_servers: [nix]` etc.) rather than guessing.

## Retrieval — prefer these over grep

| Tool | Use for |
| --- | --- |
| `get_symbols_overview` | outline of classes/functions in a file before reading it |
| `find_symbol` | locate a symbol by name path; returns bodies (use `depth` to limit nesting, `include_body` only when you need the code) |
| `find_referencing_symbols` | who uses this symbol — call before changing or deleting it |
| `find_declaration` | declaration at a specific usage (needs file + occurrence regex) |
| `find_implementations` | concrete implementations of an interface/abstract member |
| `get_diagnostics_for_file` | errors/warnings after editing a file |
| `search_for_pattern` | regex across the project (with `include_paths`/`exclude_paths`) when you truly need text search |

Name paths are `Parent::Child::member`, e.g. `HyprlandConfig::extraConfig`.
They support glob fragments: `Config::*` or `**::init`. A leading `$` makes a
pattern absolute from the project root.

## Editing — symbol granularity beats string patching

| Tool | Use for |
| --- | --- |
| `replace_symbol_body` | rewrite a symbol's body, keeps indentation/formatting correct |
| `insert_before_symbol` / `insert_after_symbol` | add definitions around an anchor symbol without line-number math |
| `safe_delete_symbol` | delete a symbol only if it has no references (fails otherwise — that is the point) |
| `rename_symbol` | project-wide consistent rename |
| `replace_content` | regex/string replacements when no symbol fits as an anchor |

After edits that change structure, run `get_diagnostics_for_file` on touched
files before moving on.

## Project memories

Serena also stores project-scoped markdown notes: `write_memory`,
`read_memory`, `list_memories`, plus an onboarding tool that drafts an
initial overview. Use memories for architecture notes, conventions, and
gotchas discovered during work — they are re-read on project activation and
save re-exploration in future sessions.

## Gotchas

- Symbol tools answer for the **active project only**; to touch another repo,
  activate it first (or use plain file tools).
- An empty `find_symbol` result for a name that surely exists usually means
  the language server is still indexing — retry once, then broaden the
  pattern with globs.
- Symbol-level tools work on code files only. Config/markup oddities in Nix
  (e.g. `mkEnableOption` description strings) are better handled with
  ast-grep or plain search.
- **Chromium — open it at the literal `~/Projects` path.** The checkout is
  bind-mounted at the exact absolute path its `compile_commands.json` and clangd
  index were built with: `~/Projects/ba/chromium-things/chromium/src`. That is
  the writable workspace overlay reached via a **bind, not a symlink** — a
  symlink would make clangd's `realpath()` canonicalization resolve away from the
  literal path and drop all compile flags. Work under `~/Projects/...`, never a
  `/shared/...` path, or clangd finds no compile command.
- **Chromium uses its own clangd.** Stock clangd cannot parse chromium's
  trunk-generated CDB (trunk-only flags trip `-Werror`). The checkout's
  `.serena/project.yml` pins a trunk-matched clangd via
  `ls_specific_settings.cpp.ls_path` → `~/.local/share/opencode/clangd-chromium`
  (project settings replace the global `cpp` block, so only chromium is
  affected). Verify with `~/.local/share/opencode/clangd-chromium/bin/clangd
  --version` (clang 23); it is created by `home.activation` on every switch.
- **Huge repos (chromium): keep calls scoped.** `find_symbol` without
  `relative_path` runs a workspace-wide query that can push clangd >10 G — always
  pass `relative_path`. Serena stats every *tracked* file at startup and before
  each symbolic call; the checkout's `project.yml` sets `ignored_paths`
  (e.g. `third_party/**`) to shrink the tracked set, otherwise that baseline poll
  alone exceeds serena's 240 s tool timeout and the first call dies. Ignored
  files stay readable but reject symbol queries.
