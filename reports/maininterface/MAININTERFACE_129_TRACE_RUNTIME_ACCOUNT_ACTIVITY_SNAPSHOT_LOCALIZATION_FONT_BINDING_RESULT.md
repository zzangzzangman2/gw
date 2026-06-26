# MAININTERFACE_129_TRACE_RUNTIME_ACCOUNT_ACTIVITY_SNAPSHOT_LOCALIZATION_FONT_BINDING_RESULT

## Verdict

`restoredClaim=false`. No candidate patch was applied.

UI129 found static code/data evidence for activity selection, localization, and TMP/font material binding, but did not find a complete local runtime/account/server snapshot that can drive `ActMgr:GetActInMain()` or `ActMgr:GetActInMainFace()`.

## Runtime Snapshot Search

- searched roots:
  - `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted`
  - `C:\Users\godho\Downloads\girlswar\download\xlualogic`
  - `C:\Users\godho\Downloads\girlswar\reports\maininterface`
  - `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData`
- candidate rows: `7651`
- candidates that can drive `GetActInMain`: `0`

Candidate type counts:

- `font_tmp_binding`: `247`
- `handler_or_code`: `3217`
- `report_or_restore_artifact`: `59`
- `runtime_snapshot_candidate`: `8`
- `static_datatable`: `1216`
- `static_localization`: `1`
- `unknown`: `2903`

Drive-capable candidates:

- none

Runtime-looking candidates checked:

- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\extracted\il2cpp_dump\stringliteral.json` | parse=`json_parsed` | fields=`DTLangCommon;TextMeshPro` | canDrive=`False`
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\extracted\unity\bundles\b_272c9612f336692d\textassets\-8545305127228593748_SaveMgr.txt` | parse=`text_scanned` | fields=`none` | canDrive=`False`
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\extracted\unity\bundles\b_3ed349f99c8026c8\textassets\8913764254204201169_UserAccountInfo.txt` | parse=`text_scanned` | fields=`none` | canDrive=`False`
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\extracted\unity\bundles\b_d44ce4a6399c3029\textassets\-3505545314723587136_Snapshot.txt` | parse=`text_scanned` | fields=`activityId;PlayerInfo` | canDrive=`False`
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\extracted\unity\clean_unityfs_slices\download\xlualogic\datanode\proto\snapshot.assetbundle` | parse=`text_scanned` | fields=`none` | canDrive=`False`
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\merged_content\AssetBundles\download\xlualogic\datanode\proto\snapshot.assetbundle` | parse=`text_scanned` | fields=`none` | canDrive=`False`
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\restore_overlay\Android\data\com.girlwars.kr\files\build\download\xlualogic\datanode\proto\snapshot.assetbundle` | parse=`text_scanned` | fields=`none` | canDrive=`False`
- `C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\restore_overlay\Android\data\com.girlwars.kr\files\download\xlualogic\datanode\proto\snapshot.assetbundle` | parse=`text_scanned` | fields=`none` | canDrive=`False`

## Reconstruction Judgment

Active activity reconstruction is `impossible_from_local_evidence` from local evidence.

Reason: decoded `ActMgr:GetActInMain()` starts from `ActMgr:GetAllActInfo(true)`, and that function iterates runtime `ActMgr.activitys`. `IsActShowInMain()` then needs server `show`, open state, `PlayerMgr.PlayerInfo.vip/level`, redpoint state, and client callback results. The local evidence contains the code and static config, not the actual runtime list/account/redpoint snapshot.

## Static Evidence Found

- `UI_MainPage` main activity wrapper slots: `btn_act_1..btn_act_8`.
- `UI_MainPage` face activity wrapper slots: `btn_face_item_1..btn_face_item_7`.
- `UI_MainPageActItem:Refresh()` and `UI_MainPageFaceActItem:Refresh()` replace placeholders via `GameTools.GetLocalize`, `ActCfgData`, `tbSpine`, and `mainPageSpineId`.
- `ActCfgData` contains static `mainPageName/mainPageSpineId` overrides for selected act ids.

Localization evidence in `DTLangCommon`:

- `activityname_1004` -> `충전`
- `activityname_1005` -> `소집`
- `activityname_1006` -> `보너스`
- `activityname_1007` -> `이벤트`
- `activityname_1008` -> `응원`
- `activityname_4100` -> `충전 보상`
- `Funtionname_10025` -> `임무`
- `Funtionname_10056` -> `잡화점`

TMP/font material evidence:

- `riyu` / `riyu_baibian_0.2_0.2_1`: usage=74 objects=lab_renwu_text;lab_shangdian_text;officer_show_num;text_off;text_qianghua;text_resetAutoHelperPos;text_title;text_title1;txt_act_name;txt_face_name samples=동 맹;무 장;마을;이미지;모 험;동 맹;마 을;전속 비서 bundle=download/ui/uifont/japanese/font_material_riyu/riyu_baibian_0.2_0.2_1.assetbundle
- `EPM` / `EPM_bai_0.2_0.2`: usage=65 objects=test_name2;text_bhll_message;text_name;text_notice_desc;text_onlyUseAttTips;text_title;text_tmp_chengyuan;text_tmp_chengyuan_num;text_tmp_message;text_tmp_message (1);text_tmp_nandu;text_tmp_nandu_num;text_tmp_zudui;text_unLockTips;text_wanfaTips;text_youjian samples= d; dadfadsfadsf;용녀 토벌령 뜨겁게 진행 중!;7 ;<color=#599F50>누적 {0}시간</color> 방치 보상! 어서 수령하세요!;동맹원: ;천하 쟁패 열렬히 진행 중!;천하쟁패 진행 중 bundle=download/ui/uifont/japanese/font_material_epm/epm_bai_0.2_0.2.assetbundle
- `riyu` / `riyu_shenzong_0.2_0.2`: usage=22 objects=text;text_beijing;text_big;text_fanhui;text_haoyou;text_haoyou (1);text_name;text_paihangbang;text_qianghua;text_queren;text_small;text_tujian;text_vip_num;text_wuyu;text_yincang;text_youjian samples=이름;친구;모험;모험;전체 화면;10;모험;도감 bundle=download/ui/uifont/japanese/font_material_riyu/riyu_shenzong_0.2_0.2.assetbundle
- `riyu` / `riyu_cheng_254_178_18`: usage=20 objects=text;text_1;text_2;text_3;text_4;text_5;text_6;text_baocun;text_qianghua;text_queding;text_queren samples= 설정;저장;확인;알림 설정;확인;계정 삭제;확인;확인 bundle=download/ui/uifont/japanese/font_material_riyu/riyu_cheng_254_178_18.assetbundle
- `riyu` / `riyu_lan_0.1_0.1`: usage=17 objects=test_name;text;text_fanhui;text_lan;text_on;text_shezhi samples=설정;성주 이미지;취소;취소;음악 설정;취소;취소;일반 설정 bundle=download/ui/uifont/japanese/font_material_riyu/riyu_lan_0.1_0.1.assetbundle

## Required Snapshot

Wrote the minimum source-backed runtime schema:

- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_129_required_snapshot_schema.json`
- `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_129_required_snapshot_schema.md`

Until those fields are supplied by a packet/cache/log/playerprefs/replay snapshot, visible activity slots/text/icons/spines cannot be changed without guessing.

## Guardrails

- Did not hide `node_act_btn/btn_act_*`.
- Did not hide `btn_discord` using review-state evidence.
- Did not set `UI_bg` raycast/interactable off.
- Did not fake icons/text/spines or paste screenshots/whole atlases.
- Preserved the UI124 Hero1005 real `SkeletonGraphic` path by applying no scene patch.

## Command Policy

- root `.cmd` count: `1`
- `_restore_tools` direct `.cmd` count: `0`

## Outputs

- JSON: `C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_129_trace_runtime_account_activity_snapshot_localization_font_binding.json`
- search candidates CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_129_runtime_snapshot_search_candidates.csv`
- evidence CSV: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_129_runtime_snapshot_evidence.csv`
- required schema JSON: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_129_required_snapshot_schema.json`
- required schema MD: `C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_129_required_snapshot_schema.md`
