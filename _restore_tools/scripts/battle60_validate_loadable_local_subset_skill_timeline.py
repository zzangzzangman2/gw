from __future__ import annotations

import csv
import json
import shutil
from collections import Counter
from datetime import datetime
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_battle_unity"
REPORT_DIR = BASE / "reports" / "battle"
CHAR_REPORT_DIR = BASE / "reports" / "characters"
UNITY_DATA = PROJECT / "Assets" / "RestoreData" / "battle"
PREFIX = "BATTLE_60_VALIDATE_LOADABLE_LOCAL_SUBSET_SKILL_TIMELINE_ASSETBUNDLE_CHAIN_NO_XLUA_NO_HANDLER_PATCH"

UNITY_SUMMARY = UNITY_DATA / f"{PREFIX}_UNITY_SUMMARY.json"
UNITY_TIMELINE = UNITY_DATA / f"{PREFIX}_SKILL_TIMELINE_SOURCE_LOAD_VALIDATION.csv"
UNITY_REFS = UNITY_DATA / f"{PREFIX}_SKILL_PREFAB_COMPONENT_DEPENDENCY_REFS.csv"

OUT_MD = REPORT_DIR / f"{PREFIX}_RESULT.md"
OUT_JSON = REPORT_DIR / f"{PREFIX}_RESULT.json"
OUT_TIMELINE = REPORT_DIR / f"{PREFIX}_SKILL_TIMELINE_SOURCE_LOAD_VALIDATION.csv"
OUT_REFS = REPORT_DIR / f"{PREFIX}_SKILL_PREFAB_COMPONENT_DEPENDENCY_REFS.csv"
OUT_BLOCKERS = REPORT_DIR / f"{PREFIX}_BLOCKER_SEPARATION_MATRIX.csv"
OUT_LOG = REPORT_DIR / f"{PREFIX}.log"

PAYLOAD_MD = REPORT_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.md"
PAYLOAD_JSON = REPORT_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.json"
PAYLOAD_CSV = REPORT_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.csv"
B57_JSON = REPORT_DIR / "BATTLE_57_REHYDRATE_SOURCE_BACKED_ASSETBUNDLE_ACTORS_IN_CANDIDATE_BUILDER_AND_CAPTURE_VALIDATE_NO_FAKE_MESH_RESULT.json"
B58_JSON = REPORT_DIR / "BATTLE_58_TRACE_XLUA_GAMEENTRY_MODULESINIT_HANDLER_BINDING_WITH_BATTLE57_ACTORS_NO_FAKE_HANDLER_RESULT.json"
B59_JSON = REPORT_DIR / "BATTLE_59_AUDIT_LOCAL_SOURCE_BACKED_XLUA_RUNTIME_RECOVERY_FEASIBILITY_AND_BOOTSTRAP_REQUIREMENTS_NO_STUB_NO_EXTERNAL_RESULT.json"
CHAR_JSON = CHAR_REPORT_DIR / "CHARACTER_UNRESOLVED_ENEMY_PAYLOAD_INSTANCE_DEEP_TRACE_RESULT.json"

PLAY_VIDEO = Path(r"C:\Users\godho\Downloads\플레이.mp4")
AUX_VIDEO = Path(r"C:\Users\godho\Downloads\참고.mp4")


def read_json(path: Path, fallback: Any) -> Any:
    try:
        return json.loads(path.read_text(encoding="utf-8-sig"))
    except Exception:
        return fallback


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, Any]], headers: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=headers)
        writer.writeheader()
        for row in rows:
            writer.writerow({h: row.get(h, "") for h in headers})


def truthy(value: Any) -> bool:
    return str(value).strip().lower() in {"1", "true", "yes"}


def intv(value: Any) -> int:
    try:
        return int(float(str(value or "0")))
    except Exception:
        return 0


def copy_unity_outputs() -> tuple[list[dict[str, str]], list[dict[str, str]], dict[str, Any]]:
    if UNITY_TIMELINE.exists():
        shutil.copyfile(UNITY_TIMELINE, OUT_TIMELINE)
    if UNITY_REFS.exists():
        shutil.copyfile(UNITY_REFS, OUT_REFS)
    return read_csv(OUT_TIMELINE), read_csv(OUT_REFS), read_json(UNITY_SUMMARY, {})


def command_policy() -> dict[str, Any]:
    root_cmds = sorted(str(p) for p in BASE.glob("*.cmd"))
    direct_cmds = sorted(str(p) for p in (BASE / "_restore_tools").glob("*.cmd"))
    return {
        "rootCmdCount": len(root_cmds),
        "rootCmdFiles": root_cmds,
        "restoreToolsDirectCmdCount": len(direct_cmds),
        "restoreToolsDirectCmdFiles": direct_cmds,
    }


def build_blockers(timeline_rows: list[dict[str, str]], b57: dict[str, Any], b58: dict[str, Any], b59: dict[str, Any], char_report: dict[str, Any]) -> list[dict[str, Any]]:
    missing_common = [r for r in timeline_rows if r.get("localStatus") == "loadable_with_unresolved_common_resource_deps"]
    resource_complete = [r for r in timeline_rows if truthy(r.get("resourceCompleteStrict"))]
    resource_complete_verified = [
        r for r in resource_complete
        if truthy(r.get("bundleLoadSuccess")) and truthy(r.get("assetLoadSuccess")) and truthy(r.get("instantiateSuccess"))
    ]
    rows: list[dict[str, Any]] = [
        {
            "blocker": "original_xlua_runtime_required_for_handlers",
            "status": "blocking_playable_handlers",
            "evidence": f"BATTLE59 importable runtime candidates={b59.get('sourceBackedImportableEditorRuntimeCandidates')}; BATTLE58 handlerBoundRows={b58.get('battle58CarryoverButtons', {}).get('handlerBoundRows')}",
            "nextAction": "Acquire original source-backed xLua/GameEntry/LuaManager runtime or get explicit approval for external xLua experiment.",
        },
        {
            "blocker": "full_payload_actor_gaps_1036_and_unresolved_enemies",
            "status": "blocking_full_payload",
            "evidence": "BATTLE57 local actor rendering verifies only 3/12; character trace keeps unresolved enemy payload ids unresolved.",
            "nextAction": "Resolve 1036 actor bundle and authoritative enemy payload instance mappings without fake aliases.",
        },
        {
            "blocker": "common_speedline_resource_gaps_if_still_missing",
            "status": "blocking_subset_effect_completeness" if missing_common else "not_blocking_resource_complete_subset",
            "evidence": f"missing common dependency rows={len(missing_common)}; bundles={sorted(set(r.get('missingDependencyBundles') for r in missing_common if r.get('missingDependencyBundles')))}",
            "nextAction": "Find source-backed pink/red/yellow speedline bundles or keep rows excluded from resource-complete subset.",
        },
        {
            "blocker": "skill_timeline_chain_verified_for_resource_complete_subset",
            "status": "verified" if len(resource_complete_verified) == 4 else "not_verified",
            "evidence": f"verified={len(resource_complete_verified)}/4; checked={len(timeline_rows)}; b57 actors={b57.get('mapping', {}).get('sourceBackedRehydratedRows')}",
            "nextAction": "Use this only for local subset runtime/interaction validation after handler runtime exists; not a full restore claim.",
        },
        {
            "blocker": "external_xlua_android_runtime_instrumentation_forbidden",
            "status": "guardrail_preserved",
            "evidence": "No external xLua/package/import/download and no Android/emulator/APK/runtime instrumentation performed.",
            "nextAction": "Keep BATTLE60 as Unity/source bundle inspection only.",
        },
    ]
    unresolved = char_report.get("targetStatusCounts") or char_report.get("statusCounts") or {}
    if unresolved:
        rows.append(
            {
                "blocker": "character_thread_enemy_payload_carryover",
                "status": "unresolved",
                "evidence": str(unresolved),
                "nextAction": "Do not promote unresolved enemy payload rows without source-backed DTMonster/DTmodel/prefab/bundle chain.",
            }
        )
    return rows


def build_md(result: dict[str, Any]) -> str:
    lines = [
        f"# {PREFIX} Result",
        "",
        "**Playable/restored claim remains false.** BATTLE60 validates only source-backed local subset skill/timeline AssetBundle chain loadability; it does not bind xLua handlers or save a scene.",
        "",
        "## Verdict",
        f"- restoredClaim: `{str(result['restoredClaim']).lower()}`",
        f"- playableClaim: `{str(result['playableClaim']).lower()}`",
        f"- sceneSaved: `{str(result['sceneSaved']).lower()}`",
        f"- handlerBindingApplied: `{str(result['handlerBindingApplied']).lower()}`",
        f"- xLuaRuntimeUsed: `{str(result['xLuaRuntimeUsed']).lower()}`",
        f"- nextBlocker: `{result['nextBlocker']}`",
        "",
        "## Skill Chain",
        f"- source-backed skill rows checked: `{result['sourceBackedSkillRowsChecked']}`",
        f"- resource-complete skill rows verified: `{result['resourceCompleteSkillRowsVerified']}` / `4`",
        f"- missing common dependency rows: `{result['missingCommonDependencyRows']}`",
        f"- skillTimelineChainVerifiedForResourceCompleteSubset: `{str(result['skillTimelineChainVerifiedForResourceCompleteSubset']).lower()}`",
        f"- bundle/asset/instantiate success rows: `{result['bundleLoadSuccessRows']}` / `{result['assetLoadSuccessRows']}` / `{result['instantiateSuccessRows']}`",
        "",
        "## Separated Blockers",
        "- `original_xlua_runtime_required_for_handlers` remains from BATTLE59.",
        "- `full_payload_actor_gaps_1036_and_unresolved_enemies` remains from payload/character trace.",
        "- `common_speedline_resource_gaps_if_still_missing` remains for pink/red/yellow speedline rows.",
        "",
        "## Outputs",
        f"- result JSON: `{OUT_JSON}`",
        f"- skill timeline validation CSV: `{OUT_TIMELINE}`",
        f"- skill prefab component/dependency refs CSV: `{OUT_REFS}`",
        f"- blocker separation matrix CSV: `{OUT_BLOCKERS}`",
        "",
        "## Command Policy",
        f"- root `.cmd` count: `{result['commandPolicy']['rootCmdCount']}`",
        f"- `_restore_tools` direct `.cmd` count: `{result['commandPolicy']['restoreToolsDirectCmdCount']}`",
        f"- `플레이.mp4`: `{'available' if PLAY_VIDEO.exists() else 'missing'}`",
        f"- `참고.mp4`: `{'available, auxiliary only' if AUX_VIDEO.exists() else 'missing'}`",
    ]
    return "\n".join(lines) + "\n"


def main() -> int:
    timeline_rows, ref_rows, unity_summary = copy_unity_outputs()
    b57 = read_json(B57_JSON, {})
    b58 = read_json(B58_JSON, {})
    b59 = read_json(B59_JSON, {})
    char_report = read_json(CHAR_JSON, {})
    payload = read_json(PAYLOAD_JSON, {})

    blocker_rows = build_blockers(timeline_rows, b57, b58, b59, char_report)
    write_csv(OUT_BLOCKERS, blocker_rows, ["blocker", "status", "evidence", "nextAction"])

    resource_complete = [r for r in timeline_rows if truthy(r.get("resourceCompleteStrict"))]
    resource_complete_verified = [
        r for r in resource_complete
        if truthy(r.get("bundleLoadSuccess")) and truthy(r.get("assetLoadSuccess")) and truthy(r.get("instantiateSuccess"))
    ]
    missing_common = [r for r in timeline_rows if r.get("localStatus") == "loadable_with_unresolved_common_resource_deps"]
    guardrails = {
        "fakeSkillCreated": False,
        "fakeEffectCreated": False,
        "fakeCardIconTextCreated": False,
        "handlerPatchApplied": False,
        "dummyLuaUsed": False,
        "externalXluaImported": False,
        "androidInstrumentationUsed": False,
        "mainInterfaceTouched": False,
    }
    result = {
        "prefix": PREFIX,
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "unitySummary": unity_summary,
        "restoredClaim": False,
        "playableClaim": False,
        "isFinalRestoredBattleScreen": False,
        "sceneSaved": False,
        "handlerBindingApplied": False,
        "xLuaRuntimeUsed": False,
        "sourceBackedSkillRowsChecked": len(timeline_rows),
        "resourceCompleteSkillRowsVerified": len(resource_complete_verified),
        "resourceCompleteSkillRowsChecked": len(resource_complete),
        "missingCommonDependencyRows": len(missing_common),
        "bundleLoadSuccessRows": sum(1 for r in timeline_rows if truthy(r.get("bundleLoadSuccess"))),
        "assetLoadSuccessRows": sum(1 for r in timeline_rows if truthy(r.get("assetLoadSuccess"))),
        "instantiateSuccessRows": sum(1 for r in timeline_rows if truthy(r.get("instantiateSuccess"))),
        "componentRefRows": len(ref_rows),
        "skillTimelineChainVerifiedForResourceCompleteSubset": len(resource_complete) == 4 and len(resource_complete_verified) == 4,
        "nextBlocker": "original_xlua_runtime_required_for_handlers_and_full_payload_actor_common_speedline_gaps",
        "guardrailsTouched": guardrails,
        "commandPolicy": command_policy(),
        "payloadClassification": payload.get("classification") or payload.get("summary", {}).get("classification") or "local_playable_subset_only_not_full_payload",
        "statusCounts": {
            "timelineLocalStatus": dict(Counter(r.get("localStatus") for r in timeline_rows)),
            "blockers": dict(Counter(r.get("status") for r in blocker_rows)),
        },
        "outputs": {
            "resultMd": str(OUT_MD),
            "resultJson": str(OUT_JSON),
            "skillTimelineValidationCsv": str(OUT_TIMELINE),
            "skillPrefabComponentDependencyRefsCsv": str(OUT_REFS),
            "blockerSeparationCsv": str(OUT_BLOCKERS),
            "log": str(OUT_LOG),
        },
    }
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    OUT_MD.write_text(build_md(result), encoding="utf-8")
    OUT_LOG.write_text(
        "\n".join(
            [
                PREFIX,
                f"sourceBackedSkillRowsChecked={result['sourceBackedSkillRowsChecked']}",
                f"resourceCompleteSkillRowsVerified={result['resourceCompleteSkillRowsVerified']}",
                f"missingCommonDependencyRows={result['missingCommonDependencyRows']}",
                f"skillTimelineChainVerifiedForResourceCompleteSubset={result['skillTimelineChainVerifiedForResourceCompleteSubset']}",
                "sceneSaved=false",
                "handlerBindingApplied=false",
                "xLuaRuntimeUsed=false",
            ]
        )
        + "\n",
        encoding="utf-8",
    )
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
