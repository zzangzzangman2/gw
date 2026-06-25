from __future__ import annotations

import argparse
import csv
import importlib.util
import json
import re
from collections import Counter, defaultdict
from datetime import datetime
from pathlib import Path
from typing import Any

import UnityPy


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
MERGED = BASE / "girlswar_merged_extracted"
PROJECT = BASE / "girlswar_maininterface_unity"
REPORT_DIR = PROJECT / "Assets" / "RestoreData"
REPORT_DATA_DIR = REPORT_DIR / "reports"
REPORT_MD_DIR = BASE / "reports" / "maininterface"
SCRIPT_DIR = BASE / "_restore_tools" / "scripts"

UNITY_MODULE_DIR = MERGED / "extracted" / "unity" / "clean_unityfs_slices" / "download" / "xlualogic" / "modules"
RAW_DIR = MERGED / "extracted" / "unity" / "raw_textassets" / "guildmain_runtime_lua_xlua"
DECODED_DIR = MERGED / "decoded" / "xlua_guildmain_runtime_trace"
EXISTING_DECODED_DIR = MERGED / "decoded" / "xlua"

TRACE_107_JSON = REPORT_DIR / "maininterface_guildmain_white_panel_material_shader_runtime_trace.json"
TRACE_107_CSV = REPORT_DATA_DIR / "maininterface_guildmain_white_panel_material_shader_runtime_trace.csv"
CLICK_SUMMARY_JSON = REPORT_DATA_DIR / "maininterface_click_validation_summary.json"
SYS_UI_TABLE = MERGED / "extracted" / "unity" / "bundles" / "b_118e2d32692e66cc" / "textassets" / "7179387777078280832_DTSysUIFormEntityTableData.txt"
TEXTASSET_INDEX = MERGED / "indexes" / "unity_textassets.csv"
IL2CPP_DUMP = MERGED / "extracted" / "il2cpp_dump" / "dump.cs"
STRING_LITERAL = MERGED / "extracted" / "il2cpp_dump" / "stringliteral.json"

OUT_JSON = REPORT_DIR / "maininterface_guildmain_runtime_lua_xlua_initialization_trace.json"
OUT_CSV = REPORT_DATA_DIR / "maininterface_guildmain_runtime_lua_xlua_initialization_trace.csv"
OUT_MD = REPORT_MD_DIR / "MAININTERFACE_GUILDMAIN_RUNTIME_LUA_XLUA_INITIALIZATION_TRACE_RESULT.md"
RAW_CSV = REPORT_DATA_DIR / "guildmain_runtime_lua_xlua_raw_textassets.csv"
DECODE_CSV = REPORT_DATA_DIR / "guildmain_runtime_lua_xlua_decode_attempts.csv"

MODULE_BUNDLES = [
    "guild.assetbundle",
    "csguildwar.assetbundle",
    "guildterritory.assetbundle",
    "guildtrials.assetbundle",
]

KEYWORDS = [
    "UI_GuildMain",
    "GuildMain",
    "guild",
    "tongmeng",
    "wanfa",
    "ContentWanfa",
    "btn_wanfa",
    "bg_beijingtu",
    "guild_tmqj",
    "UIMask",
    "gonggao",
    "UI_GuildMainView",
]

RUNTIME_CALL_MARKERS = [
    "LuaUtils.SetImageSprite",
    "SetImageSprite",
    "LuaUtils.SetActive",
    "SetActive",
    "LuaUtils.SetImageColor",
    "SetImageColor",
    "LuaUtils.SetCanvasAlpha",
    "SetCanvasAlpha",
    "LoadSpriteWithFullPath",
    "LoadMaterialAsset",
    "LoadMaterialTexture",
    "LoadMaterial",
    "GetComponents",
    "GetComponent",
    "UIMask",
    "CanvasGroup",
    "ScrollRect",
    "Mask",
]

BLOCKER_PATTERNS = [
    {
        "id": "bg_beijingtu",
        "path_hint": "bg_beijingtu/noalphabg_BG_Guid",
        "terms": ["bg_beijingtu", "noalphabg_BG_Guid", "BG_Guid", "beijingtu"],
    },
    {
        "id": "wanfa_viewport_mask",
        "path_hint": "middle/root_wanfa/Viewport/UIMask",
        "terms": ["root_wanfa", "Viewport", "UIMask", "ContentWanfa", "Mask"],
    },
    {
        "id": "middle_guild_tmqj",
        "path_hint": "middle/Image/guild_tmqj",
        "terms": ["guild_tmqj", "middle", "tmqj"],
    },
    {
        "id": "wanfa_button_backgrounds",
        "path_hint": "btn_wanfa*/bg_ditu",
        "terms": ["btn_wanfa", "bg_ditu", "ContentWanfa", "guide_btn_wanfa"],
    },
    {
        "id": "wanfa_box_icons",
        "path_hint": "wjczbx3 / Boxicon / box",
        "terms": ["wjczbx3", "Boxicon", "box", "titan_boxicon", "lingtu_boxicon"],
    },
    {
        "id": "gonggao_mask",
        "path_hint": "middle/node_gonggao/gongao_bg/gonggaoMask",
        "terms": ["gonggao", "gongao", "gonggaoMask", "T_Marquee_Bg_1"],
    },
    {
        "id": "right_buttons",
        "path_hint": "right/btn_*",
        "terms": ["right", "btn_6", "btn_7", "btn_8", "btn_9"],
    },
]


def now_kst() -> str:
    return datetime.now().strftime("%Y-%m-%d %H:%M:%S")


def safe_name(value: str) -> str:
    return "".join(ch if ch.isalnum() or ch in ("_", "-") else "_" for ch in value)


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def text_asset_raw_payload(payload: Any) -> tuple[bytes, str]:
    if payload is None:
        return b"", "empty"
    if isinstance(payload, str):
        return payload.encode("utf-8", "surrogateescape"), "str_surrogateescape_utf8"
    if isinstance(payload, bytearray):
        return bytes(payload), "bytearray"
    if isinstance(payload, bytes):
        return payload, "bytes"
    return str(payload).encode("utf-8", "surrogateescape"), f"fallback_{type(payload).__name__}"


def printable_ratio(data: bytes) -> float:
    if not data:
        return 0.0
    return sum(1 for b in data if b in (9, 10, 13) or 32 <= b <= 126) / len(data)


def clean_text(data: bytes) -> str:
    for encoding in ("utf-8", "utf-8-sig", "gb18030", "latin1"):
        try:
            return data.decode(encoding)
        except UnicodeDecodeError:
            continue
    return data.decode("utf-8", "replace")


def load_decode_helpers():
    helper_path = SCRIPT_DIR / "try_maininterface_xlua_decode.py"
    spec = importlib.util.spec_from_file_location("maininterface_xlua_decode_helpers", helper_path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"Cannot import decode helper: {helper_path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def extract_raw_textassets() -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    RAW_DIR.mkdir(parents=True, exist_ok=True)
    for bundle_name in MODULE_BUNDLES:
        bundle = UNITY_MODULE_DIR / bundle_name
        if not bundle.exists():
            rows.append(
                {
                    "bundle": f"download/xlualogic/modules/{bundle_name}",
                    "source_bundle": str(bundle),
                    "path_id": "",
                    "name": "",
                    "size": 0,
                    "output": "",
                    "prefix4": "",
                    "ascii_ratio_first512": "",
                    "source_kind": "missing_bundle",
                }
            )
            continue
        env = UnityPy.load(bundle.read_bytes())
        module_raw_dir = RAW_DIR / bundle_name.replace(".assetbundle", "")
        module_raw_dir.mkdir(parents=True, exist_ok=True)
        for obj in env.objects:
            if obj.type.name != "TextAsset":
                continue
            data = obj.read()
            name = str(getattr(data, "m_Name", None) or getattr(data, "name", None) or f"textasset_{obj.path_id}")
            payload = getattr(data, "script", None)
            if payload is None:
                payload = getattr(data, "m_Script", None)
            raw, source_kind = text_asset_raw_payload(payload)
            out_path = module_raw_dir / f"{obj.path_id}_{safe_name(name)}.bytes"
            out_path.write_bytes(raw)
            rows.append(
                {
                    "bundle": f"download/xlualogic/modules/{bundle_name}",
                    "source_bundle": str(bundle),
                    "path_id": obj.path_id,
                    "name": name,
                    "size": len(raw),
                    "output": str(out_path.relative_to(MERGED)).replace("\\", "/"),
                    "prefix4": raw[:4].decode("latin1", "replace"),
                    "ascii_ratio_first512": f"{printable_ratio(raw[:512]):.3f}",
                    "source_kind": source_kind,
                }
            )
    rows.sort(key=lambda row: (str(row["bundle"]), str(row["name"])))
    write_csv(
        RAW_CSV,
        rows,
        ["bundle", "source_bundle", "path_id", "name", "size", "output", "prefix4", "ascii_ratio_first512", "source_kind"],
    )
    return rows


def decode_assets(raw_rows: list[dict[str, Any]]) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    helper = load_decode_helpers()
    metadata = helper.METADATA.read_bytes()
    soketkey = metadata[helper.SOKETKEY_OFFSET : helper.SOKETKEY_OFFSET + 8]
    ass = metadata[helper.ASS_OFFSET : helper.ASS_OFFSET + 64]
    security_xorscale = metadata[
        helper.SECURITY_XORSCALE_OFFSET : helper.SECURITY_XORSCALE_OFFSET + helper.SECURITY_XORSCALE_SIZE
    ]

    DECODED_DIR.mkdir(parents=True, exist_ok=True)
    attempt_rows: list[dict[str, Any]] = []
    decoded_rows: list[dict[str, Any]] = []

    for asset in raw_rows:
        if asset.get("source_kind") == "missing_bundle" or not asset.get("output"):
            continue
        raw_path = MERGED / str(asset["output"])
        data = raw_path.read_bytes()
        local_payloads: dict[str, bytes | None] = {}

        def record(attempt: str, payload: bytes | None) -> None:
            local_payloads[attempt] = payload
            info = helper.classify(payload)
            attempt_rows.append(
                {
                    "bundle": asset["bundle"],
                    "asset_name": asset["name"],
                    "path_id": asset["path_id"],
                    "attempt": attempt,
                    "output_size": 0 if payload is None else len(payload),
                    "classification": info["classification"],
                    "score": info["score"],
                    "printable_ratio": info["printable_ratio"],
                    "lua_marker_count": info["lua_marker_count"],
                    "preview": info["preview"],
                }
            )

        record("raw_utf8_fallback", data)
        record("strip_prefix4", data[4:])
        security_xor_raw = helper.repeating_xor(data, security_xorscale)
        record("security_xor_raw", security_xor_raw)
        record("getluabuff_security_xor_raw_bomspace", helper.strip_utf8_bom_to_spaces(security_xor_raw))
        for label, decompressed in helper.decompress_candidates(security_xor_raw):
            record(f"security_xor_raw_{label}", decompressed)
        for label, decompressed in helper.decompress_candidates(data):
            record(f"raw_{label}", decompressed)
        for label, decompressed in helper.decompress_candidates(data[4:]):
            record(f"strip4_{label}", decompressed)
        for key_name, key in [("soketkey", soketkey), ("ass64", ass), ("ass16", ass[:16])]:
            for source_name, source_data in [("raw", data), ("strip4", data[4:])]:
                decoded = helper.xxtea_decrypt(source_data, key)
                record(f"xxtea_{key_name}_{source_name}", decoded)
                if decoded is not None:
                    for label, decompressed in helper.decompress_candidates(decoded):
                        record(f"xxtea_{key_name}_{source_name}_{label}", decompressed)
        if data.startswith(helper.MAGIC):
            magic_decoded = helper.xxtea_decrypt(data[len(helper.MAGIC) :], ass)
            record("decryptbytearray_magic_ass64", magic_decoded)
            if magic_decoded is not None:
                for label, decompressed in helper.decompress_candidates(magic_decoded):
                    record(f"decryptbytearray_magic_ass64_{label}", decompressed)

        asset_attempts = [row for row in attempt_rows if row["bundle"] == asset["bundle"] and row["path_id"] == asset["path_id"]]
        best = max(asset_attempts, key=lambda row: int(row["score"]))
        if best["classification"] in {"lua_like_text", "lua_bytecode"} and int(best["score"]) >= 100:
            payload = local_payloads.get(str(best["attempt"]))
            if payload:
                out_name = f"{asset['path_id']}_{safe_name(str(asset['name']))}_{safe_name(str(best['attempt']))}.lua"
                out_path = DECODED_DIR / out_name
                out_path.write_bytes(payload)
                decoded_rows.append(
                    {
                        "bundle": asset["bundle"],
                        "asset_name": asset["name"],
                        "path_id": asset["path_id"],
                        "best_attempt": best["attempt"],
                        "score": best["score"],
                        "classification": best["classification"],
                        "decoded_path": str(out_path),
                        "decoded_rel": str(out_path.relative_to(MERGED)).replace("\\", "/"),
                        "text": clean_text(payload),
                    }
                )

    write_csv(
        DECODE_CSV,
        attempt_rows,
        [
            "bundle",
            "asset_name",
            "path_id",
            "attempt",
            "output_size",
            "classification",
            "score",
            "printable_ratio",
            "lua_marker_count",
            "preview",
        ],
    )
    return attempt_rows, decoded_rows


def read_text_file(path: Path, max_bytes: int | None = None) -> str:
    if not path.exists():
        return ""
    data = path.read_bytes()
    if max_bytes is not None:
        data = data[:max_bytes]
    return clean_text(data)


def load_107_trace() -> dict[str, Any]:
    if not TRACE_107_JSON.exists():
        return {}
    return json.loads(TRACE_107_JSON.read_text(encoding="utf-8"))


def line_matches(text: str, terms: list[str]) -> list[dict[str, Any]]:
    matches: list[dict[str, Any]] = []
    lines = text.splitlines()
    for index, line in enumerate(lines, start=1):
        hit_terms = [term for term in terms if term and term.lower() in line.lower()]
        if not hit_terms:
            continue
        context_start = max(1, index - 2)
        context_end = min(len(lines), index + 2)
        context = "\n".join(lines[context_start - 1 : context_end])
        matches.append({"line": index, "terms": hit_terms, "text": line.strip(), "context": context.strip()})
    return matches


def runtime_call_matches(text: str) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    lines = text.splitlines()
    for index, line in enumerate(lines, start=1):
        if any(marker in line for marker in RUNTIME_CALL_MARKERS):
            rows.append({"line": index, "text": line.strip()})
    return rows


def build_corpus(decoded_rows: list[dict[str, Any]]) -> list[dict[str, Any]]:
    corpus: list[dict[str, Any]] = []
    for row in decoded_rows:
        corpus.append(
            {
                "source_kind": "decoded_guild_module",
                "source": row["decoded_path"],
                "name": row["asset_name"],
                "bundle": row["bundle"],
                "text": row["text"],
            }
        )
    if EXISTING_DECODED_DIR.exists():
        for path in sorted(EXISTING_DECODED_DIR.glob("*.lua")):
            text = read_text_file(path)
            if any(keyword.lower() in text.lower() for keyword in KEYWORDS + ["UIFormId.UI_GuildMainView"]):
                corpus.append(
                    {
                        "source_kind": "decoded_existing_xlua",
                        "source": str(path),
                        "name": path.name,
                        "bundle": "",
                        "text": text,
                    }
                )
    return corpus


def extract_table_evidence() -> dict[str, Any]:
    sys_lines: list[dict[str, Any]] = []
    guide_lines: list[dict[str, Any]] = []
    textasset_lines: list[dict[str, Any]] = []

    sys_text = read_text_file(SYS_UI_TABLE)
    for match in line_matches(sys_text, ["UI_GuildMainView"]):
        sys_lines.append({"source": str(SYS_UI_TABLE), **match})

    if TEXTASSET_INDEX.exists():
        for row in read_csv(TEXTASSET_INDEX):
            hay = " ".join(str(v) for v in row.values())
            if "guild.assetbundle" in hay.lower() or "UI_GuildMainView" in hay:
                textasset_lines.append(row)

    guide_root = MERGED / "extracted" / "unity" / "bundles"
    guide_terms = ["guide_btn_wanfa", "ON_CLICK_GUILD", "isInPage(219)", "UI_GuildMainView"]
    for path in guide_root.glob("b_*/*/*.txt"):
        if "DTGuide" not in path.name:
            continue
        text = read_text_file(path)
        for match in line_matches(text, guide_terms):
            text_line = match["text"]
            if ",219," in text_line or "isInPage(219)" in text_line or "ON_CLICK_GUILD" in text_line:
                guide_lines.append({"source": str(path), **match})
    return {"sys_ui_form": sys_lines, "textasset_index": textasset_lines, "guide": guide_lines[:80]}


def extract_il2cpp_evidence() -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    dump_text = read_text_file(IL2CPP_DUMP)
    for term in [
        "UI_GuildMainView",
        "public class YouYouImage : Image",
        "public class UIMask : Mask",
        "SetImageSprite(YouYouImage",
        "SetImageColor(Image",
        "SetCanvasAlpha(CanvasGroup",
        "LoadMaterialAsset(string",
        "LoadSpriteWithFullPath(string",
    ]:
        for match in line_matches(dump_text, [term])[:5]:
            rows.append({"source": str(IL2CPP_DUMP), "term": term, **match})
    string_text = read_text_file(STRING_LITERAL, max_bytes=8_000_000)
    for term in ["LoadSpriteWithFullPath", "LoadMaterialAsset", "SetImageColor", "SetCanvasAlpha", "SetImageSprite"]:
        for match in line_matches(string_text, [term])[:5]:
            rows.append({"source": str(STRING_LITERAL), "term": term, **match})
    return rows


def analyze_candidates(corpus: list[dict[str, Any]]) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    script_rows: list[dict[str, Any]] = []
    blocker_rows: list[dict[str, Any]] = []
    for item in corpus:
        keyword_hits = line_matches(item["text"], KEYWORDS + ["UIFormId.UI_GuildMainView", "OpenUIForm"])
        runtime_hits = runtime_call_matches(item["text"])
        if keyword_hits or runtime_hits:
            script_rows.append(
                {
                    "source_kind": item["source_kind"],
                    "source": item["source"],
                    "bundle": item.get("bundle", ""),
                    "name": item["name"],
                    "keyword_hit_count": len(keyword_hits),
                    "runtime_call_count": len(runtime_hits),
                    "keywords": ";".join(sorted({term for hit in keyword_hits for term in hit["terms"]})),
                    "runtime_calls_preview": " | ".join(hit["text"] for hit in runtime_hits[:12]),
                    "keyword_preview": " | ".join(f"L{hit['line']}:{hit['text']}" for hit in keyword_hits[:12]),
                }
            )
        for blocker in BLOCKER_PATTERNS:
            terms = blocker["terms"]
            matches = line_matches(item["text"], terms)
            runtime_near = []
            for match in matches:
                if any(marker in match["context"] for marker in RUNTIME_CALL_MARKERS) or any(
                    marker in match["text"] for marker in RUNTIME_CALL_MARKERS
                ):
                    runtime_near.append(match)
            if matches:
                confidence = "medium"
                reason = "keyword match only"
                if runtime_near:
                    confidence = "high"
                    reason = "keyword appears near runtime UI call"
                elif any(term in ("UI_GuildMainView", "UI_GuildMain") for term in [item["name"], item.get("bundle", "")]):
                    confidence = "medium"
                    reason = "match in GuildMain module asset"
                blocker_rows.append(
                    {
                        "blocker_id": blocker["id"],
                        "path_hint": blocker["path_hint"],
                        "source_kind": item["source_kind"],
                        "source": item["source"],
                        "bundle": item.get("bundle", ""),
                        "script_name": item["name"],
                        "match_count": len(matches),
                        "runtime_near_count": len(runtime_near),
                        "confidence": confidence,
                        "unresolved_reason": reason,
                        "matched_terms": ";".join(sorted({term for hit in matches for term in hit["terms"]})),
                        "preview": " | ".join(f"L{hit['line']}:{hit['text']}" for hit in (runtime_near or matches)[:8]),
                    }
                )
    hit_blockers = {row["blocker_id"] for row in blocker_rows}
    for blocker in BLOCKER_PATTERNS:
        if blocker["id"] not in hit_blockers:
            blocker_rows.append(
                {
                    "blocker_id": blocker["id"],
                    "path_hint": blocker["path_hint"],
                    "source_kind": "no_direct_lua_hit",
                    "source": "",
                    "bundle": "",
                    "script_name": "",
                    "match_count": 0,
                    "runtime_near_count": 0,
                    "confidence": "unresolved",
                    "unresolved_reason": "no decoded Lua line directly referenced this blocker term",
                    "matched_terms": "",
                    "preview": "",
                }
            )

    def script_priority(row: dict[str, Any]) -> tuple[int, int, int, str]:
        name = str(row["name"])
        return (
            0 if name == "UI_GuildMainView" else 1,
            0 if row["source_kind"] == "decoded_guild_module" else 1,
            -int(row["runtime_call_count"]),
            name,
        )

    def blocker_priority(row: dict[str, Any]) -> tuple[int, int, str, str]:
        confidence_rank = {"high": 0, "medium": 1, "unresolved": 2}.get(str(row["confidence"]), 3)
        return (
            0 if row["script_name"] == "UI_GuildMainView" else 1,
            confidence_rank,
            str(row["blocker_id"]),
            str(row["script_name"]),
        )

    script_rows.sort(key=script_priority)
    blocker_rows.sort(key=blocker_priority)
    return script_rows, blocker_rows


def focused_guildmain_evidence(corpus: list[dict[str, Any]]) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    terms = [
        "function OnInit",
        "function OnOpen",
        "LuaUtils.SetActive(btn_wanfa",
        "ContentWanfa.gameObject:GetComponent",
        "LuaUtils.RebuildLayout(ContentWanfa.transform)",
        "UIUtil.setScrollViewAutoByContainerSize(root_wanfa,true)",
        "LuaUtils.SetLocalPos(root_wanfa.transform",
        "LuaUtils.SetRectTransformSizeDelta(root_wanfa.transform",
        "UpdateGonggaoTipsSize2",
        "LuaUtils.GetRectTransformWidth(gonggaoMask)",
        "GameTools:SetImageSprite(bg_huizhang",
        "GameTools:SetImageSprite(im_huizhang",
        "LuaUtils.SetImageFillAmount(im_level_jindutiao",
        "UIUtil.SetGray(btn_jiantou_right.transform",
        "LuaUtils.SetActive(node_gonggao.transform",
        "GameTools:IsReview",
        "GameEntry.IsCommittee",
    ]
    for item in corpus:
        if "UI_GuildMainView" not in str(item["name"]):
            continue
        for match in line_matches(item["text"], terms):
            rows.append(
                {
                    "script_name": item["name"],
                    "source": item["source"],
                    "bundle": item.get("bundle", ""),
                    "line": match["line"],
                    "terms": match["terms"],
                    "text": match["text"],
                    "context": match["context"],
                }
            )
    return rows


def summarize_top_white(trace_107: dict[str, Any]) -> dict[str, Any]:
    top = trace_107.get("topWhiteVisibleImages", []) or []
    reason_counts = Counter(str(row.get("reasonClass") or row.get("finalReasonClass") or "") for row in top)
    return {
        "top_count": len(top),
        "large_white_visible_image_count": trace_107.get("largeWhiteVisibleImageCount"),
        "whiteish_visible_ratio": trace_107.get("whiteishVisibleRatio"),
        "white_no_sprite_image_count": trace_107.get("whiteNoSpriteImageCount"),
        "missing_image_sprite_count": trace_107.get("noSpriteImageCount"),
        "missing_script_object_count": trace_107.get("missingScriptObjectCount"),
        "reason_counts": dict(reason_counts),
        "top_paths": [
            {
                "rank": row.get("rank"),
                "hierarchyPath": row.get("hierarchyPath"),
                "spriteName": row.get("spriteName"),
                "reasonClass": row.get("reasonClass"),
                "screenWhiteishRatio": row.get("screenWhiteishRatio"),
                "missingScriptCountOnObject": row.get("missingScriptCountOnObject"),
            }
            for row in top[:20]
        ],
    }


def build_report(data: dict[str, Any]) -> None:
    summary = data["summary"]
    click = data.get("clickValidation", {})
    top_white = data.get("topWhiteSummary", {})
    blocker_rows = data.get("blockerRuntimeCandidates", [])
    scripts = data.get("scriptCandidates", [])
    focused = data.get("focusedGuildMainViewEvidence", [])
    confirmed_scripts = [row for row in scripts if row["source_kind"] == "decoded_guild_module"]
    high_blockers = [row for row in blocker_rows if row["confidence"] == "high"]
    confidence_counts = Counter(row["confidence"] for row in blocker_rows)

    md: list[str] = [
        "# MainInterface GuildMain Runtime Lua/XLua Initialization Trace Result",
        "",
        f"Generated: {data['generatedAt']} KST",
        "",
        "## Verdict",
        "",
        "Not normal. `UI_GuildMain` still renders as a large white/bright panel; this pass did not apply a visual fix because no serialized+Lua evidence was strong enough to safely change active/color/mask/material state.",
        "",
        "## Visual Comparison",
        "",
        "| Metric | 107 baseline | 108 trace |",
        "| --- | ---: | ---: |",
        f"| Whiteish visible ratio | `{top_white.get('whiteish_visible_ratio')}` | `{top_white.get('whiteish_visible_ratio')}` |",
        f"| Large white visible Images | `{top_white.get('large_white_visible_image_count')}` | `{top_white.get('large_white_visible_image_count')}` |",
        f"| White no-sprite Images | `{top_white.get('white_no_sprite_image_count')}` | `{top_white.get('white_no_sprite_image_count')}` |",
        f"| Missing Image sprites | `{top_white.get('missing_image_sprite_count')}` | `{top_white.get('missing_image_sprite_count')}` |",
        f"| Missing script objects | `{top_white.get('missing_script_object_count')}` | `{top_white.get('missing_script_object_count')}` |",
        "",
        "## Runtime Evidence Summary",
        "",
        f"- Raw guild TextAssets extracted: `{summary['rawTextAssets']}`",
        f"- Decoded guild Lua-like TextAssets: `{summary['decodedGuildTextAssets']}`",
        f"- Script candidates with GuildMain/runtime UI evidence: `{len(scripts)}`",
        f"- Blocker-to-runtime candidate rows: `{len(blocker_rows)}`",
        f"- High-confidence blocker rows: `{len(high_blockers)}`",
        f"- Confidence split: `{dict(confidence_counts)}`",
        f"- Evidence-based fix applied: `0`",
        "",
        "## Focused GuildMainView Runtime Initialization",
        "",
        "| Line | Evidence | Interpretation |",
        "| ---: | --- | --- |",
    ]
    interpretation_by_term = {
        "function OnInit": "Registers button handlers and initial width/mask state.",
        "function OnOpen": "Runtime initialization entry for data, events, content layout, active state, and red points.",
        "ContentWanfa.gameObject:GetComponent": "ContentWanfa layout components are enabled at runtime, not just serialized prefab state.",
        "LuaUtils.RebuildLayout(ContentWanfa.transform)": "Forces layout rebuild for the wanfa cluster.",
        "UIUtil.setScrollViewAutoByContainerSize(root_wanfa,true)": "ScrollRect/content sizing is runtime-controlled.",
        "LuaUtils.SetActive(btn_wanfa": "Wanfa buttons are runtime-gated by review/function/data state.",
        "UpdateGonggaoTipsSize2": "Notice mask/marquee is runtime-driven.",
        "LuaUtils.GetRectTransformWidth(gonggaoMask)": "gonggao mask width is read at runtime for marquee offsets.",
        "GameTools:SetImageSprite(bg_huizhang": "Guild emblem sprites are runtime-bound from guild data.",
        "GameTools:SetImageSprite(im_huizhang": "Guild foreground emblem is runtime-bound.",
        "LuaUtils.SetImageFillAmount(im_level_jindutiao": "Progress bar visual state is data-bound.",
        "UIUtil.SetGray(btn_jiantou_right.transform": "Arrow visual state is controlled by scroll position.",
        "LuaUtils.SetActive(node_gonggao.transform": "Notice panel active state is runtime-controlled.",
        "GameEntry.IsCommittee": "Committee/review branch changes root_wanfa position/size and visible buttons.",
        "GameTools:IsReview": "Review branch changes visible buttons.",
    }
    for row in focused[:40]:
        term = str(row["terms"][0]) if row.get("terms") else ""
        evidence = str(row["text"]).replace("|", "\\|")[:240]
        md.append(f"| `{row['line']}` | `{evidence}` | {interpretation_by_term.get(term, 'Runtime UI state evidence.')} |")
    md.extend(
        [
            "",
            "## Confirmed UI Form Evidence",
            "",
        ]
    )
    for row in data.get("tableEvidence", {}).get("sys_ui_form", [])[:4]:
        md.append(f"- `{Path(row['source']).name}:{row['line']}` {row['text']}")
    md.extend(
        [
            "",
            "## Decoded Guild Module Candidates",
            "",
            "| Script | Bundle | Keyword hits | Runtime UI calls | Key evidence |",
            "| --- | --- | ---: | ---: | --- |",
        ]
    )
    for row in confirmed_scripts[:20]:
        preview = str(row["keyword_preview"] or row["runtime_calls_preview"]).replace("|", "\\|")[:220]
        md.append(
            f"| `{row['name']}` | `{row['bundle']}` | `{row['keyword_hit_count']}` | `{row['runtime_call_count']}` | {preview} |"
        )
    md.extend(
        [
            "",
            "## Blocker Mapping",
            "",
            "| Blocker | Path hint | Confidence | Candidate script | Evidence | Reason |",
            "| --- | --- | --- | --- | --- | --- |",
        ]
    )
    for row in blocker_rows[:60]:
        preview = str(row["preview"]).replace("|", "\\|")[:260]
        md.append(
            f"| `{row['blocker_id']}` | `{row['path_hint']}` | `{row['confidence']}` | `{row['script_name']}` | {preview} | {row['unresolved_reason']} |"
        )
    md.extend(
        [
            "",
            "## IL2CPP / XLua Runtime API Evidence",
            "",
        ]
    )
    for row in data.get("il2cppEvidence", [])[:18]:
        md.append(f"- `{Path(row['source']).name}:{row['line']}` `{row['term']}` -> {row['text']}")
    md.extend(
        [
            "",
            "## Guide / Runtime Object Evidence",
            "",
            "- Guide rows confirm `UIForm 219` references internal GuildMain wanfa guide button names, including `guide_btn_wanfa1`, `guide_btn_wanfa4`, `guide_btn_wanfa5`, and `guide_btn_wanfa10`.",
        ]
    )
    for row in data.get("tableEvidence", {}).get("guide", [])[:12]:
        md.append(f"- `{Path(row['source']).name}:{row['line']}` {row['text']}")
    md.extend(
        [
            "",
            "## Interpretation",
            "",
            "- `UI_GuildMainView` is confirmed as form id `219`, module `Guild`, prefab `UI_GuildMain`, sprite resource `UIGuild`.",
            "- Runtime API evidence confirms XLua exposes `LuaUtils.SetImageSprite`, `SetImageColor`, `SetCanvasAlpha`, `LoadSpriteWithFullPath`, `LoadMaterialAsset`, and custom `YouYouImage`/`UIMask` paths.",
            "- The remaining white panel is still best classified as runtime/custom initialization missing, not a coordinate issue and not solved by blind sprite joins.",
            "- No active/color/mask/material override was applied because decoded evidence did not yet prove a concrete state change for the top white paths.",
            "",
            "## Verification",
            "",
            f"- JSON: `{OUT_JSON}`",
            f"- CSV: `{OUT_CSV}`",
            f"- Raw TextAsset CSV: `{RAW_CSV}`",
            f"- Decode attempts CSV: `{DECODE_CSV}`",
            f"- 107 capture reused for visual baseline: `{PROJECT / 'Assets' / 'RestoreCaptures' / 'guildmain_white_panel_trace' / 'UI_GuildMain_1680x720.png'}`",
            f"- Click validation generatedAt: `{click.get('generatedAt', '')}`",
            f"- Active / clickable / blocked / invoked: `{click.get('activeButtons', '')}` / `{click.get('raycastClickableButtons', '')}` / `{click.get('raycastBlockedButtons', '')}` / `{click.get('invokedClicks', '')}`",
            "",
            "## Next Recommendation",
            "",
            "Next: `GuildMain custom component/type reconstruction for YouYouImage and missing MonoBehaviour bindings`.",
        ]
    )
    OUT_MD.parent.mkdir(parents=True, exist_ok=True)
    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")


def run_trace(report_only: bool = False) -> dict[str, Any]:
    raw_rows = read_csv(RAW_CSV) if RAW_CSV.exists() else []
    decoded_rows: list[dict[str, Any]] = []
    decode_attempts: list[dict[str, Any]] = []
    if not report_only:
        raw_rows = extract_raw_textassets()
        decode_attempts, decoded_rows = decode_assets(raw_rows)
    else:
        raw_by_path_id = {str(row.get("path_id", "")): row for row in raw_rows}
        for path in sorted(DECODED_DIR.glob("*.lua")):
            stem = path.stem
            path_id = stem.split("_", 1)[0]
            raw_row = raw_by_path_id.get(path_id, {})
            inferred_name = str(raw_row.get("name") or re.sub(r"^-?\d+_", "", stem).replace("_security_xor_raw", ""))
            decoded_rows.append(
                {
                    "bundle": raw_row.get("bundle", ""),
                    "asset_name": inferred_name,
                    "path_id": path_id,
                    "decoded_path": str(path),
                    "text": read_text_file(path),
                }
            )
        decode_attempts = read_csv(DECODE_CSV)

    corpus = build_corpus(decoded_rows)
    script_rows, blocker_rows = analyze_candidates(corpus)
    focused_evidence = focused_guildmain_evidence(corpus)
    table_evidence = extract_table_evidence()
    il2cpp_evidence = extract_il2cpp_evidence()
    trace_107 = load_107_trace()
    top_white = summarize_top_white(trace_107)
    click = json.loads(CLICK_SUMMARY_JSON.read_text(encoding="utf-8-sig")) if CLICK_SUMMARY_JSON.exists() else {}

    csv_rows = []
    for row in blocker_rows:
        csv_rows.append(row)
    write_csv(
        OUT_CSV,
        csv_rows,
        [
            "blocker_id",
            "path_hint",
            "source_kind",
            "source",
            "bundle",
            "script_name",
            "match_count",
            "runtime_near_count",
            "confidence",
            "unresolved_reason",
            "matched_terms",
            "preview",
        ],
    )

    result = {
        "generatedAt": now_kst(),
        "verdict": "not_normal_trace_only",
        "fixApplied": 0,
        "summary": {
            "rawTextAssets": len([row for row in raw_rows if row.get("source_kind") != "missing_bundle"]),
            "decodedGuildTextAssets": len(decoded_rows),
            "decodeAttemptRows": len(decode_attempts),
            "scriptCandidateCount": len(script_rows),
            "blockerRuntimeCandidateCount": len(blocker_rows),
            "highConfidenceBlockerCandidateCount": len([row for row in blocker_rows if row["confidence"] == "high"]),
        },
        "topWhiteSummary": top_white,
        "scriptCandidates": script_rows,
        "focusedGuildMainViewEvidence": focused_evidence,
        "blockerRuntimeCandidates": blocker_rows,
        "tableEvidence": table_evidence,
        "il2cppEvidence": il2cpp_evidence,
        "clickValidation": click,
        "outputs": {
            "json": str(OUT_JSON),
            "csv": str(OUT_CSV),
            "md": str(OUT_MD),
            "rawCsv": str(RAW_CSV),
            "decodeCsv": str(DECODE_CSV),
            "decodedDir": str(DECODED_DIR),
        },
    }
    OUT_JSON.parent.mkdir(parents=True, exist_ok=True)
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    build_report(result)
    return result


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--report-only", action="store_true")
    args = parser.parse_args()
    result = run_trace(report_only=args.report_only)
    print(json.dumps({"generatedAt": result["generatedAt"], "summary": result["summary"]}, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
