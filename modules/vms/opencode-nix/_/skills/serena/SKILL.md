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
save re-exploration in future sessions. (This is separate from the global
`memory` knowledge graph; project specifics go to Serena memories.)

## Gotchas

- Symbol tools answer for the **active project only**; to touch another repo,
  activate it first (or use plain file tools).
- An empty `find_symbol` result for a name that surely exists usually means
  the language server is still indexing — retry once, then broaden the
  pattern with globs.
- Symbol-level tools work on code files only. Config/markup oddities in Nix
  (e.g. `mkEnableOption` description strings) are better handled with
  ast-grep or plain search.
- **Huge repos (chromium):** `find_symbol` without `relative_path` runs a
  workspace-wide search that can make clangd consume >10 G — always pass
  `relative_path`. Serena walks and stats every *tracked*
  project file at startup and before each symbolic call; on chromium that
  baseline poll alone exceeds serena's 240 s tool timeout, so every first
  call dies unless `.serena/project.yml` sets `ignored_paths`
  (e.g. `third_party/**`) to shrink the tracked set (~15x faster; ignored
  files then reject symbol queries but remain readable). The chromium
  checkout is exposed at the host path its `compile_commands.json` was
  generated with; open projects under that mount, not under `/shared/`, or
  clangd will not find compile flags.
- **chromium uses a different clangd.** Stock clangd cannot parse chromium's
  trunk-generated CDB (its trunk-only flags trip `-Werror`). The checkout's
  `.serena/project.yml` therefore pins a trunk-matched clangd via
  `ls_specific_settings.cpp.ls_path` → `~/.local/share/opencode/clangd-chromium`
  (project settings replace the global `cpp` block, so only chromium is
  affected). If that symlink is missing the checkout silently falls back to a
  clangd that downloads an unrunnable glibc build or errors — check it with
  `~/.local/share/opencode/clangd-chromium/bin/clangd --version` (should be
  clang 23). It is created by `home.activation` on every switch.
- **Reseeding after a VM reboot.** The overlay and its `.serena/project.yml`
  live in RAM and vanish on reboot; `home.activation` only reseeds on a
  config switch while the overlay is mounted. To re-arm manually: mount the
  overlay, then `cp` the checkout `project.yml` back (its `ls_path` and
  `ignored_paths` are what make clangd 23 resolve flags quickly).
