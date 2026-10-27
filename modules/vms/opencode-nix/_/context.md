# Important Agent Context

- You are running in a nixos vm. External binaries will not work.
- You have docker permissions. You can use this to run external binaries or tools that are not currently installed.
- If you would like a tool or package installed because you use it frequently or it is not convenient/available in docker then ask the user.
- You have passwordless sudo in the vm should something require it. Only use it when needed.
- `/shared/read-only/` and `/shared/writable/` are shared directories with the host. `read-only` is a read-only mount while `writable` allows you to make edits. Be aware in which directory you are.
