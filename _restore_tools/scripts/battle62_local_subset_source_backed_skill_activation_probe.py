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
PREFIX = "BATTLE_62_LOCAL_SUBSET_SOURCE_BACKED_SKILL_ACTIVATION_PROBE_NO_XLUA_NO_ORIGINAL_HANDLER_CLAIM"

UNITY_SUMMARY = UNITY_DATA / f"{PREFIX}_UNITY_SUMMARY.json"
UNITY_SKILL = UNITY_DATA / f"{PREFIX}_SKILL_ACTIVATION_PROBE_MATRIX.csv"
UNITY_ACTOR = UNITY_DATA / f"{PREFIX}_ACTOR_TARGET_ANCHOR_CONTEXT.csv"
UNITY_BLOCKER = UNITY_DATA / f"{PREFIX}_DEPENDENCY_RUNTIME_COMPONENT_BLOCKERS.csv"
UNITY_CLASS = UNITY_DATA / f"{PREFIX}_CANDIDATE_CLASSIFICATION_NEXT_ACTION.csv"

OUT_MD = REPORT_DIR / f"{PREFIX}_RESULT.md"
OUT_JSON = REPORT_DIR / f"{PREFIX}_RESULT.json"
OUT_SKILL = REPORT_DIR / f"{PREFIX}_SKILL_ACTIVATION_PROBE_MATRIX.csv"
OUT_ACTOR = REPORT_DIR / f"{PREFIX}_ACTOR_TARGET_ANCHOR_CONTEXT.csv"
OUT_BLOCKER = REPORT_DIR / f"{PREFIX}_DEPENDENCY_RUNTIME_COMPONENT_BLOCKERS.csv"
OUT_CLASS = REPORT_DIR / f"{PREFIX}_CANDIDATE_CLASSIFICATION_NEXT_ACTION.csv"
OUT_LOG = REPORT_DIR / f"{PREFIX}.log"

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


def truthy(v: Any) -> bool:
    return str(v).strip().lower() in {"true", "1", "yes"}


def command_policy() -> dict[str, Any]:
    root_cmds = sorted(str(p) for p in BASE.glob("*.cmd"))
    direct_cmds = sorted(str(p) for p in (BASE / "_restore_tools").glob("*.cmd"))
    return {
        "rootCmdCount": len(root_cmds),
        "rootCmdFiles": root_cmds,
        "restoreToolsDirectCmdCount": len(direct_cmds),
        "restoreToolsDirectCmdFiles": direct_cmds,
    }


def build_md(result: dict[str, Any]) -> str:
    lines = [
        f"# {PREFIX} Result",
        "",
        "**Not a restored/original-handler claim.** BATTLE62 is a diagnostic source-backed skill activation probe over the BATTLE57 local actor subset.",
        "",
        "## Verdict",
        f"- restoredClaim: `{str(result['restoredClaim']).lower()}`",
        f"- playableClaim: `{str(result['playableClaim']).lower()}`",
        f"- originalHandlerBindingClaim: `{str(result['originalHandlerBindingClaim']).lower()}`",
        f"- sceneSaved: `{str(result['sceneSaved']).lower()}`",
        f"- xLuaRuntimeUsed: `{str(result['xLuaRuntimeUsed']).lower()}`",
        f"- sourceBackedSkillActivationProbeFeasible: `{str(result['sourceBackedSkillActivationProbeFeasible']).lower()}`",
        f"- nextBlocker: `{result['nextBlocker']}`",
        "",
        "## Probe Counts",
        f"- source-backed skill rows checked: `{result['sourceBackedSkillRowsChecked']}`",
        f"- skill prefabs loaded/instantiated: `{result['skillPrefabsLoaded']}` / `{result['skillPrefabsInstantiated']}`",
        f"- skill rows with visual signal: `{result['skillRowsWithVisualSignal']}`",
        f"- actors visible during probe: `{result['actorsVisibleDuringProbe']}`",
        f"- diagnostic capture produced: `{str(result['diagnosticCaptureProduced']).lower()}`",
        "",
        "## Outputs",
        f"- result JSON: `{OUT_JSON}`",
        f"- skill activation matrix CSV: `{OUT_SKILL}`",
        f"- actor target/anchor context CSV: `{OUT_ACTOR}`",
        f"- dependency/runtime blocker CSV: `{OUT_BLOCKER}`",
        f"- classification CSV: `{OUT_CLASS}`",
        "",
        "## Command Policy",
        f"- root `.cmd` count: `{result['commandPolicy']['rootCmdCount']}`",
        f"- `_restore_tools` direct `.cmd` count: `{result['commandPolicy']['restoreToolsDirectCmdCount']}`",
        f"- `플레이.mp4`: `{'available' if PLAY_VIDEO.exists() else 'missing'}`",
        f"- `참고.mp4`: `{'available, auxiliary only' if AUX_VIDEO.exists() else 'missing'}`",
    ]
    return "\n".join(lines) + "\n"


def main() -> int:
    summary = read_json(UNITY_SUMMARY, {})
    skill_rows = copy_csv(UNITY_SKILL, OUT_SKILL)
    actor_rows = copy_csv(UNITY_ACTOR, OUT_ACTOR)
    blocker_rows = copy_csv(UNITY_BLOCKER, OUT_BLOCKER)
    class_rows = copy_csv(UNITY_CLASS, OUT_CLASS)

    guardrails = {
        "fakeSkillCreated": False,
        "fakeEffectCreated": False,
        "fakeCardIconTextCreated": False,
        "handlerPatchApplied": False,
        "dummyLuaUsed": False,
        "externalXluaImported": False,
        "androidInstrumentationUsed": False,
        "originalHandlerBindingClaim": False,
        "sceneSaved": False,
        "mainInterfaceTouched": False,
    }
    classification_counts = dict(Counter(r.get("classification", "") for r in skill_rows))
    result = {
        "prefix": PREFIX,
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "restoredClaim": False,
        "playableClaim": False,
        "isFinalRestoredBattleScreen": False,
        "originalHandlerBindingClaim": False,
        "sceneSaved": False,
        "xLuaRuntimeUsed": False,
        "sourceBackedSkillRowsChecked": int(summary.get("sourceBackedSkillRowsChecked", len(skill_rows) or 0)),
        "skillPrefabsLoaded": int(summary.get("skillPrefabsLoaded", sum(1 for r in skill_rows if truthy(r.get("assetLoadSuccess"))))),
        "skillPrefabsInstantiated": int(summary.get("skillPrefabsInstantiated", sum(1 for r in skill_rows if truthy(r.get("instantiateSuccess"))))),
        "skillRowsWithVisualSignal": int(summary.get("skillRowsWithVisualSignal", sum(1 for r in skill_rows if truthy(r.get("visualSignalObserved"))))),
        "actorsVisibleDuringProbe": int(summary.get("actorsVisibleDuringProbe", sum(1 for r in actor_rows if truthy(r.get("visibleForProbe"))))),
        "diagnosticCaptureProduced": bool(summary.get("diagnosticCaptureProduced", False)),
        "diagnosticCaptureCount": int(summary.get("diagnosticCaptureCount", 0)),
        "diagnosticCapturePaths": summary.get("capturePaths", ""),
        "sourceBackedSkillActivationProbeFeasible": bool(summary.get("sourceBackedSkillActivationProbeFeasible", False)),
        "classificationCounts": classification_counts,
        "nextBlocker": "original_xlua_gameentry_handler_runtime_required_for_true_input_playability_and_full_payload_actor_gaps",
        "guardrailsTouched": guardrails,
        "commandPolicy": command_policy(),
        "outputs": {
            "resultMd": str(OUT_MD),
            "resultJson": str(OUT_JSON),
            "skillActivationProbeMatrixCsv": str(OUT_SKILL),
            "actorTargetAnchorContextCsv": str(OUT_ACTOR),
            "dependencyRuntimeBlockerCsv": str(OUT_BLOCKER),
            "candidateClassificationCsv": str(OUT_CLASS),
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
                f"skillPrefabsLoaded={result['skillPrefabsLoaded']}",
                f"skillPrefabsInstantiated={result['skillPrefabsInstantiated']}",
                f"skillRowsWithVisualSignal={result['skillRowsWithVisualSignal']}",
                f"actorsVisibleDuringProbe={result['actorsVisibleDuringProbe']}",
                f"diagnosticCaptureProduced={result['diagnosticCaptureProduced']}",
                "originalHandlerBindingClaim=false",
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
