# Play Reference Restore Notes

## Source
- Video: `C:\Users\godho\Downloads\플레이.mp4`
- Motion analysis: `C:\Users\godho\Downloads\girlswar\reports\video_reference\PLAY_REFERENCE_VIDEO_MOTION_ANALYSIS.md`
- Metrics CSV: `C:\Users\godho\Downloads\girlswar\reports\video_reference\play_motion_metrics_0p5s.csv`
- Motion clips: `C:\Users\godho\Downloads\girlswar\reports\video_reference\clips`
- Overview contact sheet: `C:\Users\godho\Downloads\girlswar\reports\video_reference\play_overview_10s_contact.jpg`

## Recording Artifact
- A top-center circular overlay is visible across battle, menus, cut-ins, and result screens.
- Treat it as a recording/touch artifact and do not reproduce it in restored UI unless the user confirms it is in-game UI.

## Battle Motion Requirements
- Battle is side-view with fixed HUD layers over animated character/effect layers.
- Top HUD: left/right actor HP/name/level area with centered VS/round state. It remains visible during many normal battle moments.
- Bottom HUD: skill/actor cards sit near the lower center and change highlight/availability during battle.
- Right rail: vertical controls such as speed/auto/skip/settings-like buttons stay fixed through normal battle and many attack/cut-in moments.
- Damage/heal/floating numbers appear at hit points and drift/fade; they are not static labels.
- Special attacks use full-screen or near full-screen cut-in layers, dark/red/white flash frames, and camera/effect motion. The restored battle cannot be judged by a single still capture.
- Hit moments include strong brightness spikes and screen/effect shake. These must be validated with short clips or frame sequences.
- Do not reproduce debug/log overlays in final battle screens.

## High-Priority Motion Clip References
- `battle_motion_clip_01_0088s.mp4`: dark/blue projectile-hit sequence with floating damage.
- `battle_motion_clip_02_0146s.mp4`: bright character cut-in/flash sequence.
- `battle_motion_clip_03_0380s.mp4`: red/black special-skill stage/cut-in.
- `battle_motion_clip_05_0486s.mp4`: normal battle field with fixed top/bottom/right HUD.
- `battle_motion_clip_06_0500s.mp4`: full-width beam/flash hit sequence.

## UI / Menu Reference Notes
- The video includes battle result/reward panels, stage/clear panels, dialogue panels, and main/home UI near the later section.
- Use these as visual rhythm and transition references, but do not use the recorder overlay as evidence.
- MainInterface target pages should still be restored from original prefab/asset evidence first. Video is a validation reference for visual priority, transition order, and what should be visible together.

## Next Restore Use
- Battle thread: use this video before BATTLE_19 motion/HUD validation. BATTLE_18 should still focus on resolving missing UI component types first.
- UI thread: after navigation target missing-script/sprite trace, use video to prioritize visible pages and transition states that actually appear in player flow.
