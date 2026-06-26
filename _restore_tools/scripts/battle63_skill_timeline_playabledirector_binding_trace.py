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
UNITY_DATA = PROJECT / "Assets" / "RestoreData" / "battle"
PREFIX = "BATTLE_63_SKILL_TIMELINE_PLAYABLEDIRECTOR_BINDING_REQUIREMENTS_TRACE_NO_XLUA_NO_HANDLER_PATCH"

UNITY_SUMMARY = UNITY_DATA / f"{PREFIX}_UNITY_SUMMARY.json"
UNITY_DIRECTOR = UNITY_DATA / f"{PREFIX}_DIRECTOR_TYPE_MISMATCH_MATRIX.csv"
UNITY_TIMELINE = UNITY_DATA / f"{PREFIX}_TIMELINE_TRACKS_EXPOSED_BINDING_REQUIREMENTS.csv"
UNITY_REST = UNITY_DATA / f"{PREFIX}_PREFAB_COMPONENT_REST_STATE_VISUAL_CAPABILITY.csv"
UNITY_CLASS = UNITY_DATA / f"{PREFIX}_CLASSIFICATION_NEXT_ACTION.csv"

OUT_MD = REPORT_DIR / f"{PREFIX}_RESULT.md"
OUT_JSON = REPORT_DIR / f"{PREFIX}_RESULT.json"
OUT_DIRECTOR = REPORT_DIR / f"{PREFIX}_DIRECTOR_TYPE_MISMATCH_MATRIX.csv"
OUT_TIMELINE = REPORT_DIR / f"{PREFIX}_TIMELINE_TRACKS_EXPOSED_BINDING_REQUIREMENTS.csv"
OUT_REST = REPORT_DIR / f"{PREFIX}_PREFAB_COMPONENT_REST_STATE_VISUAL_CAPABILITY.csv"
OUT_CLASS = REPORT_DIR / f"{PREFIX}_CLASSIFICATION_NEXT_ACTION.csv"
OUT_LOG = REPORT_DIR / f"{PREFIX}.log"
UNITY_LOG = REPORT_DIR / f"{PREFIX}_UNITY.log"

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


def copy_csv(src: Path, dst: Path) -> list[dict[str, str]]:
    if src.exists():
        shutil.copyfile(src, dst)
    return read_csv(dst)


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


def count_unique_rows(rows: list[dict[str, str]], predicate) -> int:
    keys = set()
    for row in rows:
        if predicate(row):
            keys.add((row.get("ownerHeroDid", ""), row.get("skillDid", ""), row.get("prefabField", ""), row.get("prefabId", "")))
    return len(keys)


def build_md(result: dict[str, Any]) -> str:
    dominant = result.get("dominantClassification", "")
    lines = [
        f"# {PREFIX} Result",
        "",
        "**Investigation only.** BATTLE63 does not bind handlers, does not use xLua, and does not save a scene.",
        "",
        "## Verdict",
        f"- restoredClaim: `{str(result['restoredClaim']).lower()}`",
        f"- playableClaim: `{str(result['playableClaim']).lower()}`",
        f"- handlerPatchApplied: `{str(result['handlerPatchApplied']).lower()}`",
        f"- xLuaRuntimeUsed: `{str(result['xLuaRuntimeUsed']).lower()}`",
        f"- sceneSaved: `{str(result['sceneSaved']).lower()}`",
        f"- nextBlocker: `{result['nextBlocker']}`",
        "",
        "## Counts",
        f"- source-backed skill rows checked: `{result['sourceBackedSkillRowsChecked']}`",
        f"- PlayableDirector rows found: `{result['playableDirectorsFound']}`",
        f"- timeline assets inspectable: `{result['timelineAssetsInspectable']}`",
        f"- rows with PlayableAsset type mismatch: `{result['rowsWithPlayableAssetTypeMismatch']}`",
        f"- rows requiring timeline bindings/runtime context: `{result['rowsRequiringTimelineBindings']}`",
        f"- rows renderable at rest: `{result['rowsWithRenderableAtRest']}`",
        f"- source-backed visual activation candidates: `{result['rowsWithSourceBackedVisualActivationCandidate']}`",
        f"- dominant classification: `{dominant}`",
        "",
        "## Outputs",
        f"- director/type mismatch CSV: `{OUT_DIRECTOR}`",
        f"- timeline binding requirements CSV: `{OUT_TIMELINE}`",
        f"- rest-state visual capability CSV: `{OUT_REST}`",
        f"- classification CSV: `{OUT_CLASS}`",
        f"- result JSON: `{OUT_JSON}`",
        f"- Unity log: `{UNITY_LOG}`",
        "",
        "## Command Policy",
        f"- root `.cmd` count: `{result['commandPolicy']['rootCmdCount']}`",
        f"- `_restore_tools` direct `.cmd` count: `{result['commandPolicy']['restoreToolsDirectCmdCount']}`",
        f"- `플레이.mp4`: `{'available' if PLAY_VIDEO.exists() else 'missing'}`",
        f"- `참고.mp4`: `{'available, auxiliary only' if AUX_VIDEO.exists() else 'missing'}`",
    ]
    return "\n".join(lines) + "\n"


def main() -> int:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    summary = read_json(UNITY_SUMMARY, {})
    director_rows = copy_csv(UNITY_DIRECTOR, OUT_DIRECTOR)
    timeline_rows = copy_csv(UNITY_TIMELINE, OUT_TIMELINE)
    rest_rows = copy_csv(UNITY_REST, OUT_REST)
    class_rows = copy_csv(UNITY_CLASS, OUT_CLASS)

    classification_counts = Counter(r.get("classification", "") for r in class_rows)
    dominant_classification = classification_counts.most_common(1)[0][0] if classification_counts else ""
    rows_checked = int(summary.get("sourceBackedSkillRowsChecked") or len(class_rows) or 0)
    playable_directors = int(summary.get("playableDirectorsFound") or sum(1 for r in director_rows if r.get("directorPath")))
    timeline_inspectable = int(summary.get("timelineAssetsInspectable") or count_unique_rows(timeline_rows, lambda r: truthy(r.get("timelineInspectable"))))
    mismatch_rows = int(summary.get("rowsWithPlayableAssetTypeMismatch") or count_unique_rows(class_rows, lambda r: truthy(r.get("typeMismatchAny"))))
    binding_rows = int(summary.get("rowsRequiringTimelineBindings") or count_unique_rows(class_rows, lambda r: truthy(r.get("timelineBindingRequiredAny"))))
    renderable_rows = int(summary.get("rowsWithRenderableAtRest") or count_unique_rows(rest_rows, lambda r: truthy(r.get("hasRenderableAtRest"))))
    visual_candidate_rows = int(summary.get("rowsWithSourceBackedVisualActivationCandidate") or count_unique_rows(class_rows, lambda r: r.get("classification") == "source_backed_visual_activation_candidate"))

    next_blocker = (
        "source_compatible_timeline_playableasset_bridge_or_original_playabledirector_binding_runtime_required_"
        "plus_original_xlua_handler_and_full_payload_actor_gaps"
    )
    guardrails = {
        "fakeSkillCreated": False,
        "fakeEffectCreated": False,
        "fakeCardIconTextCreated": False,
        "handlerPatchApplied": False,
        "dummyLuaUsed": False,
        "externalXluaImported": False,
        "androidInstrumentationUsed": False,
        "mainInterfaceTouched": False,
        "sceneSaved": False,
    }
    result = {
        "prefix": PREFIX,
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "restoredClaim": False,
        "playableClaim": False,
        "isFinalRestoredBattleScreen": False,
        "handlerPatchApplied": False,
        "xLuaRuntimeUsed": False,
        "sceneSaved": False,
        "sourceBackedSkillRowsChecked": rows_checked,
        "playableDirectorsFound": playable_directors,
        "timelineAssetsInspectable": timeline_inspectable,
        "rowsWithPlayableAssetTypeMismatch": mismatch_rows,
        "rowsRequiringTimelineBindings": binding_rows,
        "rowsWithRenderableAtRest": renderable_rows,
        "rowsWithSourceBackedVisualActivationCandidate": visual_candidate_rows,
        "dominantClassification": dominant_classification,
        "classificationCounts": dict(classification_counts),
        "nextBlocker": next_blocker,
        "guardrailsTouched": guardrails,
        "commandPolicy": command_policy(),
        "outputs": {
            "resultMd": str(OUT_MD),
            "resultJson": str(OUT_JSON),
            "directorTypeMismatchCsv": str(OUT_DIRECTOR),
            "timelineBindingRequirementsCsv": str(OUT_TIMELINE),
            "prefabRestStateVisualCapabilityCsv": str(OUT_REST),
            "classificationNextActionCsv": str(OUT_CLASS),
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
                f"sourceBackedSkillRowsChecked={rows_checked}",
                f"playableDirectorsFound={playable_directors}",
                f"timelineAssetsInspectable={timeline_inspectable}",
                f"rowsWithPlayableAssetTypeMismatch={mismatch_rows}",
                f"rowsRequiringTimelineBindings={binding_rows}",
                f"dominantClassification={dominant_classification}",
                "handlerPatchApplied=false",
                "xLuaRuntimeUsed=false",
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
