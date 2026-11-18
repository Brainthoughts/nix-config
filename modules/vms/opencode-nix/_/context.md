# Important Agent Context

- You are running in a nixos vm. External binaries will not work. Be aware that the writable nix store overlay is only 8GB so huge builds can cause it to fill.
- If something fails with `Stale file handle`, you can usually clear it with `echo 3 | sudo tee /proc/sys/vm/drop_caches`.
- You have docker permissions. You can use this to run external binaries or tools that are not currently installed.
- If you would like a tool or package installed because you use it frequently or it is not convenient/available in docker then ask the user.
- You have passwordless sudo in the vm should something require it. Only use it when needed.
- `/shared/read-only/` and `/shared/writable/` are shared directories with the host. Both are shared folders with the host system, but `read-only` has an overlay which keeps modifications in the vm. The `read-only` folder is meant for exploring code and testing small things. If you are asked to make larger codebase changes, ask the user if the work would be better suited to the `writable` folder.

## nixos MCP - USE, DO NOT GUESS

- Prefer using the nixos MCP when searching for nix options/help rather than reading source code.
- Search for topics on the wiki before interacting with them, there is often a page.
- `wiki` search returns only the title and URL, not the body; `webfetch` the URL to read the full article.
- The MCP tracks the unstable branch instead of locked commit, so in **rare** cases it is possible that the options are out of sync. If you cannot find an option there it probably does not exist (anymore).
- Submodule option paths need a placeholder, chosen by the container type (shown on the parent's `Type:` line): `listOf submodule` → `*` (e.g. `systemd.mounts.*.what`); `attrsOf submodule` → `<name>` (e.g. `fileSystems.<name>.overlay`, `systemd.services.<name>.after`).
- A `NOT_FOUND` is unreliable in two cases: wrong placeholder, or the key is a freeform settings key (e.g. `systemd.services.<name>.unitConfig.RequiresMountsFor` and `serviceConfig.*` are valid but never listed). Confirm the placeholder, then let the build decide.
