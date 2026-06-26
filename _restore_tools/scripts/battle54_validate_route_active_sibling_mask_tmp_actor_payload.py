from __future__ import annotations

import csv
import json
import re
from collections import Counter, defaultdict
from datetime import datetime
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_battle_unity"
REPORT_DIR = BASE / "reports" / "battle"
UNITY_DATA = PROJECT / "Assets" / "RestoreData" / "battle"

PREFIX = "BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD"
SCENE = PROJECT / "Assets" / "Scenes" / "Battle51LuaBridgeRaycasterRegistrationCandidate.unity"
CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle51LuaBridgeRaycasterRegistrationCandidate_1920x1080.png"
PAYLOAD_MANIFEST = REPORT_DIR / "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST.json"
B51_JSON = REPORT_DIR / "BATTLE_51_RESTORE_SOURCE_BACKED_LUAUNIT_UIEVENTLISTENER_AND_EVENTSYSTEM_RAYCASTER_REGISTRATION_RESULT.json"
B52_JSON = REPORT_DIR / "BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK_RESULT.json"
B53_JSON = REPORT_DIR / "BATTLE_53_RESTORE_OR_IMPORT_SOURCE_BACKED_XLUA_RUNTIME_AND_MODULESINIT_BOOTSTRAP_OR_ACCEPT_BLOCK_RESULT.json"
REF_NOTES = BASE / "reports" / "video_reference" / "REFERENCE_MP4_RESTORE_NOTES_20260626_024037.md"

OUT_JSON = REPORT_DIR / f"{PREFIX}_RESULT.json"
OUT_MD = REPORT_DIR / f"{PREFIX}_RESULT.md"
ROUTES_CSV = REPORT_DIR / f"{PREFIX}_ROUTES.csv"
ACTORS_CSV = REPORT_DIR / f"{PREFIX}_ACTORS.csv"
MASKS_CSV = REPORT_DIR / f"{PREFIX}_MASKS.csv"
TEXT_CSV = REPORT_DIR / f"{PREFIX}_TMP_TEXT.csv"
CARDS_CSV = REPORT_DIR / f"{PREFIX}_HERO_CARDS.csv"
BUTTONS_CSV = REPORT_DIR / f"{PREFIX}_BUTTON_ROUTES.csv"

DOC_RE = re.compile(r"^--- !u!(?P<class_id>-?\d+) &(?P<file_id>-?\d+)\n", re.MULTILINE)

CLASS_NAMES = {
    1: "GameObject",
    4: "Transform",
    20: "Camera",
    21: "Material",
    23: "MeshRenderer",
    28: "Texture2D",
    33: "MeshFilter",
    48: "Shader",
    81: "AudioListener",
    114: "MonoBehaviour",
    115: "MonoScript",
    213: "Sprite",
    222: "CanvasRenderer",
    223: "Canvas",
    224: "RectTransform",
}

CRITICAL_NAME_RE = re.compile(
    r"^(CanvasLuaStateHUD_|root_battle$|root_opra$|root_top$|TopCenter$|BottomCenter$|HeroListContainer$|"
    r"Battle29BoundHeroCard_|UI_NormalBattle_HeroItem$|UI_Battle3DUI$|UI_BattleBoxPage$|pop_Content$|box_item$|"
    r"btnAuto$|btnBuff$|btnTwoSpeed$|btnFastSkill$|btnPause$|btnSkip$|btn_box$|"
    r"BATTLE39_RuntimeActor_|Battle27RuntimeActor_|BATTLE43_EvidenceBackedEventSystem$)"
)


def read_json(path: Path, fallback: Any) -> Any:
    if not path.exists():
        return fallback
    return json.loads(path.read_text(encoding="utf-8-sig"))


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows)


def scalar(body: str, key: str, default: str = "") -> str:
    m = re.search(rf"(?m)^[ \t]+{re.escape(key)}:[ \t]*(.*)$", body)
    return m.group(1).strip() if m else default


def ref_value(body: str, key: str, default: int = 0) -> int:
    m = re.search(rf"(?m)^[ \t]+{re.escape(key)}:[ \t]*\{{fileID:[ \t]*(-?\d+)", body)
    return int(m.group(1)) if m else default


def vec_value(body: str, key: str) -> str:
    m = re.search(rf"(?m)^[ \t]+{re.escape(key)}:[ \t]*\{{([^}}]+)\}}", body)
    if not m:
        return ""
    items: dict[str, str] = {}
    for part in m.group(1).split(","):
        if ":" in part:
            k, v = part.split(":", 1)
            items[k.strip()] = v.strip()
    order = ["x", "y", "z", "w"]
    vals = [items[o] for o in order if o in items]
    return "/".join(vals)


def float_tuple(text: str) -> tuple[float, ...]:
    vals = []
    for part in (text or "").split("/"):
        try:
            vals.append(float(part))
        except Exception:
            pass
    return tuple(vals)


def is_zeroish_scale(scale_text: str) -> bool:
    vals = float_tuple(scale_text)
    return bool(vals) and any(abs(v) < 1e-6 for v in vals)


def boolish(text: str) -> bool:
    return str(text).strip().lower() in {"1", "true", "yes"}


def list_refs_block(body: str, key: str, item_key: str | None = None) -> list[int]:
    m = re.search(rf"(?m)^\s+{re.escape(key)}:\n(?P<block>(?:\s+- .*\n)*)", body)
    if not m:
        return []
    refs: list[int] = []
    for line in m.group("block").splitlines():
        if item_key:
            rm = re.search(rf"{re.escape(item_key)}:\s*\{{fileID:\s*(-?\d+)", line)
        else:
            rm = re.search(r"\{fileID:\s*(-?\d+)", line)
        if rm:
            refs.append(int(rm.group(1)))
    return refs


def parse_scene(path: Path) -> dict[int, dict[str, Any]]:
    text = path.read_text(encoding="utf-8-sig", errors="replace")
    matches = list(DOC_RE.finditer(text))
    docs: dict[int, dict[str, Any]] = {}
    for i, m in enumerate(matches):
        start = m.end()
        end = matches[i + 1].start() if i + 1 < len(matches) else len(text)
        body = text[start:end]
        class_id = int(m.group("class_id"))
        file_id = int(m.group("file_id"))
        kind = CLASS_NAMES.get(class_id, str(class_id))
        docs[file_id] = {
            "file_id": file_id,
            "class_id": class_id,
            "kind": kind,
            "body": body,
        }
    return docs


def classify_component(doc: dict[str, Any]) -> str:
    class_id = doc["class_id"]
    body = doc["body"]
    if class_id != 114:
        return CLASS_NAMES.get(class_id, str(class_id))
    identifier = scalar(body, "m_EditorClassIdentifier")
    if identifier:
        return identifier.split("::")[-1]
    if "m_IgnoreReversedGraphics:" in body or "m_BlockingObjects:" in body:
        return "UnityEngine.UI.GraphicRaycaster"
    if "m_UiScaleMode:" in body or "m_ReferenceResolution:" in body:
        return "UnityEngine.UI.CanvasScaler"
    if "m_TargetGraphic:" in body or "m_OnClick:" in body or "m_Navigation:" in body:
        return "UnityEngine.UI.Button"
    if "m_ShowMaskGraphic:" in body:
        return "UnityEngine.UI.Mask(serialized_missing_script)"
    if "m_text:" in body and ("m_fontAsset:" in body or "m_fontSize:" in body):
        return "TMPro.TextMeshProUGUI"
    if "m_Sprite:" in body and "m_FillMethod:" in body:
        return "UnityEngine.UI.Image"
    if "m_RaycastTarget:" in body and "m_Color:" in body:
        return "UnityEngine.UI.Graphic(serialized_missing_script)"
    if "m_alpha:" in body and "m_Interactable:" in body:
        return "UnityEngine.CanvasGroup"
    if "LuaScriptPath:" in body:
        return "YouYou.LuaForm/LuaUnit(serialized)"
    if "LuaComs:" in body:
        return "LuaComponentBinder.LuaComBinder(serialized)"
    script_ref = ref_value(body, "m_Script")
    if script_ref == 0:
        return "<missing>"
    return "MonoBehaviour"


def go_id_for_component(doc: dict[str, Any]) -> int:
    body = doc["body"]
    if doc["class_id"] in {4, 20, 23, 33, 114, 222, 223, 224}:
        return ref_value(body, "m_GameObject")
    return 0


def scene_index(docs: dict[int, dict[str, Any]]) -> dict[str, Any]:
    game_objects: dict[int, dict[str, Any]] = {}
    transforms: dict[int, dict[str, Any]] = {}
    components_by_go: dict[int, list[int]] = defaultdict(list)
    go_by_transform: dict[int, int] = {}
    transform_by_go: dict[int, int] = {}
    component_type: dict[int, str] = {}

    for file_id, doc in docs.items():
        body = doc["body"]
        if doc["class_id"] == 1:
            comps = list_refs_block(body, "m_Component", "component")
            game_objects[file_id] = {
                "file_id": file_id,
                "name": scalar(body, "m_Name"),
                "active": boolish(scalar(body, "m_IsActive", "0")),
                "layer": scalar(body, "m_Layer"),
                "components": comps,
            }
            components_by_go[file_id].extend(comps)
        elif doc["class_id"] in {4, 224}:
            go = ref_value(body, "m_GameObject")
            children = list_refs_block(body, "m_Children")
            tr = {
                "file_id": file_id,
                "class": doc["kind"],
                "go": go,
                "father": ref_value(body, "m_Father"),
                "children": children,
                "localPosition": vec_value(body, "m_LocalPosition"),
                "localScale": vec_value(body, "m_LocalScale"),
                "anchoredPosition": vec_value(body, "m_AnchoredPosition"),
                "sizeDelta": vec_value(body, "m_SizeDelta"),
                "anchorMin": vec_value(body, "m_AnchorMin"),
                "anchorMax": vec_value(body, "m_AnchorMax"),
                "pivot": vec_value(body, "m_Pivot"),
            }
            transforms[file_id] = tr
            if go:
                go_by_transform[file_id] = go
                transform_by_go[go] = file_id
        elif doc["class_id"] in {4, 20, 23, 33, 114, 222, 223, 224}:
            go = go_id_for_component(doc)
            if go and file_id not in components_by_go[go]:
                components_by_go[go].append(file_id)
        component_type[file_id] = classify_component(doc)

    def path_for_go(go: int) -> str:
        tid = transform_by_go.get(go, 0)
        names: list[str] = []
        seen: set[int] = set()
        while tid and tid not in seen:
            seen.add(tid)
            g = go_by_transform.get(tid, 0)
            names.append(game_objects.get(g, {}).get("name") or f"go{g}")
            tid = transforms.get(tid, {}).get("father", 0)
        return "/".join(reversed(names))

    def active_in_hierarchy(go: int) -> bool:
        tid = transform_by_go.get(go, 0)
        seen: set[int] = set()
        while tid and tid not in seen:
            seen.add(tid)
            g = go_by_transform.get(tid, 0)
            if g and not game_objects.get(g, {}).get("active", False):
                return False
            tid = transforms.get(tid, {}).get("father", 0)
        return bool(game_objects.get(go, {}).get("active", False))

    def sibling_index(go: int) -> int:
        tid = transform_by_go.get(go, 0)
        father = transforms.get(tid, {}).get("father", 0)
        children = transforms.get(father, {}).get("children", [])
        try:
            return children.index(tid)
        except ValueError:
            return -1

    def sibling_count(go: int) -> int:
        tid = transform_by_go.get(go, 0)
        father = transforms.get(tid, {}).get("father", 0)
        return len(transforms.get(father, {}).get("children", []))

    def descendants(go: int) -> list[int]:
        root_tid = transform_by_go.get(go, 0)
        out: list[int] = []
        stack = list(transforms.get(root_tid, {}).get("children", []))
        while stack:
            tid = stack.pop(0)
            child_go = go_by_transform.get(tid, 0)
            if child_go:
                out.append(child_go)
            stack[0:0] = transforms.get(tid, {}).get("children", [])
        return out

    return {
        "docs": docs,
        "game_objects": game_objects,
        "transforms": transforms,
        "components_by_go": dict(components_by_go),
        "component_type": component_type,
        "go_by_transform": go_by_transform,
        "transform_by_go": transform_by_go,
        "path_for_go": path_for_go,
        "active_in_hierarchy": active_in_hierarchy,
        "sibling_index": sibling_index,
        "sibling_count": sibling_count,
        "descendants": descendants,
    }


def components_summary(idx: dict[str, Any], go: int) -> str:
    types = []
    for comp in idx["components_by_go"].get(go, []):
        types.append(idx["component_type"].get(comp, "unknown"))
    return "|".join(types)


def first_component_body(idx: dict[str, Any], go: int, type_pred) -> str:
    for comp in idx["components_by_go"].get(go, []):
        ctype = idx["component_type"].get(comp, "")
        if type_pred(ctype):
            return idx["docs"][comp]["body"]
    return ""


def route_row(idx: dict[str, Any], go: int) -> dict[str, Any]:
    gos = idx["game_objects"]
    trs = idx["transforms"]
    transform_by_go = idx["transform_by_go"]
    tid = transform_by_go.get(go, 0)
    tr = trs.get(tid, {})
    father_go = idx["go_by_transform"].get(tr.get("father", 0), 0)
    child_names = []
    for child_tid in tr.get("children", []):
        child_go = idx["go_by_transform"].get(child_tid, 0)
        if child_go:
            child_names.append(gos.get(child_go, {}).get("name", f"go{child_go}"))
    warnings: list[str] = []
    if gos.get(go, {}).get("active") and is_zeroish_scale(tr.get("localScale", "")):
        warnings.append("active_route_has_zeroish_local_scale")
    if gos.get(go, {}).get("active") and not idx["active_in_hierarchy"](go):
        warnings.append("active_self_but_inactive_parent")
    comp_summary = components_summary(idx, go)
    if "<missing>" in comp_summary:
        warnings.append("has_missing_script_component")
    return {
        "path": idx["path_for_go"](go),
        "name": gos.get(go, {}).get("name", ""),
        "fileId": go,
        "activeSelf": gos.get(go, {}).get("active", False),
        "activeInHierarchy": idx["active_in_hierarchy"](go),
        "layer": gos.get(go, {}).get("layer", ""),
        "parentPath": idx["path_for_go"](father_go) if father_go else "",
        "siblingIndex": idx["sibling_index"](go),
        "siblingCount": idx["sibling_count"](go),
        "transformType": tr.get("class", ""),
        "localPosition": tr.get("localPosition", ""),
        "anchoredPosition": tr.get("anchoredPosition", ""),
        "localScale": tr.get("localScale", ""),
        "sizeDelta": tr.get("sizeDelta", ""),
        "anchorMin": tr.get("anchorMin", ""),
        "anchorMax": tr.get("anchorMax", ""),
        "pivot": tr.get("pivot", ""),
        "childNames": " | ".join(child_names),
        "componentTypes": comp_summary,
        "warning": " | ".join(warnings),
    }


def payload_index() -> dict[str, Any]:
    manifest = read_json(PAYLOAD_MANIFEST, {})
    by_did: dict[str, dict[str, Any]] = {}
    for actor in manifest.get("actors", []):
        did = str(actor.get("payloadHeroDid", ""))
        if did:
            by_did[did] = actor
    return {"manifest": manifest, "byDid": by_did}


def actor_rows(idx: dict[str, Any], payload: dict[str, Any]) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for go, data in idx["game_objects"].items():
        name = data.get("name", "")
        if not (name.startswith("BATTLE39_RuntimeActor_") or name.startswith("Battle27RuntimeActor_")):
            continue
        did = ""
        m = re.search(r"_(\d{4,7})(?:_model|$)", name)
        if m:
            did = m.group(1)
        actor = payload["byDid"].get(did, {})
        rr = route_row(idx, go)
        rows.append(
            {
                **rr,
                "sceneActorName": name,
                "payloadHeroDid": did,
                "payloadLocalStatus": actor.get("localStatus", ""),
                "payloadModelId": actor.get("modelId", ""),
                "payloadActorBundle": actor.get("actorBundle", ""),
                "payloadReason": actor.get("reason", ""),
                "sourceKind": "active_runtime_actor_candidate" if name.startswith("BATTLE39_") else "disabled_legacy_actor_candidate",
            }
        )
    return rows


def mask_rows(idx: dict[str, Any]) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for go, data in idx["game_objects"].items():
        name = data.get("name", "")
        comp_types = components_summary(idx, go)
        is_mask_name = "mask" in name.lower()
        is_mask_comp = "Mask" in comp_types or "RectMask" in comp_types
        if not (is_mask_name or is_mask_comp):
            continue
        body = first_component_body(idx, go, lambda t: "Mask" in t)
        rr = route_row(idx, go)
        rows.append(
            {
                **rr,
                "hasMaskComponent": is_mask_comp,
                "maskComponentType": next((t for t in comp_types.split("|") if "Mask" in t), ""),
                "showMaskGraphic": scalar(body, "m_ShowMaskGraphic", ""),
                "maskScriptRef": ref_value(body, "m_Script") if body else "",
                "evidence": "component has m_ShowMaskGraphic" if body else "name-only mask candidate",
            }
        )
    return rows


def text_rows(idx: dict[str, Any]) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for go, data in idx["game_objects"].items():
        body = first_component_body(idx, go, lambda t: "TextMeshProUGUI" in t or t.endswith("Text"))
        if not body:
            continue
        rr = route_row(idx, go)
        text = scalar(body, "m_text")
        rows.append(
            {
                **rr,
                "text": text[:140],
                "fontSize": scalar(body, "m_fontSize"),
                "fontSizeBase": scalar(body, "m_fontSizeBase"),
                "enableAutoSizing": scalar(body, "m_enableAutoSizing"),
                "fontSizeMin": scalar(body, "m_fontSizeMin"),
                "fontSizeMax": scalar(body, "m_fontSizeMax"),
                "characterSpacing": scalar(body, "m_characterSpacing"),
                "characterHorizontalScale": scalar(body, "m_characterHorizontalScale"),
                "overflowMode": scalar(body, "m_overflowMode"),
                "textWrappingMode": scalar(body, "m_TextWrappingMode"),
                "fontAssetRef": ref_value(body, "m_fontAsset"),
                "sharedMaterialRef": ref_value(body, "m_sharedMaterial"),
            }
        )
    return rows


def button_rows(idx: dict[str, Any]) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for go, data in idx["game_objects"].items():
        name = data.get("name", "")
        comp_types = components_summary(idx, go)
        if "UnityEngine.UI.Button" not in comp_types and not name.startswith("btn"):
            continue
        button_body = first_component_body(idx, go, lambda t: "Button" in t)
        graphic_body = first_component_body(idx, go, lambda t: "Image" in t or "Graphic" in t)
        rr = route_row(idx, go)
        rows.append(
            {
                **rr,
                "buttonComponentPresent": "UnityEngine.UI.Button" in comp_types,
                "interactable": scalar(button_body, "m_Interactable", ""),
                "transition": scalar(button_body, "m_Transition", ""),
                "targetGraphic": ref_value(button_body, "m_TargetGraphic") if button_body else "",
                "raycastTarget": scalar(graphic_body, "m_RaycastTarget", ""),
                "spriteRef": ref_value(graphic_body, "m_Sprite") if graphic_body else "",
            }
        )
    return rows


def hero_card_rows(idx: dict[str, Any], payload: dict[str, Any]) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for go, data in idx["game_objects"].items():
        name = data.get("name", "")
        if not (name.startswith("Battle29BoundHeroCard_") or name == "UI_NormalBattle_HeroItem"):
            continue
        did = ""
        m = re.search(r"_(\d{4,7})$", name)
        if m:
            did = m.group(1)
        desc = idx["descendants"](go)
        comp_counts = Counter()
        active_desc = 0
        image_with_sprite = 0
        image_without_sprite = 0
        texts: list[str] = []
        mask_like = 0
        for child_go in desc:
            if idx["active_in_hierarchy"](child_go):
                active_desc += 1
            for comp in idx["components_by_go"].get(child_go, []):
                ctype = idx["component_type"].get(comp, "")
                comp_counts[ctype] += 1
                body = idx["docs"][comp]["body"]
                if "Image" in ctype:
                    if ref_value(body, "m_Sprite"):
                        image_with_sprite += 1
                    else:
                        image_without_sprite += 1
                if "TextMeshProUGUI" in ctype:
                    txt = scalar(body, "m_text")
                    if txt:
                        texts.append(txt)
                if "Mask" in ctype or "mask" in idx["game_objects"].get(child_go, {}).get("name", "").lower():
                    mask_like += 1
        actor = payload["byDid"].get(did, {})
        rr = route_row(idx, go)
        rows.append(
            {
                **rr,
                "payloadHeroDid": did,
                "payloadLocalStatus": actor.get("localStatus", ""),
                "descendantCount": len(desc),
                "activeDescendantCount": active_desc,
                "imageWithSpriteCount": image_with_sprite,
                "imageWithoutSpriteCount": image_without_sprite,
                "textSamples": " | ".join(texts[:8]),
                "maskLikeDescendantCount": mask_like,
                "componentTypeCounts": json.dumps(dict(comp_counts), ensure_ascii=False, sort_keys=True),
            }
        )
    return rows


def route_rows(idx: dict[str, Any]) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for go, data in idx["game_objects"].items():
        name = data.get("name", "")
        path = idx["path_for_go"](go)
        if CRITICAL_NAME_RE.search(name) or "CanvasLuaStateHUD_" in path or "Battle29BoundHeroCard_" in path:
            rows.append(route_row(idx, go))
    return sorted(rows, key=lambda r: (r["path"], r["fileId"]))


def command_policy() -> dict[str, Any]:
    root_cmds = sorted(str(p) for p in BASE.glob("*.cmd"))
    direct_cmds = sorted(str(p) for p in (BASE / "_restore_tools").glob("*.cmd"))
    return {
        "rootCmdCount": len(root_cmds),
        "rootCmdFiles": root_cmds,
        "restoreToolsDirectCmdCount": len(direct_cmds),
        "restoreToolsDirectCmdFiles": direct_cmds,
    }


def summarize(idx: dict[str, Any], routes: list[dict[str, Any]], actors: list[dict[str, Any]], masks: list[dict[str, Any]], texts: list[dict[str, Any]], cards: list[dict[str, Any]], buttons: list[dict[str, Any]], payload: dict[str, Any]) -> dict[str, Any]:
    active_route_zero_scale = [r for r in routes if r["activeSelf"] and "zeroish" in r.get("warning", "")]
    inactive_critical = [r for r in routes if not r["activeInHierarchy"] and any(key in r["name"] for key in ["CanvasLuaStateHUD_", "Battle29BoundHeroCard_", "BATTLE39_RuntimeActor_", "btn"])]
    active_actors = [r for r in actors if r["activeInHierarchy"]]
    active_loadable_actors = [r for r in active_actors if r["payloadLocalStatus"] == "loadable"]
    disabled_legacy = [r for r in actors if r["sceneActorName"].startswith("Battle27RuntimeActor_")]
    manifest = payload["manifest"]
    actor_status_counts = manifest.get("summary", {}).get("actorStatusCounts", {})
    text_autosize = Counter(str(r.get("enableAutoSizing", "")) for r in texts)
    negative_spacing = [r for r in texts if str(r.get("characterSpacing", "")).startswith("-")]
    real_mask_components = [r for r in masks if r.get("hasMaskComponent")]
    name_only_masks = [r for r in masks if not r.get("hasMaskComponent")]
    card_active = [r for r in cards if r["activeInHierarchy"]]
    card_with_sprite = [r for r in card_active if int(r.get("imageWithSpriteCount") or 0) > 0]
    return {
        "scene": str(SCENE),
        "capture": str(CAPTURE),
        "referenceNotes": str(REF_NOTES) if REF_NOTES.exists() else "",
        "routeCount": len(routes),
        "activeRouteZeroScaleCount": len(active_route_zero_scale),
        "activeRouteZeroScaleSamples": [r["path"] for r in active_route_zero_scale[:12]],
        "inactiveCriticalCount": len(inactive_critical),
        "inactiveCriticalSamples": [r["path"] for r in inactive_critical[:12]],
        "actorRows": len(actors),
        "activeActorRows": len(active_actors),
        "activeLoadableActorRows": len(active_loadable_actors),
        "disabledLegacyActorRows": len(disabled_legacy),
        "manifestActorStatusCounts": actor_status_counts,
        "manifestClassification": manifest.get("summary", {}).get("classification", ""),
        "manifestLoadableActors": manifest.get("summary", {}).get("loadableActors", ""),
        "manifestTotalActors": manifest.get("summary", {}).get("totalActors", ""),
        "maskRows": len(masks),
        "maskComponentRows": len(real_mask_components),
        "maskNameOnlyRows": len(name_only_masks),
        "textRows": len(texts),
        "textAutosizeCounts": dict(text_autosize),
        "negativeCharacterSpacingRows": len(negative_spacing),
        "cardRows": len(cards),
        "activeCardRows": len(card_active),
        "activeCardsWithSpriteRows": len(card_with_sprite),
        "buttonRows": len(buttons),
        "buttonComponentRows": sum(1 for r in buttons if r.get("buttonComponentPresent")),
        "buttonActiveRows": sum(1 for r in buttons if r.get("activeInHierarchy")),
        "b51": read_json(B51_JSON, {}),
        "b52": read_json(B52_JSON, {}),
        "b53": read_json(B53_JSON, {}),
    }


def write_report(result: dict[str, Any]) -> None:
    s = result["summary"]
    b51 = s.get("b51", {})
    b51_unity = b51.get("unitySummary", {}) if isinstance(b51, dict) else {}
    b52 = s.get("b52", {})
    b53 = s.get("b53", {})
    lines = [
        f"# {PREFIX} Result",
        "",
        "**최종 playable battle screen은 아직 아니다.** BATTLE54는 최신 BATTLE51 후보 씬을 정적 YAML/기존 Unity probe 산출물 기준으로 재검증해 route active state, sibling order, mask/stencil, TMP scale/autosize, actor/card payload 상태를 분리했다.",
        "",
        "## Verdict",
        f"- visual_status: `structural_route_actor_card_audit_complete_no_runtime_patch`",
        f"- final screen claim: `false`",
        f"- patch decision: `blocked_no_scene_patch_in_battle54_static_audit`",
        f"- scene: `{s['scene']}`",
        f"- capture: `{s['capture']}`",
        "",
        "## Route / Active / Sibling",
        f"- audited route rows: `{s['routeCount']}`",
        f"- active routes with zero-ish local scale: `{s['activeRouteZeroScaleCount']}`",
        f"- inactive critical route rows: `{s['inactiveCriticalCount']}`",
        "- zero-scale samples:",
    ]
    for sample in s["activeRouteZeroScaleSamples"][:8]:
        lines.append(f"  - `{sample}`")
    lines.extend(
        [
            "",
            "## Actors / Payload",
            f"- scene actor rows: `{s['actorRows']}`",
            f"- active scene actor rows: `{s['activeActorRows']}`",
            f"- active loadable scene actor rows: `{s['activeLoadableActorRows']}`",
            f"- disabled legacy actor rows: `{s['disabledLegacyActorRows']}`",
            f"- manifest classification: `{s['manifestClassification']}`",
            f"- manifest loadable actors: `{s['manifestLoadableActors']}` / `{s['manifestTotalActors']}`",
            f"- manifest actor status counts: `{s['manifestActorStatusCounts']}`",
            "",
            "## Mask / Stencil",
            f"- mask rows: `{s['maskRows']}`",
            f"- serialized Mask component rows: `{s['maskComponentRows']}`",
            f"- name-only mask candidate rows: `{s['maskNameOnlyRows']}`",
            "- Important: BATTLE54 does not add Mask/RectMask2D/Stencil components. Rows with `m_ShowMaskGraphic` and `m_Script: fileID 0` remain serialized/missing-script evidence, not a confirmed working stencil pipeline.",
            "",
            "## TMP / Text",
            f"- TMP/text rows: `{s['textRows']}`",
            f"- TMP auto-size counts: `{s['textAutosizeCounts']}`",
            f"- negative character-spacing rows: `{s['negativeCharacterSpacingRows']}`",
            "",
            "## Hero Cards / Buttons",
            f"- card rows: `{s['cardRows']}`",
            f"- active card rows: `{s['activeCardRows']}`",
            f"- active cards with at least one sprite-backed image: `{s['activeCardsWithSpriteRows']}`",
            f"- button route rows: `{s['buttonRows']}`",
            f"- button component rows: `{s['buttonComponentRows']}`",
            f"- active button rows: `{s['buttonActiveRows']}`",
            "",
            "## Runtime Carryover",
            f"- BATTLE51 direct target included: `{b51_unity.get('directGraphicTargetIncludedCount', '')}`",
            f"- BATTLE51 forced EventSystem target included: `{b51_unity.get('forcedEventSystemTargetIncludedCount', '')}`",
            f"- BATTLE52 Lua lifecycle executed: `{b52.get('luaLifecycleExecutedCount', '')}`",
            f"- BATTLE53 verdict: `{b53.get('verdict', '')}`",
            "",
            "## Current Root Cause Split",
            "- Visual mismatch is not explained by a single button coordinate. The latest candidate has active HUD routes and active loadable actor candidates, but final playability still lacks executable xLua/GameEntry/LuaManager lifecycle and original runtime placement/state.",
            "- Actor/card payload is only a local subset: loadable actors are present for `1002`, `1034`, and enemy `1100111 -> 3001`; `1036` and most enemy payload ids are not locally resolved.",
            "- Mask/stencil and TMP states are mostly preserved as serialized/missing-script evidence. BATTLE54 refuses to invent working stencil/TMP behavior without source/runtime confirmation.",
            "- The next safe path is either source-backed runtime import, or a separate explicitly approved non-source-backed xLua experiment; otherwise continue non-runtime evidence tasks only.",
            "",
            "## Outputs",
            f"- result JSON: `{OUT_JSON}`",
            f"- routes CSV: `{ROUTES_CSV}`",
            f"- actors CSV: `{ACTORS_CSV}`",
            f"- masks CSV: `{MASKS_CSV}`",
            f"- TMP/text CSV: `{TEXT_CSV}`",
            f"- hero cards CSV: `{CARDS_CSV}`",
            f"- buttons CSV: `{BUTTONS_CSV}`",
            "",
            "## Command Policy Check",
            f"- root CMD count: `{result['commandPolicy']['rootCmdCount']}`",
            f"- `_restore_tools` direct CMD count: `{result['commandPolicy']['restoreToolsDirectCmdCount']}`",
        ]
    )
    OUT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> None:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    docs = parse_scene(SCENE)
    idx = scene_index(docs)
    payload = payload_index()

    routes = route_rows(idx)
    actors = actor_rows(idx, payload)
    masks = mask_rows(idx)
    texts = text_rows(idx)
    cards = hero_card_rows(idx, payload)
    buttons = button_rows(idx)

    write_csv(
        ROUTES_CSV,
        routes,
        [
            "path",
            "name",
            "fileId",
            "activeSelf",
            "activeInHierarchy",
            "layer",
            "parentPath",
            "siblingIndex",
            "siblingCount",
            "transformType",
            "localPosition",
            "anchoredPosition",
            "localScale",
            "sizeDelta",
            "anchorMin",
            "anchorMax",
            "pivot",
            "childNames",
            "componentTypes",
            "warning",
        ],
    )
    write_csv(ACTORS_CSV, actors, list(actors[0].keys()) if actors else ["path"])
    write_csv(MASKS_CSV, masks, list(masks[0].keys()) if masks else ["path"])
    write_csv(TEXT_CSV, texts, list(texts[0].keys()) if texts else ["path"])
    write_csv(CARDS_CSV, cards, list(cards[0].keys()) if cards else ["path"])
    write_csv(BUTTONS_CSV, buttons, list(buttons[0].keys()) if buttons else ["path"])

    result = {
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "prefix": PREFIX,
        "summary": summarize(idx, routes, actors, masks, texts, cards, buttons, payload),
        "outputs": {
            "report": str(OUT_MD),
            "json": str(OUT_JSON),
            "routesCsv": str(ROUTES_CSV),
            "actorsCsv": str(ACTORS_CSV),
            "masksCsv": str(MASKS_CSV),
            "textCsv": str(TEXT_CSV),
            "cardsCsv": str(CARDS_CSV),
            "buttonsCsv": str(BUTTONS_CSV),
        },
        "commandPolicy": command_policy(),
    }
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    write_report(result)
    print(json.dumps({"report": str(OUT_MD), "json": str(OUT_JSON), "routes": len(routes), "actors": len(actors), "texts": len(texts)}, ensure_ascii=False))


if __name__ == "__main__":
    main()
