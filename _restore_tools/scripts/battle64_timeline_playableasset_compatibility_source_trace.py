from __future__ import annotations

import csv
import json
import re
import shutil
from collections import Counter
from datetime import datetime
from pathlib import Path
from typing import Any

import UnityPy


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_battle_unity"
REPORT_DIR = BASE / "reports" / "battle"
UNITY_DATA = PROJECT / "Assets" / "RestoreData" / "battle"
PREFIX = "BATTLE_64_TIMELINE_PLAYABLEASSET_COMPATIBILITY_AND_ORIGINAL_BINDING_SOURCE_TRACE_NO_PATCH"

MANIFEST_CSV = REPORT_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST_SPEEDLINE_RESOLVED.csv"
BATTLE63_DIRECTOR = REPORT_DIR / "BATTLE_63_SKILL_TIMELINE_PLAYABLEDIRECTOR_BINDING_REQUIREMENTS_TRACE_NO_XLUA_NO_HANDLER_PATCH_DIRECTOR_TYPE_MISMATCH_MATRIX.csv"
CLEAN_SLICE_ROOT = BASE / "girlswar_merged_extracted" / "extracted" / "unity" / "clean_unityfs_slices"
UNITY_COMPAT = UNITY_DATA / f"{PREFIX}_UNITY_PACKAGE_TYPE_IDENTITY_COMPATIBILITY_MATRIX.csv"

OUT_MD = REPORT_DIR / f"{PREFIX}_RESULT.md"
OUT_JSON = REPORT_DIR / f"{PREFIX}_RESULT.json"
OUT_COMPAT = REPORT_DIR / f"{PREFIX}_UNITY_PACKAGE_TYPE_IDENTITY_COMPATIBILITY_MATRIX.csv"
OUT_BUNDLE = REPORT_DIR / f"{PREFIX}_BUNDLED_TIMELINE_ASSET_ASSIGNED_TYPE_CLASS_MATRIX.csv"
OUT_SOURCE = REPORT_DIR / f"{PREFIX}_ORIGINAL_BINDING_SOURCE_EVIDENCE_MATRIX.csv"
OUT_DECISION = REPORT_DIR / f"{PREFIX}_DECISION_NEXT_ACTION_MATRIX.csv"
OUT_LOG = REPORT_DIR / f"{PREFIX}.log"
UNITY_LOG = REPORT_DIR / f"{PREFIX}_UNITY.log"

PLAY_VIDEO = Path(r"C:\Users\godho\Downloads\플레이.mp4")
AUX_VIDEO = Path(r"C:\Users\godho\Downloads\참고.mp4")


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, Any]], headers: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=headers, extrasaction="ignore")
        writer.writeheader()
        for row in rows:
            writer.writerow({h: row.get(h, "") for h in headers})


def truthy(value: Any) -> bool:
    return str(value).strip().lower() in {"true", "1", "yes"}


def command_policy() -> dict[str, Any]:
    root_cmds = sorted(str(p) for p in BASE.glob("*.cmd"))
    direct_cmds = sorted(str(p) for p in (BASE / "_restore_tools").glob("*.cmd"))
    return {
        "rootCmdCount": len(root_cmds),
        "rootCmdFiles": root_cmds,
        "restoreToolsDirectCmdCount": len(direct_cmds),
        "restoreToolsDirectCmdFiles": direct_cmds,
    }


def minimal_skill_rows() -> list[dict[str, str]]:
    return [
        r
        for r in read_csv(MANIFEST_CSV)
        if r.get("rowType") == "skill"
        and r.get("localStatus") == "loadable"
        and r.get("ownerHeroDid") in {"1002", "1034", "1100111"}
        and r.get("prefabId")
    ]


def resolve_bundle(bundle: str) -> Path:
    return CLEAN_SLICE_ROOT / bundle.replace("\\", "/")


def obj_name(data: Any) -> str:
    return str(getattr(data, "m_Name", "") or getattr(data, "name", "") or "")


def pptr_path_id(pptr: Any) -> int:
    return int(getattr(pptr, "m_PathID", 0) or getattr(pptr, "path_id", 0) or 0)


def object_script_name(objects: dict[int, Any], obj: Any) -> str:
    try:
        data = obj.read()
    except Exception:
        return ""
    script = getattr(data, "m_Script", None)
    sid = pptr_path_id(script)
    if not sid or sid not in objects:
        return ""
    try:
        return obj_name(objects[sid].read())
    except Exception:
        return ""


def read_object(objects: dict[int, Any], path_id: int) -> Any:
    obj = objects.get(path_id)
    if obj is None:
        return None
    try:
        return obj.read()
    except Exception:
        return None


def inspect_bundle_rows(rows: list[dict[str, str]]) -> list[dict[str, Any]]:
    output: list[dict[str, Any]] = []
    cache: dict[str, Any] = {}
    for row in rows:
        bundle = row.get("bundle", "").replace("\\", "/")
        bundle_path = resolve_bundle(bundle)
        bundle_exists = bundle_path.exists()
        env = None
        objects: dict[int, Any] = {}
        load_error = ""
        if bundle_exists:
            try:
                if bundle not in cache:
                    cache[bundle] = UnityPy.load(str(bundle_path))
                env = cache[bundle]
                objects = {int(o.path_id): o for o in env.objects}
            except Exception as exc:
                load_error = f"{type(exc).__name__}: {exc}"
        prefab_id = str(row.get("prefabId", ""))
        timeline_candidates = []
        directors_for_timeline = []
        object_type_counts = Counter()
        if env is not None:
            object_type_counts = Counter(str(o.type.name) for o in env.objects)
            for obj in env.objects:
                if str(obj.type.name) != "MonoBehaviour":
                    continue
                try:
                    data = obj.read()
                except Exception:
                    continue
                script_name = object_script_name(objects, obj)
                if obj_name(data) == prefab_id and script_name == "TimelineAsset":
                    timeline_candidates.append((obj, data))
            timeline_ids = {int(obj.path_id) for obj, _ in timeline_candidates}
            for obj in env.objects:
                if str(obj.type.name) != "PlayableDirector":
                    continue
                try:
                    data = obj.read()
                except Exception:
                    continue
                playable_id = pptr_path_id(getattr(data, "m_PlayableAsset", None))
                if playable_id in timeline_ids:
                    directors_for_timeline.append((obj, data))
        timeline_obj = timeline_candidates[0][0] if timeline_candidates else None
        timeline_data = timeline_candidates[0][1] if timeline_candidates else None
        track_ids = [pptr_path_id(p) for p in (getattr(timeline_data, "m_Tracks", []) if timeline_data is not None else [])]
        track_script_names: list[str] = []
        track_object_types: list[str] = []
        track_names: list[str] = []
        clip_counts: list[int] = []
        for tid in track_ids:
            obj = objects.get(tid)
            if obj is None:
                continue
            track_object_types.append(str(obj.type.name))
            try:
                data = obj.read()
            except Exception:
                continue
            track_names.append(obj_name(data))
            track_script_names.append(object_script_name(objects, obj))
            clips = getattr(data, "m_Clips", None)
            try:
                clip_counts.append(len(clips) if clips is not None else 0)
            except Exception:
                clip_counts.append(0)
        director_path_ids = [str(int(obj.path_id)) for obj, _ in directors_for_timeline]
        scene_binding_counts = []
        scene_binding_null_values = []
        exposed_ref_counts = []
        for _, data in directors_for_timeline:
            bindings = getattr(data, "m_SceneBindings", []) or []
            scene_binding_counts.append(len(bindings))
            null_values = 0
            for binding in bindings:
                value = getattr(binding, "value", None)
                if pptr_path_id(value) == 0:
                    null_values += 1
            scene_binding_null_values.append(null_values)
            exposed = getattr(data, "m_ExposedReferences", None)
            refs = getattr(exposed, "m_References", []) if exposed is not None else []
            exposed_ref_counts.append(len(refs) if refs is not None else 0)
        output.append(
            {
                "side": row.get("side", ""),
                "waveNo": row.get("waveNo", ""),
                "ownerHeroDid": row.get("ownerHeroDid", ""),
                "skillDid": row.get("skillDid", ""),
                "prefabField": row.get("prefabField", ""),
                "prefabId": prefab_id,
                "skillBundle": bundle,
                "resolvedBundlePath": str(bundle_path),
                "bundleExists": bundle_exists,
                "unityPyLoadSuccess": env is not None,
                "loadError": load_error,
                "bundleObjectTypeCounts": "|".join(f"{k}:{v}" for k, v in sorted(object_type_counts.items())),
                "timelineAssetObjectPathId": int(timeline_obj.path_id) if timeline_obj else "",
                "timelineAssetObjectClass": str(timeline_obj.type.name) if timeline_obj else "",
                "timelineAssetName": obj_name(timeline_data) if timeline_data is not None else "",
                "timelineAssetScriptPathId": pptr_path_id(getattr(timeline_data, "m_Script", None)) if timeline_data is not None else "",
                "timelineAssetScriptName": object_script_name(objects, timeline_obj) if timeline_obj else "",
                "timelineVersion": getattr(timeline_data, "m_Version", "") if timeline_data is not None else "",
                "timelineTrackCount": len(track_ids),
                "timelineTrackPathIds": "|".join(str(t) for t in track_ids),
                "trackObjectTypes": "|".join(track_object_types),
                "trackScriptNames": "|".join(s for s in track_script_names if s),
                "trackNames": "|".join(s for s in track_names if s),
                "trackClipCountTotal": sum(clip_counts),
                "playableDirectorsPointingToTimeline": len(directors_for_timeline),
                "playableDirectorPathIds": "|".join(director_path_ids),
                "sceneBindingKeyCount": "|".join(str(v) for v in scene_binding_counts),
                "sceneBindingNullValueCount": "|".join(str(v) for v in scene_binding_null_values),
                "exposedReferenceCount": "|".join(str(v) for v in exposed_ref_counts),
                "serializedTypeFinding": "bundle_contains_timelineasset_monoscript_and_director_pptr" if timeline_obj else "timelineasset_object_not_found_by_prefab_id",
            }
        )
    return output


def source_files() -> list[Path]:
    decoded = BASE / "girlswar_merged_extracted" / "decoded" / "xlua_battle"
    il2cpp = BASE / "girlswar_merged_extracted" / "extracted" / "il2cpp_dump"
    files = []
    files.extend(decoded.glob("**/*ProcedureNormalBattle*_raw.lua"))
    files.extend(decoded.glob("**/*HeroCtrl*_raw.lua"))
    files.extend(decoded.glob("**/*BattleSkillEffectManager*_raw.lua"))
    files.extend(decoded.glob("**/*BattlePreviewMgr*_raw.lua"))
    files.extend((BASE / "girlswar_merged_extracted" / "extracted" / "unity" / "bundles" / "b_b5ef89e1c4754d94" / "textassets").glob("*BattleTimelineResMap*.txt"))
    for name in ["dump.cs", "stringliteral.json", "script.json"]:
        p = il2cpp / name
        if p.exists():
            files.append(p)
    return files


SOURCE_PATTERNS = [
    ("lua_timeline_effect_component", re.compile(r"GetComponent\(typeof\(CS\.YouYou\.TimelineEffect\)\)|CurrTimelineEffect")),
    ("lua_buildpatch_playtimeline", re.compile(r"BuildPatchMgr:PlayTimeLine|PlayTimeLinenPreview")),
    ("lua_timeline_lifecycle", re.compile(r"isTimeLine\s*=\s*true|isTimeLine\s*=\s*false|BackupAllHeroBeforeTimeLine|RestoreAllHeroAfterTimeLine|OnStopped")),
    ("lua_timeline_damage_state", re.compile(r"BeforeTimeLine|InTimeLine|SetTimelineEffect")),
    ("il2cpp_timeline_effect_type", re.compile(r"public class TimelineEffect|YouYouTimelineEffectWrap|CurrPlayableDirector|PlayTimeLine\(")),
    ("il2cpp_playable_director_binding", re.compile(r"SetGenericBinding|GetGenericBinding|RebindPlayableGraphOutputs|PlayableDirector")),
    ("il2cpp_timeline_asset_type", re.compile(r"public class TimelineAsset : PlayableAsset|UnityEngine\.Timeline\.TimelineAsset")),
]


def collect_source_evidence(limit: int = 160, per_type_limit: int = 24) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    seen = set()
    counts: Counter[str] = Counter()
    for path in source_files():
        try:
            with path.open("r", encoding="utf-8-sig", errors="ignore") as f:
                for line_no, line in enumerate(f, start=1):
                    text = line.strip()
                    if not text:
                        continue
                    for evidence_type, pattern in SOURCE_PATTERNS:
                        if not pattern.search(text):
                            continue
                        if counts[evidence_type] >= per_type_limit:
                            continue
                        key = (str(path), line_no, evidence_type)
                        if key in seen:
                            continue
                        seen.add(key)
                        counts[evidence_type] += 1
                        rows.append(
                            {
                                "evidenceType": evidence_type,
                                "sourceFile": str(path),
                                "line": line_no,
                                "text": text[:500],
                                "implication": implication_for(evidence_type),
                            }
                        )
                        break
                    if len(rows) >= limit:
                        return rows
        except Exception:
            continue
    return rows


def implication_for(evidence_type: str) -> str:
    return {
        "lua_timeline_effect_component": "Lua expects CS.YouYou.TimelineEffect on the instantiated skill prefab and stores it as CurrTimelineEffect.",
        "lua_buildpatch_playtimeline": "Original runtime starts timeline playback through BuildPatchMgr/TimelineEffect, not raw prefab activation.",
        "lua_timeline_lifecycle": "ProcedureNormalBattle toggles timeline battle state and restores actor state around playback.",
        "lua_timeline_damage_state": "HeroCtrl/HeroBattleInfo hold timeline-only damage, fury, buff, and animation state.",
        "il2cpp_timeline_effect_type": "Original IL2CPP contains YouYou.TimelineEffect and xLua wrapper methods.",
        "il2cpp_playable_director_binding": "PlayableDirector binding API and xLua wrappers exist in original runtime.",
        "il2cpp_timeline_asset_type": "Original IL2CPP contains UnityEngine.Timeline.TimelineAsset inheriting PlayableAsset.",
    }.get(evidence_type, "")


def decision_rows(compat: list[dict[str, str]], bundle: list[dict[str, Any]], source: list[dict[str, Any]]) -> list[dict[str, Any]]:
    timeline_package_missing = any(r.get("item") == "com.unity.timeline" and r.get("value") == "absent" for r in compat)
    timeline_type_missing = any(r.get("item") == "UnityEngine.Timeline.TimelineAsset" and r.get("value") == "not_found" for r in compat)
    bundle_has_timeline = sum(1 for r in bundle if r.get("timelineAssetScriptName") == "TimelineAsset")
    source_runtime = len(source)
    return [
        {
            "decision": "safe_no_patch_report_only",
            "status": "recommended",
            "evidence": f"timelinePackageMissing={timeline_package_missing}; timelineTypeMissing={timeline_type_missing}; bundleTimelineAssets={bundle_has_timeline}; originalBindingEvidenceRows={source_runtime}",
            "nextAction": "Do not patch scene or handlers; report missing source-compatible Timeline runtime/package plus original binding context.",
        },
        {
            "decision": "source_compatible_timeline_package_reimport_candidate",
            "status": "candidate_requires_manual_review",
            "evidence": "Project manifest lacks com.unity.timeline, but source-backed executable editor package is not present in battle project.",
            "nextAction": "Only consider if a local source-compatible Timeline package/runtime is approved and imported separately.",
        },
        {
            "decision": "serialized_type_remap_candidate_needs_manual_review",
            "status": "not_applied",
            "evidence": "AssetBundle TimelineAsset is serialized as MonoBehaviour with TimelineAsset MonoScript and PlayableDirector PPtrs; remapping without exact package/runtime is unsafe.",
            "nextAction": "Manual review required before any remap; no automatic type or scene rewrite.",
        },
        {
            "decision": "requires_original_runtime_binding_context",
            "status": "active_blocker",
            "evidence": "Lua/IL2CPP evidence routes through CS.YouYou.TimelineEffect, BuildPatchMgr:PlayTimeLine, ProcedureNormalBattle state, and PlayableDirector binding wrappers.",
            "nextAction": "Recover original xLua/GameEntry/LuaManager/TimelineEffect runtime or approved equivalent before claiming activation.",
        },
        {
            "decision": "requires_external_package_or_runtime_approval",
            "status": "blocked_by_guardrail",
            "evidence": "External package import/download is forbidden for this task.",
            "nextAction": "Ask control tower/user before any external Timeline/xLua package import.",
        },
    ]


def build_md(result: dict[str, Any]) -> str:
    return "\n".join(
        [
            f"# {PREFIX} Result",
            "",
            "**Report/no-patch task.** No scene, handler, xLua, package, or runtime patch was applied.",
            "",
            "## Verdict",
            f"- restoredClaim: `{str(result['restoredClaim']).lower()}`",
            f"- playableClaim: `{str(result['playableClaim']).lower()}`",
            f"- patchApplied: `{str(result['patchApplied']).lower()}`",
            f"- sceneSaved: `{str(result['sceneSaved']).lower()}`",
            f"- recommendedDecision: `{result['recommendedDecision']}`",
            f"- nextBlocker: `{result['nextBlocker']}`",
            "",
            "## Findings",
            f"- source-backed skill rows checked: `{result['sourceBackedSkillRowsChecked']}`",
            f"- PlayableAsset type mismatch rows carried from BATTLE63: `{result['playableAssetTypeMismatchRows']}`",
            f"- timeline package compatibility finding: `{result['timelinePackageCompatibilityFinding']}`",
            f"- original binding evidence rows: `{result['originalBindingEvidenceRows']}`",
            "",
            "## Outputs",
            f"- compatibility CSV: `{OUT_COMPAT}`",
            f"- bundled timeline asset matrix CSV: `{OUT_BUNDLE}`",
            f"- original binding source evidence CSV: `{OUT_SOURCE}`",
            f"- decision matrix CSV: `{OUT_DECISION}`",
            f"- result JSON: `{OUT_JSON}`",
            "",
            "## Command Policy",
            f"- root `.cmd` count: `{result['commandPolicy']['rootCmdCount']}`",
            f"- `_restore_tools` direct `.cmd` count: `{result['commandPolicy']['restoreToolsDirectCmdCount']}`",
            f"- `플레이.mp4`: `{'available' if PLAY_VIDEO.exists() else 'missing'}`",
            f"- `참고.mp4`: `{'available, auxiliary only' if AUX_VIDEO.exists() else 'missing'}`",
        ]
    ) + "\n"


def main() -> int:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    compat_rows = read_csv(UNITY_COMPAT)
    if UNITY_COMPAT.exists():
        shutil.copyfile(UNITY_COMPAT, OUT_COMPAT)
    skill_rows = minimal_skill_rows()
    bundle_rows = inspect_bundle_rows(skill_rows)
    source_rows = collect_source_evidence()
    decisions = decision_rows(compat_rows, bundle_rows, source_rows)

    write_csv(
        OUT_BUNDLE,
        bundle_rows,
        [
            "side",
            "waveNo",
            "ownerHeroDid",
            "skillDid",
            "prefabField",
            "prefabId",
            "skillBundle",
            "resolvedBundlePath",
            "bundleExists",
            "unityPyLoadSuccess",
            "loadError",
            "bundleObjectTypeCounts",
            "timelineAssetObjectPathId",
            "timelineAssetObjectClass",
            "timelineAssetName",
            "timelineAssetScriptPathId",
            "timelineAssetScriptName",
            "timelineVersion",
            "timelineTrackCount",
            "timelineTrackPathIds",
            "trackObjectTypes",
            "trackScriptNames",
            "trackNames",
            "trackClipCountTotal",
            "playableDirectorsPointingToTimeline",
            "playableDirectorPathIds",
            "sceneBindingKeyCount",
            "sceneBindingNullValueCount",
            "exposedReferenceCount",
            "serializedTypeFinding",
        ],
    )
    write_csv(OUT_SOURCE, source_rows, ["evidenceType", "sourceFile", "line", "text", "implication"])
    write_csv(OUT_DECISION, decisions, ["decision", "status", "evidence", "nextAction"])

    b63_rows = read_csv(BATTLE63_DIRECTOR)
    mismatch_rows = sum(1 for r in b63_rows if truthy(r.get("typeMismatchReproduced")))
    package_missing = any(r.get("item") == "com.unity.timeline" and r.get("value") == "absent" for r in compat_rows)
    type_missing = any(r.get("item") == "UnityEngine.Timeline.TimelineAsset" and r.get("value") == "not_found" for r in compat_rows)
    bundle_timeline_rows = sum(1 for r in bundle_rows if r.get("timelineAssetScriptName") == "TimelineAsset")
    finding = (
        "timeline_package_and_timelineasset_type_absent_in_restored_editor_but_bundles_serialize_timelineasset_monoscript"
        if package_missing and type_missing and bundle_timeline_rows
        else "timeline_compatibility_inconclusive"
    )
    result = {
        "prefix": PREFIX,
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "restoredClaim": False,
        "playableClaim": False,
        "isFinalRestoredBattleScreen": False,
        "patchApplied": False,
        "sceneSaved": False,
        "xLuaRuntimeUsed": False,
        "externalPackageImported": False,
        "runtimeInstrumentationUsed": False,
        "sourceBackedSkillRowsChecked": len(skill_rows),
        "playableAssetTypeMismatchRows": mismatch_rows,
        "timelinePackageCompatibilityFinding": finding,
        "bundledTimelineAssetRows": bundle_timeline_rows,
        "originalBindingEvidenceRows": len(source_rows),
        "recommendedDecision": "safe_no_patch_report_only",
        "nextBlocker": "source_compatible_unity_timeline_runtime_package_or_original_timelineeffect_playabledirector_binding_context_required_plus_xlua_handler_and_full_payload_gaps",
        "guardrailsTouched": {
            "fakeTimelineCreated": False,
            "fakeBindingCreated": False,
            "fakeHandlerCreated": False,
            "patchApplied": False,
            "sceneSaved": False,
            "xLuaRuntimeUsed": False,
            "externalPackageImported": False,
            "runtimeInstrumentationUsed": False,
            "mainInterfaceTouched": False,
        },
        "commandPolicy": command_policy(),
        "outputs": {
            "resultMd": str(OUT_MD),
            "resultJson": str(OUT_JSON),
            "compatibilityCsv": str(OUT_COMPAT),
            "bundledTimelineAssetMatrixCsv": str(OUT_BUNDLE),
            "originalBindingSourceEvidenceCsv": str(OUT_SOURCE),
            "decisionNextActionCsv": str(OUT_DECISION),
            "unityLog": str(UNITY_LOG),
            "log": str(OUT_LOG),
        },
    }
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    OUT_MD.write_text(build_md(result), encoding="utf-8")
    OUT_LOG.write_text(
        "\n".join(
            [
                PREFIX,
                f"sourceBackedSkillRowsChecked={len(skill_rows)}",
                f"playableAssetTypeMismatchRows={mismatch_rows}",
                f"timelinePackageCompatibilityFinding={finding}",
                f"bundledTimelineAssetRows={bundle_timeline_rows}",
                f"originalBindingEvidenceRows={len(source_rows)}",
                "recommendedDecision=safe_no_patch_report_only",
                "patchApplied=false",
                "sceneSaved=false",
            ]
        )
        + "\n",
        encoding="utf-8",
    )
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
