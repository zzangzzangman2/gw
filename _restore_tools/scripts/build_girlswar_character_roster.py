from __future__ import annotations

import csv
import gzip
import json
import struct
import sys
from collections import Counter, defaultdict
from pathlib import Path
from typing import Any

import UnityPy


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
MERGED = BASE / "girlswar_merged_extracted"
INDEX_DIR = MERGED / "indexes"
REPORT_DIR = BASE / "reports" / "characters"
BATTLE_REPORT_DIR = BASE / "reports" / "battle"

PAYLOAD_JSON = BATTLE_REPORT_DIR / "BATTLE_TEST_PAYLOAD.json"
MANIFEST_JSON = BATTLE_REPORT_DIR / "BATTLE_PROTOTYPE_MANIFEST.json"

ASSETBUNDLES_CSV = INDEX_DIR / "assetbundles.csv"
UNITY_OBJECTS_CSV = INDEX_DIR / "unity_objects.csv"
UNITY_IMAGES_CSV = INDEX_DIR / "unity_images.csv"
UNITY_TEXTASSETS_CSV = INDEX_DIR / "unity_textassets.csv"

OUT_JSON = REPORT_DIR / "GIRLSWAR_CHARACTER_ROSTER.json"
OUT_ACTORS_CSV = REPORT_DIR / "GIRLSWAR_CHARACTER_ROSTER_ACTORS.csv"
OUT_SKILLS_CSV = REPORT_DIR / "GIRLSWAR_CHARACTER_ROSTER_SKILLS.csv"
OUT_GAPS_JSON = REPORT_DIR / "GIRLSWAR_CHARACTER_GAP_REPORT.json"
OUT_MD = REPORT_DIR / "GIRLSWAR_CHARACTER_ROSTER.md"
OUT_GAPS_MD = REPORT_DIR / "GIRLSWAR_CHARACTER_GAP_REPORT.md"
OUT_SYSPREFAB_JSON = REPORT_DIR / "DTSYSPREFAB_DIRECT_DECODE_REPORT.json"
OUT_SYSPREFAB_CSV = REPORT_DIR / "DTSYSPREFAB_BATTLE_RELEVANT_ROWS.csv"
OUT_SYSPREFAB_MD = REPORT_DIR / "DTSYSPREFAB_DIRECT_DECODE_REPORT.md"

SYSPREFAB_BUNDLE = MERGED / "extracted" / "unity" / "clean_unityfs_slices" / "download" / "datatable" / "sys.assetbundle"
SYSPREFAB_TEXTASSET_PATH_ID = 6885155417360981632

sys.path.insert(0, str(BASE / "_restore_tools" / "scripts"))
import build_battle_prototype_manifest as b5  # noqa: E402


def norm(value: str | Path | None) -> str:
    return str(value or "").replace("\\", "/").lower()


def rel(path: str | Path | None) -> str:
    if not path:
        return ""
    p = Path(path)
    try:
        return str(p.relative_to(BASE)).replace("\\", "/")
    except Exception:
        return str(path).replace("\\", "/")


def read_csv(path: Path) -> list[dict[str, str]]:
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows)


def write_json(path: Path, data: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")


def as_int(value: Any) -> int | None:
    try:
        if value is None or value == "":
            return None
        return int(value)
    except (TypeError, ValueError):
        return None


def pipe(values: list[Any]) -> str:
    return "|".join(str(v) for v in values if v not in (None, ""))


def first(rows: list[dict[str, str]], predicate) -> dict[str, str] | None:
    for row in rows:
        if predicate(row):
            return row
    return None


def by_bundle(rows: list[dict[str, str]]) -> dict[str, list[dict[str, str]]]:
    out: dict[str, list[dict[str, str]]] = defaultdict(list)
    for row in rows:
        out[norm(row.get("bundle"))].append(row)
    return out


def load_bundle_indexes(wanted_bundles: set[str]) -> dict[str, Any]:
    wanted = {norm(b) for b in wanted_bundles if b}
    bundle_rows = read_csv(ASSETBUNDLES_CSV)
    bundle_by_name = {norm(r.get("bundle")): r for r in bundle_rows if r.get("bundle")}
    objects: list[dict[str, str]] = []
    images: list[dict[str, str]] = []
    textassets: list[dict[str, str]] = []
    for path, dest in [
        (UNITY_OBJECTS_CSV, objects),
        (UNITY_IMAGES_CSV, images),
        (UNITY_TEXTASSETS_CSV, textassets),
    ]:
        with path.open("r", encoding="utf-8-sig", newline="") as f:
            reader = csv.DictReader(f)
            for row in reader:
                if norm(row.get("bundle")) in wanted:
                    dest.append(row)
    return {
        "bundleByName": bundle_by_name,
        "objectsByBundle": by_bundle(objects),
        "imagesByBundle": by_bundle(images),
        "textassetsByBundle": by_bundle(textassets),
    }


def bundle_exists(bundle: str, bundle_by_name: dict[str, dict[str, str]]) -> bool:
    row = bundle_by_name.get(norm(bundle))
    return bool(row and row.get("status") == "ok")


def actor_bundle(prefab_id: Any) -> str:
    return f"download/roleprefabsandres/battleprefabandres/{prefab_id}.assetbundle" if prefab_id else ""


def skill_bundle_from_asset_path(asset_path: str) -> str:
    return b5.skill_bundle_from_asset_path(asset_path) or ""


def flat_u32(buf: bytes, offset: int) -> int:
    return struct.unpack_from("<I", buf, offset)[0]


def flat_i32(buf: bytes, offset: int) -> int:
    return struct.unpack_from("<i", buf, offset)[0]


def flat_field(buf: bytes, table: int, index: int) -> int:
    vtable = table - flat_i32(buf, table)
    vtable_len = struct.unpack_from("<H", buf, vtable)[0]
    field_pos = 4 + index * 2
    if field_pos + 2 > vtable_len:
        return 0
    return struct.unpack_from("<H", buf, vtable + field_pos)[0]


def flat_int(buf: bytes, table: int, index: int, default: int = 0) -> int:
    offset = flat_field(buf, table, index)
    return flat_i32(buf, table + offset) if offset else default


def flat_byte(buf: bytes, table: int, index: int, default: int = 0) -> int:
    offset = flat_field(buf, table, index)
    return buf[table + offset] if offset else default


def flat_string(buf: bytes, table: int, index: int) -> str:
    offset = flat_field(buf, table, index)
    if not offset:
        return ""
    loc = table + offset
    start = loc + flat_u32(buf, loc)
    length = flat_u32(buf, start)
    return buf[start + 4 : start + 4 + length].decode("utf-8", errors="replace")


def decode_dtsys_prefab_table() -> tuple[dict[int, dict[str, Any]], dict[str, Any]]:
    env = UnityPy.load(str(SYSPREFAB_BUNDLE))
    target = None
    for obj in env.objects:
        if obj.type.name == "TextAsset" and obj.path_id == SYSPREFAB_TEXTASSET_PATH_ID:
            target = obj
            break
    if target is None:
        raise FileNotFoundError(f"DTSysPrefab TextAsset pathID {SYSPREFAB_TEXTASSET_PATH_ID} not found in {SYSPREFAB_BUNDLE}")

    raw_object = target.get_raw_data()
    gzip_start = raw_object.find(bytes([0x1F, 0x8B, 0x08]))
    if gzip_start < 0:
        raise ValueError("DTSysPrefab raw TextAsset object does not contain a gzip stream")
    decompressed = gzip.decompress(raw_object[gzip_start:])

    root = flat_u32(decompressed, 0)
    vector_field = flat_field(decompressed, root, 0)
    vector_loc = root + vector_field
    vector = vector_loc + flat_u32(decompressed, vector_loc)
    count = flat_u32(decompressed, vector)
    rows: dict[int, dict[str, Any]] = {}
    for index in range(count):
        elem = vector + 4 + index * 4
        table = elem + flat_u32(decompressed, elem)
        row = {
            "id": flat_int(decompressed, table, 0),
            "desc": flat_string(decompressed, table, 1),
            "name": flat_string(decompressed, table, 2),
            "assetCategory": flat_int(decompressed, table, 3),
            "assetPath": flat_string(decompressed, table, 4),
            "poolId": flat_byte(decompressed, table, 5),
            "useTableData": bool(flat_byte(decompressed, table, 6)),
            "cullDespawned": flat_byte(decompressed, table, 7),
            "cullAbove": flat_int(decompressed, table, 8),
            "cullDelay": flat_int(decompressed, table, 9),
            "cullMaxPerPass": flat_int(decompressed, table, 10),
        }
        rows[int(row["id"])] = row
    evidence = {
        "bundle": rel(SYSPREFAB_BUNDLE),
        "textAssetPathId": SYSPREFAB_TEXTASSET_PATH_ID,
        "rawObjectBytes": len(raw_object),
        "gzipStartOffsetInSerializedTextAsset": gzip_start,
        "gzipBytes": len(raw_object) - gzip_start,
        "decompressedBytes": len(decompressed),
        "flatbufferRootOffset": root,
        "rowCount": count,
        "status": "direct_raw_gzip_flatbuffer_decode_ok",
        "lossyExtractedTxtNote": "extracted/unity/bundles/.../6885155417360981632_DTSysPrefab.txt is lossy because UnityPy read().script converted non-UTF bytes to '?'; get_raw_data() preserves the gzip stream.",
    }
    return rows, evidence


def actor_asset_evidence(bundle: str, indexes: dict[str, Any]) -> dict[str, Any]:
    key = norm(bundle)
    objects = indexes["objectsByBundle"].get(key, [])
    images = indexes["imagesByBundle"].get(key, [])
    textassets = indexes["textassetsByBundle"].get(key, [])
    skel = first(textassets, lambda r: r.get("name", "").lower().endswith(".skel"))
    atlas = first(textassets, lambda r: r.get("name", "").lower().endswith(".atlas"))
    texture = first(images, lambda r: r.get("type", "") == "Texture2D")
    material = first(objects, lambda r: r.get("type", "") == "Material")
    game_object = first(objects, lambda r: r.get("type", "") == "GameObject")
    counts = Counter(r.get("type", "") for r in objects)
    return {
        "skeletonData": skel.get("output", "") if skel else "",
        "atlas": atlas.get("output", "") if atlas else "",
        "texture": texture.get("output", "") if texture else "",
        "materialPathId": material.get("path_id", "") if material else "",
        "gameObjectPathId": game_object.get("path_id", "") if game_object else "",
        "gameObjectName": game_object.get("name", "") if game_object else "",
        "objectTypeCounts": dict(counts),
    }


def load_payload() -> dict[str, Any]:
    data = json.loads(PAYLOAD_JSON.read_text(encoding="utf-8"))
    return data.get("battleInfo", data)


def collect_payload_actors(info: dict[str, Any]) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for idx, hero in enumerate(info.get("ourHeros", []), start=1):
        rows.append(
            {
                "side": "our",
                "waveNo": "",
                "slot": idx,
                "payloadHeroDid": hero.get("heroDid"),
                "payloadHeroId": hero.get("heroId"),
                "payload": hero,
            }
        )
    for wave in info.get("waveData", []):
        wave_no = wave.get("waveNo")
        formation_by_id = {x.get("heroDid"): x for x in wave.get("enemyTeamFormation", [])}
        for idx, hero in enumerate(wave.get("enemyHeros", []), start=1):
            formation = formation_by_id.get(hero.get("heroDid"), {})
            rows.append(
                {
                    "side": "enemy",
                    "waveNo": wave_no,
                    "slot": formation.get("position", idx),
                    "payloadHeroDid": hero.get("heroDid"),
                    "payloadHeroId": hero.get("heroId"),
                    "payload": hero,
                }
            )
    return rows


def find_monster_row(hero_did: int, monster_tables: dict[str, b5.TableData]) -> tuple[str, dict[str, Any] | None]:
    preferred = ["DTMonsterEntity", "DTMonster_FEntity", "DTMonster_GEntity", "DTMonster_HEntity", "DTMonster_KEntity", "DTMonster_OEntity"]
    search_order = [name for name in preferred if name in monster_tables]
    search_order.extend(name for name in sorted(monster_tables) if name not in search_order)
    for name in search_order:
        table = monster_tables.get(name)
        if table and hero_did in table.rows:
            return name, table.rows[hero_did]
    return "", None


def build_actor_rows(
    payload_actors: list[dict[str, Any]],
    hero_table: b5.TableData,
    model_table: b5.TableData,
    monster_tables: dict[str, b5.TableData],
    indexes: dict[str, Any],
    sys_prefabs: dict[int, dict[str, Any]],
) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    for actor in payload_actors:
        side = actor["side"]
        hero_did = as_int(actor.get("payloadHeroDid"))
        payload = actor["payload"]
        if hero_did is None:
            continue
        source_table = ""
        source_row = None
        if side == "our":
            source_table = "DTHeroEntity"
            source_row = hero_table.rows.get(hero_did)
        else:
            source_table, source_row = find_monster_row(hero_did, monster_tables)

        model_id = as_int(source_row.get("modelID")) if source_row else None
        model_row = model_table.rows.get(model_id or -1)
        prefab_id = as_int(model_row.get("prefabId")) if model_row else None
        bundle = actor_bundle(prefab_id)
        bundle_ok = bundle_exists(bundle, indexes["bundleByName"]) if bundle else False
        assets = actor_asset_evidence(bundle, indexes) if bundle_ok else {}
        sys_prefab = sys_prefabs.get(prefab_id or -1, {})
        load_status = "loadable_spine_bundle" if assets.get("skeletonData") and assets.get("atlas") and assets.get("texture") else "not_loadable_yet"
        if not bundle:
            load_status = "missing_model_or_prefab"
        elif not bundle_ok:
            load_status = "bundle_not_in_extracted_assetbundle_index"

        skill_ids = [as_int(s.get("skillDid")) for s in payload.get("skills", []) if as_int(s.get("skillDid"))]
        rows.append(
            {
                "side": side,
                "waveNo": actor["waveNo"],
                "slot": actor["slot"],
                "payloadHeroDid": hero_did,
                "payloadHeroId": actor.get("payloadHeroId"),
                "datatable": source_table,
                "datatableFound": bool(source_row),
                "modelId": model_id or "",
                "modelFound": bool(model_row),
                "prefabId": prefab_id or "",
                "petPrefabId": model_row.get("petPainting", "") if model_row else "",
                "haloPrefabId": model_row.get("haloPrefabId", "") if model_row else "",
                "battleZoom": model_row.get("battleZoom", "") if model_row else "",
                "actorBundle": bundle,
                "actorBundleExists": bundle_ok,
                "sysPrefabAssetPath": sys_prefab.get("assetPath", ""),
                "sysPrefabName": sys_prefab.get("name", ""),
                "sysPrefabFound": bool(sys_prefab),
                "spineSkeletonData": assets.get("skeletonData", ""),
                "spineAtlas": assets.get("atlas", ""),
                "spineTexture": assets.get("texture", ""),
                "materialPathId": assets.get("materialPathId", ""),
                "gameObjectPathId": assets.get("gameObjectPathId", ""),
                "gameObjectName": assets.get("gameObjectName", ""),
                "loadStatus": load_status,
                "skillDidList": pipe(skill_ids),
                "nameKey": source_row.get("heroName") if side == "our" and source_row else (source_row.get("monName") if source_row else ""),
                "evidence": "HeroCtrl:DTHero/DTMonster->DTmodel.prefabId; actor bundle path roleprefabsandres/battleprefabandres/<prefabId>.assetbundle",
            }
        )
    return rows


def build_skill_rows(
    payload_actors: list[dict[str, Any]],
    skill_act: b5.TableData,
    skill_pas: b5.TableData,
    timeline_by_prefab: dict[int, list[dict[str, Any]]],
    timeline_by_path: dict[str, dict[str, Any]],
    indexes: dict[str, Any],
    sys_prefabs: dict[int, dict[str, Any]],
) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    seen_owner_rows: set[tuple[Any, ...]] = set()
    for actor in payload_actors:
        owner = as_int(actor.get("payloadHeroDid"))
        payload = actor["payload"]
        for skill in payload.get("skills", []):
            skill_id = as_int(skill.get("skillDid"))
            if not skill_id:
                continue
            key = (actor["side"], actor["waveNo"], owner, skill.get("skillType"), skill_id)
            if key in seen_owner_rows:
                continue
            seen_owner_rows.add(key)
            act_row = skill_act.rows.get(skill_id)
            pas_row = skill_pas.rows.get(skill_id)
            prefab_pairs: list[tuple[str, int]] = []
            if act_row:
                for field in ["prefabId", "fastPrefabId", "prefabId2", "fastPrefabId2"]:
                    prefab_id = as_int(act_row.get(field))
                    if prefab_id:
                        prefab_pairs.append((field, prefab_id))
            if not prefab_pairs:
                rows.append(
                    {
                        "side": actor["side"],
                        "waveNo": actor["waveNo"],
                        "ownerHeroDid": owner,
                        "ownerHeroId": actor.get("payloadHeroId"),
                        "skillType": skill.get("skillType"),
                        "skillDid": skill_id,
                        "skillActFound": bool(act_row),
                        "skillPassiveFound": bool(pas_row),
                        "skillHeroId": act_row.get("heroId", "") if act_row else "",
                        "scriptId": act_row.get("scriptId", "") if act_row else "",
                        "prefabField": "",
                        "prefabId": "",
                        "assetPathViaGetSysprefabData": "",
                        "timelineFound": False,
                        "skillBundle": "",
                        "skillBundleExists": False,
                        "prefabDeps": "",
                        "audioDeps": "",
                        "videoDeps": "",
                        "status": "missing_DTSkillAct_prefab_mapping" if not act_row else "DTSkillAct_has_no_prefabId_fields",
                        "evidence": "BattleResPreloadMgr:GetSkillPrefabAllRes uses LuaUtils.GetSysprefabData(prefabId).AssetPath -> BattleTimelineResMap[AssetPath]",
                    }
                )
                continue
            for prefab_field, prefab_id in prefab_pairs:
                sys_prefab = sys_prefabs.get(prefab_id, {})
                sys_asset_path = sys_prefab.get("assetPath", "")
                entries = [timeline_by_path[sys_asset_path]] if sys_asset_path in timeline_by_path else timeline_by_prefab.get(prefab_id, [])
                if not entries:
                    rows.append(
                        {
                            "side": actor["side"],
                            "waveNo": actor["waveNo"],
                            "ownerHeroDid": owner,
                            "ownerHeroId": actor.get("payloadHeroId"),
                            "skillType": skill.get("skillType"),
                            "skillDid": skill_id,
                            "skillActFound": True,
                            "skillPassiveFound": bool(pas_row),
                            "skillHeroId": act_row.get("heroId", ""),
                            "scriptId": act_row.get("scriptId", ""),
                            "prefabField": prefab_field,
                            "prefabId": prefab_id,
                            "assetPathViaGetSysprefabData": sys_asset_path,
                            "sysPrefabFound": bool(sys_prefab),
                            "sysPrefabName": sys_prefab.get("name", ""),
                            "timelineFound": False,
                            "skillBundle": "",
                            "skillBundleExists": False,
                            "prefabDeps": "",
                            "audioDeps": "",
                            "videoDeps": "",
                            "status": "DTSkillAct_prefab_missing_in_BattleTimelineResMap",
                            "evidence": "DTSkillAct prefabId present; DTSysPrefab direct decode checked; no BattleTimelineResMap entry was found for that AssetPath/prefab id",
                        }
                    )
                    continue
                for entry in entries:
                    asset_path = sys_asset_path or entry.get("assetPath", "")
                    bundle = skill_bundle_from_asset_path(asset_path)
                    rows.append(
                        {
                            "side": actor["side"],
                            "waveNo": actor["waveNo"],
                            "ownerHeroDid": owner,
                            "ownerHeroId": actor.get("payloadHeroId"),
                            "skillType": skill.get("skillType"),
                            "skillDid": skill_id,
                            "skillActFound": True,
                            "skillPassiveFound": bool(pas_row),
                            "skillHeroId": act_row.get("heroId", ""),
                            "scriptId": act_row.get("scriptId", ""),
                            "prefabField": prefab_field,
                            "prefabId": prefab_id,
                            "assetPathViaGetSysprefabData": asset_path,
                            "sysPrefabFound": bool(sys_prefab),
                            "sysPrefabName": sys_prefab.get("name", ""),
                            "timelineFound": True,
                            "timelineLine": entry.get("line", ""),
                            "skillBundle": bundle,
                            "skillBundleExists": bundle_exists(bundle, indexes["bundleByName"]) if bundle else False,
                            "prefabDeps": pipe(entry.get("prefab", [])),
                            "audioDeps": pipe(entry.get("audio", [])),
                            "videoDeps": pipe(entry.get("video", [])),
                            "status": "timeline_resolved",
                            "evidence": "DTSkillAct.prefabId -> DTSysPrefab direct decode/LuaUtils.GetSysprefabData(prefabId).AssetPath -> BattleTimelineResMap[AssetPath]",
                        }
                    )
    return rows


def summarize_gaps(
    actor_rows: list[dict[str, Any]],
    skill_rows: list[dict[str, Any]],
    manifest: dict[str, Any] | None,
    monster_table_names: list[str],
) -> dict[str, Any]:
    actor_gaps = [r for r in actor_rows if r["loadStatus"] != "loadable_spine_bundle"]
    skill_gaps = [r for r in skill_rows if r["status"] != "timeline_resolved"]
    manifest_actor_gaps: list[dict[str, Any]] = []
    manifest_skill_gaps: list[dict[str, Any]] = []
    if manifest:
        manifest_actor_by_id = {(a.get("side"), str(a.get("waveNo", "")), int(a.get("payloadHeroDid") or 0)): a for a in manifest.get("actors", [])}
        for row in actor_rows:
            old = manifest_actor_by_id.get((row["side"], str(row["waveNo"]), int(row["payloadHeroDid"])))
            if old and (not old.get("datatableFound") or not old.get("actorBundle")) and row.get("datatableFound"):
                manifest_actor_gaps.append(
                    {
                        "payloadHeroDid": row["payloadHeroDid"],
                        "side": row["side"],
                        "waveNo": row["waveNo"],
                        "previousManifestStatus": "missing_or_unresolved",
                        "newStatus": row["loadStatus"],
                        "resolvedTable": row["datatable"],
                        "prefabId": row["prefabId"],
                        "actorBundle": row["actorBundle"],
                    }
                )
        manifest_skills = manifest.get("skills", [])
        for row in skill_rows:
            old_matches = [
                s for s in manifest_skills
                if int(s.get("skillDid") or 0) == int(row["skillDid"])
                and str(s.get("ownerHeroDid", "")) == str(row["ownerHeroDid"])
            ]
            if old_matches and any(not s.get("timelineFound") for s in old_matches) and row["status"] == "timeline_resolved":
                manifest_skill_gaps.append(
                    {
                        "skillDid": row["skillDid"],
                        "ownerHeroDid": row["ownerHeroDid"],
                        "previousManifestStatus": "missing_or_unresolved",
                        "newStatus": "timeline_resolved",
                        "prefabId": row["prefabId"],
                        "assetPath": row["assetPathViaGetSysprefabData"],
                    }
                )
    return {
        "actors": {
            "total": len(actor_rows),
            "loadableSpineBundle": sum(1 for r in actor_rows if r["loadStatus"] == "loadable_spine_bundle"),
            "gaps": actor_gaps,
        },
        "skills": {
            "totalRows": len(skill_rows),
            "timelineResolvedRows": sum(1 for r in skill_rows if r["status"] == "timeline_resolved"),
            "gapRows": skill_gaps,
            "uniqueGapSkillDids": sorted({r["skillDid"] for r in skill_gaps}),
        },
        "currentManifestGapDelta": {
            "actorRowsImprovedByVariantMonsterTables": manifest_actor_gaps,
            "skillRowsImproved": manifest_skill_gaps,
        },
        "nextBlockers": [
            f"Only enemy 1100111 resolves to a loadable actor bundle through extracted DTMonster_* variant tables; enemy 1100112/1100113/1100121/1100122/1100123/1100131/1100132/1100133 remain missing in all decoded non-Attr DTMonster*Entity tables with modelID fields ({', '.join(monster_table_names)}).",
            "Our hero 1036 maps to battle prefab 1036, but download/roleprefabsandres/battleprefabandres/1036.assetbundle is not in the extracted assetbundle index even though skill bundle 1036 exists.",
            "skillType=2 ids 1036401/1036402/1034401/1034402/1012401/1012403/1001401/1001403 do not resolve through DTSkillAct timeline prefab mapping; several are passive-style rows and should not be used as active timeline prefab ids without additional battle Lua evidence.",
            "DTSysPrefab direct raw decode is now available through sys.assetbundle get_raw_data() -> gzip -> FlatBuffers. Remaining DTSysPrefab work is to wire more non-battle prefab categories if needed.",
        ],
    }


def write_markdown(roster: dict[str, Any], gaps: dict[str, Any]) -> None:
    actors = roster["actors"]
    skills = roster["skills"]
    lines = [
        "# GirlsWar Character Roster",
        "",
        "Generated from original datatable/Lua/AssetBundle evidence only. No fake character, card, or skill data is introduced.",
        "",
        "## Scope",
        f"- Payload: `{rel(PAYLOAD_JSON)}`",
        f"- Current manifest compared: `{rel(MANIFEST_JSON)}`",
        "- Actor rule: `heroDid -> DTHero/DTMonster_*Entity.modelID -> DTmodel.prefabId -> roleprefabsandres/battleprefabandres/<prefabId>.assetbundle`",
        "- Skill rule: `skillDid -> DTSkillAct.prefabId -> LuaUtils.GetSysprefabData(prefabId).AssetPath -> BattleTimelineResMap[AssetPath]`",
        "",
        "## Actor Summary",
        f"- Actors in payload: `{len(actors)}`",
        f"- Loadable Spine actor bundles: `{gaps['actors']['loadableSpineBundle']}` / `{gaps['actors']['total']}`",
        "",
        "| side | wave | heroDid | table | modelId | prefabId | bundleExists | loadStatus |",
        "| --- | --- | ---: | --- | ---: | ---: | --- | --- |",
    ]
    for row in actors:
        lines.append(
            f"| {row['side']} | {row['waveNo']} | {row['payloadHeroDid']} | {row['datatable']} | {row['modelId']} | {row['prefabId']} | {row['actorBundleExists']} | {row['loadStatus']} |"
        )
    lines.extend(
        [
            "",
            "## Skill Summary",
            f"- Skill rows including fast prefab variants: `{len(skills)}`",
            f"- Timeline-resolved rows: `{gaps['skills']['timelineResolvedRows']}` / `{gaps['skills']['totalRows']}`",
            f"- Unique gap skillDids: `{', '.join(str(x) for x in gaps['skills']['uniqueGapSkillDids'])}`",
            "",
            "| skillDid | owner | prefabField | prefabId | timeline | bundleExists | status |",
            "| ---: | ---: | --- | ---: | --- | --- | --- |",
        ]
    )
    for row in skills:
        timeline = row.get("assetPathViaGetSysprefabData", "")
        short_timeline = timeline.replace("Assets/Download/SkillPrefabsAndRes/", "SkillPrefabsAndRes/")
        lines.append(
            f"| {row['skillDid']} | {row['ownerHeroDid']} | {row['prefabField']} | {row['prefabId']} | {short_timeline} | {row['skillBundleExists']} | {row['status']} |"
        )
    lines.extend(
        [
            "",
            "## Evidence Files",
            f"- `HeroCtrl`: `{rel(b5.HERO_CTRL_FILE)}`",
            f"- `BattleResPreloadMgr`: `{rel(b5.BATTLE_RES_PRELOAD_FILE)}`",
            f"- `BattleTimelineResMap`: `{rel(b5.BATTLE_TIMELINE_RES_MAP_FILE)}`",
            f"- `DTSysPrefab` direct decode report: `{rel(OUT_SYSPREFAB_JSON)}`",
            "",
            "## Outputs",
            f"- JSON: `{rel(OUT_JSON)}`",
            f"- Actor CSV: `{rel(OUT_ACTORS_CSV)}`",
            f"- Skill CSV: `{rel(OUT_SKILLS_CSV)}`",
            f"- Gap JSON: `{rel(OUT_GAPS_JSON)}`",
            f"- Gap report: `{rel(OUT_GAPS_MD)}`",
            f"- DTSysPrefab report: `{rel(OUT_SYSPREFAB_MD)}`",
        ]
    )
    OUT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")

    gap_lines = [
        "# GirlsWar Character Gap Report",
        "",
        "## Current Manifest / Payload Gaps",
        f"- Actor gaps: `{len(gaps['actors']['gaps'])}` / `{gaps['actors']['total']}`",
        f"- Skill gap rows: `{len(gaps['skills']['gapRows'])}` / `{gaps['skills']['totalRows']}`",
        "",
        "## Actor Gaps",
        "| side | wave | heroDid | tableFound | modelId | prefabId | bundle | status |",
        "| --- | --- | ---: | --- | ---: | ---: | --- | --- |",
    ]
    for row in gaps["actors"]["gaps"]:
        gap_lines.append(
            f"| {row['side']} | {row['waveNo']} | {row['payloadHeroDid']} | {row['datatableFound']} | {row['modelId']} | {row['prefabId']} | {row['actorBundle']} | {row['loadStatus']} |"
        )
    gap_lines.extend(["", "## Skill Gaps", "| skillDid | owner | skillType | actFound | passiveFound | status |", "| ---: | ---: | ---: | --- | --- | --- |"])
    for row in gaps["skills"]["gapRows"]:
        gap_lines.append(
            f"| {row['skillDid']} | {row['ownerHeroDid']} | {row['skillType']} | {row['skillActFound']} | {row['skillPassiveFound']} | {row['status']} |"
        )
    gap_lines.extend(["", "## Improvements Over Current Manifest"])
    improved_actors = gaps["currentManifestGapDelta"]["actorRowsImprovedByVariantMonsterTables"]
    if improved_actors:
        gap_lines.append("- Variant monster tables resolve these previously missing manifest actors:")
        for row in improved_actors:
            gap_lines.append(f"  - `{row['payloadHeroDid']}` via `{row['resolvedTable']}` -> prefab `{row['prefabId']}` -> `{row['actorBundle']}`")
    else:
        gap_lines.append("- No additional actor rows improved over the current manifest.")
    improved_skills = gaps["currentManifestGapDelta"]["skillRowsImproved"]
    if improved_skills:
        gap_lines.append("- Additional skill rows resolved:")
        for row in improved_skills:
            gap_lines.append(f"  - `{row['skillDid']}` -> prefab `{row['prefabId']}` -> `{row['assetPath']}`")
    else:
        gap_lines.append("- No additional skill rows improved over the current manifest.")
    gap_lines.extend(["", "## Next Blockers"])
    for blocker in gaps["nextBlockers"]:
        gap_lines.append(f"- {blocker}")
    OUT_GAPS_MD.write_text("\n".join(gap_lines) + "\n", encoding="utf-8")


def main() -> None:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    info = load_payload()
    payload_actors = collect_payload_actors(info)
    textassets = b5.load_textasset_map()
    sys_prefabs, sys_prefab_evidence = decode_dtsys_prefab_table()

    hero_table = b5.load_table("hero", "DTHeroEntity", "DTHeroEntityTableData", textassets)
    model_table = b5.load_table("model", "DTmodelEntity", "DTmodelEntityTableData", textassets)
    monster_tables: dict[str, b5.TableData] = {}
    monster_table_discovery: list[dict[str, Any]] = []
    for table_data_name in sorted(n for n in textassets if n.startswith("DTMonster") and n.endswith("EntityTableData")):
        entity_name = table_data_name[: -len("TableData")]
        discovery = {"entity": entity_name, "tableData": table_data_name}
        if entity_name not in textassets:
            discovery["status"] = "skipped_missing_entity_textasset"
            monster_table_discovery.append(discovery)
            continue
        if "Attr" in entity_name:
            discovery["status"] = "skipped_attr_table"
            monster_table_discovery.append(discovery)
            continue
        table = b5.load_table(entity_name, entity_name, table_data_name, textassets)
        discovery["rows"] = len(table.rows)
        discovery["fields"] = table.fields
        if "modelID" not in table.fields:
            discovery["status"] = "skipped_no_modelID_field"
            monster_table_discovery.append(discovery)
            continue
        monster_tables[entity_name] = table
        discovery["status"] = "loaded_modelID_table"
        monster_table_discovery.append(discovery)
    skill_act = b5.load_table("skillact", "DTSkillActEntity", "DTSkillActEntityTableData", textassets)
    skill_pas = b5.load_table("skillpas", "DTSkillPasEntity", "DTSkillPasEntityTableData", textassets)
    timeline_by_prefab, timeline_by_path = b5.scan_timeline_entries()

    wanted_bundles: set[str] = set()
    for row in payload_actors:
        hero_did = as_int(row["payloadHeroDid"])
        if hero_did is None:
            continue
        if row["side"] == "our":
            source = hero_table.rows.get(hero_did)
        else:
            _table, source = find_monster_row(hero_did, monster_tables)
        model_id = as_int(source.get("modelID")) if source else None
        model_row = model_table.rows.get(model_id or -1)
        prefab_id = as_int(model_row.get("prefabId")) if model_row else None
        bundle = actor_bundle(prefab_id)
        if bundle:
            wanted_bundles.add(bundle)
    for entries in timeline_by_prefab.values():
        for entry in entries:
            b = skill_bundle_from_asset_path(entry.get("assetPath", ""))
            if b:
                wanted_bundles.add(b)
            for dep in entry.get("prefab", []):
                dep_bundle = skill_bundle_from_asset_path(dep)
                if dep_bundle:
                    wanted_bundles.add(dep_bundle)

    indexes = load_bundle_indexes(wanted_bundles)
    actor_rows = build_actor_rows(payload_actors, hero_table, model_table, monster_tables, indexes, sys_prefabs)
    skill_rows = build_skill_rows(payload_actors, skill_act, skill_pas, timeline_by_prefab, timeline_by_path, indexes, sys_prefabs)
    manifest = json.loads(MANIFEST_JSON.read_text(encoding="utf-8")) if MANIFEST_JSON.exists() else None
    gaps = summarize_gaps(actor_rows, skill_rows, manifest, list(monster_tables))

    battle_relevant_ids = sorted(
        {
            as_int(row.get("prefabId"))
            for row in actor_rows + skill_rows
            if as_int(row.get("prefabId")) is not None
        }
    )
    battle_relevant_sys_prefabs = [sys_prefabs[i] for i in battle_relevant_ids if i in sys_prefabs]
    sys_prefab_report = {
        **sys_prefab_evidence,
        "battleRelevantIds": battle_relevant_ids,
        "battleRelevantRowsFound": len(battle_relevant_sys_prefabs),
        "battleRelevantRowsMissing": [i for i in battle_relevant_ids if i not in sys_prefabs],
        "sampleBattleRelevantRows": battle_relevant_sys_prefabs[:40],
    }

    roster = {
        "name": "GirlsWar character roster for battle prototype",
        "generatedBy": rel(Path(__file__)),
        "workspace": str(BASE),
        "payloadPath": rel(PAYLOAD_JSON),
        "manifestCompared": rel(MANIFEST_JSON) if MANIFEST_JSON.exists() else "",
        "mapId": info.get("mapId"),
        "battleType": info.get("battleType"),
        "randomSeed": info.get("randomSeed"),
        "actors": actor_rows,
        "skills": skill_rows,
        "gaps": gaps,
        "datatableSources": {
            "hero": {"entity": rel(hero_table.entity_path), "tableData": rel(hero_table.table_path), "rows": len(hero_table.rows)},
            "model": {"entity": rel(model_table.entity_path), "tableData": rel(model_table.table_path), "rows": len(model_table.rows)},
            "skillAct": {"entity": rel(skill_act.entity_path), "tableData": rel(skill_act.table_path), "rows": len(skill_act.rows)},
            "skillPas": {"entity": rel(skill_pas.entity_path), "tableData": rel(skill_pas.table_path), "rows": len(skill_pas.rows)},
            "monsterTables": {
                name: {"entity": rel(table.entity_path), "tableData": rel(table.table_path), "rows": len(table.rows)}
                for name, table in monster_tables.items()
            },
            "monsterTableDiscovery": monster_table_discovery,
            "monsterSearchOrder": list(monster_tables),
            "sysPrefab": sys_prefab_evidence,
        },
        "evidencePrinciples": [
            "No fake character/card/skill data was generated.",
            "No name-only inference was used for actor or skill mapping.",
            "Original/evidence files were read only; no extracted source file was deleted or moved.",
        ],
    }

    actor_fields = [
        "side", "waveNo", "slot", "payloadHeroDid", "payloadHeroId", "datatable", "datatableFound", "modelId", "modelFound",
        "prefabId", "petPrefabId", "haloPrefabId", "battleZoom", "actorBundle", "actorBundleExists", "sysPrefabFound",
        "sysPrefabAssetPath", "sysPrefabName", "spineSkeletonData",
        "spineAtlas", "spineTexture", "materialPathId", "gameObjectPathId", "gameObjectName", "loadStatus", "skillDidList", "nameKey", "evidence",
    ]
    skill_fields = [
        "side", "waveNo", "ownerHeroDid", "ownerHeroId", "skillType", "skillDid", "skillActFound", "skillPassiveFound",
        "skillHeroId", "scriptId", "prefabField", "prefabId", "assetPathViaGetSysprefabData", "sysPrefabFound", "sysPrefabName", "timelineFound", "timelineLine",
        "skillBundle", "skillBundleExists", "prefabDeps", "audioDeps", "videoDeps", "status", "evidence",
    ]
    write_json(OUT_JSON, roster)
    write_json(OUT_GAPS_JSON, gaps)
    write_json(OUT_SYSPREFAB_JSON, sys_prefab_report)
    write_csv(OUT_ACTORS_CSV, actor_rows, actor_fields)
    write_csv(OUT_SKILLS_CSV, skill_rows, skill_fields)
    write_csv(
        OUT_SYSPREFAB_CSV,
        battle_relevant_sys_prefabs,
        ["id", "desc", "name", "assetCategory", "assetPath", "poolId", "useTableData", "cullDespawned", "cullAbove", "cullDelay", "cullMaxPerPass"],
    )
    OUT_SYSPREFAB_MD.write_text(
        "\n".join(
            [
                "# DTSysPrefab Direct Decode Report",
                "",
                f"- Status: `{sys_prefab_evidence['status']}`",
                f"- Bundle: `{sys_prefab_evidence['bundle']}`",
                f"- TextAsset pathID: `{sys_prefab_evidence['textAssetPathId']}`",
                f"- Raw serialized object bytes: `{sys_prefab_evidence['rawObjectBytes']}`",
                f"- Gzip stream offset: `{sys_prefab_evidence['gzipStartOffsetInSerializedTextAsset']}`",
                f"- Decompressed FlatBuffer bytes: `{sys_prefab_evidence['decompressedBytes']}`",
                f"- Decoded rows: `{sys_prefab_evidence['rowCount']}`",
                f"- Battle relevant ids: `{len(battle_relevant_ids)}`; found `{len(battle_relevant_sys_prefabs)}`",
                "",
                "## Note",
                sys_prefab_evidence["lossyExtractedTxtNote"],
                "",
                "## Outputs",
                f"- JSON: `{rel(OUT_SYSPREFAB_JSON)}`",
                f"- Battle relevant CSV: `{rel(OUT_SYSPREFAB_CSV)}`",
            ]
        )
        + "\n",
        encoding="utf-8",
    )
    write_markdown(roster, gaps)

    print(f"Wrote {OUT_JSON}")
    print(f"Wrote {OUT_ACTORS_CSV}")
    print(f"Wrote {OUT_SKILLS_CSV}")
    print(f"Wrote {OUT_GAPS_JSON}")
    print(f"Wrote {OUT_SYSPREFAB_JSON}")
    print(f"Wrote {OUT_SYSPREFAB_CSV}")
    print(f"Wrote {OUT_SYSPREFAB_MD}")
    print(f"Wrote {OUT_MD}")
    print(f"Wrote {OUT_GAPS_MD}")
    print(json.dumps({
        "actorLoadable": f"{gaps['actors']['loadableSpineBundle']}/{gaps['actors']['total']}",
        "skillTimelineResolved": f"{gaps['skills']['timelineResolvedRows']}/{gaps['skills']['totalRows']}",
        "uniqueGapSkillDids": gaps["skills"]["uniqueGapSkillDids"],
    }, ensure_ascii=False, indent=2))


if __name__ == "__main__":
    main()
