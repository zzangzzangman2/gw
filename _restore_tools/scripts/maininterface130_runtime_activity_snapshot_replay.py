from __future__ import annotations

import argparse
import csv
import json
import re
from datetime import datetime
from pathlib import Path
from typing import Any

import UnityPy


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
REPORTS = BASE / "reports" / "maininterface"
RESTORE_REPORTS = BASE / "girlswar_maininterface_unity" / "Assets" / "RestoreData" / "reports"

DATAMGR_BUNDLE = (
    BASE
    / "girlswar_merged_extracted"
    / "extracted"
    / "unity"
    / "clean_unityfs_slices"
    / "download"
    / "xlualogic"
    / "datanode"
    / "datamanager"
    / "datamgr.assetbundle"
)
LANGCOMMON = (
    BASE
    / "girlswar_merged_extracted"
    / "extracted"
    / "unity"
    / "bundles"
    / "b_7e5552edea2c10f4"
    / "textassets"
    / "-2670652165716608051_DTLangCommon.txt"
)
TMP_SHARED_MATERIALS = RESTORE_REPORTS / "maininterface_tmp_shared_materials.csv"
UI129_SCHEMA = REPORTS / "MAININTERFACE_129_required_snapshot_schema.json"

OUT_PREFIX = "MAININTERFACE_130_RUNTIME_ACTIVITY_SNAPSHOT_IMPORT_REPLAY_PIPELINE_NO_FAKE_PATCH"
OUT_MD = REPORTS / f"{OUT_PREFIX}_RESULT.md"
OUT_JSON = REPORTS / f"{OUT_PREFIX}_RESULT.json"
OUT_TEMPLATE = REPORTS / "MAININTERFACE_130_runtime_activity_snapshot_template.json"
OUT_REPLAY_JSON = REPORTS / "MAININTERFACE_130_runtime_activity_snapshot_replay_result.json"
OUT_REPLAY_MD = REPORTS / "MAININTERFACE_130_runtime_activity_snapshot_replay_result.md"
OUT_FIELDS = REPORTS / "MAININTERFACE_130_replayable_fields.csv"

XOR_SCALE = bytes.fromhex("2D 42 26 37 17 FE 09 A5 5A 13 29 2D C9 3A 37 25 FE B9 A5 A9 13 AB")
SYSTEM_ORDER = [1004, 1005, 1006, 1007, 1008]
SYSTEM_NAMES = {
    1004: "charge",
    1005: "recruit",
    1006: "welfare",
    1007: "activity",
    1008: "rally",
}


def read_json(path: Path) -> Any:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def write_json(path: Path, value: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2), encoding="utf-8")


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str] | None = None) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if fieldnames is None:
        seen: list[str] = []
        for row in rows:
            for key in row:
                if key not in seen:
                    seen.append(key)
        fieldnames = seen or ["empty"]
    with path.open("w", encoding="utf-8-sig", newline="") as handle:
        writer = csv.DictWriter(handle, fieldnames=fieldnames, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows)


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as handle:
        return list(csv.DictReader(handle))


def decode_datamgr_textassets() -> dict[str, str]:
    decoded: dict[str, str] = {}
    env = UnityPy.load(DATAMGR_BUNDLE.read_bytes())
    for obj in env.objects:
        if obj.type.name != "TextAsset":
            continue
        data = obj.read()
        name = getattr(data, "m_Name", "")
        if name not in {"ActMgr", "ActCfgData"}:
            continue
        payload = getattr(data, "m_Script", b"")
        raw = payload.encode("utf-8", "surrogateescape") if isinstance(payload, str) else bytes(payload)
        out = bytes(byte ^ XOR_SCALE[i % len(XOR_SCALE)] for i, byte in enumerate(raw))
        decoded[name] = out.decode("utf-8", errors="replace")
    return decoded


def load_langcommon() -> dict[str, str]:
    if not LANGCOMMON.exists():
        return {}
    text = LANGCOMMON.read_text(encoding="utf-8-sig", errors="replace")
    return dict(re.findall(r"\['([^']+)'\]\s*=\s*'([^']*)'", text))


def one_line(text: str, max_len: int = 420) -> str:
    text = " ".join(str(text).split())
    if len(text) > max_len:
        return text[: max_len - 1] + "..."
    return text


def actcfg_override(act_cfg: str, act_id: int) -> dict[str, Any]:
    marker = f"[{act_id}]="
    idx = act_cfg.find(marker)
    if idx < 0:
        return {}
    window = act_cfg[idx : idx + 2200]
    name_match = re.search(r'mainPageName\s*=\s*"([^"]+)"', window)
    spine_match = re.search(r"mainPageSpineId\s*=\s*(\d+)", window)
    touch_match = re.search(r"mainPageTouchJumpId\s*=\s*function", window)
    red_match = re.search(r"mainPageRedPointFunc\s*=\s*function", window)
    return {
        "actId": act_id,
        "mainPageName": name_match.group(1) if name_match else None,
        "mainPageSpineId": int(spine_match.group(1)) if spine_match else None,
        "hasMainPageTouchJumpId": bool(touch_match),
        "hasMainPageRedPointFunc": bool(red_match),
        "sourceSnippet": one_line(window, 900),
    }


def make_template() -> dict[str, Any]:
    return {
        "schemaVersion": 1,
        "source": "Fill from real server/account/cache/packet/playerprefs/replay evidence only. Do not insert guessed activities.",
        "activitys": [],
        "faceActivitys": [],
        "playerInfo": {
            "level": None,
            "vip": None,
            "playerId": None,
            "name": None,
            "head": None,
            "headFrame": None,
        },
        "redPointState": {
            "serverRedPointIds": None,
            "actSpecificRedPoints": None,
        },
        "reviewState": {
            "GameTools_IsReview": None,
            "GameEntry_IsReview": None,
            "GameEntry_IsCommittee": None,
        },
        "guideState": {
            "ModulesInit_GuideMgr_isGuide": None,
            "CurrGuidEnterActId": None,
        },
        "timeState": {
            "serverTimeStep": None,
            "serverMillTimeStamp": None,
        },
        "clientCallbackOutputs": {
            "showInMainFunc": None,
            "clientCheckIsOpen": None,
            "getActNewName": None,
            "mainPageTouchJumpId": None,
        },
        "localization": {
            "language": "LangCommon Korean",
            "keys": None,
        },
        "resources": {
            "activitySpine": None,
            "tmpFontMaterial": None,
        },
    }


def is_missing(value: Any) -> bool:
    return value is None or value == ""


def nested_get(value: dict[str, Any], path: str) -> Any:
    current: Any = value
    for part in path.split("."):
        if isinstance(current, dict) and part in current:
            current = current[part]
        else:
            return None
    return current


def validate_snapshot(snapshot: dict[str, Any]) -> tuple[list[str], list[dict[str, Any]]]:
    required_paths = [
        "activitys",
        "faceActivitys",
        "playerInfo.level",
        "playerInfo.vip",
        "redPointState.serverRedPointIds",
        "reviewState.GameTools_IsReview",
        "reviewState.GameEntry_IsReview",
        "reviewState.GameEntry_IsCommittee",
        "guideState.ModulesInit_GuideMgr_isGuide",
        "timeState.serverTimeStep",
        "timeState.serverMillTimeStamp",
        "clientCallbackOutputs.showInMainFunc",
        "clientCallbackOutputs.clientCheckIsOpen",
        "clientCallbackOutputs.getActNewName",
        "clientCallbackOutputs.mainPageTouchJumpId",
    ]
    rows: list[dict[str, Any]] = []
    missing: list[str] = []
    for path in required_paths:
        value = nested_get(snapshot, path)
        ok = not is_missing(value)
        if path in {"activitys", "faceActivitys"}:
            ok = isinstance(value, list) and len(value) > 0
        if not ok:
            missing.append(path)
        rows.append(
            {
                "field": path,
                "status": "present" if ok else "missing",
                "sourceRule": source_rule_for_field(path),
                "requiredFor": required_for_field(path),
                "valueSummary": summarize_value(value),
            }
        )
    for list_name in ["activitys", "faceActivitys"]:
        activities = snapshot.get(list_name)
        if not isinstance(activities, list):
            continue
        for idx, activity in enumerate(activities):
            if not isinstance(activity, dict):
                missing.append(f"{list_name}[{idx}]")
                continue
            for key in ["activityId", "show", "systemId", "openSecond", "closeSecond"]:
                field = f"{list_name}[{idx}].{key}"
                ok = key in activity and not is_missing(activity.get(key))
                if not ok:
                    missing.append(field)
                rows.append(
                    {
                        "field": field,
                        "status": "present" if ok else "missing",
                        "sourceRule": source_rule_for_field(field),
                        "requiredFor": required_for_field(field),
                        "valueSummary": summarize_value(activity.get(key)),
                    }
                )
    return missing, rows


def summarize_value(value: Any) -> str:
    if value is None:
        return ""
    if isinstance(value, list):
        return f"list[{len(value)}]"
    if isinstance(value, dict):
        return f"dict[{len(value)}]"
    return one_line(value, 140)


def source_rule_for_field(path: str) -> str:
    if path.startswith("activitys"):
        return "ActMgr:GetAllActInfo(true) iterates ActMgr.activitys; IsActShowInMain checks each server activity."
    if path.startswith("playerInfo"):
        return "ActMgr:IsActShowInMain checks PlayerMgr.PlayerInfo.vip and PlayerMgr.PlayerInfo.level."
    if path.startswith("redPointState"):
        return "UI_MainPageActItem/FaceActItem and ActCfgData callbacks call RedPointMgr:checkServerRedPoint."
    if path.startswith("reviewState"):
        return "GameTools:IsReview/GameEntry review flags alter home buttons and activity visibility."
    if path.startswith("guideState"):
        return "UI_MainPage home logic and activity jumps can branch on guide/current-enter state."
    if path.startswith("timeState"):
        return "ActMgr:IsOpen and face activity timers require server time."
    if path.startswith("clientCallbackOutputs"):
        return "ActCfgData/client activity callbacks can override show/open/name/touch jump decisions."
    return "UI129 required snapshot schema."


def required_for_field(path: str) -> str:
    if "systemId" in path:
        return "grouping selected activity into charge/recruit/welfare/activity/rally columns"
    if "openSecond" in path or "closeSecond" in path or path.startswith("timeState"):
        return "source-backed open/closed filtering"
    if path.startswith("clientCallbackOutputs.getActNewName"):
        return "source-backed runtime label override"
    if path.startswith("clientCallbackOutputs"):
        return "source-backed callback filtering without guessing"
    return "blocking replay without fake defaults"


def should_show_activity(activity: dict[str, Any], snapshot: dict[str, Any]) -> tuple[bool, list[str]]:
    reasons: list[str] = []
    if activity.get("show") is not True:
        return False, ["server show flag is not true"]
    now = snapshot["timeState"]["serverTimeStep"]
    open_second = activity.get("openSecond")
    close_second = activity.get("closeSecond")
    if open_second is not None and now < open_second:
        return False, [f"not open: serverTimeStep {now} < openSecond {open_second}"]
    if close_second is not None and close_second > 0 and now > close_second:
        return False, [f"closed: serverTimeStep {now} > closeSecond {close_second}"]
    player = snapshot["playerInfo"]
    on_main_lv = activity.get("onMainLv")
    if player.get("vip", 0) <= 0 and on_main_lv is not None and player.get("level", 0) < on_main_lv:
        return False, [f"level gated: level {player.get('level')} < onMainLv {on_main_lv}"]
    callback_open = snapshot.get("clientCallbackOutputs", {}).get("clientCheckIsOpen", {}).get(str(activity.get("activityId")))
    if callback_open is False:
        return False, ["clientCheckIsOpen callback is false"]
    callback_show = snapshot.get("clientCallbackOutputs", {}).get("showInMainFunc", {}).get(str(activity.get("activityId")))
    if callback_show is False:
        return False, ["showInMainFunc callback is false"]
    reasons.append("show=true and required runtime filters passed")
    return True, reasons


def localized_label(activity: dict[str, Any], override: dict[str, Any], snapshot: dict[str, Any], lang: dict[str, str]) -> tuple[str | None, str]:
    act_id = str(activity.get("activityId"))
    callback_name = snapshot.get("clientCallbackOutputs", {}).get("getActNewName", {}).get(act_id)
    if callback_name:
        return str(callback_name), "clientCallbackOutputs.getActNewName"
    key = override.get("mainPageName") or activity.get("mainPageName") or activity.get("name")
    if key:
        snapshot_keys = snapshot.get("localization", {}).get("keys", {})
        return snapshot_keys.get(str(key)) or lang.get(str(key)) or str(key), f"localized key {key}"
    system_id = activity.get("systemId")
    if system_id:
        key = f"activityname_{system_id}"
        snapshot_keys = snapshot.get("localization", {}).get("keys", {})
        return snapshot_keys.get(key) or lang.get(key) or key, f"system fallback {key}"
    return None, "no label source"


def replay_snapshot(snapshot: dict[str, Any], decoded: dict[str, str], lang: dict[str, str]) -> dict[str, Any]:
    act_cfg = decoded.get("ActCfgData", "")
    visible: list[dict[str, Any]] = []
    for activity in snapshot.get("activitys", []):
        if not isinstance(activity, dict):
            continue
        show, reasons = should_show_activity(activity, snapshot)
        if not show:
            continue
        act_id = int(activity["activityId"])
        system_id = int(activity["systemId"])
        override = actcfg_override(act_cfg, act_id)
        label, label_source = localized_label(activity, override, snapshot, lang)
        spine = override.get("mainPageSpineId") or activity.get("mainPageSpineId") or activity.get("tbSpine")
        visible.append(
            {
                "activityId": act_id,
                "systemId": system_id,
                "systemName": SYSTEM_NAMES.get(system_id, "unknown"),
                "label": label,
                "labelSource": label_source,
                "spineId": spine,
                "spineSource": "ActCfgData.mainPageSpineId" if override.get("mainPageSpineId") else "snapshot.activitySpine/tbSpine",
                "redPoint": str(act_id) in {str(v) for v in snapshot.get("redPointState", {}).get("serverRedPointIds", [])},
                "sourceReasons": reasons,
                "actCfgOverride": override,
            }
        )
    slots = build_group_slots(visible, "btn_act", 8)
    face_visible: list[dict[str, Any]] = []
    for activity in snapshot.get("faceActivitys", []):
        if not isinstance(activity, dict):
            continue
        show, reasons = should_show_activity(activity, snapshot)
        if not show:
            continue
        act_id = int(activity["activityId"])
        override = actcfg_override(act_cfg, act_id)
        label, label_source = localized_label(activity, override, snapshot, lang)
        face_visible.append(
            {
                "activityId": act_id,
                "systemId": int(activity["systemId"]),
                "systemName": SYSTEM_NAMES.get(int(activity["systemId"]), "unknown"),
                "label": label,
                "labelSource": label_source,
                "spineId": override.get("mainPageSpineId") or activity.get("mainPageSpineId") or activity.get("tbSpine"),
                "spineSource": "ActCfgData.mainPageSpineId" if override.get("mainPageSpineId") else "snapshot.activitySpine/tbSpine",
                "redPoint": str(act_id) in {str(v) for v in snapshot.get("redPointState", {}).get("serverRedPointIds", [])},
                "sourceReasons": reasons,
                "actCfgOverride": override,
            }
        )
    face_slots = build_group_slots(face_visible, "btn_face_item", 7)
    return {
        "status": "replay_success_candidate_patch_plan_only",
        "mainSlots": slots,
        "faceSlots": face_slots,
        "candidatePatchAllowed": True,
        "candidatePatchPlan": "Use these slots to generate a candidate-only scene patch after separate visual/click validation; no patch is emitted by this replay script.",
    }


def build_group_slots(items: list[dict[str, Any]], prefix: str, max_slots: int) -> list[dict[str, Any]]:
    grouped: dict[int, list[dict[str, Any]]] = {system: [] for system in SYSTEM_ORDER}
    for item in items:
        if item["systemId"] in grouped:
            grouped[item["systemId"]].append(item)
    slots: list[dict[str, Any]] = []
    slot_index = 1
    for system_id in SYSTEM_ORDER:
        group = sorted(grouped[system_id], key=lambda item: (item.get("sort", 999999), item["activityId"]))
        if not group:
            continue
        item = group[0]
        item["slot"] = f"{prefix}_{slot_index}"
        slots.append(item)
        slot_index += 1
        if slot_index > max_slots:
            break
    return slots


def command_policy() -> dict[str, Any]:
    root_cmd = list(BASE.glob("*.cmd"))
    direct_tools_cmd = list((BASE / "_restore_tools").glob("*.cmd"))
    return {
        "rootCmdCount": len(root_cmd),
        "rootCmdFiles": [str(path) for path in root_cmd],
        "restoreToolsDirectCmdCount": len(direct_tools_cmd),
        "restoreToolsDirectCmdFiles": [str(path) for path in direct_tools_cmd],
    }


def build_result(snapshot_path: Path) -> dict[str, Any]:
    template = make_template()
    if not OUT_TEMPLATE.exists():
        write_json(OUT_TEMPLATE, template)
    snapshot = read_json(snapshot_path)
    decoded = decode_datamgr_textassets()
    lang = load_langcommon()
    missing, rows = validate_snapshot(snapshot)
    write_csv(OUT_FIELDS, rows)

    if missing:
        replay = {
            "status": "blocked_missing_runtime_snapshot_fields",
            "missingFields": missing,
            "candidatePatchAllowed": False,
            "mainSlots": [],
            "faceSlots": [],
            "reason": "Replayer refuses fake default activity state. Fill template fields from real runtime evidence first.",
        }
    else:
        replay = replay_snapshot(snapshot, decoded, lang)

    result = {
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "restoredClaim": False,
        "snapshotPath": str(snapshot_path),
        "templatePath": str(OUT_TEMPLATE),
        "ui129SchemaPath": str(UI129_SCHEMA),
        "replayableFieldsCsv": str(OUT_FIELDS),
        "replay": replay,
        "staticEvidence": {
            "actMgrSource": str(DATAMGR_BUNDLE),
            "actCfgDataSource": str(DATAMGR_BUNDLE),
            "localizationSource": str(LANGCOMMON),
            "tmpFontMaterialSource": str(TMP_SHARED_MATERIALS),
        },
        "guardrails": {
            "noScenePatchWithoutSnapshot": True,
            "noFakeDefaultActivities": True,
            "noActivitySlotArbitraryHide": True,
            "noBtnDiscordReviewHide": True,
            "noUiBgRaycastOff": True,
            "noFakeIconTextSpine": True,
        },
        "commandPolicy": command_policy(),
        "scriptPath": str(Path(__file__).resolve()),
    }
    return result


def write_reports(result: dict[str, Any]) -> None:
    write_json(OUT_JSON, result)
    write_json(OUT_REPLAY_JSON, result["replay"])
    missing = result["replay"].get("missingFields", [])
    missing_lines = "\n".join(f"- `{field}`" for field in missing[:80]) or "- none"
    command = result["commandPolicy"]
    replay_status = result["replay"]["status"]
    replay_md = f"""# MAININTERFACE_130 Runtime Activity Snapshot Replay Result

- status: `{replay_status}`
- restoredClaim: `false`
- candidatePatchAllowed: `{result['replay'].get('candidatePatchAllowed')}`
- snapshot: `{result['snapshotPath']}`

Missing fields:

{missing_lines}

No fake activity slots, labels, spines, redpoints, or scene patches were generated.
"""
    OUT_REPLAY_MD.write_text(replay_md, encoding="utf-8")

    md = f"""# {OUT_PREFIX}_RESULT

## Verdict

`restoredClaim=false`. UI130 added a runtime snapshot import/replay pipeline only. No scene visual patch was applied.

Default replay status is `{replay_status}` because the generated template intentionally contains no real runtime activity/account/server state.

## Pipeline

- script: `{Path(__file__).resolve()}`
- default snapshot template: `{OUT_TEMPLATE}`
- replay result JSON: `{OUT_REPLAY_JSON}`
- replay result MD: `{OUT_REPLAY_MD}`
- replayable fields CSV: `{OUT_FIELDS}`

The script accepts an optional snapshot path:

```powershell
python .\\_restore_tools\\scripts\\maininterface130_runtime_activity_snapshot_replay.py --snapshot .\\reports\\maininterface\\MAININTERFACE_130_runtime_activity_snapshot_template.json
```

## Missing Runtime Fields

{missing_lines}

## Source-Backed Replay Rules

- Uses decoded `ActMgr`/`ActCfgData` from `{DATAMGR_BUNDLE}`.
- Requires `activitys` instead of fabricating active activity ids.
- Requires `PlayerMgr.PlayerInfo` level/vip fields for `IsActShowInMain` filtering.
- Requires redpoint/review/guide/time/client callback fields before producing a candidate patch plan.
- Uses `DTLangCommon` from `{LANGCOMMON}` for labels only after an active activity id/key is source-backed.
- Uses TMP/font material evidence from `{TMP_SHARED_MATERIALS}` as binding evidence, not as a reason to invent visible labels.

## Guardrails

- Did not hide `node_act_btn/btn_act_*`.
- Did not hide `btn_discord` using review branch evidence.
- Did not set `UI_bg` raycast/interactable off.
- Did not fake icons/text/spines or paste screenshots/whole atlases.
- No candidate patch is allowed until a real snapshot passes validation.

## Command Policy

- root `.cmd` count: `{command['rootCmdCount']}`
- `_restore_tools` direct `.cmd` count: `{command['restoreToolsDirectCmdCount']}`

## Outputs

- result JSON: `{OUT_JSON}`
- template JSON: `{OUT_TEMPLATE}`
- replay result JSON: `{OUT_REPLAY_JSON}`
- replay result MD: `{OUT_REPLAY_MD}`
- replayable fields CSV: `{OUT_FIELDS}`
"""
    OUT_MD.write_text(md, encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description="Replay UI_MainInterface runtime activity snapshot without fake defaults.")
    parser.add_argument("--snapshot", type=Path, default=OUT_TEMPLATE, help="Runtime snapshot JSON path.")
    args = parser.parse_args()
    REPORTS.mkdir(parents=True, exist_ok=True)
    if args.snapshot.resolve() == OUT_TEMPLATE.resolve() or not OUT_TEMPLATE.exists():
        write_json(OUT_TEMPLATE, make_template())
    result = build_result(args.snapshot)
    write_reports(result)


if __name__ == "__main__":
    main()
