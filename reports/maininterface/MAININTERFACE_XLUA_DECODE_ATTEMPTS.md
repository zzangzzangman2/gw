# MainInterface xLua decode 실험

## 요약

- 테스트한 TextAsset: `36`
- Asset CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_xlua_textasset_raw.csv`
- 실험 row: `720`
- `DecryptByteArray` magic branch 진입 asset: `0`
- Lua-like 최종 결과: `36`
- `SoketKey`: `66 78 16 18 58 06 77 58`
- `ass`: `24 FA 49 9B 10 8D 62 59 29 26 81 67 4B F7 91 EB 36 1F 78 07 49 CA 35 A2 37 D7 B0 A6 49 D3 31 D5 9A 5B 46 86 14 FF 21 CB BC 63 BA 1C 49 FC 94 2F F8 35 D9 46 1F 15 2B 2F 37 54 9D CC 44 D9 77 C4`
- `SecurityUtil.xorScale`: `2D 42 26 37 17 FE 09 A5 5A 13 29 2D C9 3A 37 25 FE B9 A5 A9 13 AB`

## 해석

- MainInterface xLua TextAsset은 native `0C 07 08 0D 0B 09` magic이 아니라 `A-EV` 또는 `K7HT`로 시작한다.
- `LuaManager.GetLuaBuff`는 TextAsset bytes를 읽은 뒤 `/DataTable/`, `/Proto/`가 아니면 `YouYouUtil.SecurityUtil.Xor`를 적용한다.
- `SecurityUtil.Xor`는 `xorScale[i % 22]` 반복 XOR이며, `xorScale`은 IL2CPP `.cctor` 정적 배열에서 회수했다.
- 이 리포트는 raw fallback, GetLuaBuff SecurityUtil.Xor, prefix strip, zlib/gzip, 회수 키 기반 XXTEA, XOR probe를 재현 가능하게 기록한다.

## Asset별 최고 점수 시도

| Asset | Prefix | 최고 점수 시도 | 분류 | 점수 | Preview |
|---|---|---|---:|---:|---|
| `Bubbles` | `A-EV` | `security_xor_raw` | `lua_like_text` | `168` | `local e=Class("Bubbles",{})\ne.ShowMap={}\ne.ShowInst=nil\ne.GTimer=nil\nfunction e.Refresh()\nif PlayerMgr.loginLoadCom` |
| `MainPageLimitMgr` | `A-EV` | `security_xor_raw` | `lua_like_text` | `192` | `local o=require('DataNode/DataTable/Create/worldMap/DTMainLimitTimeDBModel')\nlocal i=require('DataNode/DataTable/Create` |
| `MainPageMgr` | `A-EV` | `security_xor_raw` | `lua_like_text` | `168` | `local e={\nwarnDids={},\nisCheckPopView=true,\nisFormEarthRoot=false,\nplayMainMapId=102002,\nplayMainSaveId=10200201,\n` |
| `UIGoldAllChangeHint` | `A-EV` | `security_xor_raw` | `lua_like_text` | `155` | `local o=require("DataNode/DataManager/DataMgr/DataUtil")\nlocal e=nil\nlocal t=0\nfunction OnInit(a,a)\nbtn_ok.onClick:A` |
| `UI_AdventureInterface` | `A-EV` | `security_xor_raw` | `lua_like_text` | `192` | `local e=require('DataNode/DataTable/Create/player/DTHeadDBModel')\nlocal e=require('DataNode/DataTable/Create/player/DTL` |
| `UI_Adventure_Item` | `A-EV` | `security_xor_raw` | `lua_like_text` | `180` | `local e={\n}\nfunction e:New(t)\nlocal e={\ntrans=nil,\nind=0,\nicon=nil,\ntips_trans=nil,\nname_trans=nil,\ntime_trans=` |
| `UI_Adventure_Item_New` | `A-EV` | `security_xor_raw` | `lua_like_text` | `180` | `local e={\n}\nfunction e:New(t)\nlocal e={\ntrans=nil,\nind=0,\nbg=nil,\nredPoint_trans=nil,\ntime_trans=nil,\ncondition` |
| `UI_Adventure_RootView` | `A-EV` | `security_xor_raw` | `lua_like_text` | `204` | `local e=require('DataNode/DataTable/Create/player/DTHeadDBModel')\nlocal e=require('DataNode/DataTable/Create/player/DTL` |
| `UI_BgSet` | `A-EV` | `security_xor_raw` | `lua_like_text` | `168` | `local e=require("DataNode/DataTable/Create/hero/DTHeroDBModel")\nlocal e=require("DataNode/DataTable/Create/player/DTPro` |
| `UI_CDKExchange` | `K7HT` | `security_xor_raw` | `lua_like_text` | `192` | `function OnInit(e,e)\nImage.onClick:AddListener(closeUI)\ninputAcc.onValueChanged:AddListener(function(e)\nif e then\nen` |
| `UI_ChangeAccExplain` | `A-EV` | `security_xor_raw` | `lua_like_text` | `156` | `local e\nfunction OnInit(e,e)\nself:AddBtnClickListener(Image,closeUI)\nself:AddBtnClickListener(btn_fanhui,closeUI)\nse` |
| `UI_ChangeAccSet` | `K7HT` | `security_xor_raw` | `lua_like_text` | `168` | `function OnInit(e,e)\nImage.onClick:AddListener(closeUI)\nbtn_fanhui.onClick:AddListener(closeUI)\nbtn_queren.onClick:Ad` |
| `UI_ChangeAccSetSelect` | `A-EV` | `security_xor_raw` | `lua_like_text` | `168` | `local e\nfunction OnInit(e,e)\nself:AddBtnClickListener(Image,closeUI)\nself:AddBtnClickListener(btn_mail,btnMail)\nself` |
| `UI_ChapterCityShow` | `A-EV` | `security_xor_raw` | `lua_like_text` | `204` | `local a=require('Common/cs_coroutine')\nlocal e\nlocal t=false\nfunction OnInit(e,e)\nbtn_mainPlay.onClick:AddListener(f` |
| `UI_CostHCConfirm` | `A-EV` | `security_xor_raw` | `lua_like_text` | `168` | `local t\nlocal o\nlocal e\nfunction OnInit(t,t)\nImage.onClick:AddListener(closeUI)\nbtn_fanhui.onClick:AddListener(clos` |
| `UI_CostHCConfirm2` | `A-EV` | `security_xor_raw` | `lua_like_text` | `168` | `local a\nlocal o\nlocal t\nfunction OnInit(e,e)\nImage.onClick:AddListener(closeUI)\nbtn_fanhui.onClick:AddListener(clos` |
| `UI_CostSecondSureView` | `A-EV` | `security_xor_raw` | `lua_like_text` | `168` | `local a\nlocal o\nlocal t\nfunction OnInit(e,e)\nImage.onClick:AddListener(closeUI)\nbtn_fanhui.onClick:AddListener(clos` |
| `UI_DeleteHint` | `A-EV` | `security_xor_raw` | `lua_like_text` | `180` | `local e=1\nlocal t=3\nfunction OnInit(e,e)\nself:AddBtnClickListener(Image,closeUI)\nself:AddBtnClickListener(btn_cancel` |
| `UI_Dock` | `A-EV` | `security_xor_raw` | `lua_like_text` | `168` | `local e=require('DataNode/DataTable/Create/dragon/DTDragonStageDBModel')\nlocal e=require("DataNode/DataTable/Create/con` |
| `UI_Flower_Complete_Tips` | `A-EV` | `security_xor_raw` | `lua_like_text` | `192` | `local m=require('DataNode/DataTable/Create/flower/DTFlowerJumpDBModel')\nlocal e=nil\nlocal t=nil\nlocal i=0\nlocal r=0\` |
| `UI_GameExplain` | `K7HT` | `security_xor_raw` | `lua_like_text` | `156` | `function OnInit(e,e)\nImage.onClick:AddListener(closeUI)\nbtn_queding.onClick:AddListener(closeUI)\nend\nfunction OnOpen` |
| `UI_GameFuncTipView` | `A-EV` | `security_xor_raw` | `lua_like_text` | `192` | `local e=require('DataNode/DataTable/Create/item/DTItemDBModel')\nlocal e=require("DataNode/DataTable/Create/constant/DTB` |
| `UI_GameSettings` | `A-EV` | `security_xor_raw` | `lua_like_text` | `180` | `local e\nlocal t\nlocal a\nfunction OnInit(o,o)\nImage.onClick:AddListener(btnColse)\ntoggle_ui_set_30.onValueChanged:Ad` |
| `UI_GoldChange` | `A-EV` | `security_xor_raw` | `lua_like_text` | `192` | `local e=require('DataNode/DataTable/Create/shop/DTExchangeGoldDBModel')\nlocal o=require('DataNode/DataTable/Create/vip/` |
| `UI_HeadSet` | `A-EV` | `security_xor_raw` | `lua_like_text` | `168` | `local j=require('DataNode/DataTable/Create/player/DTHeadDBModel')\nlocal m=require("DataNode/DataTable/Create/hero/DTHer` |
| `UI_HeroSmallTheater` | `A-EV` | `security_xor_raw` | `lua_like_text` | `204` | `local h=require("DataNode/DataTable/Create/hero/DTHeroDBModel")\nlocal a=nil\nlocal t=nil\nlocal e=""\nlocal l=false\nlo` |
| `UI_JingjiFrame_View` | `A-EV` | `security_xor_raw` | `lua_like_text` | `192` | `local e=require('DataNode/DataTable/Create/function/DTFunctionDBModel')\nlocal f=require("DataNode/DataManager/DataMgr/D` |
| `UI_Line_Show` | `A-EV` | `security_xor_raw` | `lua_like_text` | `168` | `local e=nil\nlocal t=false\nlocal a=nil\nfunction OnInit(e,e)\nbg.onClick:AddListener(function()\nt=true\nGameTools.Clos` |
| `UI_MainPage` | `A-EV` | `security_xor_raw` | `lua_like_text` | `192` | `local ce=require("DataNode/DataTable/Create/player/DTLevelUpDBModel")\nlocal ge=require("DataNode/DataTable/Create/harem` |
| `UI_MainPageActItem` | `A-EV` | `security_xor_raw` | `lua_like_text` | `216` | `local e=Class("UI_MainPageActItem",{})\nlocal i=require("DataNode/DataManager/DataMgr/ActCfgData")\nfunction e:Create(t,` |
| `UI_MainPageFaceActItem` | `A-EV` | `security_xor_raw` | `lua_like_text` | `204` | `local e=Class("UI_MainPageFaceActItem",{})\nlocal o=require("DataNode/DataManager/DataMgr/ActCfgData")\nfunction e:Creat` |
| `UI_NormalSet` | `A-EV` | `security_xor_raw` | `lua_like_text` | `168` | `local l=require('DataNode/DataTable/Create/player/DTPushSetDBModel')\nlocal d={\nNORMAL=1,\nPUSH=2\n}\nlocal e={\nPERSON` |
| `UI_PlayerChangeName` | `K7HT` | `security_xor_raw` | `lua_like_text` | `180` | `function OnInit(e,e)\nImage.onClick:AddListener(function()\ncloseView()\nend)\ninputAcc.onValueChanged:AddListener(funct` |
| `UI_RoleLordShow` | `A-EV` | `security_xor_raw` | `lua_like_text` | `180` | `local e=require("DataNode/DataTable/Create/player/DTProfileDBModel")\nlocal s=require("DataNode/DataManager/DataMgr/Data` |
| `UI_SystemSet` | `A-EV` | `security_xor_raw` | `lua_like_text` | `192` | `local o=require('DataNode/DataTable/Create/player/DTLevelUpDBModel')\nlocal t=nil\nlocal e=0\nfunction OnInit(a,a)\nImag` |
| `UI_VoiceSet` | `A-EV` | `security_xor_raw` | `lua_like_text` | `168` | `local e=true\nlocal o=true\nlocal i=true\nlocal n\nlocal s\nlocal d\nlocal r\nlocal a\nlocal t\nlocal h\nfunction OnInit` |

## 산출물

- CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_xlua_decode_attempts.csv`
- JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_xlua_decode_summary.json`
- decoded output directory: `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua`
- 고신뢰 decoded 파일 저장: `36`
