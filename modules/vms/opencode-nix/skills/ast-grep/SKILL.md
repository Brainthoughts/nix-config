---
name: ast-grep
description: Structural code search with ast-grep (matches AST nodes, not text) via the "ast-grep" MCP tools. Use for searching code by syntactic shape — find all calls of a function with a certain argument shape, every match arm, attribute or option usage, or dangerous construct — or when grep returns too many false positives.
---

# ast-grep Structural Search

The `ast-grep` MCP server exposes four tools that run the `ast-grep` CLI:

| Tool | Purpose |
| --- | --- |
| `find_code` | search a project for a simple pattern, e.g. `$FUNC($A, $B)` |
| `find_code_by_rule` | search with a full YAML rule (relational constraints: `inside`, `has`, `all`, `any`, `not`) |
| `test_match_code_rule` | test a YAML rule against a code snippet before running it project-wide |
| `dump_syntax_tree` | print the AST of a code snippet to see how to match it |

## Core rules

- `project_folder` must be an **absolute path**.
- Patterns must be syntactically valid code — `find_code($X)` matches an
  expression node, not text. Regex-like thinking does not apply.
- Meta-variables are `$VAR` (single node) and `$$$ARGS` (node sequence).
  `$VAR` cannot repeat to mean the same value across a rule unless you
  rely on pattern matching semantics within one pattern.
- Prefer `output_format: "text"` (default) — it returns just the matched
  snippets with `file:line-range` and uses far fewer tokens than `"json"`.
  Use `"json"` only when you need ranges or meta-variable captures.
- Set `max_results` when you only need examples, not an exhaustive count.
- A "no matches" result is a **valid answer**, not a failure. `test_match_code_rule`
  raises an error on zero matches — that's how you learn a rule is wrong.

## Rule-development loop (for anything beyond a one-node pattern)

1. Break the query into sub-conditions and draft a YAML rule with
   `id`, `language`, and `rule` keys.
2. `dump_syntax_tree` on a small representative snippet to confirm node
   kinds and nesting (check e.g. whether `await` wraps the call you target).
3. `test_match_code_rule` against that snippet.
4. If it doesn't match: relax the rule one condition at a time — remove a
   `has`/`inside` clause, or add `stopBy: end` to relational clauses
   (`inside`, `has` only traverse direct children without it).
5. Once it matches, run `find_code_by_rule` over the project.

```yaml
id: example
language: nix
rule:
  pattern: import <...>
  inside:
    kind: attrpath_expression
    stopBy: end
```

Language is auto-detected from file extensions when omitted, but passing
`language` explicitly avoids surprises in mixed repos. ast-grep understands
the syntax of Nix, Rust, Python, JS/TS, Go, C, and many more languages, so
use it here instead of grep whenever shape matters (e.g. "every `mkEnableOption`
with a multi-line description", "all `submodule` declarations that define an
`enable` option").

For complex rewrites, validate a rule with `test_match_code_rule` first, then
apply changes with your edit tools — this server only searches.
