# MainInterface GuildMain Custom Component Type Reconstruction Result

Generated: 2026-06-25 18:56:27 KST

## Verdict

Not normal. The custom type stubs/proxies reduced missing script objects, but `UI_GuildMain` still renders as a large white/bright panel. This remains a partial reconstruction, not a visually correct GuildMain UI.

## Visual Metrics

| Metric | 108 baseline | 109 after type stubs |
| --- | ---: | ---: |
| Whiteish visible ratio | `0.8171147704124451` | `0.8221056461334229` |
| Large white visible Images | `19` | `21` |
| White no-sprite Images | `78` | `444` |
| Missing Image sprites | `152` | `518` |
| Missing script objects | `881` | `170` |
| Missing script object reduction | `` | `711` |
| Screen looks normal | `False` | `False` |

## Stub / Proxy Result

- Stub/proxy class definitions added: `20`
- Stub/proxy component types now present in instantiated `UI_GuildMain`: `7`
- Top white blocker remaining missing script count: `0`

| Recovered type | Instantiated count | Original evidence |
| --- | ---: | --- |
| `YouYou.YouYouImage` | `640` | `Assembly-CSharp.dll` pathID `1242602534869556086`, original refs `931` |
| `LuaComponentBinder.LuaComBinder` | `58` | `Assembly-CSharp.dll` pathID `1924290018182821150`, original refs `107` |
| `YouYou.LuaForm` | `1` | `Assembly-CSharp.dll` pathID `8347263561838679580`, original refs `23` |
| `YouYou.YouYouCanvasHelper` | `7` | `Assembly-CSharp.dll` pathID `2150366434557054024`, original refs `31` |
| `YouYou.UISpineCtr` | `47` | `Assembly-CSharp.dll` pathID `-8877758280253173385`, original refs `67` |
| `SuperScrollView.LoopListView2` | `1` | `Assembly-CSharp.dll` pathID `-3254468290337994374`, original refs `3` |
| `SuperScrollView.LoopStaggeredGridView` | `0` | `Assembly-CSharp.dll` pathID `-8634314620412448528`, original refs `11` |
| `UnityEngine.UI.Empty4Raycast` | `1` | `Assembly-CSharp.dll` pathID `-2324043793906593294`, original refs `5` |

## Original MonoScript Evidence

| Type | Assembly | Script pathID | Original component refs | 109 action |
| --- | --- | ---: | ---: | --- |
| `UnityEngine.UI.Image` | `UnityEngine.UI.dll` | `-7030229213176759517` | `1558` | trace-only |
| `YouYou.YouYouImage` | `Assembly-CSharp.dll` | `1242602534869556086` | `931` | stub/proxy added |
| `TMPro.TextMeshProUGUI` | `Unity.TextMeshPro.dll` | `-5755350681981302373` | `637` | trace-only |
| `UnityEngine.UI.Button` | `UnityEngine.UI.dll` | `-787143586316466668` | `389` | trace-only |
| `Spine.Unity.SkeletonGraphic` | `spine-unity.dll` | `-6938409698251234290` | `172` | trace-only: external assembly name |
| `UnityEngine.UI.Text` | `UnityEngine.UI.dll` | `-7978266203517415465` | `161` | trace-only |
| `UnityEngine.UI.ContentSizeFitter` | `UnityEngine.UI.dll` | `-5392852106782294089` | `161` | trace-only |
| `LuaComponentBinder.LuaComBinder` | `Assembly-CSharp.dll` | `1924290018182821150` | `107` | stub/proxy added |
| `YouYou.UISpineCtr` | `Assembly-CSharp.dll` | `-8877758280253173385` | `67` | stub/proxy added |
| `Coffee.UIExtensions.UIParticle` | `Coffee.UIParticle.dll` | `-7396295067816475631` | `64` | trace-only: external assembly name |
| `Spine.Unity.SkeletonSubmeshGraphic` | `spine-unity.dll` | `5804373309048859138` | `52` | trace-only: external assembly name |
| `UnityEngine.UI.GraphicRaycaster` | `UnityEngine.UI.dll` | `8390977652835490180` | `46` | trace-only |
| `YouYou.YouYouCanvasHelper` | `Assembly-CSharp.dll` | `2150366434557054024` | `31` | stub/proxy added |
| `UnityEngine.UI.CanvasScaler` | `UnityEngine.UI.dll` | `-8797238614672040712` | `30` | trace-only |
| `UnityEngine.UI.Mask` | `UnityEngine.UI.dll` | `-7784299604066853536` | `29` | trace-only |
| `YouYou.FullscreenCenter` | `Assembly-CSharp.dll` | `9044316936709120141` | `24` | stub/proxy added |
| `YouYou.LuaForm` | `Assembly-CSharp.dll` | `8347263561838679580` | `23` | stub/proxy added |
| `UnityEngine.UI.ScrollRect` | `UnityEngine.UI.dll` | `-8826248144273319766` | `18` | trace-only |
| `UnityEngine.UI.HorizontalLayoutGroup` | `UnityEngine.UI.dll` | `-8091456346061954500` | `15` | trace-only |
| `UnityEngine.UI.VerticalLayoutGroup` | `UnityEngine.UI.dll` | `348253180598357110` | `12` | trace-only |
| `SuperScrollView.LoopStaggeredGridView` | `Assembly-CSharp.dll` | `-8634314620412448528` | `11` | stub/proxy added |
| `UnityEngine.UI.InputField` | `UnityEngine.UI.dll` | `-6449259990898891853` | `8` | trace-only |
| `YouYou.UIEventListener` | `Assembly-CSharp.dll` | `-6333827617915679503` | `6` | stub/proxy added |
| `UnityEngine.UI.Toggle` | `UnityEngine.UI.dll` | `9006062995516675145` | `5` | trace-only |

## Top White Blockers After 109

| Path | Missing scripts | Image type | Sprite | MonoBehaviour types |
| --- | ---: | --- | --- | --- |
| `UI_GuildMain_NavigationPrototype/bg_beijingtu` | `0` | `UnityEngine.UI.Image` | `noalphabg_BG_Guid` | `UnityEngine.UI.Image;YouYou.FullscreenCenter` |
| `UI_GuildMain_NavigationPrototype/left/bg_ditu` | `0` | `UnityEngine.UI.Image` | `` | `UnityEngine.UI.Image` |
| `UI_GuildMain_NavigationPrototype/left/btn_zhaomu` | `0` | `UnityEngine.UI.Image` | `icon_zm` | `UnityEngine.UI.Button;UnityEngine.UI.Image` |
| `UI_GuildMain_NavigationPrototype/middle/Image` | `0` | `UnityEngine.UI.Image` | `guild_tmqj` | `UnityEngine.UI.Image` |
| `UI_GuildMain_NavigationPrototype/middle/node_gonggao/gongao_bg` | `0` | `UnityEngine.UI.Image` | `T_Marquee_Bg_1` | `UnityEngine.UI.Image` |
| `UI_GuildMain_NavigationPrototype/middle/node_gonggao/gongao_bg/gonggaoMask` | `0` | `UnityEngine.UI.Image` | `` | `UnityEngine.UI.Image;UnityEngine.UI.Mask` |
| `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport` | `0` | `UnityEngine.UI.Image` | `UIMask` | `UnityEngine.UI.Image;UnityEngine.UI.Mask` |
| `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa1/Boxicon` | `0` | `UnityEngine.UI.Image` | `IC_baoxiang_6` | `UnityEngine.UI.Button;UnityEngine.UI.Image` |
| `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa1/bg_ditu` | `0` | `UnityEngine.UI.Image` | `T_tianxiazhengba` | `UnityEngine.UI.Image` |
| `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa1/bg_name` | `0` | `UnityEngine.UI.Image` | `T_biaoti_zhengba` | `UnityEngine.UI.Image` |
| `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa1/p_curr_state/bg_msg` | `0` | `UnityEngine.UI.Image` | `BG_zidi_hong` | `UnityEngine.UI.Image` |
| `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa1/p_open/llv_skycity_self_city/Viewport` | `0` | `UnityEngine.UI.Image` | `UIMask` | `UnityEngine.UI.Image;UnityEngine.UI.Mask` |
| `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa1/p_open/llv_skycity_self_city/Viewport/Content/cityitem/im_city` | `0` | `YouYou.YouYouImage` | `btn_S1_city_3` | `YouYou.YouYouImage` |
| `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa1/p_open/llv_skycity_self_city/Viewport/Content/cityitem/im_city_state` | `0` | `YouYou.YouYouImage` | `jtcz_xzjs9` | `YouYou.YouYouImage` |
| `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa1/p_open/llv_skycity_self_city/node_battle/im_battle` | `0` | `YouYou.YouYouImage` | `` | `YouYou.YouYouImage` |
| `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa1/starts/im_start2` | `0` | `UnityEngine.UI.Image` | `T_xingxing` | `UnityEngine.UI.Image` |
| `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa1/starts/im_start4` | `0` | `UnityEngine.UI.Image` | `T_xingxing` | `UnityEngine.UI.Image` |
| `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa2/bg_name/im_name` | `0` | `UnityEngine.UI.Image` | `T_biaoti_baoxiang` | `UnityEngine.UI.Image` |
| `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa2/p_open/btn_titan_set` | `0` | `UnityEngine.UI.Image` | `` | `UnityEngine.UI.Button;UnityEngine.UI.Image` |
| `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa2/titan_bg` | `0` | `UnityEngine.UI.Image` | `T_baoxiangniang` | `UnityEngine.UI.Button;UnityEngine.UI.ContentSizeFitter;UnityEngine.UI.Image` |
| `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa2/titan_boxicon` | `0` | `UnityEngine.UI.Image` | `wjczbx3` | `UnityEngine.UI.Button;UnityEngine.UI.Image` |
| `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa2/titan_status/bg_msg` | `0` | `UnityEngine.UI.Image` | `BG_zidi_lan` | `UnityEngine.UI.Image` |
| `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa3/bg_ditu` | `0` | `UnityEngine.UI.Image` | `T_tongmenghezhan` | `UnityEngine.UI.Image` |
| `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa3/bg_name/im_name` | `0` | `UnityEngine.UI.Image` | `T_biaoti_hezhan` | `UnityEngine.UI.Image` |
| `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa3/box` | `0` | `UnityEngine.UI.Image` | `wjczbx3` | `UnityEngine.UI.Button;UnityEngine.UI.Image` |
| `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa3/new_no_open/bg_msg` | `0` | `UnityEngine.UI.Image` | `BG_zidi_cheng` | `UnityEngine.UI.Image` |
| `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa4/Boxicon` | `0` | `UnityEngine.UI.Image` | `wjczbx3` | `UnityEngine.UI.Button;UnityEngine.UI.Image` |
| `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa4/bg_ditu` | `0` | `UnityEngine.UI.Image` | `T_juntuanshilian` | `UnityEngine.UI.Image` |
| `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa4/bg_name/im_name` | `0` | `UnityEngine.UI.Image` | `T_biaotizi_tongmengshilian` | `UnityEngine.UI.Image` |
| `UI_GuildMain_NavigationPrototype/middle/root_wanfa/Viewport/ContentWanfa/btn_wanfa6/Boxicon` | `0` | `UnityEngine.UI.Image` | `wjczbx3` | `UnityEngine.UI.Button;UnityEngine.UI.Image` |

## Interpretation

- `YouYouImage` and other Assembly-CSharp custom component types now resolve as real components where Unity can bind the original script reference.
- The visual white panel did not improve, which means the main blocker is no longer simply missing C# type names.
- `UI_GuildMainView.OnOpen` still is not being executed with game runtime data, so layout rebuild, active-state gates, red points, guild data sprites, marquee/mask behavior, and scroll sizing remain uninitialized.
- External assembly components such as Spine/Coffee UIParticle/DOTween remain trace-only because their original assembly names are not safely reconstructed in this Unity project yet.

## Verification

- Report JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\maininterface_guildmain_custom_component_type_reconstruction.json`
- Report CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_guildmain_custom_component_type_reconstruction.csv`
- Original MonoScript counts CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_guildmain_original_monoscript_type_counts.csv`
- Capture: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreCaptures\guildmain_custom_component_type_reconstruction\UI_GuildMain_1680x720.png`
- Click validation generatedAt: `2026-06-25 18:56:26`
- Active / clickable / blocked / invoked: `24` / `24` / `0` / `24`

## Next Recommendation

Next: `GuildMain Lua runtime harness for UI_GuildMainView.OnOpen data/layout initialization`.
