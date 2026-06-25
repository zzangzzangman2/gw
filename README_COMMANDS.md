# GirlsWar command layout

The root folder is intentionally kept clean.

Start here:
- `00_COMMAND_CENTER.cmd`

Current quick CMD wrappers:
- `_restore_tools\current\`

Archived tool CMDs:
- `_restore_tools\cmd_archive\`

Current quick actions in `00_COMMAND_CENTER.cmd`:
- latest MainInterface UI validation: `_restore_tools\current\01_RUN_LATEST_MAININTERFACE_UI_VALIDATION.cmd`
- latest battle validation: `_restore_tools\current\02_RUN_LATEST_BATTLE_VALIDATION.cmd`
- git status and push helper

Archived old root shortcuts:
- `_restore_tools\root_cmd_archive\`

Current thread split:
- Main thread: root docs, command layout, coordination, GitHub push to `main`.
- UI thread: MainInterface visual/font/layout restoration.
- Battle thread: battle HUD, video motion matching, actor/card runtime validation.

Notes:
- Nothing was deleted in this cleanup.
- Keep the root folder to one launcher CMD only.
- Do not place CMD files directly under `_restore_tools\`.
- Put historical or numbered executable helpers under `_restore_tools\cmd_archive\`.
- Put only small current entry wrappers under `_restore_tools\current\`.
- Use the archive only when you need to inspect or rerun an older root shortcut exactly as it was.
