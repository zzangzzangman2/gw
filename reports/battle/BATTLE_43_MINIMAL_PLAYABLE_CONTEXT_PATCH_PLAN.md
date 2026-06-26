# BATTLE_43 Minimal Playable Context Patch Plan

## Applied In BATTLE43 Candidate
- Added `GraphicRaycaster` to active canvases: `9`.
- Added evidence-backed `Button` components to active button-like Image controls: `10`.
- Reopen component raycast-ready buttons: `0`.
- No click handlers were fabricated; this is component/raycast readiness only.

## Still Blocked
- Mask/RectMask2D remain `0` / `0` after reopen despite source evidence counts in `BATTLE_UI_COMPONENT_TYPE_EVIDENCE.csv`.
- TMP/Text remain `0` / `0`; original text/font/material/autosize values are not reconstructed.
- Missing script count remains `1208`; custom YouYouImage/Lua binder/control scripts are still unresolved.
- Missing resource bundles for playable actor/skill context: `4`.
- Button raycast misses are `{'no_graphic_hits_at_button_center': 20}`; current samples show `hitCount=0`, so no Graphic is hit at the candidate button centers.

## Runtime Data Evidence
- Map id: `11001`; battle type: `1`; waves: `3`.
- Our heroes: `1036, 1002, 1034`.
- Our formation positions are present in `BATTLE_TEST_PAYLOAD.json` and can replace BATTLE29 inferred card placement in the next patch.
- Skill ids are present in payload and `resource_index.csv`; timeline/common effect missing bundles must be handled before skill/cut-in playback can be called playable.

## Next Patch Candidate
- Use `BATTLE_TEST_PAYLOAD.json` to bind hero cards and actor roots by formation position, not hard-coded BATTLE29 slots.
- Restore TMP/Text from original prefab serialized YAML/PPtr evidence before adding visible labels.
- Restore Mask/RectMask2D only after mapping original missing-script serialized fields to exact transforms.
- Trace original Button MonoScript locations and `targetGraphic` serialized references; BATTLE43's child-Image heuristic can persist Buttons, but it does not recreate the original raycast geometry.
- Link Lua/IL2CPP button handlers after component raycast readiness; current BATTLE43 button patch deliberately has no fake onClick.
