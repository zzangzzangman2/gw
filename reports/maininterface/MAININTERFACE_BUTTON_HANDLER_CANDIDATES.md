# MainInterface Button Handler Candidates

이 문서는 복원된 `UI_MainInterface` root 버튼을 직접 텍스트/config/IL2CPP 증거와 연결한 후보 보고서다.

중요: `download/xlualogic/modules/maininterface.assetbundle` TextAsset 본문은 `A-EV` prefix로 시작한다. Lua 본문이 암호화/패킹되어 있으므로 정확한 함수명은 별도 디코더나 런타임 instrumentation으로 확인해야 한다.

## 요약

- Root Button 인스턴스: 77
- 고유 Button 이름: 56
- Root LuaCom Type 4 버튼 바인딩: 47
- LuaCom 정확 매칭 Button 인스턴스: 47
- LuaCom 정확 매칭 고유 Button 이름: 46
- 직접 텍스트 증거가 있는 Button 이름: 13
- 가이드/이벤트 증거가 있는 Button 이름: 6
- MainInterface XLua 모듈: 36
- 암호화/패킹된 XLua 모듈: 36

## 우선 확인할 XLua 모듈 후보

- `UI_MainPage`
- `MainPageMgr`
- `UI_MainPageActItem`: activity/banner 계열 버튼
- `UI_MainPageFaceActItem`: face/head/qinmi/marry/watch 계열 버튼
- `UI_Line_Show`: chat/line 계열 버튼
- `UI_SystemSet`: settings 계열 버튼

## 직접 증거 샘플

| Button | LuaCom | 그룹/이름 | 직접 hit | 증거 출처 | 후보 모듈 | 이벤트 증거 |
|---|---:|---|---:|---|---|---|
| `btn_download` | 1 | download; btn_download | 12 | guide_textasset | `UI_MainPage;MainPageMgr` |  |
| `btn_jia` | 2 | right; btn_jia_gold;btn_jia_holy | 12 | guide_textasset;unity_textasset | `UI_MainPage;MainPageMgr` |  |
| `btn_head` | 1 | tuxiang; btn_head | 8 | guide_textasset | `UI_MainPage;MainPageMgr;UI_MainPageFaceActItem` | {402001,402,{0},249,"guide_btn_head",1,1,37,1,"","","",0,0,0,1,"OPEN_MAINPAGE_SUC",0,0,"","",0,{},0,"","",0,0,0,0,0,0,"",0,0,"",0,0,0,"","",0,0,0,"noviceguidebubble402001",0,0,3,{343,-238},{402,403},{"isInPage(0)"}}, |
| `btn_go` | 0 |  | 5 | guide_textasset | `UI_MainPage;MainPageMgr` |  |
| `btn_renwu` | 1 | right; btn_renwu | 5 | guide_textasset | `UI_MainPage;MainPageMgr` | {216001,216,{0},249,"guide_btn_renwu",1,1,10,-47,"","","",0,0,0,1,"OPEN_MAINPAGE_SUC",0,7,"","",0,{},0,"","",0,0,0,0,0,0,"",0,0,"",0,0,0,"","",0,0,0,"",0,0,0,{0},{215,216},{"isInPage(1,0,249)"}}, |
| `btn_act` | 0 |  | 3 | guide_textasset | `UI_MainPage;MainPageMgr;UI_MainPageActItem` | {13001,13,{0},249,"guide_btn_act_2",1,1,10,-47,"","","",0,0,0,1,"OPEN_MAINPAGE_SUC",0,0,"","ON_CLICK_ACTICON_SUC",0,{},0,"","",0,0,0,0,0,0,"",0,0,"",0,0,0,"","",0,0,0,"",0,0,0,{0},{13},{"isInPage(1,0,999)"}}, \|\| {20701 |
| `btn_lingqu` | 0 |  | 2 | guide_textasset | `UI_MainPage;MainPageMgr` |  |
| `UI_bg` | 0 |  | 1 | il2cpp | `UI_MainPage;MainPageMgr` |  |
| `btnToggle4` | 1 | rightbom; btnToggle4 | 1 | guide_textasset | `UI_MainPage;MainPageMgr` | {99003,99,{34},249,"guide_btnToggle4",1,1,0,0,"","","",0,0,0,2,"1.5",0,0,"","ON_CLICK_MAINHUFU_SUC",0,{},0,"","",0,0,0,0,0,0,"",0,0,"",0,0,0,"","",0,0,0,"noviceguidebubble100206",0,0,1,{-151,183},{99},{"isInPage(0,219)"} |
| `btn_huodong3` | 0 |  | 1 | guide_textasset | `UI_MainPage;MainPageMgr;UI_MainPageActItem` |  |
| `btn_shangdian` | 1 | right; btn_shangdian | 1 | guide_textasset | `UI_MainPage;MainPageMgr` | {16005,16,{0},249,"guide_btn_shangdian",1,1,10,-47,"","","",0,0,0,2,"0.5",0,0,"","ON_CLICK_MAINSHOP_SUC",0,{},0,"","",0,0,0,0,0,0,"",0,0,"",0,0,0,"","",0,0,0,"",0,0,0,{0},{16,17},{"isInPage(0)"}}, |
| `btn_show` | 1 | middle; btn_show | 1 | guide_textasset | `UI_MainPage;MainPageMgr` |  |
| `shangdian_Btn` | 0 |  | 1 | guide_textasset | `UI_MainPage;MainPageMgr` | {16005,16,{0},249,"guide_btn_shangdian",1,1,10,-47,"","","",0,0,0,2,"0.5",0,0,"","ON_CLICK_MAINSHOP_SUC",0,{},0,"","",0,0,0,0,0,0,"",0,0,"",0,0,0,"","",0,0,0,"",0,0,0,{0},{16,17},{"isInPage(0)"}}, |
| `autoHelper_Root` | 1 | autohelper; autoHelper_Root | 0 |  | `UI_MainPage;MainPageMgr` |  |
| `bannerBgBtn` | 1 | act_banner; bannerBgBtn | 0 |  | `UI_MainPage;MainPageMgr;UI_MainPageActItem` |  |
| `bg_ditu2` | 0 |  | 0 |  | `UI_MainPage;MainPageMgr` |  |
| `bg_juese` | 1 | tuxiang; bg_juese | 0 |  | `UI_MainPage;MainPageMgr` |  |
| `btnToggle1` | 1 | rightbom; btnToggle1 | 0 |  | `UI_MainPage;MainPageMgr` |  |
| `btnToggle2` | 1 | rightbom; btnToggle2 | 0 |  | `UI_MainPage;MainPageMgr` |  |
| `btnToggle3` | 1 | rightbom; btnToggle3 | 0 |  | `UI_MainPage;MainPageMgr` |  |

## 파일

- CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_button_handler_candidates.csv`
- Button-LuaCom join CSV: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_button_luacom_join.csv`
- XLua 모듈 목록: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_xlua_modules.csv`
- 요약 JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_button_handler_summary.json`
