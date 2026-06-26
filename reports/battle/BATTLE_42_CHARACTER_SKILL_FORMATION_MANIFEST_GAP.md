# BATTLE_42 Character Skill Formation Manifest Gap

## Current Evidence Filled
- persistent HUD sprite marker rows bound: `232`
- active-in-hierarchy bound rows: `56`
- hero/head-like rows: `9`
- skill/fury-like rows: `15`
- formation/card-like rows: `131`
- reopened Image/Graphic rows: `232` / `232`

## Manifest Gaps To Close Before Playable Battle
- Character roster is still hard-wired to the three BATTLE29 sample heroes (`1036`, `1002`, `1034`) and must be sourced from original formation/battle datatable/Lua runtime state.
- Skill card mapping currently carries BATTLE29 evidence for normal/small/big skill ids only; cooldown, fury/ready state, icon source bundle, and click handler mapping still need datatable + Lua + IL2CPP join.
- Formation positions need original side/team/order evidence, not the BATTLE29 inferred three-card placement.
- Top HP/VS/wave and right auto/skip/speed controls have persistent sprite candidates, but runtime text/TMP values, masks/stencil, and button handler binding are not validated as playable.
- Actor motion/timing and skill/cut-in effect timelines remain outside this HUD persistence patch.

## Required Next Evidence
- Original battle/formation datatables for actor ids, enemy wave ids, side, slot/order, level, and head/icon refs.
- Decoded Lua call sites that populate `HeroListContainer`, skill cards, HP bars, wave text, auto/skip/speed state, and skill activation.
- IL2CPP method/type evidence for Image/Button/Text/TMP/custom YouYouImage fields where original MonoBehaviour script PPtrs were lost in saved scenes.
- Mask/stencil and Canvas/CanvasScaler verification after persistent Image reconstruction.
