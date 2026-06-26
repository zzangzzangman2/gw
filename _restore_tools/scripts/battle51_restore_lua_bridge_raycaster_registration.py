from __future__ import annotations

import argparse
import csv
import json
from pathlib import Path
from typing import Any

import cv2
import numpy as np
from PIL import Image, ImageDraw
import UnityPy


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_battle_unity"
MERGED = BASE / "girlswar_merged_extracted"
UNITY_DATA = PROJECT / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"

PLAY_VIDEO = Path(r"C:\Users\godho\Downloads\플레이.mp4")
AUX_VIDEO = Path(r"C:\Users\godho\Downloads\참고.mp4")

PREFIX = "BATTLE_51_RESTORE_SOURCE_BACKED_LUAUNIT_UIEVENTLISTENER_AND_EVENTSYSTEM_RAYCASTER_REGISTRATION"
UNITY_JSON = UNITY_DATA / f"{PREFIX}_UNITY.json"
ROWS_CSV = UNITY_DATA / f"{PREFIX}_COMPONENTS.csv"
BRIDGE_CSV = UNITY_DATA / f"{PREFIX}_BRIDGE.csv"
ORIGINAL_BRIDGE_CSV = REPORT_DIR / f"{PREFIX}_ORIGINAL_BRIDGE_COMPONENTS.csv"
BUTTONS_CSV = REPORT_DIR / f"{PREFIX}_BUTTONS.csv"
OUT_MD = REPORT_DIR / f"{PREFIX}_RESULT.md"
OUT_JSON = REPORT_DIR / f"{PREFIX}_RESULT.json"
CONTACT = REPORT_DIR / f"{PREFIX}_CONTACT_SHEET.jpg"
UNITY_LOG = REPORT_DIR / f"{PREFIX}.log"

B50_JSON = REPORT_DIR / "BATTLE_50_TRACE_ORIGINAL_LUA_IL2CPP_BUTTON_HANDLER_BINDING_AND_MISSING_SCRIPTS_RESULT.json"
B50_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle50OriginalLuaIl2cppButtonHandlerTrace_1920x1080.png"
B51_CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle51LuaBridgeRaycasterRegistrationCandidate_1920x1080.png"
PAYLOAD_MANIFEST = REPORT_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.md"

SOURCE_BUNDLE = MERGED / "extracted" / "unity" / "clean_unityfs_slices" / "download" / "ui" / "uiprefabandres" / "battle_ext_prefabs.assetbundle"

BUTTON_ORDER = ["btnAuto", "btnBuff", "btnTwoSpeed", "btnFastSkill", "btn_box"]


def read_json(path: Path, fallback: Any) -> Any:
    if not path.exists():
        return fallback
    return json.loads(path.read_text(encoding="utf-8-sig"))


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def boolv(row: dict[str, str], key: str) -> bool:
    return (row.get(key) or "").lower() == "true"


def intv(row: dict[str, str], key: str) -> int:
    try:
        return int(float(row.get(key) or 0))
    except Exception:
        return 0


def count_cmds(path: Path) -> int:
    return len(list(path.glob("*.cmd"))) if path.exists() else 0


def build_original_bridge_rows() -> list[dict[str, Any]]:
    if not SOURCE_BUNDLE.exists():
        return []
    env = UnityPy.load(SOURCE_BUNDLE.read_bytes())
    objs = {obj.path_id: obj for obj in env.objects}
    script_map: dict[int, dict[str, str]] = {}
    for obj in env.objects:
        if obj.type.name != "MonoScript":
            continue
        try:
            data = obj.read()
            namespace = getattr(data, "m_Namespace", "") or ""
            class_name = getattr(data, "m_ClassName", "") or getattr(data, "m_Name", "") or ""
            assembly = getattr(data, "m_AssemblyName", "") or ""
            script_map[obj.path_id] = {
                "assembly": assembly,
                "namespace": namespace,
                "className": class_name,
                "fullName": f"{namespace}.{class_name}".strip("."),
            }
        except Exception:
            continue

    components_by_go: dict[int, list[int]] = {}
    name_by_go: dict[int, str] = {}
    parent_by_transform: dict[int, int] = {}
    go_by_transform: dict[int, int] = {}
    transform_by_go: dict[int, int] = {}
    typetrees: dict[int, dict[str, Any]] = {}
    for pid, obj in objs.items():
        try:
            tt = obj.read_typetree()
        except Exception:
            continue
        typetrees[pid] = tt
        if obj.type.name == "GameObject":
            name_by_go[pid] = tt.get("m_Name", "")
            comps = []
            for comp in tt.get("m_Component", []):
                ref = comp.get("component") or comp.get("m_Component") or comp
                if isinstance(ref, dict) and ref.get("m_PathID"):
                    comps.append(ref["m_PathID"])
            components_by_go[pid] = comps
        elif obj.type.name in {"Transform", "RectTransform"}:
            go = tt.get("m_GameObject", {}).get("m_PathID")
            if go:
                go_by_transform[pid] = go
                transform_by_go[go] = pid
            parent = tt.get("m_Father", {}).get("m_PathID")
            if parent:
                parent_by_transform[pid] = parent

    def path_for_go(go: int | None) -> str:
        if not go:
            return ""
        tid = transform_by_go.get(go)
        names: list[str] = []
        while tid:
            g = go_by_transform.get(tid)
            names.append(name_by_go.get(g or 0, f"go{g}"))
            tid = parent_by_transform.get(tid)
        return "/".join(reversed(names))

    def script_for_component(component_pid: int) -> dict[str, str]:
        obj = objs.get(component_pid)
        if not obj:
            return {"type": "missing", "scriptPathId": "", "fullName": ""}
        if obj.type.name != "MonoBehaviour":
            return {"type": obj.type.name, "scriptPathId": "", "fullName": obj.type.name}
        script_path_id = typetrees.get(component_pid, {}).get("m_Script", {}).get("m_PathID")
        script = script_map.get(script_path_id or 0, {})
        return {
            "type": "MonoBehaviour",
            "scriptPathId": str(script_path_id or ""),
            "fullName": script.get("fullName", ""),
            "assembly": script.get("assembly", ""),
        }

    targets = {
        "UI_NormalBattle": "panel LuaForm",
        "UI_Battle3DUI": "3D panel LuaUnit",
        "UI_Battle3DUI/root_battle/UI_BattleBoxPage": "box page LuaUnit",
        "UI_Battle3DUI/root_battle/UI_BattleBoxPage/pop_Content/box_item": "box item LuaComBinder",
        "UI_Battle3DUI/root_battle/UI_BattleBoxPage/pop_Content/box_item/btn_box": "btn_box UIEventListener",
    }
    wanted_types = {"YouYou.LuaForm", "YouYou.LuaUnit", "LuaComponentBinder.LuaComBinder", "YouYou.UIEventListener", "YouYou.GuideNode"}
    rows: list[dict[str, Any]] = []
    for go, comps in components_by_go.items():
        path = path_for_go(go)
        if path not in targets:
            continue
        for comp in comps:
            info = script_for_component(comp)
            if info.get("fullName") in wanted_types:
                rows.append(
                    {
                        "originalPath": path,
                        "role": targets[path],
                        "componentPathId": comp,
                        "assembly": info.get("assembly", ""),
                        "fullName": info.get("fullName", ""),
                        "scriptPathId": info.get("scriptPathId", ""),
                        "sourceBundle": str(SOURCE_BUNDLE),
                        "evidence": "UnityPy original battle_ext_prefabs typetree m_Script PPtr",
                    }
                )
    return rows


def row_summary(rows: list[dict[str, str]], bridge: list[dict[str, str]], unity: dict[str, Any]) -> dict[str, Any]:
    return {
        "rowCount": len(rows),
        "directTargetIncludedCount": sum(1 for r in rows if boolv(r, "directTargetIncluded")),
        "eventTargetIncludedCount": sum(1 for r in rows if boolv(r, "eventTargetIncluded")),
        "forcedEventTargetIncludedCount": sum(1 for r in rows if boolv(r, "eventTargetIncludedForced")),
        "uiEventListenerPresentRows": sum(1 for r in rows if boolv(r, "uiEventListenerPresent")),
        "uiEventListenerDelegateRows": sum(1 for r in rows if boolv(r, "uiEventListenerHasDelegate")),
        "restoredOnClickKnownRows": sum(1 for r in rows if intv(r, "buttonOnClickPersistentCount") + intv(r, "buttonOnClickRuntimeCount") > 0),
        "bridgeRows": len(bridge),
        "bridgeAddedRows": sum(1 for r in bridge if boolv(r, "added")),
        "missingOnParentsTotal": sum(intv(r, "missingOnParents") for r in rows),
        "unityPatchDecision": unity.get("patchDecision", ""),
    }


def build_button_rows(rows: list[dict[str, str]]) -> list[dict[str, Any]]:
    by_button = {r.get("buttonName"): r for r in rows}
    out = []
    for button in BUTTON_ORDER:
        r = by_button.get(button, {})
        out.append(
            {
                "buttonName": button,
                "luaLifecycleExecuted": False,
                "runtimeListenerCount": intv(r, "buttonOnClickRuntimeCount"),
                "persistentListenerCount": intv(r, "buttonOnClickPersistentCount"),
                "uiEventListenerPresent": boolv(r, "uiEventListenerPresent"),
                "uiEventListenerHasDelegate": boolv(r, "uiEventListenerHasDelegate"),
                "handlerPath": r.get("luaHandlerCandidate", ""),
                "eventSystemTargetIncluded": boolv(r, "eventTargetIncluded"),
                "eventSystemTargetIncludedAfterForcedRaycasterRegistration": boolv(r, "eventTargetIncludedForced"),
                "directGraphicRaycasterTargetIncluded": boolv(r, "directTargetIncluded"),
                "executeClickResult": "not_reexecuted_in_b51_no_fake_handler",
                "gameplayHandlerExecution": "blocked_no_xlua_gameentry_modulesinit_runtime",
                "missingComponentChain": r.get("missingComponentChain", ""),
                "patchDecision": "candidate_bridge_patch_no_fake_handler",
            }
        )
    return out


def capture_metrics(path: Path) -> dict[str, Any]:
    img = cv2.imread(str(path))
    if img is None:
        return {"captureExists": False}
    total = img.shape[0] * img.shape[1]
    return {
        "captureExists": True,
        "width": int(img.shape[1]),
        "height": int(img.shape[0]),
        "nonBlackPixelRatio": round(float(np.count_nonzero(np.any(img > 20, axis=2))) / total, 6),
    }


def image_similarity(a: Path, b: Path) -> dict[str, Any]:
    ia = cv2.imread(str(a))
    ib = cv2.imread(str(b))
    if ia is None or ib is None:
        return {"available": False}
    if ia.shape != ib.shape:
        ib = cv2.resize(ib, (ia.shape[1], ia.shape[0]))
    diff = float(np.mean(np.abs(ia.astype(np.float32) - ib.astype(np.float32))) / 255.0)
    corr = float(np.corrcoef(ia.reshape(-1).astype(float), ib.reshape(-1).astype(float))[0, 1])
    return {"available": True, "meanAbsDiff": round(diff, 6), "pixelCorrelation": round(corr, 6)}


def panel(label: str, path: Path, size=(640, 360)) -> Image.Image:
    img = cv2.imread(str(path))
    out = Image.new("RGB", size, (8, 8, 8))
    draw = ImageDraw.Draw(out)
    if img is not None:
        pil = Image.fromarray(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))
        pil.thumbnail((size[0], size[1] - 28), Image.Resampling.LANCZOS)
        out.paste(pil, ((size[0] - pil.width) // 2, 0))
    else:
        draw.text((20, 140), f"missing: {path}", fill=(235, 235, 235))
    draw.text((8, size[1] - 21), label, fill=(235, 235, 235))
    return out


def make_contact(result: dict[str, Any]) -> None:
    sheet = Image.new("RGB", (1920, 900), (0, 0, 0))
    sheet.paste(panel("BATTLE50", B50_CAPTURE), (0, 0))
    sheet.paste(panel("BATTLE51", B51_CAPTURE), (640, 0))
    text = Image.new("RGB", (640, 360), (8, 8, 8))
    draw = ImageDraw.Draw(text)
    lines = [
        "BATTLE_51 summary",
        f"visual_status: {result['visual_status']}",
        f"final restored: {result['isFinalRestoredBattleScreen']}",
        f"direct/event/forced: {result['rowSummary']['directTargetIncludedCount']} / {result['rowSummary']['eventTargetIncludedCount']} / {result['rowSummary']['forcedEventTargetIncludedCount']}",
        f"bridge added: {result['rowSummary']['bridgeAddedRows']}",
        f"handler delegate rows: {result['rowSummary']['uiEventListenerDelegateRows']}",
    ]
    y = 18
    for line in lines:
        draw.text((18, y), line[:100], fill=(235, 235, 235))
        y += 27
    sheet.paste(text, (1280, 0))
    sheet.paste(panel("BATTLE51 detail", B51_CAPTURE, (960, 540)), (0, 360))
    notes = Image.new("RGB", (960, 540), (8, 8, 8))
    draw = ImageDraw.Draw(notes)
    note_lines = [
        "Candidate patch restored source-backed bridge components/serialized fields only.",
        "No fake transparent overlay, fake onClick closure, fake gameplay handler, fake art, screenshot paste, or whole-atlas placement.",
        f"play video available: {PLAY_VIDEO.exists()} {PLAY_VIDEO}",
        f"aux reference available: {AUX_VIDEO.exists()} {AUX_VIDEO}",
    ]
    y = 20
    for line in note_lines:
        draw.text((18, y), line[:135], fill=(235, 235, 235))
        y += 30
    sheet.paste(notes, (960, 360))
    CONTACT.parent.mkdir(parents=True, exist_ok=True)
    sheet.save(CONTACT, quality=92)


def verify(unity_exit: int) -> None:
    unity = read_json(UNITY_JSON, {})
    b50 = read_json(B50_JSON, {})
    rows = read_csv(ROWS_CSV)
    bridge_rows = read_csv(BRIDGE_CSV)
    original_bridge = build_original_bridge_rows()
    write_csv(
        ORIGINAL_BRIDGE_CSV,
        original_bridge,
        ["originalPath", "role", "componentPathId", "assembly", "fullName", "scriptPathId", "sourceBundle", "evidence"],
    )
    button_rows = build_button_rows(rows)
    write_csv(
        BUTTONS_CSV,
        button_rows,
        [
            "buttonName",
            "luaLifecycleExecuted",
            "runtimeListenerCount",
            "persistentListenerCount",
            "uiEventListenerPresent",
            "uiEventListenerHasDelegate",
            "handlerPath",
            "eventSystemTargetIncluded",
            "eventSystemTargetIncludedAfterForcedRaycasterRegistration",
            "directGraphicRaycasterTargetIncluded",
            "executeClickResult",
            "gameplayHandlerExecution",
            "missingComponentChain",
            "patchDecision",
        ],
    )
    rows_summary = row_summary(rows, bridge_rows, unity)
    visual_status = "source_backed_lua_bridge_candidate_restored_eventsystem_forced_registration_validated_but_xlua_runtime_missing"
    patch_decision = "candidate_bridge_patch_no_fake_handler"
    result = {
        "verdict": "BATTLE51 restored source-backed Lua bridge component candidates and proved EventSystem.RaycastAll failure is RaycasterManager registration/lifecycle in the editor probe; final playable screen remains false.",
        "visual_status": visual_status,
        "isFinalRestoredBattleScreen": False,
        "unityExitCode": unity_exit,
        "referenceVideoAvailable": PLAY_VIDEO.exists(),
        "referenceVideoPath": str(PLAY_VIDEO),
        "auxiliaryReferenceVideoAvailable": AUX_VIDEO.exists(),
        "auxiliaryReferenceVideoPath": str(AUX_VIDEO),
        "unitySummary": unity,
        "battle50Carryover": {
            "visual_status": b50.get("visual_status"),
            "eventRootCauseCounts": b50.get("rowSummary", {}).get("eventRootCauseCounts"),
            "patchDecision": b50.get("patchDecision"),
        },
        "rowSummary": rows_summary,
        "buttonRows": button_rows,
        "originalBridgeRows": original_bridge,
        "patchDecision": patch_decision,
        "nextBlocker": "BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK",
        "raycasterRegistrationFinding": {
            "editorBefore": unity.get("raycasterManagerBefore"),
            "afterBridge": unity.get("raycasterManagerAfterBridge"),
            "afterForcedRegistration": unity.get("raycasterManagerAfterForcedRegistration"),
            "reopenBeforeForced": unity.get("raycasterManagerReopenBeforeForced"),
            "reopenAfterForced": unity.get("raycasterManagerReopenAfterForced"),
            "interpretation": "EventSystem.RaycastAll is zero while RaycasterManager count is zero in editor batch context; direct GraphicRaycaster works. Reflective AddRaycaster forced-lifecycle probe makes target inclusion 5/5, so runtime/PlayMode OnEnable registration is the next input plumbing check rather than camera/rect/art.",
            "playModeProbe": "not_entered_in_b51_batch; forced RaycasterManager registration used as lifecycle-equivalent probe",
        },
        "handlerBindingFinding": {
            "knownUnityButtonListeners": rows_summary["restoredOnClickKnownRows"],
            "uiEventListenerDelegateRows": rows_summary["uiEventListenerDelegateRows"],
            "luaLifecycleExecutedRows": 0,
            "blocker": "The source-backed bridge components and LuaScriptPath/ComBinder fields are present, but no xLua/GameEntry/ModulesInit runtime executed UI_NormalBattle/UI_Battle3DUI/UI_BattleBoxPage OnInit/Open, so no original closures are bound.",
        },
        "captureMetrics": capture_metrics(B51_CAPTURE),
        "battle50ToBattle51CaptureSimilarity": image_similarity(B50_CAPTURE, B51_CAPTURE),
        "localPlayablePayloadManifest": {
            "available": PAYLOAD_MANIFEST.exists(),
            "path": str(PAYLOAD_MANIFEST),
            "useCondition": "Use only after source-backed handler binding executes; local subset is debug/runtime validation only, not full payload or final restore evidence.",
        },
        "rootCmdCount": count_cmds(BASE),
        "restoreToolsDirectCmdCount": count_cmds(BASE / "_restore_tools"),
        "outputs": {
            "report": str(OUT_MD),
            "resultJson": str(OUT_JSON),
            "rowsCsv": str(ROWS_CSV),
            "bridgeCsv": str(BRIDGE_CSV),
            "originalBridgeCsv": str(ORIGINAL_BRIDGE_CSV),
            "buttonCsv": str(BUTTONS_CSV),
            "scene": str(PROJECT / "Assets" / "Scenes" / "Battle51LuaBridgeRaycasterRegistrationCandidate.unity"),
            "capture": str(B51_CAPTURE),
            "contactSheet": str(CONTACT),
            "unityLog": str(UNITY_LOG),
        },
        "notes": [
            "BATTLE51 does not add fake transparent overlays, fake onClick closures, fake gameplay handlers, fake HUD/cards/icons, screenshot paste, or whole-atlas placement.",
            "플레이.mp4 remains missing when referenceVideoAvailable is false; 참고.mp4 is auxiliary only.",
        ],
    }
    make_contact(result)
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    write_markdown(result)
    print(json.dumps({
        "visual_status": visual_status,
        "rows": rows_summary,
        "patchDecision": patch_decision,
        "nextBlocker": result["nextBlocker"],
        "rootCmdCount": result["rootCmdCount"],
        "restoreToolsDirectCmdCount": result["restoreToolsDirectCmdCount"],
    }, ensure_ascii=False, indent=2))


def write_markdown(result: dict[str, Any]) -> None:
    rows = result["rowSummary"]
    ray = result["raycasterRegistrationFinding"]
    handler = result["handlerBindingFinding"]
    md = [
        "# BATTLE_51 Restore Source Backed LuaUnit UIEventListener And EventSystem Raycaster Registration Result",
        "",
        "**최종 playable battle screen은 아직 아니다.** BATTLE51은 원본 prefab typetree에 근거해 Lua bridge 후보 컴포넌트를 최소 복원하고, `EventSystem.RaycastAll` 0 원인을 RaycasterManager 등록/lifecycle 쪽으로 분리했다.",
        "",
        "## Verdict",
        f"- visual_status: `{result['visual_status']}`",
        "- final screen claim: `false`",
        f"- patch decision: `{result['patchDecision']}`",
        f"- Unity exit code: `{result['unityExitCode']}`",
        f"- reference video available: `{result['referenceVideoAvailable']}` (`{result['referenceVideoPath']}`)",
        f"- auxiliary reference video available: `{result['auxiliaryReferenceVideoAvailable']}` (`{result['auxiliaryReferenceVideoPath']}`)",
        "",
        "## Source-Backed Bridge Patch",
        "- `UI_NormalBattle`: original root `YouYou.LuaForm`, script pathId `8347263561838679580`, `LuaScriptPath=/Download/xLuaLogic/Modules/MainCity/UI_NormalBattle.bytes`.",
        "- `UI_Battle3DUI`: original root `YouYou.LuaUnit`, script pathId `3319520142972745523`, `LuaScriptPath=/Download/xLuaLogic/Modules/MainCity/UI_Battle3DUI.bytes`.",
        "- `UI_BattleBoxPage`: original `YouYou.LuaUnit`, script pathId `3319520142972745523`, `LuaScriptPath=/Download/xLuaLogic/Modules/MainCity/UI_BattleBoxPage.bytes`.",
        "- `box_item`: original `LuaComponentBinder.LuaComBinder`, script pathId `1924290018182821150`, `LuaComs=sp_box Type25; btn_box Type4`.",
        "- `btn_box`: original `YouYou.UIEventListener`, script pathId `-6333827617915679503`.",
        f"- bridge rows / added rows: `{rows['bridgeRows']}` / `{rows['bridgeAddedRows']}`.",
        "",
        "## Input Plumbing",
        f"- direct GraphicRaycaster target included: `{rows['directTargetIncludedCount']}` / `{rows['rowCount']}`",
        f"- EventSystem target included before forced registration: `{rows['eventTargetIncludedCount']}` / `{rows['rowCount']}`",
        f"- EventSystem target included after forced RaycasterManager registration: `{rows['forcedEventTargetIncludedCount']}` / `{rows['rowCount']}`",
        f"- RaycasterManager editor before: `{ray['editorBefore']}`",
        f"- RaycasterManager forced: `{ray['afterForcedRegistration']}`",
        f"- PlayMode probe: `{ray['playModeProbe']}`",
        "",
        "## Handler Binding",
        f"- known restored Button listener rows: `{handler['knownUnityButtonListeners']}`",
        f"- UIEventListener delegate rows: `{handler['uiEventListenerDelegateRows']}`",
        f"- Lua lifecycle executed rows: `{handler['luaLifecycleExecutedRows']}`",
        f"- blocker: `{handler['blocker']}`",
        "",
        "## Button Rows",
    ]
    for row in result["buttonRows"]:
        md.append(
            f"- `{row['buttonName']}`: event before/forced/direct = `{row['eventSystemTargetIncluded']}` / `{row['eventSystemTargetIncludedAfterForcedRaycasterRegistration']}` / `{row['directGraphicRaycasterTargetIncluded']}`, handler=`{row['handlerPath']}`, execution=`{row['gameplayHandlerExecution']}`"
        )
    md += [
        "",
        "## Outputs",
        f"- result JSON: `{OUT_JSON}`",
        f"- components CSV: `{ROWS_CSV}`",
        f"- bridge CSV: `{BRIDGE_CSV}`",
        f"- original bridge CSV: `{ORIGINAL_BRIDGE_CSV}`",
        f"- button CSV: `{BUTTONS_CSV}`",
        f"- capture: `{B51_CAPTURE}`",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Command Policy Check",
        f"- root CMD count: `{result['rootCmdCount']}`",
        f"- `_restore_tools` direct CMD count: `{result['restoreToolsDirectCmdCount']}`",
        "",
        "## Next Blocker",
        f"- `{result['nextBlocker']}`",
    ]
    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("mode", choices=["verify"])
    parser.add_argument("--unity-exit", type=int, default=0)
    args = parser.parse_args()
    verify(args.unity_exit)


if __name__ == "__main__":
    main()
