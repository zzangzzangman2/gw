# GirlsWar command layout

The root folder is intentionally kept clean.

Start here:
- `00_COMMAND_CENTER.cmd`

Active tool CMDs:
- `_restore_tools\`

Current quick actions in `00_COMMAND_CENTER.cmd`:
- latest MainInterface UI validation: `_restore_tools\111_REVALIDATE_MAININTERFACE_ROUTE_LABEL_RECT_OVERRIDES.cmd`
- latest battle validation: `_restore_tools\BATTLE_31_ATTACH_LOADABLE_ACTOR_SPINE_ANIMATION_RUNTIME_PROBE.cmd`
- git status and push helper

Archived old root shortcuts:
- `_restore_tools\root_cmd_archive\`

Current thread split:
- Main thread: root docs, command layout, coordination, GitHub push to `main`.
- UI thread: MainInterface visual/font/layout restoration.
- Battle thread: battle HUD, video motion matching, actor/card runtime validation.

Notes:
- Nothing was deleted in this cleanup.
- Keep the root folder to one launcher CMD only; put new executable helpers under `_restore_tools\`.
- Use the archive only when you need to inspect or rerun an older root shortcut exactly as it was.
