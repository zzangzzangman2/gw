# GirlsWar command layout

The root folder is intentionally kept clean.

Start here:
- `00_COMMAND_CENTER.cmd`

Home checkpoint test:
- `00_COMMAND_CENTER.cmd` -> `B`
- or run `_restore_tools\current\00_RUN_HOME_CHECKPOINT_TESTS.cmd`

Current quick CMD wrappers:
- `_restore_tools\current\00_RUN_HOME_CHECKPOINT_TESTS.cmd`
- `_restore_tools\current\01_RUN_LATEST_MAININTERFACE_UI_VALIDATION.cmd`
- `_restore_tools\current\02_RUN_LATEST_BATTLE_VALIDATION.cmd`

Archived tool CMDs:
- `_restore_tools\cmd_archive\`

Current latest validation targets:
- MainInterface: `_restore_tools\cmd_archive\121_VERIFY_ROUTE_SKELETONGRAPHIC_CANVASRENDERER_TEXTURE_HANDOFF_AND_CLIPPING_TRIANGULATION_ZONG1.cmd`
- Battle: `_restore_tools\cmd_archive\BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT.cmd`

Experimental next tool, created but not used as the default checkpoint test:
- Battle: `_restore_tools\cmd_archive\BATTLE_41_TRACE_BATTLE_HUD_RUNTIME_SPRITE_TEXTURE_PERSISTENCE_AND_CAPTURE_PIPELINE.cmd`

Home handoff:
- `reports\NEXT_RESTORE_HANDOFF.md`
- `reports\HOME_RESUME_AFTER_UI121_BATTLE40_20260625_2325.md`

Current thread split:
- Main thread: root docs, command layout, coordination, GitHub push to `main`.
- UI thread: MainInterface visual/font/layout restoration.
- Battle thread: battle HUD, video motion matching, actor/card runtime validation.

Notes:
- The project is still not visually restored.
- Keep the root folder to one launcher CMD only.
- Do not place CMD files directly under `_restore_tools\`.
- Put historical or numbered executable helpers under `_restore_tools\cmd_archive\`.
- Put only small current entry wrappers under `_restore_tools\current\`.
