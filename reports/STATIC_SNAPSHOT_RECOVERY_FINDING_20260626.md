# Static Snapshot Recovery Finding

Generated: 2026-06-26 KST
Author: main thread (control tower)
Status: **decision-changing** — read before requesting any runtime dump.

## TL;DR

The "missing runtime snapshot" blocker that has gated both MainInterface (UI) and
Battle (HUD) is **largely not a runtime problem**. ~80-90% of the `7,540` missing
"runtime" values are **statically derivable** from artifacts already in this repo.
The pipeline has been waiting for an original runtime dump it does not actually need.

Do not keep blocking on runtime-dump approval for **layout/structure** fields.
Only a thin slice of **content** values (account/server payload) truly needs a live
session, and content does not block the structural UI/HUD restore.

## Why the blocker is mostly static

The UI framework is a deterministic, data-driven YouYou/xLua stack. Depth/sorting,
mask, open-stack, parent, and active-state are written explicitly in source:

### 1. Depth -> sortingOrder is computed, not snapshotted

Framework formula (from `il2cpp_dump/dump.cs`):

```
Canvas.sortingOrder = UIGroup.BaseOrder[GroupId] + UIFormBase.Depth
```

- `GroupId` comes from `DTSysUIForm.UiGroupId` (per-form data table).
- `UIGroup.BaseOrder` comes from `UILayer.m_UILayerDic[GroupId]`.
- `Depth` is assigned at open time by `YouYouUIManager.SetSortingOrder` / `OpenUIForm`.

`UI_MainPage` Lua even assigns canvas order directly (~line 1639):

```lua
local e = self.Depth - 1
a.sortingOrder = e                                   -- live2d_Canvas
local h = m:GetComponent(typeof(CS.YouYou.Live2DHelper)); h:SetDepth(e)
local t = a:GetComponent(typeof(CS.UnityEngine.Canvas)); t.sortingOrder = e
```

Relevant il2cpp classes: `YouYouCanvasHelper` (SetDepth/ResetDepth/OnDepthChanged),
`UIFormBase` (Depth/GroupId/CurrCanvas/enumActive), `UILayer`+`UIGroup`
(`UIGroup{ byte Id; ushort BaseOrder; Transform Group; }`, `SetSortingOrder`),
`YouYouUIManager` (OpenUIForm/SetSortingOrder/FocusAndBlurUnder),
`EnumUIState{ None=0, Hide=1, Active=2, Closing=3, Close=4 }`.

### 2. Open-stack / active-tab / mask are explicit in `UI_Dock`

`UI_Dock` decoded Lua defines `setCurrView` (form-stack push/pop), `initTab`
(on/off node SetActive per selected tab), and `OnLoadingClosed` (mask fade):

```lua
function setCurrView(t)
  local a = i:PopBack(); if a then GameTools.CloseUIForm(a) end   -- i = open-stack
  if e == DOCK_TYPE.MAIN_PAGE then a = UIFormId.UI_MainPage; GameEntry.UI:OpenUIForm(UIFormId.UI_MainPage, t)
  elseif e == DOCK_TYPE.CAMP then a = UIFormId.UI_Camp
  ...
  i:PushBack(a)
end
function initTab()
  for t = DOCK_TYPE.MAIN_PAGE, DOCK_TYPE.MAIN_CITY do
    local sel = (t == e)
    LuaUtils.SetActive(d[t][1].transform, sel)        -- "_on" node active iff selected
    LuaUtils.SetActive(d[t][2].transform, not sel)    -- "_off" node active iff not
  end
end
```

- **Default entry tab = `DOCK_TYPE.MAIN_PAGE`** -> home/lobby is the default screen,
  confirming UI149's conclusion that the reference image is home/lobby (NOT route/world).
- Steady-state `show_mask = false` (forced inactive on close, faded after loading).

### 3. The single highest-leverage artifact already exists

`girlswar_merged_extracted/indexes/ui_recttransforms.csv` — **129,148 rows** of fully
serialized RectTransform state: parent, sibling order, anchors, pivot, anchoredPos,
sizeDelta, localScale, **and GameObject active flag**.
`maininterface.assetbundle` alone = **2,404 rows** (1,779 active / 625 inactive), with
node names matching UI_Dock/UI_MainPage exactly.

## Recoverability by blocker category (B75: 7,337 battle + 203 UI = 7,540)

| Category | Count | Static source | Recoverable |
| --- | ---: | --- | --- |
| rect_transform | 2,356 | `ui_recttransforms.csv` | ~100% |
| active_chain | 942 | CSV active flag + UI_Dock SetActive rules | mostly |
| graphic_image_button_raycast | 1,780 | prefab serialization + LuaComBinder/UIEventListener GUIDs | mostly |
| mask_rectmask_stencil_material | 411 | RectMask2D in prefab + Lua mask rules | mostly |
| tmp_autosize_font_material | 997 | prefab-serialized TMP fields | mostly |
| handler_lua_lifecycle | 148 | decoded Lua (ProcedureNormalBattle, UI_Dock) | structure/lifecycle yes |
| Canvas sortingOrder/Depth | subset | DTSysUIForm.UiGroupId + framework formula | deterministic |

**The validator's own B75 classification already says `runtime_snapshot_required = 15`**
out of 7,337. The other 7,322 are `handler_or_xlua_required` (5,118) or
`component_rehydration_required` (2,204) — both suppliable from decoded Lua + prefab
serialization + il2cpp metadata.

### Genuinely runtime/account-only (do NOT block structural restore)

Live chat text/usernames, profile/power/currency numbers, redpoint counts,
`ActMgr:GetActInMain` activity slots, server-driven battle action payload.
These are **content**, not layout — placeholder-but-structurally-correct content is
acceptable for a layout restore.

## Key source files (full paths)

Home/lobby:
- `girlswar_merged_extracted/decoded/xlua/-4615102950863731052_UI_Dock_security_xor_raw.lua`
- `girlswar_merged_extracted/decoded/xlua/-6351603197391775840_UI_MainPage_security_xor_raw.lua`
- `girlswar_merged_extracted/decoded/xlua/-3138555983938251346_MainPageMgr_security_xor_raw.lua`

Framework:
- `girlswar_merged_extracted/extracted/il2cpp_dump/dump.cs`
  (`YouYouCanvasHelper`, `UIFormBase`, `UILayer`, `UIGroup`, `YouYouUIManager`,
  `EnumUIState`, `DTSysUIForm`)

Battle:
- `girlswar_merged_extracted/decoded/xlua_battle/download_xlualogic_modules_procedure/-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua`
  (UI_NormalBattle opened ~line 1881, closed ~6516, LoadBattleUI3D 1164-1189)

Static layout:
- `girlswar_merged_extracted/indexes/ui_recttransforms.csv`

## Known gap

`UI_NormalBattle` **form** Lua was NOT in the decoded batch (UI_MainPage/UI_Dock are).
Battle HUD layout is still recoverable from its prefab in `ui_recttransforms.csv` +
its `DTSysUIForm` entry, but per-node active/refresh logic needs that form decoded the
same way the others were.

## Recommended next step (resolver design)

Build a static resolver `_restore_tools/scripts/control_tower_static_snapshot_resolver.py` that:

1. Reads `ui_recttransforms.csv` filtered to `maininterface.assetbundle` (and the battle
   HUD prefab bundle) for parent / sibling / anchors / pivot / pos / scale / active.
2. Reads `DTSysUIForm` for each form's `UiGroupId` / `DisableUILayer` / `IsLock` / `ShowMode`.
3. Applies the framework formula `sortingOrder = UILayer.BaseOrder[GroupId] + Depth`.
4. Layers `UI_Dock` `initTab` / `setCurrView` / `OnLoadingClosed` rules for steady-state
   active/mask values (default tab = MAIN_PAGE, show_mask=false).
5. Emits filled packets:
   - UI: fill `MAININTERFACE_146_runtime_snapshot_template.json` null leaves.
   - Battle: fill `BATTLE_75_..._APPROVAL_PACKET_TEMPLATE.json` `fieldChecklist[].runtimeValue`
     (which `BATTLE_84` already consumes as `BATTLE_84_ORIGINAL_RUNTIME_SNAPSHOT_FILLED.json`).
6. Re-run `_restore_tools/scripts/control_tower_validate_runtime_snapshot_packets.py`.

Each emitted value must carry a `staticSource` provenance field (csv row id / lua line /
dump.cs line) so it stays inside the no-fake / no-coordinate-only guardrail. Values that
genuinely have no static source stay `null` and are reported as the true residual.

Expected outcome: most rows flip from `runtime_snapshot_required` to source-backed; the
validator's residual should approach its own `runtime_snapshot_required = 15` floor plus
the account/content slice.
