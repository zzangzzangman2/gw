# BATTLE_80_PLAYMODE_RAYCAST_COORDINATE_VERIFICATION

- status: `battle80_playmode_raycast_coordinate_verified`
- scene: `C:\Users\godho\Downloads\girlswar\girlswar_battle_unity\Assets\Scenes\Battle76PlayableRosterCandidate.unity`
- playModeEntered: `True`
- roster rows actor/skill/characterCatalog: `12 / 61 / 131`
- character catalog name/head/battleBundle rows: `130 / 130 / 38`
- runtimeStartGeneratedUiVerified: `True`
- allCoordinateRaycastsVerified: `True`
- selection: `1002 -> 1034 -> 1002`
- HP loop: `attack 958/920, skill 916/765, reset 1000/1000`

## Raycast Probes
- `ActorRow_2` screen=`118.5,367.1` hits=`3` top=`ActorRow_2` targetIndex=`0` clicked=`True`
- `ActorRow_1` screen=`118.5,381.8` hits=`3` top=`ActorRow_1` targetIndex=`0` clicked=`True`
- `AttackButton` screen=`37.2,188.9` hits=`2` top=`AttackButton` targetIndex=`0` clicked=`True`
- `SkillButton` screen=`90.0,188.9` hits=`2` top=`SkillButton` targetIndex=`0` clicked=`True`
- `ResetButton` screen=`142.8,188.9` hits=`2` top=`ResetButton` targetIndex=`0` clicked=`True`

## Notes
- This computes each target button center in screen coordinates, verifies the top `GraphicRaycaster` hit is that button, then dispatches pointer-click through `ExecuteEvents.ExecuteHierarchy`.
- It directly covers coordinate/raycast/sibling blocker behavior for the playable roster overlay.
