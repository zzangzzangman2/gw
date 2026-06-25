from __future__ import annotations

import csv
import json
import subprocess
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any

import UnityPy


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
UNITY_DIR = BASE / "girlswar_battle_unity"
UNITY_DATA = UNITY_DIR / "Assets" / "RestoreData" / "battle"
REPORT_DIR = BASE / "reports" / "battle"

ATTACH_MANIFEST = UNITY_DATA / "BATTLE_FLOW_WITH_HUD_ATTACH_MANIFEST.json"
ATTACH_RESULT = UNITY_DATA / "BATTLE_FLOW_WITH_HUD_ATTACH_RESULT.json"
TYPE_EVIDENCE_JSON = UNITY_DATA / "BATTLE_UI_COMPONENT_TYPE_EVIDENCE.json"
TYPE_EVIDENCE_CSV = UNITY_DATA / "BATTLE_UI_COMPONENT_TYPE_EVIDENCE.csv"
STUB_MANIFEST = UNITY_DATA / "BATTLE_UI_COMPONENT_STUB_MANIFEST.json"

IL2CPP_DUMP = BASE / "girlswar_merged_extracted" / "extracted" / "il2cpp_dump" / "dump.cs"
DECODED = BASE / "girlswar_merged_extracted" / "decoded"


def read_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8-sig")) if path.exists() else {}


def rg_first(pattern: str, root: Path, glob: str | None = None) -> list[dict[str, str]]:
    if not root.exists():
        return []
    cmd = ["rg", "-n", "--fixed-strings", pattern, str(root)]
    if glob:
        cmd.extend(["-g", glob])
    try:
        cp = subprocess.run(cmd, capture_output=True, text=True, encoding="utf-8", errors="replace", timeout=8)
    except Exception:
        return []
    out = []
    for line in cp.stdout.splitlines()[:3]:
        parts = line.split(":", 2)
        if len(parts) == 3:
            out.append({"path": parts[0], "line": parts[1], "snippet": parts[2].strip()[:240]})
    return out


def classify(name: str, namespace: str, assembly: str) -> str:
    full = f"{namespace}.{name}".strip(".")
    lower = full.lower()
    if name in {"Image", "RawImage", "YouYouImage", "Empty4Raycast"}:
        return "visual image/raycast"
    if name in {"Text", "TextMeshProUGUI"}:
        return "text/font"
    if name == "Button" or "click" in lower or "eventlistener" in lower:
        return "button/click"
    if name in {"ScrollRect", "GridLayoutGroup", "HorizontalLayoutGroup", "VerticalLayoutGroup", "ContentSizeFitter", "RectMask2D", "Mask"}:
        return "layout/mask"
    if name in {"CanvasScaler", "GraphicRaycaster"}:
        return "canvas/raycast"
    if "spine" in lower or "particle" in lower or "tween" in lower:
        return "effect/animation"
    if "lua" in lower or "binder" in lower or "form" in lower or "unit" in lower:
        return "lua binder/controller"
    return "unknown/controller"


def load_scripts(bundle_path: str) -> tuple[list[dict[str, Any]], Counter[int]]:
    env = UnityPy.load(bundle_path)
    scripts: dict[int, dict[str, Any]] = {}
    refs: Counter[int] = Counter()
    for obj in env.objects:
        if obj.type.name == "MonoScript":
            data = obj.read()
            scripts[int(obj.path_id)] = {
                "scriptPathId": int(obj.path_id),
                "className": getattr(data, "m_ClassName", "") or "",
                "namespace": getattr(data, "m_Namespace", "") or "",
                "assemblyName": getattr(data, "m_AssemblyName", "") or "",
                "name": getattr(data, "m_Name", "") or "",
            }
        elif obj.type.name == "MonoBehaviour":
            try:
                tree = obj.read_typetree()
                path_id = int(tree.get("m_Script", {}).get("m_PathID", 0))
                refs[path_id] += 1
            except Exception:
                pass
    out = []
    for path_id, item in scripts.items():
        item["monoBehaviourRefCount"] = refs[path_id]
        item["likelyRole"] = classify(item["className"], item["namespace"], item["assemblyName"])
        full_name = f"{item['namespace']}.{item['className']}".strip(".")
        item["fullName"] = full_name
        item["il2cppEvidence"] = rg_first(item["className"], IL2CPP_DUMP)[:2]
        item["luaEvidence"] = rg_first(item["className"], DECODED, "*.lua")[:2]
        out.append(item)
    return sorted(out, key=lambda x: (-int(x["monoBehaviourRefCount"]), x["assemblyName"], x["fullName"])), refs


def main() -> None:
    UNITY_DATA.mkdir(parents=True, exist_ok=True)
    manifest = read_json(ATTACH_MANIFEST)
    before = read_json(ATTACH_RESULT).get("summary", {})
    bundles: dict[str, dict[str, str]] = {}
    for a in manifest.get("attachments", []):
        bundles[a.get("bundle", "")] = {"bundle": a.get("bundle", ""), "absolutePath": a.get("absolutePath", "")}

    all_scripts: list[dict[str, Any]] = []
    unresolved_refs: dict[str, list[int]] = {}
    for bundle, info in sorted(bundles.items()):
        scripts, refs = load_scripts(info["absolutePath"])
        script_ids = {int(s["scriptPathId"]) for s in scripts}
        for s in scripts:
            s["bundle"] = bundle
            all_scripts.append(s)
        unresolved_refs[bundle] = [path_id for path_id, count in refs.items() if path_id not in script_ids for _ in range(0)]

    by_type: dict[str, dict[str, Any]] = {}
    for s in all_scripts:
        key = f"{s['assemblyName']}::{s['fullName']}"
        row = by_type.setdefault(
            key,
            {
                "assemblyName": s["assemblyName"],
                "namespace": s["namespace"],
                "className": s["className"],
                "fullName": s["fullName"],
                "likelyRole": s["likelyRole"],
                "scriptPathIds": [],
                "bundles": [],
                "monoBehaviourRefCount": 0,
                "il2cppEvidence": s["il2cppEvidence"],
                "luaEvidence": s["luaEvidence"],
            },
        )
        row["scriptPathIds"].append(s["scriptPathId"])
        row["bundles"].append(s["bundle"])
        row["monoBehaviourRefCount"] += int(s["monoBehaviourRefCount"])

    identified = sorted(by_type.values(), key=lambda x: (-int(x["monoBehaviourRefCount"]), x["assemblyName"], x["fullName"]))
    stubbed = [
        r for r in identified
        if r["assemblyName"] in {"Assembly-CSharp.dll", "Assembly-CSharp-firstpass.dll", "spine-unity.dll", "Coffee.UIParticle.dll"}
        and r["className"] not in {"CanvasScaler", "GraphicRaycaster"}
    ]
    official = [r for r in identified if r["assemblyName"] in {"UnityEngine.UI.dll", "Unity.TextMeshPro.dll"}]
    evidence = {
        "status": "battle_ui_component_type_evidence_ready",
        "sourceManifest": str(ATTACH_MANIFEST),
        "sourceAttachResult": str(ATTACH_RESULT),
        "beforeCounts": before,
        "bundleCount": len(bundles),
        "identifiedTypeCount": len(identified),
        "officialPackageTypeCount": len(official),
        "stubProxyTypeCount": len(stubbed),
        "identifiedTypes": identified,
        "officialPackageActions": [
            {"package": "com.unity.ugui", "version": "2.0.0", "reason": "resolves UnityEngine.UI.dll and Unity.TextMeshPro.dll script references"}
        ],
        "stubProxyActions": [
            {
                "assemblyName": r["assemblyName"],
                "fullName": r["fullName"],
                "likelyRole": r["likelyRole"],
                "refCount": r["monoBehaviourRefCount"],
            }
            for r in stubbed
        ],
    }
    TYPE_EVIDENCE_JSON.write_text(json.dumps(evidence, ensure_ascii=False, indent=2), encoding="utf-8")
    STUB_MANIFEST.write_text(json.dumps({"stubProxyActions": evidence["stubProxyActions"]}, ensure_ascii=False, indent=2), encoding="utf-8")
    with TYPE_EVIDENCE_CSV.open("w", newline="", encoding="utf-8-sig") as f:
        writer = csv.DictWriter(
            f,
            fieldnames=[
                "assemblyName",
                "namespace",
                "className",
                "fullName",
                "likelyRole",
                "monoBehaviourRefCount",
                "scriptPathIds",
                "bundles",
                "il2cppEvidenceCount",
                "luaEvidenceCount",
            ],
        )
        writer.writeheader()
        for r in identified:
            writer.writerow(
                {
                    **{k: r.get(k, "") for k in ["assemblyName", "namespace", "className", "fullName", "likelyRole", "monoBehaviourRefCount"]},
                    "scriptPathIds": ";".join(map(str, r.get("scriptPathIds", []))),
                    "bundles": ";".join(sorted(set(r.get("bundles", [])))),
                    "il2cppEvidenceCount": len(r.get("il2cppEvidence", [])),
                    "luaEvidenceCount": len(r.get("luaEvidence", [])),
                }
            )
    print(json.dumps({
        "typeEvidence": str(TYPE_EVIDENCE_JSON),
        "identifiedTypeCount": len(identified),
        "officialPackageTypeCount": len(official),
        "stubProxyTypeCount": len(stubbed),
        "beforeMissingScriptCount": before.get("missingScriptCount", 0),
    }, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
