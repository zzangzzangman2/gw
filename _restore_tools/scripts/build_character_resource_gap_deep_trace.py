from __future__ import annotations

import csv
import json
import sys
from pathlib import Path
from typing import Any


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
MERGED = BASE / "girlswar_merged_extracted"
INDEX_DIR = MERGED / "indexes"
REPORT_DIR = BASE / "reports" / "characters"
BATTLE_REPORT_DIR = BASE / "reports" / "battle"

ASSETBUNDLES_CSV = INDEX_DIR / "assetbundles.csv"
VERSIONFILE_CSV = INDEX_DIR / "versionfile_VersionFile_bytes.csv"
CDN_VERSIONFILE_CSV = INDEX_DIR / "versionfile_CDNVersionFile_bytes.csv"
PAYLOAD_JSON = BATTLE_REPORT_DIR / "BATTLE_TEST_PAYLOAD.json"

OUT_JSON = REPORT_DIR / "CHARACTER_RESOURCE_GAP_DEEP_TRACE.json"
OUT_MD = REPORT_DIR / "CHARACTER_RESOURCE_GAP_DEEP_TRACE.md"
OUT_RESOURCE_CSV = REPORT_DIR / "CHARACTER_RESOURCE_GAP_DEEP_TRACE_1036_RESOURCE.csv"
OUT_ENEMY_CSV = REPORT_DIR / "CHARACTER_RESOURCE_GAP_DEEP_TRACE_ENEMY_ALIAS.csv"

PROCEDURE_NORMAL_BATTLE = (
    MERGED
    / "decoded"
    / "xlua_battle"
    / "download_xlualogic_modules_procedure"
    / "-3424355311143813575_ProcedureNormalBattle_security_xor_raw.lua"
)
CAMP_AIN_BB_DATA = (
    MERGED
    / "decoded"
    / "xlua_battle"
    / "download_xlualogic_modules_battle"
    / "7184371722040177329_CampainBBData_security_xor_raw.lua"
)
BATTLE_BEFORE_DATA_UTIL = (
    MERGED
    / "decoded"
    / "xlua_battle"
    / "download_xlualogic_modules_battle"
    / "2075196316440867225_BattleBeforeDataUtil_security_xor_raw.lua"
)
HERO_CTRL = (
    MERGED
    / "decoded"
    / "xlua_battle"
    / "download_xlualogic_modules_battle"
    / "-2133702496468653963_HeroCtrl_security_xor_raw.lua"
)

sys.path.insert(0, str(BASE / "_restore_tools" / "scripts"))
import build_battle_prototype_manifest as b5  # noqa: E402


def rel(path: str | Path | None) -> str:
    if not path:
        return ""
    p = Path(path)
    try:
        return str(p.relative_to(BASE)).replace("\\", "/")
    except Exception:
        return str(path).replace("\\", "/")


def norm(value: Any) -> str:
    return str(value or "").replace("\\", "/").lower()


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_json(path: Path, data: Any) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")


def write_csv(path: Path, rows: list[dict[str, Any]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames, extrasaction="ignore")
        writer.writeheader()
        writer.writerows(rows)


def line_hits(path: Path, needles: list[str]) -> list[dict[str, Any]]:
    if not path.exists():
        return []
    out: list[dict[str, Any]] = []
    lines = path.read_text(encoding="utf-8", errors="replace").splitlines()
    for idx, line in enumerate(lines, start=1):
        if all(needle in line for needle in needles):
            out.append({"file": rel(path), "line": idx, "text": line[:240]})
    return out


def version_rows_for(asset: str) -> list[dict[str, Any]]:
    rows: list[dict[str, Any]] = []
    target = norm(asset)
    for source, path in [("VersionFile", VERSIONFILE_CSV), ("CDNVersionFile", CDN_VERSIONFILE_CSV)]:
        for row in read_csv(path):
            if norm(row.get("AssetBundleName")) == target:
                rows.append({"source": source, **row})
    return rows


def assetbundle_rows_for(asset: str) -> list[dict[str, Any]]:
    target = norm(asset)
    return [row for row in read_csv(ASSETBUNDLES_CSV) if norm(row.get("bundle")) == target]


def local_file_candidates(asset: str) -> list[dict[str, Any]]:
    relative = Path(*asset.split("/"))
    candidates = [
        MERGED / "merged_content" / "AssetBundles" / relative,
        MERGED / "extracted" / "unity" / "clean_unityfs_slices" / relative,
    ]
    out: list[dict[str, Any]] = []
    for path in candidates:
        out.append(
            {
                "path": rel(path),
                "exists": path.exists(),
                "size": path.stat().st_size if path.exists() else "",
            }
        )
    exact_name = relative.name.lower()
    found: list[Path] = []
    for root in [MERGED / "merged_content" / "AssetBundles", MERGED / "extracted" / "unity" / "clean_unityfs_slices"]:
        if root.exists():
            found.extend(p for p in root.rglob(relative.name) if p.is_file() and p.name.lower() == exact_name)
    for path in sorted(set(found)):
        out.append(
            {
                "path": rel(path),
                "exists": True,
                "size": path.stat().st_size,
                "note": "same filename candidate",
            }
        )
    return out


def payload_enemy_ids(info: dict[str, Any]) -> list[dict[str, Any]]:
    out: list[dict[str, Any]] = []
    for wave in info.get("waveData", []):
        wave_no = wave.get("waveNo")
        formation = {x.get("heroDid"): x for x in wave.get("enemyTeamFormation", [])}
        for hero in wave.get("enemyHeros", []):
            hero_did = hero.get("heroDid")
            out.append(
                {
                    "waveNo": wave_no,
                    "position": formation.get(hero_did, {}).get("position", ""),
                    "payloadHeroDid": hero_did,
                    "payloadHeroId": hero.get("heroId"),
                    "skillDids": [x.get("skillDid") for x in hero.get("skills", []) if x.get("skillDid")],
                }
            )
    return out


def flatten_numbers(value: Any) -> list[int]:
    if isinstance(value, int):
        return [value]
    if isinstance(value, list):
        out: list[int] = []
        for item in value:
            out.extend(flatten_numbers(item))
        return out
    return []


def load_table_if_present(textassets: dict[str, Any], entity: str) -> b5.TableData | None:
    table_data = f"{entity}TableData"
    if entity in textassets and table_data in textassets:
        return b5.load_table(entity, entity, table_data, textassets)
    return None


def monster_table_trace(textassets: dict[str, Any], ids: list[int]) -> tuple[dict[int, list[dict[str, Any]]], dict[str, b5.TableData]]:
    tables: dict[str, b5.TableData] = {}
    for entity in sorted(n for n in textassets if n.startswith("DTMonster") and n.endswith("Entity") and "Attr" not in n):
        table = load_table_if_present(textassets, entity)
        if table and "modelID" in table.fields:
            tables[entity] = table

    hits: dict[int, list[dict[str, Any]]] = {i: [] for i in ids}
    for monster_id in ids:
        for name, table in tables.items():
            row = table.rows.get(monster_id)
            if row:
                hits[monster_id].append(
                    {
                        "table": name,
                        "modelID": row.get("modelID", ""),
                        "monName": row.get("monName", ""),
                        "skills": [row.get("monSkill1"), row.get("monSkill2"), row.get("monSkill3"), row.get("monSkill4")],
                        "passiveSkills": row.get("monSkillPas", []),
                    }
                )
    return hits, tables


def map_wave_trace(textassets: dict[str, Any], map_id: int) -> list[dict[str, Any]]:
    out: list[dict[str, Any]] = []
    for entity in ["DTMapsWaveEntity", "DTMapsWave_FEntity", "DTMapsWave_GEntity", "DTMapsWave_HEntity", "DTMapsWave_KEntity"]:
        table = load_table_if_present(textassets, entity)
        if not table:
            continue
        for row_id, row in sorted(table.rows.items()):
            if row.get("mapId") == map_id:
                out.append(
                    {
                        "table": entity,
                        "rowId": row_id,
                        "wave": row.get("wave"),
                        "monsterLists": row.get("monsterLists", []),
                        "newMonsterLists": row.get("newMonsterLists", []),
                        "monsterEffect": row.get("monsterEffect", []),
                        "name": row.get("Name", ""),
                        "icon": row.get("Icon", ""),
                        "level": row.get("level", ""),
                    }
                )
    return out


def build_report() -> dict[str, Any]:
    payload = json.loads(PAYLOAD_JSON.read_text(encoding="utf-8"))
    info = payload.get("battleInfo", payload)
    map_id = int(info.get("mapId") or 0)
    payload_enemies = payload_enemy_ids(info)
    payload_enemy_ids_only = [int(x["payloadHeroDid"]) for x in payload_enemies]

    desired_1036 = "download/roleprefabsandres/battleprefabandres/1036.assetbundle"
    version_rows = version_rows_for(desired_1036)
    index_rows = assetbundle_rows_for(desired_1036)
    file_candidates = local_file_candidates(desired_1036)
    exact_files = [x for x in file_candidates if norm(x["path"]).endswith(norm(desired_1036))]
    same_name_files = [x for x in file_candidates if x.get("note") == "same filename candidate"]
    resource_status = (
        "present_in_versionfile_but_not_extracted"
        if version_rows and not index_rows and not any(x.get("exists") for x in exact_files)
        else "still_unresolved"
    )

    textassets = b5.load_textasset_map()
    direct_monster_hits, monster_tables = monster_table_trace(textassets, payload_enemy_ids_only)
    map_waves = map_wave_trace(textassets, map_id)
    stage_candidate_ids = sorted({n for row in map_waves for n in flatten_numbers(row.get("monsterLists", [])) + flatten_numbers(row.get("newMonsterLists", [])) if n > 0})
    stage_candidate_hits, _ = monster_table_trace(textassets, stage_candidate_ids)

    enemy_rows: list[dict[str, Any]] = []
    for enemy in payload_enemies:
        hero_did = int(enemy["payloadHeroDid"])
        direct_hits = direct_monster_hits.get(hero_did, [])
        formula_like = str(hero_did) == f"{map_id}{enemy['waveNo']}{enemy['position']}"
        if direct_hits:
            status = "direct_monster_row_resolved"
        elif formula_like:
            status = "still_unresolved_payload_instance_id"
        else:
            status = "still_unresolved"
        enemy_rows.append(
            {
                **enemy,
                "formulaLikeMapWaveSlot": formula_like,
                "directMonsterTables": ", ".join(x["table"] for x in direct_hits),
                "directModelIDs": ", ".join(str(x["modelID"]) for x in direct_hits),
                "status": status,
                "note": "No code evidence found that aliases this payload heroDid to DTMapsWave.monsterLists; normal campaign generator uses monsterLists value directly as heroDid.",
            }
        )

    evidence = {
        "embeddedFightPlayPayload": line_hits(PROCEDURE_NORMAL_BATTLE, ["local t='", "battleInfo"]),
        "embeddedPayloadDecode": line_hits(PROCEDURE_NORMAL_BATTLE, ["JsonUtil.decode(t).battleInfo"]),
        "campaignUsesMapsWave": line_hits(CAMP_AIN_BB_DATA, ["c.GetMapsWave"]),
        "campaignPassesMonsterLists": line_hits(CAMP_AIN_BB_DATA, ["GetFormationFromMonsterList"]),
        "formationUsesMonsterListAsHeroDid": line_hits(BATTLE_BEFORE_DATA_UTIL, ["heroDid=a"]),
        "heroCtrlMonsterLookupByHeroDid": line_hits(HERO_CTRL, ["self.DTMonsterRow=t.GetEntity(self.heroDid)"]),
    }

    return {
        "name": "GirlsWar character resource gap deep trace",
        "generatedBy": rel(Path(__file__)),
        "payload": {
            "path": rel(PAYLOAD_JSON),
            "mapId": map_id,
            "battleType": info.get("battleType"),
            "waveCount": len(info.get("waveData", [])),
        },
        "hero1036ActorBundle": {
            "desiredBundle": desired_1036,
            "classification": resource_status,
            "versionfileRows": version_rows,
            "assetbundleIndexRows": index_rows,
            "localFileCandidates": file_candidates,
            "sameFilenameButDifferentCategory": same_name_files,
            "conclusion": "CDNVersionFile lists the exact battle actor bundle, but no exact merged_content file, clean_unityfs_slice, or assetbundles.csv row exists in this local extraction.",
        },
        "enemyPayloadAliasTrace": {
            "classification": "still_unresolved",
            "payloadEnemyRows": enemy_rows,
            "mapWaveRowsForMapId": map_waves,
            "stageCandidateMonsterIds": stage_candidate_ids,
            "stageCandidateMonsterHits": stage_candidate_hits,
            "monsterTablesSearched": sorted(monster_tables),
            "conclusion": "Payload enemy ids after 1100111 look like mapId+wave+slot instance ids, but normal campaign generation and HeroCtrl lookup use monsterLists/heroDid directly. No authoritative alias from these payload ids to DTMapsWave monster ids was found.",
        },
        "evidence": evidence,
        "principles": [
            "No fake character/card/skill data was generated.",
            "No name-only inference was used.",
            "Unity scenes and source evidence files were not modified.",
        ],
    }


def write_reports(report: dict[str, Any]) -> None:
    write_json(OUT_JSON, report)

    resource_rows: list[dict[str, Any]] = []
    for row in report["hero1036ActorBundle"]["versionfileRows"]:
        resource_rows.append({"kind": "versionfile", "classification": report["hero1036ActorBundle"]["classification"], **row})
    for row in report["hero1036ActorBundle"]["assetbundleIndexRows"]:
        resource_rows.append({"kind": "assetbundle_index", "classification": report["hero1036ActorBundle"]["classification"], **row})
    for row in report["hero1036ActorBundle"]["localFileCandidates"]:
        resource_rows.append(
            {
                "kind": "local_file",
                "classification": report["hero1036ActorBundle"]["classification"],
                "path": row.get("path", ""),
                "exists": row.get("exists", ""),
                "localFileSize": row.get("size", ""),
                "note": row.get("note", ""),
            }
        )
    write_csv(
        OUT_RESOURCE_CSV,
        resource_rows,
        ["kind", "classification", "source", "index", "AssetBundleName", "MD5", "Size", "IsFirstData", "IsEncrypt", "Priority", "Category", "Version", "ResOffset", "bundle", "status", "path", "exists", "localFileSize", "note"],
    )

    write_csv(
        OUT_ENEMY_CSV,
        report["enemyPayloadAliasTrace"]["payloadEnemyRows"],
        ["waveNo", "position", "payloadHeroDid", "payloadHeroId", "skillDids", "formulaLikeMapWaveSlot", "directMonsterTables", "directModelIDs", "status", "note"],
    )

    lines = [
        "# Character Resource Gap Deep Trace",
        "",
        "Generated from local datatable/Lua/AssetBundle/versionfile evidence only. No fake mappings were introduced.",
        "",
        "## 1036 Actor Bundle",
        f"- Classification: `{report['hero1036ActorBundle']['classification']}`",
        f"- Desired bundle: `{report['hero1036ActorBundle']['desiredBundle']}`",
        f"- Versionfile exact rows: `{len(report['hero1036ActorBundle']['versionfileRows'])}`",
        f"- Extracted assetbundle index exact rows: `{len(report['hero1036ActorBundle']['assetbundleIndexRows'])}`",
        f"- Exact local files: `{sum(1 for x in report['hero1036ActorBundle']['localFileCandidates'] if x.get('exists') and x['path'].lower().endswith(report['hero1036ActorBundle']['desiredBundle']))}`",
        "",
        "Conclusion: " + report["hero1036ActorBundle"]["conclusion"],
        "",
        "## Enemy Payload Alias",
        f"- Classification: `{report['enemyPayloadAliasTrace']['classification']}`",
        f"- Payload enemy rows: `{len(report['enemyPayloadAliasTrace']['payloadEnemyRows'])}`",
        f"- DTMapsWave rows for mapId `{report['payload']['mapId']}`: `{len(report['enemyPayloadAliasTrace']['mapWaveRowsForMapId'])}`",
        f"- Stage candidate monster ids: `{', '.join(str(x) for x in report['enemyPayloadAliasTrace']['stageCandidateMonsterIds'])}`",
        "",
        "Conclusion: " + report["enemyPayloadAliasTrace"]["conclusion"],
        "",
        "| wave | pos | payloadHeroDid | formulaLike | directTables | status |",
        "| ---: | ---: | ---: | --- | --- | --- |",
    ]
    for row in report["enemyPayloadAliasTrace"]["payloadEnemyRows"]:
        lines.append(
            f"| {row['waveNo']} | {row['position']} | {row['payloadHeroDid']} | {row['formulaLikeMapWaveSlot']} | {row['directMonsterTables']} | {row['status']} |"
        )
    lines.extend(
        [
            "",
            "## Stage Wave Rows",
            "| table | rowId | wave | monsterLists | newMonsterLists | name |",
            "| --- | ---: | ---: | --- | --- | --- |",
        ]
    )
    for row in report["enemyPayloadAliasTrace"]["mapWaveRowsForMapId"]:
        lines.append(
            f"| {row['table']} | {row['rowId']} | {row['wave']} | {row['monsterLists']} | {row['newMonsterLists']} | {row['name']} |"
        )
    lines.extend(
        [
            "",
            "## Evidence",
            f"- Embedded FightPlay payload/decode: `{rel(PROCEDURE_NORMAL_BATTLE)}`",
            f"- Normal campaign maps wave flow: `{rel(CAMP_AIN_BB_DATA)}`",
            f"- Monster-list formation builder: `{rel(BATTLE_BEFORE_DATA_UTIL)}`",
            f"- HeroCtrl monster lookup: `{rel(HERO_CTRL)}`",
            "",
            "## Outputs",
            f"- JSON: `{rel(OUT_JSON)}`",
            f"- 1036 resource CSV: `{rel(OUT_RESOURCE_CSV)}`",
            f"- enemy alias CSV: `{rel(OUT_ENEMY_CSV)}`",
        ]
    )
    OUT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> None:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    report = build_report()
    write_reports(report)
    print(f"Wrote {OUT_JSON}")
    print(f"Wrote {OUT_MD}")
    print(f"Wrote {OUT_RESOURCE_CSV}")
    print(f"Wrote {OUT_ENEMY_CSV}")
    print(
        json.dumps(
            {
                "hero1036": report["hero1036ActorBundle"]["classification"],
                "enemyAlias": report["enemyPayloadAliasTrace"]["classification"],
                "stageCandidateMonsterIds": report["enemyPayloadAliasTrace"]["stageCandidateMonsterIds"],
            },
            ensure_ascii=False,
            indent=2,
        )
    )


if __name__ == "__main__":
    main()
