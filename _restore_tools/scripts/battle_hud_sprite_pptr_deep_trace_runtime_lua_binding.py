from __future__ import annotations

import csv
import json
import os
import subprocess
from collections import Counter
from pathlib import Path
from typing import Any

import UnityPy


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY_DIR = BASE / "girlswar_battle_unity"
UNITY_DATA = UNITY_DIR / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"
INDEX_DIR = BASE / "girlswar_merged_extracted" / "indexes"

B21_CSV = UNITY_DATA / "BATTLE_HUD_RUNTIME_BINDING_SPRITE_PPTR_TRACE_COMPONENTS.csv"
B21_JSON = UNITY_DATA / "BATTLE_HUD_RUNTIME_BINDING_SPRITE_PPTR_TRACE.json"
B21_REPORT_JSON = REPORT_DIR / "BATTLE_HUD_RUNTIME_BINDING_SPRITE_PPTR_TRACE_RESULT.json"
PREV_STAGE = "BATTLE_" + "21"
B21_CONTACT = REPORT_DIR / f"{PREV_STAGE}_HUD_RUNTIME_BINDING_SPRITE_PPTR_TRACE_CONTACT_SHEET.jpg"

OUT_JSON = UNITY_DATA / "BATTLE_HUD_SPRITE_PPTR_DEEP_TRACE_RUNTIME_LUA_BINDING.json"
OUT_CSV = UNITY_DATA / "BATTLE_HUD_SPRITE_PPTR_DEEP_TRACE_RUNTIME_LUA_BINDING_COMPONENTS.csv"
REPORT_JSON = REPORT_DIR / "BATTLE_HUD_SPRITE_PPTR_DEEP_TRACE_RUNTIME_LUA_BINDING_RESULT.json"
REPORT_MD = REPORT_DIR / "BATTLE_HUD_SPRITE_PPTR_DEEP_TRACE_RUNTIME_LUA_BINDING_RESULT.md"

CAB_MAP = INDEX_DIR / "unity_cab_to_bundle.csv"

VISIBLE_ROOTS = {
    "battle_root_hud",
    "battle_3d_overlay_hud",
    "actor_heroitem_template",
    "pause_panel_entry",
    "skip_panel_entry",
}


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig")) if path.exists() else {}


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, Any]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if not rows:
        path.write_text("", encoding="utf-8-sig")
        return
    fieldnames = list(rows[0].keys())
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        writer.writeheader()
        writer.writerows(rows)


def parse_pptr(value: str) -> tuple[int, int]:
    if not value or ":" not in value:
        return (0, 0)
    left, right = value.split(":", 1)
    try:
        return int(left), int(right)
    except ValueError:
        return (0, 0)


def load_cab_map() -> dict[str, dict[str, str]]:
    rows = read_csv(CAB_MAP)
    return {r.get("cab_name", "").lower(): r for r in rows}


class BundleResolver:
    def __init__(self) -> None:
        self.cab_map = load_cab_map()
        self.env_cache: dict[str, Any] = {}
        self.external_cache: dict[str, dict[int, dict[str, str]]] = {}
        self.object_cache: dict[tuple[str, int], dict[str, Any]] = {}

    def load_env(self, clean_path: str):
        if not clean_path or not Path(clean_path).exists():
            return None
        if clean_path not in self.env_cache:
            try:
                self.env_cache[clean_path] = UnityPy.load(clean_path)
            except Exception:
                self.env_cache[clean_path] = None
        return self.env_cache[clean_path]

    def source_path(self, bundle: str) -> str:
        if not bundle:
            return ""
        p = BASE / "girlswar_merged_extracted" / "extracted" / "unity" / "clean_unityfs_slices" / Path(bundle.replace("/", os.sep))
        return str(p)

    def external_map(self, clean_path: str) -> dict[int, dict[str, str]]:
        if clean_path in self.external_cache:
            return self.external_cache[clean_path]
        out: dict[int, dict[str, str]] = {}
        env = self.load_env(clean_path)
        if not env or not getattr(env, "assets", None):
            self.external_cache[clean_path] = out
            return out
        asset = env.assets[0]
        externals = getattr(asset, "externals", []) or []
        for idx, ext in enumerate(externals, start=1):
            cab = "CAB-" + str(ext).split("CAB-")[-1].split(")")[0]
            mapped = self.cab_map.get(cab.lower(), {})
            out[idx] = {
                "cabName": cab,
                "externalBundle": mapped.get("bundle", ""),
                "externalCleanPath": mapped.get("clean_path", ""),
                "externalExists": str(Path(mapped.get("clean_path", "")).exists()) if mapped.get("clean_path") else "False",
            }
        self.external_cache[clean_path] = out
        return out

    def resolve(self, source_bundle: str, pptr: str) -> dict[str, Any]:
        file_id, path_id = parse_pptr(pptr)
        result: dict[str, Any] = {
            "pptr": pptr,
            "fileID": file_id,
            "pathID": path_id,
            "sourceCleanPath": self.source_path(source_bundle),
            "externalCab": "",
            "externalBundle": "",
            "externalCleanPath": "",
            "externalExists": False,
            "assetFound": False,
            "assetType": "",
            "assetName": "",
            "textureName": "",
            "textureSize": "",
            "spriteRect": "",
            "alphaEvidence": "",
            "resolveStatus": "empty_pptr" if file_id == 0 and path_id == 0 else "unresolved",
        }
        if file_id == 0 and path_id == 0:
            return result
        source_path = result["sourceCleanPath"]
        target_path = source_path
        if file_id > 0:
            ext = self.external_map(source_path).get(file_id, {})
            result["externalCab"] = ext.get("cabName", "")
            result["externalBundle"] = ext.get("externalBundle", "")
            result["externalCleanPath"] = ext.get("externalCleanPath", "")
            result["externalExists"] = ext.get("externalExists") == "True"
            target_path = result["externalCleanPath"]
            if not target_path:
                result["resolveStatus"] = "external_cab_unmapped"
                return result
            if not Path(target_path).exists():
                result["resolveStatus"] = "external_bundle_not_extracted"
                return result
        env = self.load_env(target_path)
        if not env:
            result["resolveStatus"] = "bundle_load_failed"
            return result
        key = (target_path, path_id)
        if key in self.object_cache:
            return {**result, **self.object_cache[key]}
        found = None
        for obj in env.objects:
            if int(obj.path_id) == path_id:
                found = obj
                break
        if not found:
            info = {"assetFound": False, "resolveStatus": "pathid_missing_from_bundle"}
            self.object_cache[key] = info
            return {**result, **info}
        info = self.describe_object(found)
        self.object_cache[key] = info
        return {**result, **info}

    def describe_object(self, obj) -> dict[str, Any]:
        info: dict[str, Any] = {
            "assetFound": True,
            "assetType": obj.type.name,
            "assetName": "",
            "textureName": "",
            "textureSize": "",
            "spriteRect": "",
            "alphaEvidence": "",
            "resolveStatus": "resolved_object",
        }
        try:
            data = obj.read()
            info["assetName"] = getattr(data, "m_Name", "") or getattr(data, "name", "") or ""
            if obj.type.name == "Sprite":
                tree = obj.read_typetree()
                info["assetName"] = tree.get("m_Name", info["assetName"])
                rd = tree.get("m_RD", {})
                tex = rd.get("texture", {}) if isinstance(rd, dict) else {}
                rect = rd.get("textureRect", {}) if isinstance(rd, dict) else {}
                info["spriteRect"] = rect_string(rect)
                tex_id = int(tex.get("m_PathID") or 0) if isinstance(tex, dict) else 0
                if tex_id:
                    # Texture is usually local to the sprite bundle.
                    for tex_obj in obj.assets_file.objects.values():
                        if int(tex_obj.path_id) == tex_id:
                            tdata = tex_obj.read()
                            info["textureName"] = getattr(tdata, "m_Name", "") or getattr(tdata, "name", "") or ""
                            w = getattr(tdata, "m_Width", 0) or getattr(tdata, "width", 0)
                            h = getattr(tdata, "m_Height", 0) or getattr(tdata, "height", 0)
                            info["textureSize"] = f"{w}x{h}" if w and h else ""
                            break
            elif obj.type.name == "Texture2D":
                w = getattr(data, "m_Width", 0) or getattr(data, "width", 0)
                h = getattr(data, "m_Height", 0) or getattr(data, "height", 0)
                info["textureName"] = info["assetName"]
                info["textureSize"] = f"{w}x{h}" if w and h else ""
            elif obj.type.name == "Material":
                info["assetName"] = getattr(data, "m_Name", "") or info["assetName"]
            info["resolveStatus"] = "resolved_" + obj.type.name.lower()
        except Exception as exc:
            info["resolveStatus"] = "read_failed:" + str(exc)[:80]
        return info


def rect_string(rect: Any) -> str:
    if not isinstance(rect, dict):
        return ""
    return f"{rect.get('x', 0)},{rect.get('y', 0)},{rect.get('width', 0)},{rect.get('height', 0)}"


def priority(row: dict[str, str]) -> int:
    score = 0
    if row.get("visiblePlaceholderBlock") == "true":
        score += 1000
    if row.get("visibleOnCamera") == "true":
        score += 200
    if row.get("role") in {"Image", "RawImage"} and not row.get("spriteName") and not row.get("textureName"):
        score += 150
    if row.get("prefabRoot") in VISIBLE_ROOTS:
        score += 50
    if any(z in row.get("screenZone", "") for z in ["top", "bottom", "right"]):
        score += 25
    return score


def classify(row: dict[str, Any]) -> str:
    if row.get("role") == "TMP" and row.get("originalTmpFontAssetPPtr") != "0:0":
        status = row.get("fontResolveStatus", "")
        if "resolved" in status:
            return "tmp_material_only"
        return "font_bundle_missing"
    if row.get("role") in {"Text", "TMP"}:
        return "font_pptr_unresolved"
    if row.get("role") in {"Image", "RawImage"}:
        if row.get("componentType", "").endswith("YouYouImage") and row.get("originalSpritePPtr") == "0:0":
            return "custom_youyouimage_binding"
        if row.get("originalSpritePPtr") == "0:0" and row.get("originalTexturePPtr") == "0:0":
            if any(k in row.get("hierarchyPath", "").lower() for k in ["head", "icon", "skill", "buff", "hp"]):
                return "runtime_lua_set_image_sprite"
            return "sprite_pptr_unresolved"
        if row.get("spriteExternalBundle") and row.get("spriteExternalBundleLoadedInB21") == "False":
            return "external_bundle_not_loaded"
        if row.get("spriteResolveStatus") == "pathid_missing_from_bundle":
            return "sprite_pathid_missing_from_export"
        if row.get("spriteResolveStatus", "").startswith("resolved"):
            return "resolved_external_candidate_not_loaded_runtime"
        return "unknown"
    return "unknown"


def search_runtime_bindings() -> list[dict[str, str]]:
    keywords = (
        "UI_NormalBattle|UI_Battle3DUI|NormalBattle|ProcedureNormalBattle|OnBattleUILoadComplete|"
        "SetImageSprite|LoadSpriteWithFullPath|SetHeadBar|SetLeftInfo|SetRightInfo|heroitem|skill|auto|pause|speed|skip|"
        "Skill_BattleUI_Show|Skill_BattleUI_Hide"
    )
    roots = [
        BASE / "girlswar_merged_extracted" / "decoded" / "xlua_battle",
        BASE / "girlswar_merged_extracted" / "decoded" / "xlua",
        BASE / "il2cpp_native",
    ]
    out: list[dict[str, str]] = []
    for root in roots:
        if not root.exists():
            continue
        cmd = ["rg", "-n", "-i", keywords, str(root), "-g", "*.lua", "-g", "*.txt", "-g", "*.json", "-g", "*.asm"]
        try:
            proc = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=25)
        except Exception:
            continue
        for line in proc.stdout.splitlines():
            parts = line.rsplit(":", 2)
            if len(parts) == 3 and parts[1].isdigit():
                out.append({"path": parts[0], "line": parts[1], "text": parts[2][:260]})
            if len(out) >= 160:
                return out
    return out


def summarize_bindings(hints: list[dict[str, str]]) -> dict[str, list[dict[str, str]]]:
    groups = {
        "ui_open_load": ["OpenUIForm", "OnBattleUILoadComplete", "LoadBattleUI3D", "UI_NormalBattle"],
        "runtime_state_binding": ["SetLeftInfo", "SetRightInfo", "SetHeadBar", "ShowHeadBar"],
        "button_controls": ["auto", "pause", "speed", "skip", "GameSpeed", "GameFastSkill"],
        "hide_show_motion": ["Skill_BattleUI_Show", "Skill_BattleUI_Hide", "IsHideBattleUIInStart"],
        "sprite_setters": ["SetImageSprite", "LoadSpriteWithFullPath", "sprite", "icon"],
    }
    out: dict[str, list[dict[str, str]]] = {k: [] for k in groups}
    for hint in hints:
        text = hint["text"]
        for group, terms in groups.items():
            if any(term.lower() in text.lower() for term in terms):
                if len(out[group]) < 20:
                    out[group].append(hint)
    return out


def main() -> None:
    rows = read_csv(B21_CSV)
    b21 = read_json(B21_REPORT_JSON)
    resolver = BundleResolver()

    # The previous runtime trace loaded only the sprite bundles in its manifest. The deep trace should
    # mark other external bundles as not loaded in the previous runtime capture.
    b21_loaded_bundles = set()
    candidates = read_json(UNITY_DATA / "BATTLE_HUD_SPRITE_REGION_FONT_JOIN_CANDIDATES.json")
    for bundle in candidates.get("spriteBundles", []):
        if bundle.get("exists"):
            b21_loaded_bundles.add(bundle.get("bundle", ""))

    target_rows = [r for r in rows if priority(r) > 0 or r.get("traceUnresolvedReason")]
    target_rows.sort(key=priority, reverse=True)
    out_rows: list[dict[str, Any]] = []
    for row in target_rows:
        sprite = resolver.resolve(row.get("sourceBundle", ""), row.get("originalSpritePPtr", ""))
        material = resolver.resolve(row.get("sourceBundle", ""), row.get("originalMaterialPPtr", ""))
        font = resolver.resolve(row.get("sourceBundle", ""), row.get("originalFontPPtr", ""))
        tmp_font = resolver.resolve(row.get("sourceBundle", ""), row.get("originalTmpFontAssetPPtr", ""))
        shared_mat = resolver.resolve(row.get("sourceBundle", ""), row.get("originalSharedMaterialPPtr", ""))
        merged = {
            **row,
            "priority": priority(row),
            "spriteFileID": sprite["fileID"],
            "spritePathID": sprite["pathID"],
            "spriteExternalCab": sprite["externalCab"],
            "spriteExternalBundle": sprite["externalBundle"],
            "spriteExternalBundleExists": sprite["externalExists"],
            "spriteExternalBundleLoadedInB21": str(sprite["externalBundle"] in b21_loaded_bundles),
            "spriteResolveStatus": sprite["resolveStatus"],
            "spriteAssetFound": sprite["assetFound"],
            "spriteAssetType": sprite["assetType"],
            "spriteAssetName": sprite["assetName"],
            "spriteTextureName": sprite["textureName"],
            "spriteTextureSize": sprite["textureSize"],
            "spriteRect": sprite["spriteRect"],
            "materialResolveStatus": material["resolveStatus"],
            "materialAssetName": material["assetName"],
            "fontResolveStatus": font["resolveStatus"],
            "fontAssetName": font["assetName"],
            "tmpFontResolveStatus": tmp_font["resolveStatus"],
            "tmpFontAssetName": tmp_font["assetName"],
            "sharedMaterialResolveStatus": shared_mat["resolveStatus"],
            "sharedMaterialAssetName": shared_mat["assetName"],
        }
        merged["deepUnresolvedReason"] = classify(merged)
        out_rows.append(merged)

    reason_counts = Counter(r["deepUnresolvedReason"] for r in out_rows)
    placeholder_rows = [r for r in out_rows if r.get("visiblePlaceholderBlock") == "true"]
    evidence_candidates = [
        r for r in out_rows
        if r["deepUnresolvedReason"] in {"external_bundle_not_loaded", "resolved_external_candidate_not_loaded_runtime", "tmp_material_only"}
    ]
    runtime_hints = search_runtime_bindings()
    grouped_hints = summarize_bindings(runtime_hints)
    summary = {
        "userVisibleVerdict": "아직 원본 전투 HUD 아님",
        "reference_video_used": True,
        "videoReference": str(REPORT_DIR / "BATTLE_20_PLAY_VIDEO_NORMAL_BATTLE_REFERENCE_486S.jpg"),
        "contactSheet": str(B21_CONTACT),
        "visual_status": "failed_missing_runtime_binding",
        "matches_clip05_static_hud_layout": False,
        "camera_visible_hud": bool(b21.get("camera_visible_hud", True)),
        "camera_visible_original_hud": False,
        "placeholder_block_visible": bool(b21.get("placeholder_block_visible", True)),
        "visible_original_sprite_count": 0,
        "visible_placeholder_block_count": len(placeholder_rows),
        "prioritizedRowCount": len(out_rows),
        "deepReasonCounts": dict(reason_counts),
        "evidenceCandidateCount": len(evidence_candidates),
        "fixApplied": False,
        "runtimeBindingHintCount": len(runtime_hints),
        "runtimeBindingGroups": {k: len(v) for k, v in grouped_hints.items()},
        "nextBlocker": "BATTLE_23_LOAD_MISSING_HUD_EXTERNAL_DEPENDENCIES_AND_VALIDATE_CLIP05_VISUAL",
    }
    output = {
        "summary": summary,
        "components": out_rows,
        "runtimeBindingHints": runtime_hints[:160],
        "runtimeBindingGroups": grouped_hints,
        "sourceB21": str(B21_CSV),
        "sourceContactSheet": str(B21_CONTACT),
    }
    OUT_JSON.write_text(json.dumps(output, ensure_ascii=False, indent=2), encoding="utf-8")
    REPORT_JSON.write_text(json.dumps(summary, ensure_ascii=False, indent=2), encoding="utf-8")
    write_csv(OUT_CSV, out_rows)
    write_report(summary, out_rows, grouped_hints)
    print(json.dumps(summary, ensure_ascii=False, indent=2))


def write_report(summary: dict[str, Any], rows: list[dict[str, Any]], grouped_hints: dict[str, list[dict[str, str]]]) -> None:
    lines = [
        "# Battle HUD Sprite PPtr Deep Trace + Runtime Lua Binding Result",
        "",
        "## User-Visible Verdict",
        "- 아직 원본 전투 HUD 아님.",
        "- clip05의 HP/VS, 하단 actor/skill cards, 오른쪽 세로 control sprite 형태와 일치하지 않습니다.",
        "- 이번 단계는 fix가 아니라 PPtr/external bundle/runtime binding blocker 추적입니다.",
        "",
        "## Verdict First",
        f"- visual_status: `{summary['visual_status']}`",
        f"- matches_clip05_static_hud_layout: `{summary['matches_clip05_static_hud_layout']}`",
        f"- camera_visible_original_hud: `{summary['camera_visible_original_hud']}`",
        f"- placeholder_block_visible: `{summary['placeholder_block_visible']}`",
        f"- visible_original_sprite_count: `{summary['visible_original_sprite_count']}`",
        f"- visible_placeholder_block_count: `{summary['visible_placeholder_block_count']}`",
        f"- fixApplied: `{summary['fixApplied']}`",
        f"- nextBlocker: `{summary['nextBlocker']}`",
        "",
        "## Video Gate",
        f"- Reference/contact: `{summary['contactSheet']}`",
        "- Earlier top/bottom/right zone pass is treated as false positive unless sprite shapes match clip05.",
        "",
        "## Deep Reason Counts",
    ]
    for reason, count in sorted(summary["deepReasonCounts"].items(), key=lambda x: (-x[1], x[0])):
        lines.append(f"- `{reason}`: `{count}`")
    lines.extend([
        "",
        "## Highest Priority Placeholder Rows",
        "| priority | zone | path | sprite PPtr | external bundle | status | reason |",
        "| ---: | --- | --- | --- | --- | --- | --- |",
    ])
    for row in [r for r in rows if r.get("visiblePlaceholderBlock") == "true"][:20]:
        lines.append(
            f"| {row.get('priority')} | {row.get('screenZone','')} | `{row.get('hierarchyPath','')}` | `{row.get('originalSpritePPtr','')}` | `{row.get('spriteExternalBundle','')}` | `{row.get('spriteResolveStatus','')}` | `{row.get('deepUnresolvedReason','')}` |"
        )
    lines.extend([
        "",
        "## Runtime Lua / XLua / IL2CPP Binding Evidence",
    ])
    for group, hints in grouped_hints.items():
        lines.append(f"### {group}")
        if not hints:
            lines.append("- none")
            continue
        for hint in hints[:10]:
            lines.append(f"- `{hint['path']}:{hint['line']}` {hint['text']}")
    lines.extend([
        "",
        "## Outputs",
        f"- Unity data JSON: `{OUT_JSON}`",
        f"- Components CSV: `{OUT_CSV}`",
        f"- Report JSON: `{REPORT_JSON}`",
        "",
        "## BATTLE_23 Recommendation",
        f"- `{summary['nextBlocker']}`",
    ])
    REPORT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
