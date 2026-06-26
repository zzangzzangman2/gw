# REFERENCE_MP4_RESTORE_NOTES_20260626_024037

## Source

- Video: `C:\Users\godho\Downloads\참고.mp4`
- Size: `26,278,715 bytes`
- Duration: `121.277823s`
- Resolution/FPS: `1280x570` / `30fps`
- Video codec: `h264`
- Audio codec: `aac`
- Overview contact sheet: `reports\video_reference\reference_overview_10s_contact.jpg`
- Exact 10s frames: `reports\video_reference\reference_frames\frame_000s.jpg` through `frame_120s.jpg`

## Timeline Notes

| time | screen | restore use |
| ---: | --- | --- |
| `0s` | Main/home UI with large character illustration, top currencies, right-side icon stack, bottom navigation, left event/task icons, and speech/event bubble. | MainInterface visual validation only. Do not infer active events without runtime `ActMgr.activitys` snapshot. |
| `10s` | Bright cloud/transition screen. | Low restore value; treat as transition reference. |
| `20s` | Battle starts on burning village stage, large Korean "battle start" overlay, 5 friendly units left, enemy units right, fixed battle HUD visible. | Good battle layout reference. |
| `30s` | Normal attack/hit flash, floating damage/resist text, top HP bars, right auto/speed rail, bottom cards visible. | Good reference for hit feedback and HUD persistence. |
| `40s` | Normal battle idle/attack mix, same stage and HUD. | Good reference for actor placement and spacing. |
| `50s` | Stable normal battle field. | Best reference for baseline battle HUD and actor positions. |
| `60s` | Wave 2 style state with more enemies; bottom cards show "오의" ready overlays/glow. | Good reference for skill-ready card state. |
| `70s` | Skill cut-in close-up over pale background; right auto/speed rail remains visible. | Reference for special-skill cut-in layering. |
| `80s` | Full character cut-in with pink effects; right rail still visible. | Reference for cinematic skill layer. |
| `90s` | Dark/red skill attack stage, top HUD and bottom cards visible, damage/weak text present. | Strong reference for ultimate attack phase and HUD persistence. |
| `100s` | Battle returns to field with enemies cleared; top HUD and bottom cards still visible. | Reference for post-action battle field. |
| `110s` | Dialogue scene in forest with character portrait and dialogue box. | Not battle gameplay; useful only for later story/dialog UI reference. |
| `120s` | Reward popup/result overlay. | Reward/result UI reference, not a battle-control restore target. |

## Battle Restore Implications

- The battle screen is not a static screenshot target. It needs baseline field, actor animation, hit flashes, floating numbers, skill-ready cards, cut-in layers, and result transitions.
- Core fixed HUD elements during battle:
  - Top left/right name, level, portrait, HP bars, centered `VS`, wave/round text.
  - Right vertical controls including `AUTO`, play/skip-like button, and `x2.0`.
  - Bottom-center 5 character cards with readiness overlays and glow states.
- Cut-in phases preserve at least the right rail and often preserve top/bottom HUD layers, so these should not be hidden wholesale during skill playback.
- The 20s, 50s, 60s, and 90s frames are the most useful references for the current battle restoration.

## MainInterface Restore Implications

- The 0s frame confirms the home layout style and density: large character art, top currency bars, right icon cluster, bottom navigation, left activity/task stack, and small event/dialog prompt.
- It does not prove which events should be active in the current restored scene. Active events, redpoints, review visibility, text, and spines must still come from runtime/account evidence.
- This is consistent with `MAININTERFACE_130_RUNTIME_ACTIVITY_SNAPSHOT_IMPORT_REPLAY_PIPELINE_NO_FAKE_PATCH`, which refuses fake default activity state.

## Current Limits

- `참고.mp4` is a visual/motion reference, not executable runtime evidence.
- It cannot supply missing xLua/GameEntry/LuaManager runtime required by BATTLE53.
- It cannot supply account/server runtime activity state required by UI130.
- Do not reproduce recorder/touch overlays or debug artifacts if any appear in source videos.

## Priority Use

1. Use `frame_050s.jpg` as baseline normal battle composition.
2. Use `frame_060s.jpg` for bottom card skill-ready state.
3. Use `frame_090s.jpg` for special attack/cut-in HUD persistence.
4. Use `frame_000s.jpg` as auxiliary main UI visual reference only.
