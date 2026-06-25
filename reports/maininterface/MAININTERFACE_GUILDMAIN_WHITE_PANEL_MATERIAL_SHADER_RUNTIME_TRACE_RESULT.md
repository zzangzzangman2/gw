# MainInterface GuildMain White Panel Material Shader Runtime Trace Result

Generated: 2026-06-25 18:28:24 KST

## Verdict

Not normal. The `UI_GuildMain` target still renders as a large white/bright panel even after sprite references were joined. The 106 step reduced null Sprite counts, but visual quality remains partial/failing by capture metrics.

## Visual Metrics

| Metric | Before 107 | 107 trace |
| --- | ---: | ---: |
| Whiteish visible ratio | `0.8171147704124451` | `0.8171147704124451` |
| Whiteish pixels | `988382` | `988382` |
| White no-sprite Images | `78` | `78` |
| Missing Image sprites | `152` | `152` |
| Large white visible Images | `` | `19` |
| Missing script objects | `881` | `881` |
| Screen looks normal | `` | `False` |

## Cause Split

| Class | Count |
| --- | ---: |
| `resolved_sprite_but_white_render_or_covered` | `41` |
| `no_sprite` | `8` |
| `runtime_bound` | `1` |

## Top Visible White Images

| Rank | Path | Sprite | White ratio | Pixels | Material / Shader | Source PNG white | Class |
| ---: | --- | --- | ---: | ---: | --- | ---: | --- |
| `1` | `UI_GuildMain_NavigationPrototype/bg_beijingtu` | `noalphabg_BG_Guid` | `0.9681` | `408918` | `Default UI Material` / `UI/Default` | `` | `resolved_sprite_but_white_render_or_covered` |
| `2` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport` | `UIMask` | `0.9680` | `321580` | `Default UI Material` / `UI/Default` | `` | `resolved_sprite_but_white_render_or_covered` |
| `3` | `UI_GuildMain_NavigationPrototype/middle/Image` | `guild_tmqj` | `1.0000` | `94022` | `Default UI Material` / `UI/Default` | `0.0036` | `resolved_sprite_but_white_render_or_covered` |
| `4` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa2/titan_bg` | `T_baoxiangniang` | `1.0000` | `49956` | `Default UI Material` / `UI/Default` | `` | `resolved_sprite_but_white_render_or_covered` |
| `5` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa8/bg_ditu` | `lsmj_rukou` | `1.0000` | `49404` | `Default UI Material` / `UI/Default` | `0.1681` | `resolved_sprite_but_white_render_or_covered` |
| `6` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa6/bg_ditu` | `huachuanbisairukou` | `1.0000` | `49404` | `Default UI Material` / `UI/Default` | `0.1103` | `resolved_sprite_but_white_render_or_covered` |
| `7` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa3/bg_ditu` | `T_tongmenghezhan` | `1.0000` | `49404` | `Default UI Material` / `UI/Default` | `0.1737` | `resolved_sprite_but_white_render_or_covered` |
| `8` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa1/bg_ditu` | `T_tianxiazhengba` | `1.0000` | `49404` | `Default UI Material` / `UI/Default` | `0.0763` | `resolved_sprite_but_white_render_or_covered` |
| `9` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa7/img_award_cup2` | `T_yanchang3` | `1.0000` | `49404` | `Default UI Material` / `UI/Default` | `0.1572` | `resolved_sprite_but_white_render_or_covered` |
| `10` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa7/img_award_cup` | `T_yanchang1` | `1.0000` | `49404` | `Default UI Material` / `UI/Default` | `0.1632` | `resolved_sprite_but_white_render_or_covered` |
| `11` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa7/img_award_preheat` | `T_yanchangx` | `1.0000` | `49404` | `Default UI Material` / `UI/Default` | `0.1723` | `resolved_sprite_but_white_render_or_covered` |
| `12` | `UI_GuildMain_NavigationPrototype/middle/node_gonggao/gongao_bg/gonggaoMask` | `` | `1.0000` | `23142` | `Default UI Material` / `UI/Default` | `` | `runtime_bound` |
| `13` | `UI_GuildMain_NavigationPrototype/middle/node_gonggao/gongao_bg` | `T_Marquee_Bg_1` | `0.9358` | `17136` | `Default UI Material` / `UI/Default` | `` | `resolved_sprite_but_white_render_or_covered` |
| `14` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa4/bg_ditu` | `T_juntuanshilian` | `0.5842` | `11448` | `Default UI Material` / `UI/Default` | `0.1832` | `resolved_sprite_but_white_render_or_covered` |
| `15` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa1/p_open/llv_skycity_self_city/Viewport` | `UIMask` | `1.0000` | `9394` | `Default UI Material` / `UI/Default` | `` | `resolved_sprite_but_white_render_or_covered` |
| `16` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa8/box` | `wjczbx3` | `1.0000` | `6300` | `Default UI Material` / `UI/Default` | `0.0379` | `resolved_sprite_but_white_render_or_covered` |
| `17` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa6/Boxicon` | `wjczbx3` | `1.0000` | `6300` | `Default UI Material` / `UI/Default` | `0.0379` | `resolved_sprite_but_white_render_or_covered` |
| `18` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa3/box` | `wjczbx3` | `1.0000` | `6300` | `Default UI Material` / `UI/Default` | `0.0379` | `resolved_sprite_but_white_render_or_covered` |
| `19` | `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa2/titan_boxicon` | `wjczbx3` | `1.0000` | `6230` | `Default UI Material` / `UI/Default` | `0.0379` | `resolved_sprite_but_white_render_or_covered` |
| `20` | `UI_GuildMain_NavigationPrototype/right/btn_6` | `` | `1.0000` | `4392` | `Default UI Material` / `UI/Default` | `` | `no_sprite` |

## Evidence Interpretation

- Joined-before rows among top visible white list: `15`.
- Resolved sprite but still white/bright rows: `41`.
- No-sprite/runtime-bound rows in top list: `9`.
- The dominant material/shader on traced rows remains default UI rendering; no confirmed custom material/shader replacement was found in this pass.
- Several joined source sprites are not fully white in their exported PNGs, so the remaining white panel cannot be called solved by sprite join alone.
- Runtime-bound rows with original `m_Sprite=0` were not guessed; they need Lua/XLua or custom script/type reconstruction evidence.

## Material / Shader Counts

| Name | Count |
| --- | ---: |
| shader `UI/Default` | `50` |
| material `Default UI Material` | `50` |

## Verification

| Check | Result |
| --- | --- |
| Trace JSON | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_guildmain_white_panel_material_shader_runtime_trace.json` |
| Trace CSV | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_guildmain_white_panel_material_shader_runtime_trace.csv` rows=`50` |
| Capture | `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\guildmain_white_panel_trace\UI_GuildMain_1680x720.png` |
| Contact sheet | `C:\Users\godho\Downloads\girlswar\reports\maininterface\GUILDMAIN_WHITE_PANEL_TRACE_CONTACT_SHEET.jpg` |
| Click validation generatedAt | `2026-06-25 18:28:23` |
| Active / clickable / blocked / invoked | `24` / `24` / `0` / `24` |
| Tool | `C:\Users\godho\Downloads\girlswar\_restore_tools\107_TRACE_GUILDMAIN_WHITE_PANEL_MATERIAL_SHADER_RUNTIME.cmd` |

## Fix Applied

No material/shader/color/type fix was applied in this pass. The trace found evidence of unresolved runtime/custom script behavior, but not a safe material or tint override that would preserve original hierarchy and rendering semantics.

## Next Recommendation

Next: `target runtime Lua/XLua initialization trace`