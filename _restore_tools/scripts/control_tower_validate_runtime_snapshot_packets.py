from __future__ import annotations

import argparse
import csv
import json
from collections import Counter
from datetime import datetime
from pathlib import Path
from typing import Any


ROOT = Path(r"C:\Users\godho\Downloads\girlswar")
REPORT_DIR = ROOT / "reports"

B75_PREFIX = "BATTLE_75_ORIGINAL_RUNTIME_SNAPSHOT_APPROVAL_PACKET_FOR_UI_NORMALBATTLE_ROUTE_TMP_MASK_HANDLER_AFTER_B74_NO_EXECUTION_NO_PATCH"
UI148_PREFIX = "MAININTERFACE_148_RUNTIME_SNAPSHOT_APPROVAL_PACKET_AND_STATIC_FIELD_EXHAUSTION_NO_RUNTIME_NO_PATCH"

DEFAULT_BATTLE_TEMPLATE = REPORT_DIR / "battle" / f"{B75_PREFIX}_APPROVAL_PACKET_TEMPLATE.json"
DEFAULT_BATTLE_RESULT = REPORT_DIR / "battle" / f"{B75_PREFIX}_RESULT.json"
DEFAULT_UI_TEMPLATE = REPORT_DIR / "maininterface" / f"{UI148_PREFIX}_approval_packet_template.json"
DEFAULT_UI_RESULT = REPORT_DIR / "maininterface" / f"{UI148_PREFIX}_RESULT.json"
DEFAULT_UNIFIED_PACKET = REPORT_DIR / "CONTROL_TOWER_UNIFIED_PRE_RUNTIME_APPROVAL_PACKET_20260626_093259.json"

PREFIX = "CONTROL_TOWER_RUNTIME_SNAPSHOT_PACKET_VALIDATOR"

PLACEHOLDER_STRINGS = {
    "",
    "todo",
    "tbd",
    "unknown",
    "n/a",
    "na",
    "null",
    "none",
    "placeholder",
    "fake",
    "dummy",
    "guess",
}


def read_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def write_json(path: Path, obj: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(obj, ensure_ascii=False, indent=2), encoding="utf-8")


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows)


def command_policy() -> dict[str, Any]:
    root_cmds = sorted(p.name for p in ROOT.glob("*.cmd"))
    restore_tools = ROOT / "_restore_tools"
    direct_cmds = sorted(p.name for p in restore_tools.glob("*.cmd")) if restore_tools.exists() else []
    return {
        "rootCmdCount": len(root_cmds),
        "rootCmdFiles": root_cmds,
        "restoreToolsDirectCmdCount": len(direct_cmds),
        "restoreToolsDirectCmdFiles": direct_cmds,
        "policyOk": len(root_cmds) == 1 and len(direct_cmds) == 0,
    }


def is_placeholder(value: Any) -> bool:
    if value is None:
        return False
    if isinstance(value, str):
        return value.strip().lower() in PLACEHOLDER_STRINGS
    return False


def approval_evidence_present(obj: Any) -> bool:
    if not isinstance(obj, dict):
        return False
    keys = {str(k).lower() for k in obj.keys()}
    approval_keys = {
        "approvalevidence",
        "userapproval",
        "approvedbyuser",
        "runtimecapturesource",
        "snapshotmetadata",
        "originalruntimesnapshotmetadata",
    }
    return bool(keys & approval_keys)


def iter_leaves(value: Any, path: str = ""):
    if isinstance(value, dict):
        for key, child in value.items():
            child_path = f"{path}.{key}" if path else str(key)
            yield from iter_leaves(child, child_path)
    elif isinstance(value, list):
        for index, child in enumerate(value):
            child_path = f"{path}[{index}]"
            yield from iter_leaves(child, child_path)
    else:
        yield path, value


def get_path(obj: Any, path: str) -> Any:
    current = obj
    token = ""
    index_mode = False
    index_token = ""
    parts: list[Any] = []
    for ch in path:
        if ch == "." and not index_mode:
            if token:
                parts.append(token)
                token = ""
            continue
        if ch == "[" and not index_mode:
            if token:
                parts.append(token)
                token = ""
            index_mode = True
            index_token = ""
            continue
        if ch == "]" and index_mode:
            parts.append(int(index_token))
            index_mode = False
            continue
        if index_mode:
            index_token += ch
        else:
            token += ch
    if token:
        parts.append(token)

    for part in parts:
        if isinstance(part, int):
            if not isinstance(current, list) or part >= len(current):
                return None
            current = current[part]
        else:
            if not isinstance(current, dict) or part not in current:
                return None
            current = current[part]
    return current


def validate_battle(template: dict[str, Any], result: dict[str, Any]) -> tuple[dict[str, Any], list[dict[str, Any]]]:
    fields = template.get("fieldChecklist", [])
    hook_candidates = template.get("hookCandidates", [])
    rows: list[dict[str, Any]] = []
    category_counter: Counter[str] = Counter()
    missing = 0
    filled = 0
    placeholders = 0
    missing_prop = 0
    duplicate_counter: Counter[tuple[str, str]] = Counter()

    for index, row in enumerate(fields):
        object_path = str(row.get("objectPath", ""))
        field_name = str(row.get("fieldName", ""))
        key = (object_path, field_name)
        duplicate_counter[key] += 1
        category = str(row.get("category", "uncategorized"))
        category_counter[category] += 1
        has_runtime_value = "runtimeValue" in row
        value = row.get("runtimeValue")
        value_state = "missing"
        if not has_runtime_value:
            missing_prop += 1
            value_state = "missing_runtimeValue_property"
        elif value is None:
            missing += 1
        elif is_placeholder(value):
            placeholders += 1
            filled += 1
            value_state = "placeholder_string"
        else:
            filled += 1
            value_state = "filled"
        if index < 500 or value_state != "missing":
            rows.append({
                "track": "battle",
                "index": index,
                "objectPath": object_path,
                "fieldName": field_name,
                "category": category,
                "requirementLevel": row.get("requirementLevel", ""),
                "valueState": value_state,
                "patchUnlockedBy": row.get("patchUnlockedBy", ""),
                "unblockCategory": row.get("unblockCategory", ""),
            })

    duplicate_keys = sum(1 for count in duplicate_counter.values() if count > 1)
    summary = {
        "expectedFields": len(fields),
        "expectedFieldsFromResult": result.get("deduplicatedRuntimeFieldsCount"),
        "requiredFieldCountFromResult": result.get("requiredFieldCount"),
        "hookCandidates": len(hook_candidates),
        "hookCandidatesFromResult": result.get("hookCandidatesCount"),
        "filledRuntimeValues": filled,
        "missingRuntimeValues": missing,
        "placeholderRuntimeValues": placeholders,
        "missingRuntimeValuePropertyRows": missing_prop,
        "duplicateObjectPathFieldNameKeys": duplicate_keys,
        "approvalEvidencePresent": approval_evidence_present(template),
        "templateMode": filled == 0 and missing > 0,
        "patchDecisionUnlocked": False,
        "categoryCounts": dict(sorted(category_counter.items())),
        "blockingReason": "battle runtime values are not filled" if filled == 0 else "battle snapshot needs source/approval review before patch",
    }
    return summary, rows


def null_paths(obj: Any) -> list[str]:
    return [path for path, value in iter_leaves(obj) if value is None]


def validate_ui(template: dict[str, Any], result: dict[str, Any], snapshot: dict[str, Any] | None = None) -> tuple[dict[str, Any], list[dict[str, Any]]]:
    source_template = template.get("templateWithNullPlaceholders", {})
    target = snapshot if snapshot is not None else source_template
    expected_null_paths = null_paths(source_template)
    rows: list[dict[str, Any]] = []
    filled = 0
    missing = 0
    placeholders = 0

    for index, path in enumerate(expected_null_paths):
        value = get_path(target, path)
        if value is None:
            missing += 1
            value_state = "missing"
        elif is_placeholder(value):
            placeholders += 1
            filled += 1
            value_state = "placeholder_string"
        else:
            filled += 1
            value_state = "filled"
        if index < 500 or value_state != "missing":
            rows.append({
                "track": "maininterface",
                "index": index,
                "objectPath": path.rsplit(".", 1)[0] if "." in path else "",
                "fieldName": path.rsplit(".", 1)[-1],
                "category": infer_ui_category(path),
                "requirementLevel": "runtime_snapshot_required",
                "valueState": value_state,
                "patchUnlockedBy": infer_ui_unblock(path),
                "unblockCategory": infer_ui_category(path),
            })

    group_field_sum = sum(int(group.get("fieldCount", 0)) for group in template.get("groups", []))
    summary = {
        "expectedNullRuntimePaths": len(expected_null_paths),
        "groupCount": len(template.get("groups", [])),
        "groupFieldSum": group_field_sum,
        "requiredRuntimeFieldsFromResult": result.get("requiredRuntimeFieldsCount"),
        "staticKnownFieldsFromResult": result.get("staticKnownFieldsCount"),
        "filledRuntimeValues": filled,
        "missingRuntimeValues": missing,
        "placeholderRuntimeValues": placeholders,
        "approvalEvidencePresent": approval_evidence_present(template) or approval_evidence_present(snapshot),
        "templateMode": filled == 0 and missing > 0,
        "patchDecisionUnlocked": False,
        "blockingReason": "maininterface runtime values are not filled" if filled == 0 else "maininterface snapshot needs source/approval review before patch",
    }
    return summary, rows


def infer_ui_category(path: str) -> str:
    lower = path.lower()
    if "canvashelper" in lower or "depth" in lower or "sorting" in lower:
        return "canvas_depth_stack"
    if "guardednodes" in lower or "active" in lower or "sibling" in lower:
        return "guarded_active_sibling"
    if "uibg" in lower or "raycast" in lower or "interactable" in lower:
        return "ui_bg_raycast"
    if "dynamicruntime" in lower or "activity" in lower or "currency" in lower or "chat" in lower or "account" in lower:
        return "dynamic_activity_account_chat_currency"
    if "mask" in lower or "stencil" in lower or "tmp" in lower or "material" in lower:
        return "tmp_mask_material"
    if "forms" in lower or "openstack" in lower:
        return "form_stack"
    return "runtime_state"


def infer_ui_unblock(path: str) -> str:
    category = infer_ui_category(path)
    if category == "canvas_depth_stack":
        return "decide UI_Dock/UI_MainPage canvas/depth patch review"
    if category == "guarded_active_sibling":
        return "decide guarded node active/sibling patch review"
    if category == "ui_bg_raycast":
        return "decide UI_bg input/raycast patch review"
    if category == "dynamic_activity_account_chat_currency":
        return "decide dynamic activity/account/chat/currency replay values"
    if category == "tmp_mask_material":
        return "decide TMP/mask/material component patch review"
    return "decide source-backed MainInterface patch review"


def make_md(summary: dict[str, Any], validation_csv: Path, sample_csv: Path) -> str:
    battle = summary["battle"]
    ui = summary["maininterface"]
    combined = summary["combined"]
    lines = [
        f"# {summary['packet']}",
        "",
        "## Scope",
        "",
        "- Offline validator only.",
        "- No runtime/APK/emulator execution.",
        "- No scene patch or package import.",
        "- No fake runtime values are generated by this validator.",
        "",
        "## Battle Packet",
        "",
        f"- Expected fields: `{battle['expectedFields']}`",
        f"- Filled runtime values: `{battle['filledRuntimeValues']}`",
        f"- Missing runtime values: `{battle['missingRuntimeValues']}`",
        f"- Placeholder strings: `{battle['placeholderRuntimeValues']}`",
        f"- Hook candidates: `{battle['hookCandidates']}`",
        f"- Patch decision unlocked: `{str(battle['patchDecisionUnlocked']).lower()}`",
        "",
        "## MainInterface Packet",
        "",
        f"- Expected null runtime paths: `{ui['expectedNullRuntimePaths']}`",
        f"- UI148 required runtime fields: `{ui['requiredRuntimeFieldsFromResult']}`",
        f"- Filled runtime values: `{ui['filledRuntimeValues']}`",
        f"- Missing runtime values: `{ui['missingRuntimeValues']}`",
        f"- Placeholder strings: `{ui['placeholderRuntimeValues']}`",
        f"- Patch decision unlocked: `{str(ui['patchDecisionUnlocked']).lower()}`",
        "",
        "## Combined Decision",
        "",
        f"- Ready for patch review: `{str(combined['readyForPatchReview']).lower()}`",
        f"- Approval still required: `{str(combined['approvalStillRequired']).lower()}`",
        f"- Runtime values missing total: `{combined['missingRuntimeValuesTotal']}`",
        f"- Placeholder strings total: `{combined['placeholderRuntimeValuesTotal']}`",
        f"- Next action: `{combined['recommendedNextAction']}`",
        "",
        "## Outputs",
        "",
        f"- Validation matrix: `{validation_csv}`",
        f"- Missing/filled field sample: `{sample_csv}`",
    ]
    return "\n".join(lines) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate UI148/B75 runtime snapshot packets without executing runtime instrumentation.")
    parser.add_argument("--battle-template", default=str(DEFAULT_BATTLE_TEMPLATE))
    parser.add_argument("--battle-result", default=str(DEFAULT_BATTLE_RESULT))
    parser.add_argument("--ui-template", default=str(DEFAULT_UI_TEMPLATE))
    parser.add_argument("--ui-result", default=str(DEFAULT_UI_RESULT))
    parser.add_argument("--ui-filled-snapshot", default="")
    parser.add_argument("--unified-packet", default=str(DEFAULT_UNIFIED_PACKET))
    args = parser.parse_args()

    battle_template_path = Path(args.battle_template)
    battle_result_path = Path(args.battle_result)
    ui_template_path = Path(args.ui_template)
    ui_result_path = Path(args.ui_result)
    ui_snapshot_path = Path(args.ui_filled_snapshot) if args.ui_filled_snapshot else None
    unified_packet_path = Path(args.unified_packet)

    battle_template = read_json(battle_template_path)
    battle_result = read_json(battle_result_path)
    ui_template = read_json(ui_template_path)
    ui_result = read_json(ui_result_path)
    ui_snapshot = read_json(ui_snapshot_path) if ui_snapshot_path and ui_snapshot_path.exists() else None
    unified_packet = read_json(unified_packet_path) if unified_packet_path.exists() else {}

    battle_summary, battle_rows = validate_battle(battle_template, battle_result)
    ui_summary, ui_rows = validate_ui(ui_template, ui_result, ui_snapshot)

    missing_total = battle_summary["missingRuntimeValues"] + ui_summary["missingRuntimeValues"]
    placeholder_total = battle_summary["placeholderRuntimeValues"] + ui_summary["placeholderRuntimeValues"]
    ready = (
        battle_summary["filledRuntimeValues"] > 0
        and ui_summary["filledRuntimeValues"] > 0
        and missing_total == 0
        and placeholder_total == 0
        and (battle_summary["approvalEvidencePresent"] or ui_summary["approvalEvidencePresent"])
    )

    combined = {
        "readyForPatchReview": ready,
        "approvalStillRequired": not ready,
        "missingRuntimeValuesTotal": missing_total,
        "placeholderRuntimeValuesTotal": placeholder_total,
        "recommendedNextAction": (
            "REVIEW_FILLED_RUNTIME_SNAPSHOT_FOR_SOURCE_BACKED_PATCH"
            if ready
            else "FILL_UI148_AND_B75_RUNTIME_SNAPSHOT_VALUES_WITH_EXPLICIT_APPROVAL_EVIDENCE"
        ),
    }

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    out_prefix = f"{PREFIX}_{timestamp}"
    result_json = REPORT_DIR / f"{out_prefix}_RESULT.json"
    result_md = REPORT_DIR / f"{out_prefix}_RESULT.md"
    validation_csv = REPORT_DIR / f"{out_prefix}_VALIDATION_MATRIX.csv"
    sample_csv = REPORT_DIR / f"{out_prefix}_FIELD_SAMPLE.csv"

    validation_rows = [
        {
            "track": "battle",
            "expectedFieldCount": battle_summary["expectedFields"],
            "filledRuntimeValues": battle_summary["filledRuntimeValues"],
            "missingRuntimeValues": battle_summary["missingRuntimeValues"],
            "placeholderRuntimeValues": battle_summary["placeholderRuntimeValues"],
            "approvalEvidencePresent": battle_summary["approvalEvidencePresent"],
            "patchDecisionUnlocked": battle_summary["patchDecisionUnlocked"],
            "blockingReason": battle_summary["blockingReason"],
        },
        {
            "track": "maininterface",
            "expectedFieldCount": ui_summary["expectedNullRuntimePaths"],
            "filledRuntimeValues": ui_summary["filledRuntimeValues"],
            "missingRuntimeValues": ui_summary["missingRuntimeValues"],
            "placeholderRuntimeValues": ui_summary["placeholderRuntimeValues"],
            "approvalEvidencePresent": ui_summary["approvalEvidencePresent"],
            "patchDecisionUnlocked": ui_summary["patchDecisionUnlocked"],
            "blockingReason": ui_summary["blockingReason"],
        },
    ]
    sample_rows = battle_rows + ui_rows

    result = {
        "packet": out_prefix,
        "validatorOnly": True,
        "restoredClaim": False,
        "playableClaim": False,
        "runtimeInstrumentationUsed": False,
        "apkOrEmulatorExecuted": False,
        "scenePatched": False,
        "packageImported": False,
        "externalXluaImported": False,
        "fakeValuesGenerated": False,
        "coordinateOnlyPatchAllowed": False,
        "battleTemplatePath": str(battle_template_path),
        "uiTemplatePath": str(ui_template_path),
        "uiFilledSnapshotPath": str(ui_snapshot_path) if ui_snapshot_path else "",
        "unifiedPacketPath": str(unified_packet_path),
        "unifiedPacketStatus": unified_packet.get("status", ""),
        "battle": battle_summary,
        "maininterface": ui_summary,
        "combined": combined,
        "outputs": {
            "resultJson": str(result_json),
            "resultMd": str(result_md),
            "validationCsv": str(validation_csv),
            "fieldSampleCsv": str(sample_csv),
        },
        "commandPolicy": command_policy(),
    }

    write_csv(
        validation_csv,
        validation_rows,
        [
            "track",
            "expectedFieldCount",
            "filledRuntimeValues",
            "missingRuntimeValues",
            "placeholderRuntimeValues",
            "approvalEvidencePresent",
            "patchDecisionUnlocked",
            "blockingReason",
        ],
    )
    write_csv(
        sample_csv,
        sample_rows,
        [
            "track",
            "index",
            "objectPath",
            "fieldName",
            "category",
            "requirementLevel",
            "valueState",
            "patchUnlockedBy",
            "unblockCategory",
        ],
    )
    write_json(result_json, result)
    result_md.write_text(make_md(result, validation_csv, sample_csv), encoding="utf-8")

    print(json.dumps(result["outputs"], ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
