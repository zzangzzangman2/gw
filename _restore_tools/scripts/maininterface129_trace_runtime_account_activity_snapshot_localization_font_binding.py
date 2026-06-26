from __future__ import annotations

import csv
import json
import os
import re
from collections import Counter
from datetime import datetime
from pathlib import Path
from typing import Any

import UnityPy


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_maininterface_unity"
REPORTS = BASE / "reports" / "maininterface"
RESTORE_REPORTS = PROJECT / "Assets" / "RestoreData" / "reports"

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
XLUA_DIR = BASE / "girlswar_merged_extracted" / "decoded" / "xlua"
MAINPAGE = XLUA_DIR / "-6351603197391775840_UI_MainPage_security_xor_raw.lua"
ACTITEM = XLUA_DIR / "-8694572285188909557_UI_MainPageActItem_security_xor_raw.lua"
FACEACTITEM = XLUA_DIR / "-7919191389644174794_UI_MainPageFaceActItem_security_xor_raw.lua"
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

OUT_MD = REPORTS / "MAININTERFACE_129_TRACE_RUNTIME_ACCOUNT_ACTIVITY_SNAPSHOT_LOCALIZATION_FONT_BINDING_RESULT.md"
OUT_JSON = RESTORE_REPORTS / "maininterface_129_trace_runtime_account_activity_snapshot_localization_font_binding.json"
OUT_SEARCH = REPORTS / "MAININTERFACE_129_runtime_snapshot_search_candidates.csv"
OUT_EVIDENCE = REPORTS / "MAININTERFACE_129_runtime_snapshot_evidence.csv"
OUT_SCHEMA_JSON = REPORTS / "MAININTERFACE_129_required_snapshot_schema.json"
OUT_SCHEMA_MD = REPORTS / "MAININTERFACE_129_required_snapshot_schema.md"

XOR_SCALE = bytes.fromhex("2D 42 26 37 17 FE 09 A5 5A 13 29 2D C9 3A 37 25 FE B9 A5 A9 13 AB")

SEARCH_ROOTS = [
    BASE / "girlswar_merged_extracted",
    BASE / "download" / "xlualogic",
    REPORTS,
    PROJECT / "Assets" / "RestoreData",
]

TEXT_EXTS = {
    ".txt",
    ".lua",
    ".json",
    ".csv",
    ".md",
    ".log",
    ".xml",
    ".asset",
    ".prefab",
    ".bytes",
    ".bigd",
    ".bin",
    ".dat",
    ".save",
}
SKIP_EXTS = {
    ".png",
    ".jpg",
    ".jpeg",
    ".webp",
    ".psd",
    ".mp4",
    ".mov",
    ".wav",
    ".ogg",
    ".mp3",
    ".ttf",
    ".otf",
    ".dll",
    ".exe",
    ".pdb",
}
NAME_MARKERS = [
    "actmgr",
    "activity",
    "act_",
    "prt_",
    "resp",
    "handler",
    "playerinfo",
    "playermgr",
    "redpoint",
    "red_point",
    "langcommon",
    "localize",
    "font",
    "tmp",
    "material",
    "cache",
    "save",
    "playerprefs",
    "packet",
    "snapshot",
    "account",
]
CONTENT_PATTERNS = [
    "ActMgr.activitys",
    "GetAllActInfo",
    "GetActInMain",
    "GetActInMainFace",
    "activityId",
    "activityTimes",
    "PlayerMgr.PlayerInfo",
    "PlayerInfo",
    "RedPointMgr",
    "checkServerRedPoint",
    "GameTools.GetLocalize",
    "LanguageCategory.LangCommon",
    "DTLangCommon",
    "TextMeshPro",
    "m_fontAsset",
    "m_sharedMaterial",
    "font_material",
]


def read_text(path: Path, limit: int | None = None) -> str:
    data = path.read_bytes()
    if limit is not None:
        data = data[:limit]
    return data.decode("utf-8-sig", errors="replace")


def one_line(text: str, max_len: int = 420) -> str:
    text = " ".join(text.split())
    if len(text) > max_len:
        return text[: max_len - 1] + "..."
    return text


def snippet(text: str, marker: str, before: int = 220, after: int = 700) -> str:
    idx = text.find(marker)
    if idx < 0:
        return ""
    return one_line(text[max(0, idx - before) : idx + after], 900)


def function_snippet(text: str, marker: str, max_chars: int = 1300) -> str:
    idx = text.find(marker)
    if idx < 0:
        return ""
    return one_line(text[idx : idx + max_chars], 1200)


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


def read_csv_rows(path: Path) -> list[dict[str, str]]:
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


def classify_path(path: Path, text: str, is_json_data: bool) -> str:
    lower = str(path).lower()
    name = path.name.lower()
    if "reports" in lower or "restoredata" in lower:
        if any(token in name for token in ["tmp", "font", "material"]):
            return "font_tmp_binding"
        return "report_or_restore_artifact"
    if "dtlangcommon" in name:
        return "static_localization"
    if any(token in name for token in ["dtactivity", "dtmaininlet", "dtmaininterface"]):
        return "static_datatable"
    if "prt_" in name and "handler" in name:
        return "handler_or_code"
    if path.suffix.lower() in {".lua", ".txt"} and any(token in text for token in ["function ", "require(", "GameTools.GetLocalize"]):
        return "handler_or_code"
    if any(token in name for token in ["playerprefs", "cache", "save", "snapshot", "packet", "account"]):
        return "runtime_snapshot_candidate"
    if is_json_data and any(token in text for token in ['"activitys"', '"PlayerInfo"', '"redPoint"', '"vip"', '"level"']):
        return "runtime_snapshot_candidate"
    if any(token in name for token in ["font", "tmp", "material"]) or "font_material" in text:
        return "font_tmp_binding"
    return "unknown"


def flatten_keys(value: Any, prefix: str = "", limit: int = 300) -> list[str]:
    keys: list[str] = []
    if len(keys) >= limit:
        return keys
    if isinstance(value, dict):
        for key, child in value.items():
            full = f"{prefix}.{key}" if prefix else str(key)
            keys.append(full)
            if len(keys) >= limit:
                return keys
            keys.extend(flatten_keys(child, full, limit - len(keys)))
            if len(keys) >= limit:
                return keys
    elif isinstance(value, list):
        for idx, child in enumerate(value[:12]):
            full = f"{prefix}[{idx}]"
            keys.extend(flatten_keys(child, full, limit - len(keys)))
            if len(keys) >= limit:
                return keys
    return keys[:limit]


def find_key_value(value: Any, names: set[str]) -> dict[str, Any]:
    found: dict[str, Any] = {}
    if isinstance(value, dict):
        for key, child in value.items():
            if str(key) in names and str(key) not in found:
                found[str(key)] = child if isinstance(child, (str, int, float, bool, type(None))) else type(child).__name__
            found.update(find_key_value(child, names))
    elif isinstance(value, list):
        for child in value[:50]:
            found.update(find_key_value(child, names))
    return found


def looks_like_runtime_activity_json(value: Any) -> tuple[bool, str]:
    keys = set(flatten_keys(value, limit=1000))
    joined = " ".join(keys).lower()
    has_activity = "activityid" in joined or "activitys" in joined or "activitytimes" in joined
    has_player = "playerinfo" in joined or ".vip" in joined or ".level" in joined
    has_redpoint = "redpoint" in joined or "serverredpoint" in joined
    if has_activity and has_player:
        return True, "json_has_activity_and_player_fields"
    parts = []
    if has_activity:
        parts.append("activity_fields")
    if has_player:
        parts.append("player_fields")
    if has_redpoint:
        parts.append("redpoint_fields")
    return False, ",".join(parts)


def parse_candidate(path: Path) -> dict[str, Any] | None:
    try:
        stat = path.stat()
    except OSError:
        return None
    suffix = path.suffix.lower()
    lower_name = path.name.lower()
    name_hit = any(marker in lower_name for marker in NAME_MARKERS)
    if suffix in SKIP_EXTS and not name_hit:
        return None
    text = ""
    matched: list[str] = []
    parse_status = "metadata_only"
    is_json_data = False
    can_drive = False
    fields_found = ""
    sample = ""
    if suffix in TEXT_EXTS or name_hit:
        try:
            text = read_text(path, limit=1_500_000)
            matched = [pattern for pattern in CONTENT_PATTERNS if pattern.lower() in text.lower()]
            if not name_hit and not matched:
                return None
            parse_status = "text_scanned"
            sample_marker = matched[0] if matched else ""
            sample = snippet(text, sample_marker, 120, 420) if sample_marker else one_line(text, 260)
        except Exception as exc:  # noqa: BLE001
            parse_status = f"read_failed:{type(exc).__name__}"
    elif not name_hit:
        return None

    json_reason = ""
    if suffix == ".json":
        try:
            data = json.loads(read_text(path))
            is_json_data = True
            can_drive, json_reason = looks_like_runtime_activity_json(data)
            kv = find_key_value(data, {"activitys", "activityId", "show", "PlayerInfo", "vip", "level", "redPoint"})
            fields_found = ";".join(f"{key}={value}" for key, value in list(kv.items())[:16])
            parse_status = "json_parsed"
        except Exception as exc:  # noqa: BLE001
            parse_status = f"json_failed:{type(exc).__name__}"

    category = classify_path(path, text, is_json_data)
    if category in {"handler_or_code", "static_datatable", "static_localization", "font_tmp_binding", "report_or_restore_artifact"}:
        can_drive = False
    if "ActMgr.activitys" in text and re.search(r"ActMgr\.activitys\s*=", text):
        fields_found = (fields_found + "; " if fields_found else "") + "ActMgr.activitys_assignment_text"
    elif "ActMgr.activitys" in text:
        fields_found = (fields_found + "; " if fields_found else "") + "ActMgr.activitys_reference"
    if json_reason and not fields_found:
        fields_found = json_reason
    return {
        "path": str(path),
        "type": category,
        "sizeBytes": stat.st_size,
        "parseStatus": parse_status,
        "matchedMarkers": ";".join(matched[:16]),
        "fieldsFound": fields_found,
        "canDriveGetActInMain": str(bool(can_drive)),
        "driveReason": "has_runtime_activity_and_player_json" if can_drive else "not_a_complete_runtime_activity_player_snapshot",
        "sample": sample,
    }


def scan_candidates() -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    seen: set[Path] = set()
    for root in SEARCH_ROOTS:
        if not root.exists():
            continue
        for dirpath, dirnames, filenames in os.walk(root):
            dirnames[:] = [
                dirname
                for dirname in dirnames
                if dirname not in {".git", "Library", "Temp", "Obj", "Build", "Logs"}
                and "girlswar_battle_unity" not in str(Path(dirpath) / dirname).lower()
            ]
            for filename in filenames:
                path = Path(dirpath) / filename
                if path in seen:
                    continue
                seen.add(path)
                row = parse_candidate(path)
                if row is not None:
                    rows.append(row)
    rows.sort(key=lambda row: (row["type"], row["path"]))
    return rows


def localization_rows() -> list[dict[str, Any]]:
    keys = [
        "activityname_1004",
        "activityname_1005",
        "activityname_1006",
        "activityname_1007",
        "activityname_1008",
        "activityname_4100",
        "Funtionname_10025",
        "Funtionname_10056",
    ]
    text = read_text(LANGCOMMON) if LANGCOMMON.exists() else ""
    rows: list[dict[str, Any]] = []
    for key in keys:
        pattern = re.compile(r"\['" + re.escape(key) + r"'\]\s*=\s*'([^']*)'")
        match = pattern.search(text)
        rows.append(
            {
                "topic": "localization_static_mapping",
                "source": str(LANGCOMMON),
                "key": key,
                "value": match.group(1) if match else "",
                "runtimeDecision": "available_for_selected_key_only",
                "blocker": "Active activity id/key still requires ActMgr runtime result.",
                "snippet": snippet(text, key, 40, 100) if match else "",
            }
        )
    return rows


def tmp_rows() -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    shared = read_csv_rows(TMP_SHARED_MATERIALS)
    for row in shared[:12]:
        rows.append(
            {
                "topic": "tmp_font_material_binding",
                "source": str(TMP_SHARED_MATERIALS),
                "key": row.get("font_key", ""),
                "value": row.get("material_name", ""),
                "runtimeDecision": "static_prefab_material_available",
                "blocker": "Does not decide runtime activity visibility or label text without active act id.",
                "snippet": one_line(
                    f"usage={row.get('usage_count','')} objects={row.get('game_object_names','')} samples={row.get('text_samples','')} bundle={row.get('bundle','')}",
                    900,
                ),
            }
        )
    return rows


def evidence_rows(decoded: dict[str, str]) -> list[dict[str, Any]]:
    act_mgr = decoded.get("ActMgr", "")
    act_cfg = decoded.get("ActCfgData", "")
    mainpage = read_text(MAINPAGE) if MAINPAGE.exists() else ""
    actitem = read_text(ACTITEM) if ACTITEM.exists() else ""
    faceitem = read_text(FACEACTITEM) if FACEACTITEM.exists() else ""
    rows: list[dict[str, Any]] = [
        {
            "topic": "GetActInMain_source",
            "source": str(DATAMGR_BUNDLE),
            "key": "ActMgr:GetActInMain",
            "value": "charge/recruit/welfare/activity/rally dynamic groups",
            "runtimeDecision": "requires_runtime_snapshot",
            "blocker": "Starts from ActMgr:GetAllActInfo(true), which iterates ActMgr.activitys server data.",
            "snippet": function_snippet(act_mgr, "function ActMgr:GetActInMain()", 1300),
        },
        {
            "topic": "GetAllActInfo_source",
            "source": str(DATAMGR_BUNDLE),
            "key": "ActMgr:GetAllActInfo",
            "value": "iterates ActMgr.activitys",
            "runtimeDecision": "requires_server_activitys",
            "blocker": "Static code identifies the list source but does not contain server list contents.",
            "snippet": function_snippet(act_mgr, "function ActMgr:GetAllActInfo", 1100),
        },
        {
            "topic": "IsActShowInMain_source",
            "source": str(DATAMGR_BUNDLE),
            "key": "ActMgr:IsActShowInMain",
            "value": "show/IsOpen/vip/level/client callbacks/review",
            "runtimeDecision": "requires_runtime_activity_account_redpoint",
            "blocker": "Needs server show/open state plus PlayerMgr.PlayerInfo and callback/redpoint state.",
            "snippet": function_snippet(act_mgr, "function ActMgr:IsActShowInMain", 1100),
        },
        {
            "topic": "main_slot_wrappers",
            "source": str(MAINPAGE),
            "key": "btn_act_1..8",
            "value": "main activity wrapper slots",
            "runtimeDecision": "slots_known_visibility_unknown",
            "blocker": "refreshMainAct disables all wrappers then enables only ActMgr:GetActInMain results.",
            "snippet": snippet(mainpage, "local le={", 0, 520),
        },
        {
            "topic": "face_slot_wrappers",
            "source": str(MAINPAGE),
            "key": "btn_face_item_1..7",
            "value": "face activity wrapper slots",
            "runtimeDecision": "slots_known_visibility_unknown",
            "blocker": "refreshFaceAct active rows require ActMgr:GetActInMainFace runtime result.",
            "snippet": snippet(mainpage, "local ue={", 0, 520),
        },
        {
            "topic": "main_activity_refresh_binding",
            "source": str(ACTITEM),
            "key": "UI_MainPageActItem:Refresh",
            "value": "GameTools.GetLocalize + ActCfgData mainPageName/mainPageSpineId",
            "runtimeDecision": "placeholder_not_authoritative",
            "blocker": "The visible text/spine depends on selected runtime actInfo.",
            "snippet": function_snippet(actitem, "function e:Refresh", 1400),
        },
        {
            "topic": "face_activity_refresh_binding",
            "source": str(FACEACTITEM),
            "key": "UI_MainPageFaceActItem:Refresh",
            "value": "runtime label/timer/spine refresh",
            "runtimeDecision": "placeholder_not_authoritative",
            "blocker": "The visible text/spine/timer depends on selected runtime actInfo.",
            "snippet": function_snippet(faceitem, "function e:Refresh", 1400),
        },
        {
            "topic": "actcfg_override_static",
            "source": str(DATAMGR_BUNDLE),
            "key": "ActCfgData mainPageName/mainPageSpineId",
            "value": "static override table exists",
            "runtimeDecision": "available_for_selected_act_only",
            "blocker": "The selected activity id still comes from server/runtime ActMgr.activitys.",
            "snippet": snippet(act_cfg, "mainPageSpineId", 850, 900),
        },
    ]
    rows.extend(localization_rows())
    rows.extend(tmp_rows())
    return rows


def required_snapshot_schema() -> dict[str, Any]:
    return {
        "purpose": "Minimum runtime snapshot needed to source-back UI_MainInterface_old normal-home activity/text reconstruction.",
        "activitys": [
            {
                "activityId": "number; server activity id used by ActMgr:GetAllActInfo",
                "show": "boolean; server show flag checked by IsActShowInMain",
                "openSecond": "number/string; open timestamp if present",
                "closeSecond": "number/string; close timestamp if present",
                "stageId": "number/string; stage/state if present",
                "activityTimes": "object/list; runtime counters used by act managers",
                "extraServerFields": "object; raw packet fields retained for client callbacks",
            }
        ],
        "playerInfo": {
            "level": "number; checked against activity onMainLv",
            "vip": "number; vip>0 bypasses onMainLv filter",
            "playerId": "number/string",
            "name": "string",
            "head": "number/string",
            "headFrame": "number/string",
        },
        "redPointState": {
            "serverRedPointIds": ["number/string; RedPointMgr:checkServerRedPoint ids"],
            "actSpecificRedPoints": "object keyed by act id for ActCfgData mainPageRedPointFunc/haveRedFunc callbacks",
        },
        "reviewState": {
            "GameTools_IsReview": "boolean",
            "GameEntry_IsReview": "boolean",
            "GameEntry_IsCommittee": "boolean",
        },
        "guideState": {
            "ModulesInit_GuideMgr_isGuide": "boolean",
            "CurrGuidEnterActId": "number/null",
        },
        "timeState": {
            "serverTimeStep": "number",
            "serverMillTimeStamp": "number",
        },
        "clientCallbackOutputs": {
            "showInMainFunc": "map activityId -> boolean",
            "clientCheckIsOpen": "map activityId -> boolean",
            "getActNewName": "map activityId -> localized/string override",
            "mainPageTouchJumpId": "map activityId -> target act id",
        },
        "localization": {
            "language": "LangCommon Korean",
            "keys": "map of activityname_*, activitysamllname_*, Funtionname_* keys to resolved text",
        },
        "resources": {
            "activitySpine": "map tbSpine/mainPageSpineId -> bundle/prefab/skeleton resource",
            "tmpFontMaterial": "map UI text path -> TMP font asset/shared material",
        },
    }


def command_policy() -> dict[str, Any]:
    root_cmd = list(BASE.glob("*.cmd"))
    direct_tools_cmd = list((BASE / "_restore_tools").glob("*.cmd"))
    return {
        "rootCmdCount": len(root_cmd),
        "rootCmdFiles": [str(path) for path in root_cmd],
        "restoreToolsDirectCmdCount": len(direct_tools_cmd),
        "restoreToolsDirectCmdFiles": [str(path) for path in direct_tools_cmd],
    }


def main() -> None:
    REPORTS.mkdir(parents=True, exist_ok=True)
    RESTORE_REPORTS.mkdir(parents=True, exist_ok=True)

    decoded = decode_datamgr_textassets()
    candidates = scan_candidates()
    evidence = evidence_rows(decoded)
    schema = required_snapshot_schema()
    command = command_policy()

    can_drive_rows = [row for row in candidates if row.get("canDriveGetActInMain") == "True"]
    category_counts = Counter(row["type"] for row in candidates)

    write_csv(OUT_SEARCH, candidates)
    write_csv(OUT_EVIDENCE, evidence)
    OUT_SCHEMA_JSON.write_text(json.dumps(schema, ensure_ascii=False, indent=2), encoding="utf-8")

    schema_md = """# MAININTERFACE_129 Required Runtime Snapshot Schema

This schema lists the minimum data needed before activity slots, labels, redpoints, and activity spines can be restored without guessing.

```json
""" + json.dumps(schema, ensure_ascii=False, indent=2) + """
```
"""
    OUT_SCHEMA_MD.write_text(schema_md, encoding="utf-8")

    active_reconstruction_possible = bool(can_drive_rows)
    summary = {
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "restoredClaim": False,
        "candidatePatchApplied": False,
        "searchRoots": [str(path) for path in SEARCH_ROOTS if path.exists()],
        "candidateCount": len(candidates),
        "candidateTypeCounts": dict(category_counts),
        "canDriveGetActInMainCount": len(can_drive_rows),
        "canDriveGetActInMainCandidates": can_drive_rows,
        "activeActivityReconstructionPossible": active_reconstruction_possible,
        "activeActivityReconstructionVerdict": (
            "possible_from_found_snapshot" if active_reconstruction_possible else "impossible_from_local_evidence"
        ),
        "localizationEvidence": str(LANGCOMMON),
        "tmpFontMaterialEvidence": str(TMP_SHARED_MATERIALS),
        "requiredSnapshotSchemaJson": str(OUT_SCHEMA_JSON),
        "requiredSnapshotSchemaMd": str(OUT_SCHEMA_MD),
        "searchCsv": str(OUT_SEARCH),
        "evidenceCsv": str(OUT_EVIDENCE),
        "commandPolicy": command,
        "guardrails": {
            "noActivitySlotArbitraryHide": True,
            "noBtnDiscordReviewHide": True,
            "noUiBgRaycastOff": True,
            "noFakeIconTextSpine": True,
            "preserveHero1005SkeletonGraphic": True,
        },
    }
    OUT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")

    counts_lines = "\n".join(f"- `{key}`: `{value}`" for key, value in sorted(category_counts.items()))
    loc_values = [row for row in evidence if row["topic"] == "localization_static_mapping" and row["value"]]
    loc_lines = "\n".join(f"- `{row['key']}` -> `{row['value']}`" for row in loc_values)
    tmp_values = [row for row in evidence if row["topic"] == "tmp_font_material_binding"][:5]
    tmp_lines = "\n".join(f"- `{row['key']}` / `{row['value']}`: {row['snippet']}" for row in tmp_values)
    runtime_like = [row for row in candidates if row["type"] == "runtime_snapshot_candidate"]
    runtime_like_lines = "\n".join(
        "- `{path}` | parse=`{parse}` | fields=`{fields}` | canDrive=`{drive}`".format(
            path=row["path"],
            parse=row["parseStatus"],
            fields=row["fieldsFound"] or row["matchedMarkers"] or "none",
            drive=row["canDriveGetActInMain"],
        )
        for row in runtime_like
    ) or "- none"
    can_drive_lines = (
        "\n".join(f"- `{row['path']}` ({row['fieldsFound']})" for row in can_drive_rows)
        if can_drive_rows
        else "- none"
    )

    md = f"""# MAININTERFACE_129_TRACE_RUNTIME_ACCOUNT_ACTIVITY_SNAPSHOT_LOCALIZATION_FONT_BINDING_RESULT

## Verdict

`restoredClaim=false`. No candidate patch was applied.

UI129 found static code/data evidence for activity selection, localization, and TMP/font material binding, but did not find a complete local runtime/account/server snapshot that can drive `ActMgr:GetActInMain()` or `ActMgr:GetActInMainFace()`.

## Runtime Snapshot Search

- searched roots:
  - `{BASE / 'girlswar_merged_extracted'}`
  - `{BASE / 'download' / 'xlualogic'}`
  - `{REPORTS}`
  - `{PROJECT / 'Assets' / 'RestoreData'}`
- candidate rows: `{len(candidates)}`
- candidates that can drive `GetActInMain`: `{len(can_drive_rows)}`

Candidate type counts:

{counts_lines}

Drive-capable candidates:

{can_drive_lines}

Runtime-looking candidates checked:

{runtime_like_lines}

## Reconstruction Judgment

Active activity reconstruction is `{summary['activeActivityReconstructionVerdict']}` from local evidence.

Reason: decoded `ActMgr:GetActInMain()` starts from `ActMgr:GetAllActInfo(true)`, and that function iterates runtime `ActMgr.activitys`. `IsActShowInMain()` then needs server `show`, open state, `PlayerMgr.PlayerInfo.vip/level`, redpoint state, and client callback results. The local evidence contains the code and static config, not the actual runtime list/account/redpoint snapshot.

## Static Evidence Found

- `UI_MainPage` main activity wrapper slots: `btn_act_1..btn_act_8`.
- `UI_MainPage` face activity wrapper slots: `btn_face_item_1..btn_face_item_7`.
- `UI_MainPageActItem:Refresh()` and `UI_MainPageFaceActItem:Refresh()` replace placeholders via `GameTools.GetLocalize`, `ActCfgData`, `tbSpine`, and `mainPageSpineId`.
- `ActCfgData` contains static `mainPageName/mainPageSpineId` overrides for selected act ids.

Localization evidence in `DTLangCommon`:

{loc_lines}

TMP/font material evidence:

{tmp_lines}

## Required Snapshot

Wrote the minimum source-backed runtime schema:

- `{OUT_SCHEMA_JSON}`
- `{OUT_SCHEMA_MD}`

Until those fields are supplied by a packet/cache/log/playerprefs/replay snapshot, visible activity slots/text/icons/spines cannot be changed without guessing.

## Guardrails

- Did not hide `node_act_btn/btn_act_*`.
- Did not hide `btn_discord` using review-state evidence.
- Did not set `UI_bg` raycast/interactable off.
- Did not fake icons/text/spines or paste screenshots/whole atlases.
- Preserved the UI124 Hero1005 real `SkeletonGraphic` path by applying no scene patch.

## Command Policy

- root `.cmd` count: `{command['rootCmdCount']}`
- `_restore_tools` direct `.cmd` count: `{command['restoreToolsDirectCmdCount']}`

## Outputs

- JSON: `{OUT_JSON}`
- search candidates CSV: `{OUT_SEARCH}`
- evidence CSV: `{OUT_EVIDENCE}`
- required schema JSON: `{OUT_SCHEMA_JSON}`
- required schema MD: `{OUT_SCHEMA_MD}`
"""
    OUT_MD.write_text(md, encoding="utf-8")


if __name__ == "__main__":
    main()
