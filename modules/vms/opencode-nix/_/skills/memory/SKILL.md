---
name: memory
description: Persist durable knowledge across sessions in the "memory" knowledge-graph MCP server. Use when the user shares stable preferences, project decisions, environment facts, or recurring pitfalls worth remembering, and at the start of tasks where past context could apply.
---

# Knowledge Graph Memory

The `memory` MCP server stores a persistent knowledge graph (JSON file on the
opencode state volume — it survives sessions and VM rebuilds).

Model:

- **Entities** — nodes with `name`, `entityType`, and atomic `observations`
  (one fact per observation string).
- **Relations** — directed edges `{from, to, relationType}`, active voice,
  both endpoints must already exist.

| Tool | Use for |
| --- | --- |
| `search_nodes` | free-text recall over names, types, observations — start here |
| `open_nodes` | fetch known entity names (and relations between them) |
| `read_graph` | whole graph; only when the graph is small or you must audit it |
| `create_entities` | new subjects (person, project, decision, preference, pitfall) |
| `create_relations` | link existing entities |
| `add_observations` | append facts to an existing entity (creation skips existing names silently) |
| `delete_entities` / `delete_observations` / `delete_relations` | corrections; entity deletion cascades its relations |

## When to write

Write only information that stays useful beyond this session:

- user preferences and corrections ("prefers nixfmt-tree style", "commits without Co-Authored-By")
- durable environment facts ("opencode VM: state on ~/.local/share/opencode volume", "hosts: blacknix, pronix, macnix")
- design decisions and their rationale
- recurring pitfalls and their fixes

Do **not** write: transient task state, anything trivially re-derivable from
the repo (git history, file layout), or secrets.

## How to write

- At task start, if the task touches work you may have seen before, run a
  quick `search_nodes` with the project/topic name.
- Prefer updating an existing entity (`add_observations`) over creating near-
  duplicate entities; check with `search_nodes`/`open_nodes` first.
- Keep observations atomic and self-contained — each string must make sense
  without the others.
- Model relationships, not just facts: `ConfigRepo — follows — GitFlow`,
  `User — uses — OpencodeVM`. Relations make later recall queryable.
- On corrections, delete or amend stale observations — a wrong memory is
  worse than none.
