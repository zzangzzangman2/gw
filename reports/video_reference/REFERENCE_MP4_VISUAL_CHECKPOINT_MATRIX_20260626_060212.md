# REFERENCE_MP4_VISUAL_CHECKPOINT_MATRIX_20260626_060212

Generated: 2026-06-26 06:02 KST

## Scope

This report converts `C:\Users\godho\Downloads\참고.mp4` into a visual checkpoint matrix for MainInterface and battle restoration. It is reference-only evidence. It does not approve or perform package import, manifest edit, runtime instrumentation, scene save, file import/copy into Unity assets, xLua patch, handler patch, fake HUD patch, fake actor patch, or coordinate-only success.

## Source Frames

- Video: `C:\Users\godho\Downloads\참고.mp4`
- Video metadata: `1280x570`, `30fps`, `121.277823s`, aspect `2.2456`
- Main reference image: `C:\Users\godho\.codex\attachments\e607fc34-b674-4516-b051-8d396cd6df06\image-1.png`
- Main reference image metadata: `1180x526`, aspect `2.2433`
- Newly sampled 5s frames: `work/reference_video/frames_5s/sample_000.jpg` through `sample_024.jpg`
- Newly sampled contact sheet: `work/reference_video/reference_5s_contact_sheet.jpg`
- Existing reference notes: `reports/video_reference/REFERENCE_MP4_RESTORE_NOTES_20260626_024037.md`

## Critical Aspect Finding

The reference video and reference MainInterface image are both about `2.24:1`. Current battle candidate captures used by BATTLE51/BATTLE54/BATTLE57 are `1920x1080`, aspect `1.7778`.

This means raw pixel coordinates from the reference cannot be compared against current captures until the GameView/camera/render view rect is aspect-correct. If a 1920-wide output is used for a `2.2456` reference aspect, the comparable content height is about `855px`, not `1080px`. Any coordinate patch made against full 16:9 output risks preserving the wrong final state.

The mismatch is not only aspect ratio. In current BATTLE57, the top HUD sits around `y=0.19-0.28` normalized in the 1080p capture, while the reference normal-battle top HUD sits around `y=0.03-0.14` normalized in the 570p frame. Bottom cards in the reference occupy the lower band around `y=0.81-0.99`, while current BATTLE57 mostly shows detached skill labels/glows around `y=0.65-0.79` and lacks the full card frames/icons.

## Visual Checkpoint Matrix

| checkpoint | reference frame/time | reference normalized region | current BATTLE57 observation | project evidence to join | validation target |
|---|---|---:|---|---|---|
| Main home aspect/layout | `sample_000`, `0s`; attached image | full frame aspect `~2.24`; bottom nav `y~0.88-1.00`; top/player/currency bands `y~0.02-0.16` | Not checked in battle capture; UI146 still needs runtime snapshot. | `MAININTERFACE_146_runtime_snapshot_template.json`; UI146 required field matrix | Compare only after approved runtime UI snapshot. Do not infer active events/redpoints from video. |
| Formation screen slots | `sample_003`, `15s` | arena center `x~0.02-0.98`, `y~0.15-0.78`; six left/right slot centers; bottom roster `y~0.82-0.98` | Current battle candidate does not reproduce this screen. | Character roster/actor payload reports; BATTLE54 actors/cards CSV | Use as formation/roster layout reference, not as normal battle coordinate proof. |
| Normal battle top HUD | `sample_004`, `20s`; `sample_007`, `35s`; `sample_012`, `60s` | player/enemy HP and portraits `y~0.03-0.14`; centered `VS`; wave text under center | BATTLE57 top HUD is visually much lower, around upper-middle of 1080p capture. | BATTLE54 routes CSV; BATTLE57 capture; `root_battle/root_top/TopCenter` rows | Fix only via aspect-correct view rect + source-backed RectTransform/Canvas state; no isolated coordinate tweak claim. |
| Right battle control rail | `sample_004`, `20s`; `sample_012`, `60s`; skill frames | `x~0.90-0.96`; `AUTO`/play/`x2.0` stack `y~0.38-0.59`; rail persists through skill overlays | BATTLE57 rail is further right/lower and labels differ (`x1`, skip/new markers); positions reflect different route/state. | BATTLE54 button routes CSV; BATTLE50 decoded Lua button handlers; BATTLE52/BATTLE53 xLua blocker | Must validate route active state, sibling order, and handler binding together. Position alone is not playability. |
| Bottom hero cards | `sample_004`, `20s`; `sample_007`, `35s`; `sample_012`, `60s`; `sample_018`, `90s` | five cards centered `x~0.30-0.71`, `y~0.80-1.00`; card frames/icons remain visible except during some full-screen cut-ins | BATTLE57 shows detached `오의`/`스킬` labels and glows but not full five card frames/icons; only local subset is available. | BATTLE54 hero cards CSV; TMP/text CSV; CHARACTER64 exact `1036` blocker | Need full actor/card payload plus mask/stencil/material/scale validation. No fake card/icon/text filling. |
| Friendly actor formation | normal battle `20-60s` | five friendly units on left: rough field band `x~0.18-0.45`, `y~0.25-0.86`; overlapping but all visible | BATTLE57 has only source-backed local subset actors visible and incorrectly distributed vertically; no complete left formation. | BATTLE57 actor evidence; CHARACTER64 exact `1036` missing; CHARACTER63 unresolved enemies | Actor list cannot be called complete until exact `1036` and unresolved actor chains are source-backed. |
| Enemy actor formation | normal battle `20-60s` | enemy units on right: rough field band `x~0.55-0.82`, `y~0.25-0.82`; wave 2 has more enemies | BATTLE57 shows a limited enemy/actor subset; one actor overlaps top HUD area. | BATTLE54 actor CSV; CHARACTER63/64 actor payload blockers | Validate source-backed enemy ids and formation slots before final battle claim. |
| Skill white/black mask overlay | `sample_013`, `65s` | screen-wide white stage; black silhouettes; right rail stays visible; damage text and HP bars remain above relevant units | Current BATTLE63/64 shows TimelineAsset mismatch; BATTLE65 needs approval for local Timeline package import/test. | BATTLE63/BATTLE64/BATTLE65 reports; TimelineEffect evidence matrix | Treat as mask/stencil/effect overlay validation, not as normal route coordinate reference. |
| Skill cinematic overlay | `sample_015`, `75s`; `sample_018`, `90s` | screen-wide dark/red/pink effects; top/bottom HUD can persist depending on phase; right rail persists | Current project cannot source-evaluate TimelineAsset bindings yet. | BATTLE64 original binding evidence; BATTLE65 local package candidate | Requires Timeline package/type compatibility plus original `TimelineEffect`/PlayableDirector binding. |
| TMP/text visual state | all battle HUD frames | Korean labels are compact, high-contrast, mostly within small HUD elements; no broad overflow in normal frames | BATTLE54 has `65` TMP/text rows, autosize `1/65`, negative spacing rows `15`; current visual placement/text state still differs. | BATTLE54 TMP/text CSV; BATTLE50 decoded Lua text paths | Validate font/material/autosize/scale after correct view aspect and route state; do not patch text by screenshot. |

## Root Cause Split Updated From Video

1. Aspect/view-rect mismatch is a first-order blocker for any coordinate comparison: reference `~2.24:1`, current battle captures `16:9`.
2. HUD route placement is also wrong after accounting for aspect: current top HUD appears too low and bottom card visuals are not assembled as in the reference.
3. Actor visibility is a local-subset state, not a complete roster state: BATTLE57 proves some source-backed actor pixels, but not full reference formation.
4. Skill visual playback is blocked by Timeline type/binding/runtime gaps, not only missing particles.
5. MainInterface video confirms visual density and aspect, but does not supply runtime activity/redpoint/account state; UI146 snapshot gate still stands.

## Safe Next Validation Rules

- Normalize every reference comparison to a `2.24:1` render area before evaluating coordinates.
- Validate `route active state + sibling order + mask/stencil + TMP scale/autosize` as a bundle; any single-axis coordinate pass is insufficient.
- Use `sample_007`/`35s` and `sample_012`/`60s` as normal-battle layout references.
- Use `sample_013`/`65s`, `sample_015`/`75s`, and `sample_018`/`90s` only as skill overlay and Timeline/mask/stencil references.
- Keep `참고.mp4` auxiliary. It cannot replace missing original xLua/GameEntry/LuaManager, exact actor bundles, or approved runtime UI snapshots.

