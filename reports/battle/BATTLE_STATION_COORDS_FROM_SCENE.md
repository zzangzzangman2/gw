# Battle station coordinates — extracted from gamescene_normalbattle.assetbundle

Source (authoritative, NOT hardcoded): `download/scenes/normalscene/gamescene_normalbattle.assetbundle`
parsed via UnityPy. Hierarchy: `NormalBattleCtrl(0,-1.51) > OurTeam(local -4,-1.05 = world -4.0,-2.56)`
and `EnemyTeam(local 4,-1.05 = world 4.0,-2.56)`; each has `BattleStation_1..9` children.

World position = team_root_world + station_local. Hero formation `position N` -> `BattleStation_N`.

## OurTeam (world = -4.0,-2.56 + local)  — all x NEGATIVE (left)
| pos | local (x,y,z) | WORLD (x,y) |
|----|----|----|
| 1 | (1.644, 1.25, 0.9)   | (-2.356, -1.31) |
| 2 | (0.11, 0.15, -0.1)   | (-3.890, -2.41) |
| 3 | (1.644, -0.84, -1.1) | (-2.356, -3.40) |
| 4 | (-1.319, 1.56, 1.0)  | (-5.319, -1.00) |
| 5 | (-2.649, 0.15, 0.0)  | (-6.649, -2.41) |
| 6 | (-1.758, -1.12, -1.0)| (-5.758, -3.68) |
| 7 | (-4.12, 0.64, 1.0)   | (-8.120, -1.92) |
| 8 | (-2.91, 1.64, 0.9)   | (-6.910, -0.92) |
| 9 | (-3.8, -0.858, -0.1) | (-7.800, -3.418) |

## EnemyTeam (world = 4.0,-2.56 + local) — all x POSITIVE (right), mirrored
| pos | WORLD (x,y) |
|----|----|
| 1 | (2.351, -1.31) |
| 2 | (3.890, -2.41) |
| 3 | (2.351, -3.40) |
| 4 | (5.319, -1.00) |
| 5 | (6.608, -2.41) |
| 6 | (5.758, -3.68) |
| 7 | (8.120, -1.92) |
| 8 | (6.910, -0.92) |
| 9 | (7.800, -3.418) |

Notes: 9-slot (3x3 perspective) grid. Front cluster (pos 1/2/3) x≈-2.4~-3.9; back (pos 7/8/9) x≈-7~-8.
z encodes draw depth. Camera should center x=0, frame ≈ x[-8.5,8.5] (orthoSize ~3.8 @ 1280x570).
