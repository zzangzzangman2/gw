# MAININTERFACE_139_NATIVE_METHOD_BODY_OR_RUNTIME_DUMP_PATH_FOR_UI_DEPTH_AND_UISPINECTR_NO_PATCH

Generated: 2026-06-26T04:16:25

## Decision
- restoredClaim: false
- scenePatchApplied: false
- candidatePatchApplied: false
- patchDecision: trace_only_no_patch
- nativeMethodBodiesRecovered: false
- uiDepthFormulaRecovered: false
- uiSpineRuntimeBindingRecovered: false
- runtimeDumpExecuted: false
- runtimeDumpPlanAvailable: true
- requiresUserApproval: true, for any original APK/emulator/runtime instrumentation path

## Static Recovery
- Local Il2CppDumper artifacts exist: `dump.cs`, `il2cpp.h`, `script.json`, `stringliteral.json`, DummyDll, `libil2cpp.so`, and `global-metadata.dat`.
- `dump.cs` provides RVAs and signatures for the target UI methods, and raw native bytes can be mapped from `libil2cpp.so`.
- No local disassembler/lifter is available in PATH (`objdump/readelf/Ghidra/Cpp2IL/frida/adb` not available), so raw ARM64 bytes did not become a proven formula.
- Existing `il2cpp_xlua_target_disassembly.asm` is for prior xLua/XXTEA targets, not the UI depth or UISpineCtr methods.

## Formula Status
- UI form group/depth/canvas formulas: not recovered.
- UISpineCtr runtime binding/animation behavior: not recovered.
- UI_Dock promotion remains blocked; no scene or candidate patch was applied.

## Exact Next Blocker
Either provide/approve a local ARM64 native method-body lifting path for the listed RVAs, or approve a safe original APK runtime dump environment. Runtime approval text is in the JSON under `requiredApprovalText`.
