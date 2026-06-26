# Control Tower Status - 2026-06-26 04:18:17 KST

## Current State

- Project root: `C:\Users\godho\Downloads\girlswar`
- UI worker `019eff6c-a02a-7f73-9ffb-74456322d1ce`: idle after UI139.
- Battle worker `019eff6c-edb7-7ca1-b7b9-fff5378a6ff6`: idle after BATTLE59.
- Character/data worker `019eff6d-307b-7532-8b1d-7105b18cd6b7`: idle after unresolved enemy trace.
- Current restore status: not restored; evidence boundary reached.

## UI139 Result

- Task: `MAININTERFACE_139_NATIVE_METHOD_BODY_OR_RUNTIME_DUMP_PATH_FOR_UI_DEPTH_AND_UISPINECTR_NO_PATCH`
- Result:
  - `restoredClaim=false`
  - `scenePatchApplied=false`
  - `candidatePatchApplied=false`
  - `patchDecision=trace_only_no_patch`
  - `nativeMethodBodiesRecovered=false`
  - `uiDepthFormulaRecovered=false`
  - `uiSpineRuntimeBindingRecovered=false`
  - `runtimeDumpExecuted=false`
  - `runtimeDumpPlanAvailable=true`
  - `requiresUserApproval=true`
- Outputs:
  - `reports\maininterface\MAININTERFACE_139_NATIVE_METHOD_BODY_OR_RUNTIME_DUMP_PATH_FOR_UI_DEPTH_AND_UISPINECTR_NO_PATCH_RESULT.md`
  - `reports\maininterface\MAININTERFACE_139_NATIVE_METHOD_BODY_OR_RUNTIME_DUMP_PATH_FOR_UI_DEPTH_AND_UISPINECTR_NO_PATCH_RESULT.json`
  - `reports\maininterface\MAININTERFACE_139_native_method_body_rva_symbol_recovery_evidence.csv`
  - `reports\maininterface\MAININTERFACE_139_ui_depth_formula_recovery_decision_matrix.csv`
  - `reports\maininterface\MAININTERFACE_139_uispinectr_runtime_binding_recovery_decision_matrix.csv`
  - `reports\maininterface\MAININTERFACE_139_approved_runtime_dump_plan_blocker_matrix.csv`
  - `_restore_tools\scripts\maininterface139_native_method_body_runtime_dump_path.py`
- Row counts:
  - native method evidence: 102
  - UI depth formula matrix: 5
  - UISpineCtr binding matrix: 3
  - runtime dump plan matrix: 4
- Command policy: root `.cmd` count 1, `_restore_tools` direct `.cmd` count 0, policy OK.

## UI139 Evidence

- Existing local Il2CppDumper artifacts were found:
  - `dump.cs`
  - `il2cpp.h`
  - `script.json`
  - `stringliteral.json`
  - DummyDll
  - `libil2cpp.so`
  - `global-metadata.dat`
- Existing prior disassembly artifact:
  - `il2cpp_native\il2cpp_xlua_target_disassembly.asm`
  - This is for prior xLua/XXTEA targets, not UI depth or UISpineCtr methods.
- `dump.cs` provides target UI method RVAs and signatures.
- `libil2cpp.so` ELF segment mapping can locate raw native bytes for target RVAs.
- Therefore local static evidence reaches:
  - method signature
  - RVA
  - native file offset
  - raw ARM64 bytes availability
- It does not reach:
  - lifted/disassembled formula
  - proven `Canvas.sortingOrder` calculation
  - proven `YouYouCanvasHelper` child render-depth cascade
  - proven `UISpineCtr` runtime `SkeletonGraphic` binding lifecycle

## Local Tool Boundary

- Available:
  - `ilspycmd`
  - `dotnet`
  - Python
- Not available in PATH:
  - `adb`
  - `frida`
  - `objdump`
  - `readelf`
  - `llvm-objdump`
  - Ghidra `analyzeHeadless`
  - `Cpp2IL`
  - `Il2CppDumper` executable
- Existing generated Il2CppDumper artifacts are usable as evidence, but local tooling is insufficient to lift raw ARM64 bytes into trusted formulas.

## UI Current Blocker

- UI_Dock promotion remains blocked.
- Reason:
  - UI136 showed static source-built sibling candidate worsens reference metrics.
  - UI137 showed production depends on UIManager/form group/canvas/runtime state.
  - UI138 recovered class/field signatures for the UI depth and UISpineCtr chain, but not method bodies.
  - UI139 recovered RVA/raw native byte availability, but not formulas or runtime bindings.
- Next step requires explicit approval for one of:
  - local ARM64 native method-body lifting/disassembler path, or
  - original APK runtime dump on a safe local Android device/emulator/instrumentation path.

## Approval Text From UI139

`Approve launching/instrumenting the original APK on a local Android device/emulator, or approve use/installation of a native ARM64 IL2CPP disassembler/lifter, to dump UI_Dock/UI_MainPage form group/BaseOrder/Depth/Canvas.sortingOrder/mask-stencil/CanvasScaler and UISpineCtr SkeletonGraphic/SkeletonDataAsset/material bindings.`

## Guardrails

- No scene patch.
- No candidate patch.
- No Android/emulator runtime execution.
- No external tool/package installation.
- No `UI_bg` raycast/interactable change.
- No `btn_discord` hide.
- No activity/chat/account/currency fake or hide.
- No route/world/zhuye node hide.
- No `Painting_1005_back` promotion.
- No fake HUD/icon/text/spine.

## Battle Boundary

- Battle remains at BATTLE59 `blocked_no_patch`.
- No source-backed importable editor xLua runtime candidate exists locally.
- No executable local xLua runtime exists.
- No GameEntry/LuaManager bootstrap exists.
- Battle restoration requires original xLua runtime, or explicit user approval for external xLua plus remaining payload-gap handling.

## Character/Data Boundary

- Loadable battle actor payloads remain 3/12:
  - our `1002`
  - our `1034`
  - enemy `1100111 -> prefab/model 3001`
- `1036` remains `not_fetchable_local`.
- Enemy payloads `1100112`, `1100113`, `1100121`, `1100122`, `1100123`, `1100131`, `1100132`, `1100133` remain unresolved from local evidence.

## Recommended Control Decision

- Pause automatic UI patch attempts.
- Ask the user before proceeding with either:
  - native ARM64 disassembler/lifter installation/use, or
  - Android/emulator/APK runtime instrumentation dump.
- Without that approval, next safe work is limited to passive report review, not restoration patching.

