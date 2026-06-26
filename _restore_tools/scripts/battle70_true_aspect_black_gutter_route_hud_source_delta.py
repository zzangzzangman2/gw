from __future__ import annotations

import csv
import json
import re
from datetime import datetime
from pathlib import Path


PREFIX = "BATTLE_70_TRUE_ASPECT_BLACK_GUTTER_ROUTE_HUD_SOURCE_DELTA_NO_PATCH"


def read_json(path: Path, default=None):
    if not path.exists():
        return default
    return json.loads(path.read_text(encoding="utf-8-sig"))


def read_csv(path: Path):
    if not path.exists():
        return []
    with path.open("r", encoding="utf-8-sig", newline="") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows, fieldnames):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames, extrasaction="ignore")
        writer.writeheader()
        for row in rows:
            writer.writerow(row)


def count_root_cmds(root: Path):
    root_cmd = len(list(root.glob("*.cmd")))
    direct_restore_cmd = len(list((root / "_restore_tools").glob("*.cmd"))) if (root / "_restore_tools").exists() else 0
    return {
        "rootCmdCount": root_cmd,
        "restoreToolsDirectCmdCount": direct_restore_cmd,
        "policyOk": root_cmd == 1 and direct_restore_cmd == 0,
    }


def line_hits(path: Path, needles):
    if not path.exists():
        return []
    rows = []
    lines = path.read_text(encoding="utf-8-sig", errors="ignore").splitlines()
    for idx, line in enumerate(lines, 1):
        if any(n in line for n in needles):
            rows.append({"line": idx, "text": line.strip()})
    return rows


def first_line(path: Path, needle: str):
    hits = line_hits(path, [needle])
    if not hits:
        return ""
    return str(hits[0]["line"])


def parse_map_layers(editor_path: Path):
    if not editor_path.exists():
        return []
    text = editor_path.read_text(encoding="utf-8-sig", errors="ignore")
    pattern = re.compile(
        r'CreateMapLayerPixel\(root,\s*"(?P<name>[^"]+)",\s*"(?P<role>[^"]+)",\s*"(?P<asset>[^"]+)",\s*(?P<x>[-\d.]+)f,\s*(?P<y>[-\d.]+)f,\s*(?P<order>\d+)\)'
    )
    rows = []
    line_map = {}
    for idx, line in enumerate(text.splitlines(), 1):
        if "CreateMapLayerPixel(root" in line:
            line_map[line.strip()] = idx
    for match in pattern.finditer(text):
        text_line = match.group(0)
        line = ""
        for raw, raw_line in line_map.items():
            if match.group("name") in raw:
                line = str(raw_line)
                break
        rows.append(
            {
                "sourceFile": str(editor_path),
                "sourceLine": line,
                "gameObjectOrPath": match.group("name"),
                "component": "SpriteRenderer/Transform",
                "property": "pixelX/pixelY/sortingOrder/sourceTexture",
                "currentValue": f"x={match.group('x')}; y={match.group('y')}; sortingOrder={match.group('order')}",
                "sourceEvidence": f"{match.group('role')}; {match.group('asset')}",
                "observedDelta": "map layer authored through 1920x1080 pixel-space builder, then rendered in 1920x855 true-aspect capture",
                "inferredCause": "map/world reprojection may still be 16:9-authored while BATTLE68 only changed RenderTexture aspect",
                "classification": "safe_source_backed_patch_candidate",
                "proposedExactChange": "candidate-only: recompute these Map_11003 layer Transform positions from the same source pixel rows for the true reference-aspect capture context; do not stretch screenshots",
                "verification": "rerun BATTLE68 true-aspect capture and BATTLE69 black-gutter matrix; require side gutter near reference before any layout claim",
            }
        )
    return rows


def route_focus_rows(source_join_rows):
    focus_tokens = [
        "root_battle/root_top",
        "root_battle/root_top/TopCenter",
        "root_opra",
        "btnAuto",
        "btnTwoSpeed",
        "btnFastSkill",
        "btnSkip",
        "btnPause",
        "btnhelp",
        "btnBuff",
    ]
    kept = []
    for row in source_join_rows:
        path = row.get("path", "")
        if any(token in path for token in focus_tokens):
            kept.append(row)
    return kept


def add_route_row(rows, source_row, classification, source_evidence, runtime_control, proposed):
    rows.append(
        {
            "routePath": source_row.get("path", ""),
            "sourceTable": source_row.get("sourceTable", ""),
            "activeSelf": source_row.get("activeSelf", ""),
            "activeInHierarchy": source_row.get("activeInHierarchy", ""),
            "siblingIndex": source_row.get("siblingIndex", ""),
            "siblingCount": source_row.get("siblingCount", ""),
            "anchoredPosition": source_row.get("anchoredPosition", ""),
            "localScale": source_row.get("localScale", ""),
            "sizeDelta": source_row.get("sizeDelta", ""),
            "anchorMin": source_row.get("anchorMin", ""),
            "anchorMax": source_row.get("anchorMax", ""),
            "sourceEvidence": source_evidence,
            "runtimeControlEvidence": runtime_control,
            "classification": classification,
            "proposedExactChange": proposed,
        }
    )


def main():
    root = Path(__file__).resolve().parents[2]
    reports = root / "reports" / "battle"
    scripts = root / "girlswar_battle_unity" / "Assets" / "Editor"

    b69_json = read_json(reports / "BATTLE_69_TRUE_ASPECT_CAPTURE_ROUTE_HUD_CARD_ACTOR_NORMALIZED_VALIDATION_NO_PATCH_RESULT.json", {})
    b69_gutter_rows = read_csv(reports / "BATTLE_69_TRUE_ASPECT_CAPTURE_ROUTE_HUD_CARD_ACTOR_NORMALIZED_VALIDATION_NO_PATCH_TRUE_CAPTURE_IMAGE_REGION_AND_BLACK_GUTTER_MATRIX.csv")
    b69_layout_rows = read_csv(reports / "BATTLE_69_TRUE_ASPECT_CAPTURE_ROUTE_HUD_CARD_ACTOR_NORMALIZED_VALIDATION_NO_PATCH_REFERENCE_VS_TRUE_CAPTURE_NORMALIZED_LAYOUT_MATRIX.csv")
    b69_source_rows = read_csv(reports / "BATTLE_69_TRUE_ASPECT_CAPTURE_ROUTE_HUD_CARD_ACTOR_NORMALIZED_VALIDATION_NO_PATCH_SOURCE_ROUTE_CARD_ACTOR_TMP_MASK_EVIDENCE_JOIN_MATRIX.csv")
    b68_unity = read_json(root / "girlswar_battle_unity" / "Assets" / "RestoreData" / "battle" / "BATTLE_68_TRUE_REFERENCE_ASPECT_CAPTURE_PIPELINE_AND_VIEWRECT_SOURCE_TRACE_NO_SCENE_SAVE_UNITY.json", {})

    b68_editor = scripts / "Battle68TrueReferenceAspectCaptureNoSceneSaveEditor.cs"
    b27_editor = scripts / "BattleCorrectMapSceneHudPreviewClip05Editor.cs"
    b39_editor = scripts / "Battle39AttachRuntimeActorsToMap11003HudContextWithEvidenceEditor.cs"
    b57_editor = scripts / "Battle57RehydrateSourceBackedAssetBundleActorsEditor.cs"
    lua_normal_battle = reports / "BATTLE_50_DECODED_MAINCITY_LUA" / "874003978109174219_UI_NormalBattle.lua"
    b26_md = reports / "BATTLE_26_MAP_VIDEO_MATCH_RUNTIME_SCENE_EVIDENCE_RESULT.md"

    camera_rows = []
    camera_rows.append(
        {
            "sourceFile": str(reports / "BATTLE_69_TRUE_ASPECT_CAPTURE_ROUTE_HUD_CARD_ACTOR_NORMALIZED_VALIDATION_NO_PATCH_RESULT.json"),
            "sourceLine": "",
            "gameObjectOrPath": "BATTLE69 true capture image analysis",
            "component": "image-analysis",
            "property": "black side gutter",
            "currentValue": f"left={b69_json.get('blackGutter', {}).get('leftGutterPx')}; right={b69_json.get('blackGutter', {}).get('rightGutterPx')}; totalRatio={b69_json.get('blackGutter', {}).get('totalGutterRatio')}",
            "sourceEvidence": "true aspect capture, not BATTLE67 analysis crop",
            "observedDelta": "reference frames at same aspect have only about 0.625% total side gutter; candidate has 11.8229%",
            "inferredCause": "render/map framing delta exists after aspect-correct capture",
            "classification": "analysis_only",
            "proposedExactChange": "",
            "verification": "use BATTLE68 no-scene-save capture path for later patch validation",
        }
    )
    camera_rows.append(
        {
            "sourceFile": str(b68_editor),
            "sourceLine": first_line(b68_editor, "CaptureHeight = 855"),
            "gameObjectOrPath": b68_unity.get("cameraName", "BattleHudSpriteAtlasTextureRuntimeBindingClip05Camera"),
            "component": "Camera/RenderTexture capture",
            "property": "targetTexture capture size and camera state",
            "currentValue": f"capture={b68_unity.get('captureWidth')}x{b68_unity.get('captureHeight')}; aspect={b68_unity.get('captureAspect')}; pixelRectBefore={b68_unity.get('cameraPixelRectBefore')}; orthographicSize={b68_unity.get('cameraOrthographicSize')}",
            "sourceEvidence": "BATTLE68 creates 1920x855 RenderTexture and calls camera.Render without scene save",
            "observedDelta": "true output aspect is solved, but camera pixelRect remains 640x480 and scene content remains inherited from BATTLE57/B27 setup",
            "inferredCause": "capture path changed output aspect only; it did not re-author map layer placement or camera composition",
            "classification": "analysis_only",
            "proposedExactChange": "none in BATTLE70",
            "verification": "later candidate patch must preserve sceneDirty=false for capture-only validation",
        }
    )
    camera_rows.append(
        {
            "sourceFile": str(b27_editor),
            "sourceLine": first_line(b27_editor, "CaptureHeight = 1080"),
            "gameObjectOrPath": "BattleCorrectMapSceneHudPreviewClip05Root",
            "component": "map builder constants",
            "property": "CaptureWidth/CaptureHeight",
            "currentValue": "1920x1080",
            "sourceEvidence": "BATTLE27/BattleCorrectMapSceneHudPreviewClip05Editor builds map/HUD preview in 16:9 pixel-space",
            "observedDelta": "BATTLE68 renders the same candidate context at 1920x855",
            "inferredCause": "16:9-authored map world positions can leave asymmetric gutters when rendered at 2.2456:1",
            "classification": "safe_source_backed_patch_candidate",
            "proposedExactChange": "candidate-only: create true-aspect map-framing builder/reprojection from the same Map_11003 source rows; do not modify this no-patch task",
            "verification": "rerun BATTLE68 true capture and compare black-gutter matrix against reference side-gutter ratio",
        }
    )
    camera_rows.append(
        {
            "sourceFile": str(b27_editor),
            "sourceLine": first_line(b27_editor, "pixelsPerWorldUnit = CaptureHeight"),
            "gameObjectOrPath": "CreateMapLayerPixel",
            "component": "pixel-to-world projection",
            "property": "pixelsPerWorldUnit/worldX/worldY",
            "currentValue": "pixelsPerWorldUnit = CaptureHeight / (5f * 2f); world positions use CaptureWidth/CaptureHeight",
            "sourceEvidence": "map layer transforms are derived from capture dimensions rather than original runtime camera metadata",
            "observedDelta": "the same world transforms are later captured with a different output height",
            "inferredCause": "projection formula is the exact source delta to test before changing route/HUD coordinates",
            "classification": "safe_source_backed_patch_candidate",
            "proposedExactChange": "candidate-only: recompute Map_11003 transform positions for 1920x855 or source-backed reference view rect and validate; no screenshot stretch",
            "verification": "black gutter left/right must converge toward reference without hiding HUD/card/actors",
        }
    )
    camera_rows.extend(parse_map_layers(b27_editor))
    camera_rows.append(
        {
            "sourceFile": str(b39_editor),
            "sourceLine": first_line(b39_editor, "CaptureWidth = 1920"),
            "gameObjectOrPath": "BATTLE39 actor/map/HUD context",
            "component": "capture/context builder",
            "property": "capture dimensions and actor placement caveat",
            "currentValue": "1920x1080",
            "sourceEvidence": "BATTLE39 carried map/hud context forward and warned formation/camera placement was not original runtime verified",
            "observedDelta": "BATTLE57/BATTLE68 inherit this candidate context for actors",
            "inferredCause": "actor visibility can be true while map framing still remains candidate-only",
            "classification": "analysis_only",
            "proposedExactChange": "",
            "verification": "keep actor rendering success separate from map framing success",
        }
    )
    camera_rows.append(
        {
            "sourceFile": str(b57_editor),
            "sourceLine": first_line(b57_editor, "CaptureHeight = 1080"),
            "gameObjectOrPath": "BATTLE57 runtime rehydrated actor candidate scene",
            "component": "actor capture pipeline",
            "property": "capture dimensions",
            "currentValue": "1920x1080",
            "sourceEvidence": "BATTLE57 rehydrated actors source-backed, but its capture constants remained 16:9",
            "observedDelta": "BATTLE68 true capture opened this scene and changed only RenderTexture size",
            "inferredCause": "actor blocker solved; view framing not solved by BATTLE57",
            "classification": "analysis_only",
            "proposedExactChange": "",
            "verification": "later validation must preserve BATTLE57 actor source-backed rehydration evidence",
        }
    )
    camera_rows.append(
        {
            "sourceFile": str(b26_md),
            "sourceLine": "",
            "gameObjectOrPath": "Map_11003 source sprites",
            "component": "source map evidence",
            "property": "battlemap strip candidates",
            "currentValue": "Map_11003_2/5/4_2/3/6 source-backed candidates",
            "sourceEvidence": "BATTLE26 identifies extracted battlemap sprite candidates; no screenshot paste or fake atlas",
            "observedDelta": "source map art exists, but its true-aspect composition has not been revalidated",
            "inferredCause": "map framing candidate should use original sprite rows, not route coordinate guessing",
            "classification": "analysis_only",
            "proposedExactChange": "",
            "verification": "map reprojection patch must still use these source-backed map sprites",
        }
    )

    route_rows = []
    focus_rows = route_focus_rows(b69_source_rows)
    lua_evidence = {
        "btnAuto": "UI_NormalBattle.lua lines 86-110 and 1494+ control click and active/auto state through ModulesInit.ProcedureNormalBattle",
        "btnTwoSpeed": "UI_NormalBattle.lua lines 111-131, 413-417, 683-687, 1193, 1278 control speed state and active state",
        "btnFastSkill": "UI_NormalBattle.lua lines 132-146, 692-696, 1279 control fast-skill state",
        "btnSkip": "UI_NormalBattle.lua lines 81, 544, 838, 1246-1264, 1276 control skip visibility and sprite/text state",
        "btnPause": "UI_NormalBattle.lua lines 73, 562-620, 796-830, 1182-1184, 1275 control pause visibility",
        "TopCenter": "UI_NormalBattle.lua lines 222, 1194, 1218, 1224 control top-center visibility",
    }
    for row in focus_rows:
        path = row.get("path", "")
        token = next((key for key in lua_evidence if key in path), "")
        if token:
            classification = "needs_runtime_or_handler_evidence"
            runtime = lua_evidence[token]
            proposed = "do not patch active/sprite/child state until source-backed xLua/GameEntry/ModulesInit runtime state is available"
        elif "root_top" in path or "root_opra" in path:
            classification = "analysis_only"
            runtime = "route exists in BATTLE54/BATTLE69 source join; no source-backed runtime state delta proven"
            proposed = "no route transform patch in BATTLE70; compare after map/view framing is corrected"
        else:
            classification = "analysis_only"
            runtime = "focused descendant reviewed for route/HUD context"
            proposed = ""
        add_route_row(
            route_rows,
            row,
            classification,
            "BATTLE54/BATTLE69 route/card/TMP/mask evidence join",
            runtime,
            proposed,
        )

    route_rows.append(
        {
            "routePath": "decoded UI_NormalBattle.lua",
            "sourceTable": "decoded_lua",
            "activeSelf": "",
            "activeInHierarchy": "",
            "siblingIndex": "",
            "siblingCount": "",
            "anchoredPosition": "",
            "localScale": "",
            "sizeDelta": "",
            "anchorMin": "",
            "anchorMax": "",
            "sourceEvidence": f"{lua_normal_battle}: button listeners and LuaUtils.SetActive/SetChildActive calls",
            "runtimeControlEvidence": "BATTLE58/BATTLE59: xLua/GameEntry/LuaManager/ModulesInit unavailable; listener/delegate/lifecycle rows remain 0",
            "classification": "needs_runtime_or_handler_evidence",
            "proposedExactChange": "no fake handler, no arbitrary right-rail hide/show, no coordinate-only route success",
        }
    )

    patch_rows = [
        {
            "candidateId": "map_layer_reprojection_true_aspect",
            "category": "wrong_render_framing_black_gutters",
            "exactObjectOrField": "BattleCorrectMapSceneHudPreviewClip05Root/Map_11003_* Transform.localPosition derived by CreateMapLayerPixel",
            "sourceEvidence": "BATTLE27 editor code uses Map_11003 source sprites and 1920x1080 pixel-to-world projection; BATTLE69 measured 200px/27px true-aspect gutters",
            "classification": "safe_source_backed_patch_candidate",
            "proposedExactChange": "candidate-only patch: reproject Map_11003 layer positions from the same pixel-space source rows for 1920x855/reference view rect; save only a candidate scene if later task approves",
            "blockedOrForbiddenReason": "",
            "verificationPlanId": "verify_true_aspect_gutter_after_map_reprojection",
        },
        {
            "candidateId": "camera_ortho_position_or_pixelrect_adjust",
            "category": "wrong_render_framing_black_gutters",
            "exactObjectOrField": "BattleHudSpriteAtlasTextureRuntimeBindingClip05Camera orthographicSize/aspect/pixelRect/targetTexture",
            "sourceEvidence": "BATTLE68 camera orthoSize=5 and pixelRect=0/0/640/480; no original runtime camera framing metadata found in this task",
            "classification": "analysis_only",
            "proposedExactChange": "do not change camera before isolating map reprojection, because it can move HUD, actors, and raycast coordinates together",
            "blockedOrForbiddenReason": "camera-only change would be coordinate-only without original camera evidence",
            "verificationPlanId": "compare_camera_vs_map_delta_if_needed",
        },
        {
            "candidateId": "top_hud_right_rail_active_state",
            "category": "route_hud_layout",
            "exactObjectOrField": "root_top/TopCenter, root_opra buttons and im_on/im_off children",
            "sourceEvidence": "UI_NormalBattle.lua controls these states through ModulesInit.ProcedureNormalBattle and LuaUtils.SetActive/SetChildActive",
            "classification": "needs_runtime_or_handler_evidence",
            "proposedExactChange": "none",
            "blockedOrForbiddenReason": "xLua/GameEntry/ModulesInit runtime is unavailable; active state cannot be guessed",
            "verificationPlanId": "verify_after_original_runtime_or_source_state_evidence",
        },
        {
            "candidateId": "right_rail_rect_transform_coordinate_patch",
            "category": "route_hud_layout",
            "exactObjectOrField": "btnAuto/btnTwoSpeed/btnFastSkill/btnSkip/btnPause RectTransform anchors/positions",
            "sourceEvidence": "BATTLE54 route rows show current values; no separate original rect delta proving a correction was found",
            "classification": "forbidden_guess",
            "proposedExactChange": "none",
            "blockedOrForbiddenReason": "coordinate-only patch is forbidden and would hide runtime state problems",
            "verificationPlanId": "",
        },
        {
            "candidateId": "bottom_five_card_assembly",
            "category": "card_payload",
            "exactObjectOrField": "bottom card container / five-card expected region",
            "sourceEvidence": "BATTLE69 bottom card mismatch and BATTLE54 active card rows only prove local subset, not full card assembly",
            "classification": "blocked_by_payload",
            "proposedExactChange": "none in BATTLE70",
            "blockedOrForbiddenReason": "card/icon/payload completion remains separate; fake card/icon is forbidden",
            "verificationPlanId": "verify_after_payload_chain",
        },
        {
            "candidateId": "full_actor_formation_payload",
            "category": "actor_payload",
            "exactObjectOrField": "1036 and unresolved enemy actor ids",
            "sourceEvidence": "CHARACTER65/BATTLE69: ready actors 3, source-known missing 1036, unresolved enemies remain",
            "classification": "blocked_by_payload",
            "proposedExactChange": "none in BATTLE70",
            "blockedOrForbiddenReason": "BATTLE57 local subset actors are visible but full formation is not source-complete",
            "verificationPlanId": "verify_after_actor_bundle_chain",
        },
    ]

    verification_rows = [
        {
            "planId": "verify_true_aspect_gutter_after_map_reprojection",
            "stepOrder": 1,
            "action": "Apply only a candidate scene/builder map reprojection from BATTLE27 Map_11003 pixel rows if approved in a later task",
            "inputs": "BATTLE27 map layer rows; BATTLE68 true-aspect capture path",
            "successCriteria": "BATTLE68/BATTLE69 rerun shows side gutters near reference (~0.625% total) and no fake/stretch artifacts",
            "guardrails": "candidate-only; no screenshot paste; no final restored/playable claim",
        },
        {
            "planId": "verify_true_aspect_gutter_after_map_reprojection",
            "stepOrder": 2,
            "action": "Rerun BATTLE68 no-scene-save true capture against the candidate scene",
            "inputs": "1920x855 capture path; same camera unless source evidence requires a change",
            "successCriteria": "sceneDirtyBefore/After false for capture; capture aspect remains 2.245614",
            "guardrails": "no package/manifest/xLua/handler changes",
        },
        {
            "planId": "verify_true_aspect_gutter_after_map_reprojection",
            "stepOrder": 3,
            "action": "Rerun BATTLE69 normalized layout metrics",
            "inputs": "reference frames sample_004/sample_007/sample_012 and true capture",
            "successCriteria": "black gutter no longer dominates route/HUD comparison; payload blockers still reported separately",
            "guardrails": "no coordinate-only success",
        },
        {
            "planId": "verify_after_original_runtime_or_source_state_evidence",
            "stepOrder": 1,
            "action": "Do not patch right-rail active state until original runtime state or source-backed serialized route evidence is available",
            "inputs": "UI_NormalBattle.lua, BATTLE58/BATTLE59 xLua blocker reports",
            "successCriteria": "Button/TopCenter states are explained by original handler/runtime or original prefab serialized values, not manual guessing",
            "guardrails": "no fake handler or arbitrary hide/show",
        },
    ]

    safe_count = sum(1 for r in patch_rows if r["classification"] == "safe_source_backed_patch_candidate")
    patch_runtime_count = sum(1 for r in patch_rows if r["classification"] == "needs_runtime_or_handler_evidence")
    route_runtime_count = sum(1 for r in route_rows if r["classification"] == "needs_runtime_or_handler_evidence")
    runtime_count = patch_runtime_count + route_runtime_count
    payload_count = sum(1 for r in patch_rows if r["classification"] == "blocked_by_payload")
    forbidden_count = sum(1 for r in patch_rows if r["classification"] == "forbidden_guess")
    command_policy = count_root_cmds(root)

    result = {
        "task": PREFIX,
        "generatedAt": datetime.now().isoformat(timespec="seconds"),
        "restoredClaim": False,
        "playableClaim": False,
        "patchApplied": False,
        "sceneSaved": False,
        "packageImported": False,
        "manifestModified": False,
        "runtimeInstrumentationUsed": False,
        "trueCaptureUsed": True,
        "blackGutterInputPxLeft": 200,
        "blackGutterInputPxRight": 27,
        "cameraMapFramingRowsReviewed": len(camera_rows),
        "routeHudRowsReviewed": len(route_rows),
        "safeSourceBackedPatchCandidates": safe_count,
        "runtimeOrHandlerEvidenceRequiredRows": runtime_count,
        "patchCandidateRuntimeOrHandlerEvidenceRequiredRows": patch_runtime_count,
        "routeRuntimeOrHandlerEvidenceRequiredRows": route_runtime_count,
        "payloadBlockedRows": payload_count,
        "forbiddenGuessRows": forbidden_count,
        "recommendedNextAction": "CREATE_CANDIDATE_ONLY_MAP_FRAMING_REPROJECTION_PATCH_AND_VALIDATE_WITH_BATTLE68_TRUE_ASPECT_CAPTURE_BEFORE_ROUTE_HUD_PATCH",
        "nextBlocker": "MAP_FRAMING_REPROJECTION_CANDIDATE_VALIDATION_AND_ROUTE_HUD_RUNTIME_STATE_BLOCKERS",
        "guardrailsTouched": [
            "no_scene_save",
            "no_package_import",
            "no_manifest_edit",
            "no_xlua_or_handler_patch",
            "no_fake_hud_card_icon_text_actor_effect",
            "no_screenshot_or_atlas_paste_as_asset",
            "no_coordinate_only_success",
            "no_runtime_instrumentation",
        ],
        "commandPolicy": command_policy,
        "inputs": {
            "battle69Result": str(reports / "BATTLE_69_TRUE_ASPECT_CAPTURE_ROUTE_HUD_CARD_ACTOR_NORMALIZED_VALIDATION_NO_PATCH_RESULT.json"),
            "battle68UnitySummary": str(root / "girlswar_battle_unity" / "Assets" / "RestoreData" / "battle" / "BATTLE_68_TRUE_REFERENCE_ASPECT_CAPTURE_PIPELINE_AND_VIEWRECT_SOURCE_TRACE_NO_SCENE_SAVE_UNITY.json"),
            "battle68EditorMethod": str(b68_editor),
            "battle27MapBuilder": str(b27_editor),
            "uiNormalBattleLua": str(lua_normal_battle),
        },
    }

    camera_csv = reports / f"{PREFIX}_CAMERA_RENDER_MAP_FRAMING_SOURCE_DELTA_MATRIX.csv"
    route_csv = reports / f"{PREFIX}_ROUTE_HUD_RIGHT_RAIL_SOURCE_DELTA_MATRIX.csv"
    patch_csv = reports / f"{PREFIX}_PATCH_CANDIDATE_CLASSIFICATION_MATRIX.csv"
    verify_csv = reports / f"{PREFIX}_LATER_VERIFICATION_PLAN_MATRIX.csv"
    json_path = reports / f"{PREFIX}_RESULT.json"
    md_path = reports / f"{PREFIX}_RESULT.md"

    write_csv(
        camera_csv,
        camera_rows,
        [
            "sourceFile",
            "sourceLine",
            "gameObjectOrPath",
            "component",
            "property",
            "currentValue",
            "sourceEvidence",
            "observedDelta",
            "inferredCause",
            "classification",
            "proposedExactChange",
            "verification",
        ],
    )
    write_csv(
        route_csv,
        route_rows,
        [
            "routePath",
            "sourceTable",
            "activeSelf",
            "activeInHierarchy",
            "siblingIndex",
            "siblingCount",
            "anchoredPosition",
            "localScale",
            "sizeDelta",
            "anchorMin",
            "anchorMax",
            "sourceEvidence",
            "runtimeControlEvidence",
            "classification",
            "proposedExactChange",
        ],
    )
    write_csv(
        patch_csv,
        patch_rows,
        [
            "candidateId",
            "category",
            "exactObjectOrField",
            "sourceEvidence",
            "classification",
            "proposedExactChange",
            "blockedOrForbiddenReason",
            "verificationPlanId",
        ],
    )
    write_csv(
        verify_csv,
        verification_rows,
        ["planId", "stepOrder", "action", "inputs", "successCriteria", "guardrails"],
    )
    json_path.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")

    md = [
        f"# {PREFIX} Result",
        "",
        "## Verdict",
        "- `restoredClaim=false`, `playableClaim=false`.",
        "- `patchApplied=false`; no scene/package/manifest/xLua/handler/runtime mutation was performed.",
        "- True BATTLE68 capture is used as input evidence; BATTLE67 crop remains analysis-only.",
        f"- Input black gutter: left `{result['blackGutterInputPxLeft']}` px, right `{result['blackGutterInputPxRight']}` px.",
        "",
        "## Source Delta",
        "- The strongest source-backed delta is map framing: BATTLE27 built Map_11003 layers from source sprites using a `1920x1080` pixel-to-world projection, while BATTLE68 only changed the capture RenderTexture to `1920x855`.",
        "- This supports one candidate-only patch path: reproject source-backed Map_11003 layer transforms for the true reference-aspect view and validate with the existing no-scene-save capture pipeline.",
        "- Route/HUD/right-rail active states are not safe to patch yet because `UI_NormalBattle.lua` drives them through `ModulesInit.ProcedureNormalBattle`, and BATTLE58/BATTLE59 keep original xLua/GameEntry runtime unavailable.",
        "",
        "## Counts",
        f"- Camera/render/map framing rows reviewed: `{result['cameraMapFramingRowsReviewed']}`.",
        f"- Route/HUD/right-rail rows reviewed: `{result['routeHudRowsReviewed']}`.",
        f"- Safe source-backed patch candidates: `{safe_count}`.",
        f"- Runtime/handler evidence required rows: `{runtime_count}` (`route={route_runtime_count}`, `patchCandidates={patch_runtime_count}`).",
        f"- Payload blocked rows: `{payload_count}`.",
        f"- Forbidden guess rows: `{forbidden_count}`.",
        "",
        "## Outputs",
        f"- `{camera_csv}`",
        f"- `{route_csv}`",
        f"- `{patch_csv}`",
        f"- `{verify_csv}`",
        f"- `{json_path}`",
        "",
        "## Next Blocker",
        f"- `{result['nextBlocker']}`",
        "",
        "## Command Policy",
        f"- root `.cmd` count: `{command_policy['rootCmdCount']}`",
        f"- `_restore_tools` direct `.cmd` count: `{command_policy['restoreToolsDirectCmdCount']}`",
        f"- policy ok: `{command_policy['policyOk']}`",
    ]
    md_path.write_text("\n".join(md) + "\n", encoding="utf-8")

    print(
        json.dumps(
            {
                "result": str(json_path),
                "cameraRows": len(camera_rows),
                "routeRows": len(route_rows),
                "safeSourceBackedPatchCandidates": safe_count,
                "nextBlocker": result["nextBlocker"],
            },
            ensure_ascii=False,
        )
    )


if __name__ == "__main__":
    main()
