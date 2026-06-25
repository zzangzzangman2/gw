# Play Reference Video Motion Analysis

## Source
- Video: `C:\Users\godho\Downloads\플레이.mp4`
- Duration: `600.82s`
- Resolution/FPS: `1920x896` / `55.344`
- Motion sample interval: `0.506s`

## Important Restore Notes
- Treat the top-center circular overlay as a recording/touch artifact unless confirmed otherwise.
- Battle restoration must use motion clips for camera shake, attack travel, hit flash, cut-in timing, floating damage, and HUD transitions.
- Do not reproduce debug/log/recording overlays in final scenes.

## High Motion Segments
| rank | start | end | duration | mean motion | max motion | max flash | clip |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| 1 | 89.55 | 91.57 | 2.02 | 0.48959 | 0.87481 | 0.74163 | `C:\Users\godho\Downloads\girlswar\reports\video_reference\clips\battle_motion_clip_01_0088s.mp4` |
| 2 | 147.73 | 151.27 | 3.54 | 0.41117 | 0.68211 | 0.95173 | `C:\Users\godho\Downloads\girlswar\reports\video_reference\clips\battle_motion_clip_02_0146s.mp4` |
| 3 | 381.97 | 382.99 | 1.02 | 0.46318 | 0.64623 | 0.40837 | `C:\Users\godho\Downloads\girlswar\reports\video_reference\clips\battle_motion_clip_03_0380s.mp4` |
| 4 | 421.94 | 422.95 | 1.01 | 0.42136 | 0.5917 | 0.03271 | `C:\Users\godho\Downloads\girlswar\reports\video_reference\clips\battle_motion_clip_04_0420s.mp4` |
| 5 | 487.71 | 488.73 | 1.02 | 0.44238 | 0.57457 | 0.08215 | `C:\Users\godho\Downloads\girlswar\reports\video_reference\clips\battle_motion_clip_05_0486s.mp4` |
| 6 | 501.88 | 503.4 | 1.52 | 0.48171 | 0.56681 | 0.96669 | `C:\Users\godho\Downloads\girlswar\reports\video_reference\clips\battle_motion_clip_06_0500s.mp4` |

## Flash / Cut-In Candidates
| rank | start | end | duration | max flash |
| ---: | ---: | ---: | ---: | ---: |
| 1 | 33.9 | 36.93 | 3.03 | 0.98193 |
| 2 | 502.39 | 502.89 | 0.5 | 0.96669 |
| 3 | 238.29 | 243.35 | 5.06 | 0.94485 |
| 4 | 198.32 | 201.36 | 3.04 | 0.9146 |
| 5 | 90.05 | 90.56 | 0.51 | 0.74163 |
| 6 | 402.72 | 403.22 | 0.5 | 0.73165 |
| 7 | 289.9 | 291.41 | 1.51 | 0.61464 |
| 8 | 407.27 | 408.28 | 1.01 | 0.55112 |
| 9 | 94.1 | 95.62 | 1.52 | 0.50836 |
| 10 | 14.67 | 15.68 | 1.01 | 0.476 |
| 11 | 191.75 | 192.76 | 1.01 | 0.47188 |
| 12 | 509.97 | 510.99 | 1.02 | 0.46644 |

## Outputs
- JSON: `C:\Users\godho\Downloads\girlswar\reports\video_reference\PLAY_REFERENCE_VIDEO_MOTION_ANALYSIS.json`
- Metrics CSV: `C:\Users\godho\Downloads\girlswar\reports\video_reference\play_motion_metrics_0p5s.csv`
- Overview contact sheet: `C:\Users\godho\Downloads\girlswar\reports\video_reference\play_overview_10s_contact.jpg`
- Motion clips: `C:\Users\godho\Downloads\girlswar\reports\video_reference\clips`
