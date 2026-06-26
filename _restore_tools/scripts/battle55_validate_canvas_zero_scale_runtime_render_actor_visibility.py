from __future__ import annotations

import argparse
import csv
import json
import shutil
from collections import Counter
from pathlib import Path
from typing import Any

from PIL import Image, ImageDraw


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
PROJECT = BASE / "girlswar_battle_unity"
REPORT_DIR = BASE / "reports" / "battle"
UNITY_DATA = PROJECT / "Assets" / "RestoreData" / "battle"
PREFIX = "BATTLE_55_VALIDATE_CANVAS_ZERO_SCALE_RUNTIME_RENDER_AND_ACTOR_VISIBILITY_OR_SOURCE_BACKED_PATCH"

UNITY_SUMMARY = UNITY_DATA / f"{PREFIX}_UNITY_SUMMARY.json"
UNITY_ZERO = UNITY_DATA / f"{PREFIX}_ZERO_SCALE_RUNTIME.csv"
UNITY_ACTORS = UNITY_DATA / f"{PREFIX}_ACTOR_VISIBILITY.csv"
UNITY_CAMERAS = UNITY_DATA / f"{PREFIX}_CAMERAS.csv"
UNITY_RENDERERS = UNITY_DATA / f"{PREFIX}_RENDERERS.csv"

OUT_MD = REPORT_DIR / f"{PREFIX}_RESULT.md"
OUT_JSON = REPORT_DIR / f"{PREFIX}_RESULT.json"
OUT_ZERO = REPORT_DIR / f"{PREFIX}_ZERO_SCALE_RUNTIME.csv"
OUT_ACTORS = REPORT_DIR / f"{PREFIX}_ACTOR_VISIBILITY.csv"
OUT_CAMERAS = REPORT_DIR / f"{PREFIX}_CAMERAS.csv"
OUT_RENDERERS = REPORT_DIR / f"{PREFIX}_RENDERERS.csv"
CONTACT = REPORT_DIR / f"{PREFIX}_CONTACT_SHEET.jpg"
LOG = REPORT_DIR / f"{PREFIX}.log"

B54_JSON = REPORT_DIR / "BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_RESULT.json"
B54_ROUTES = REPORT_DIR / "BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_ROUTES.csv"
B54_ACTORS = REPORT_DIR / "BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_ACTORS.csv"
B54_CARDS = REPORT_DIR / "BATTLE_54_VALIDATE_ROUTE_ACTIVE_SIBLING_MASK_TMP_SCALE_AUTOSIZE_ACTOR_PAYLOAD_HERO_CARDS.csv"
B53_JSON = REPORT_DIR / "BATTLE_53_RESTORE_OR_IMPORT_SOURCE_BACKED_XLUA_RUNTIME_AND_MODULESINIT_BOOTSTRAP_OR_ACCEPT_BLOCK_RESULT.json"
CAPTURE = PROJECT / "Assets" / "RestoreCaptures" / "battle_actor" / "Battle51LuaBridgeRaycasterRegistrationCandidate_1920x1080.png"
PLAY_VIDEO = Path(r"C:\Users\godho\Downloads\플레이.mp4")
AUX_VIDEO = Path(r"C:\Users\godho\Downloads\참고.mp4")


def read_json(path: Path, fallback: Any) -> Any:
    if not path.exists():
        return fallback
    return json.loads(path.read_text(encoding="utf-8-sig"))


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


def copy_csv(src: Path, dst: Path) -> list[dict[str, str]]:
    if src.exists():
        dst.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(src, dst)
    return read_csv(dst)


def count_cmds(path: Path) -> int:
    return len(list(path.glob("*.cmd"))) if path.exists() else 0


def truthy(value: Any) -> bool:
    return str(value).strip().lower() in {"true", "1", "yes"}


def intv(value: Any) -> int:
    try:
        return int(float(str(value or "0")))
    except Exception:
        return 0


def floatv(value: Any) -> float:
    try:
        return float(str(value or "0"))
    except Exception:
        return 0.0


def parse_rect(text: str) -> tuple[float, float, float, float] | None:
    vals: list[float] = []
    for part in (text or "").split("/"):
        try:
            vals.append(float(part))
        except Exception:
            return None
    if len(vals) != 4:
        return None
    return vals[0], vals[1], vals[2], vals[3]


def summarize_zero(rows: list[dict[str, str]]) -> dict[str, Any]:
    interpretations = Counter(r.get("runtimeInterpretation", "") for r in rows)
    canvas_rows = [r for r in rows if truthy(r.get("isCanvas"))]
    depth_canvas = [r for r in canvas_rows if truthy(r.get("hasDepthReadyDescendantGraphics"))]
    collapsed = [r for r in rows if not truthy(r.get("hasNonZeroScreenRect")) and intv(r.get("descendantGraphicCount")) > 0]
    runtime_zero = [r for r in rows if any(abs(floatv(v)) < 1e-6 for v in (r.get("localScale", "").split("/") if r.get("localScale") else []))]
    runtime_zero_canvas = [r for r in canvas_rows if any(abs(floatv(v)) < 1e-6 for v in (r.get("localScale", "").split("/") if r.get("localScale") else []))]
    return {
        "rows": len(rows),
        "canvasRows": len(canvas_rows),
        "runtimeZeroLocalScaleRows": len(runtime_zero),
        "runtimeZeroLocalScaleCanvasRows": len(runtime_zero_canvas),
        "canvasRowsWithDepthReadyDescendantGraphics": len(depth_canvas),
        "collapsedGraphicRoutes": len(collapsed),
        "interpretationCounts": dict(interpretations),
        "zeroScaleCanvasConclusion": "b54_static_zero_canvas_candidates_deserialize_as_nonzero_runtime_canvas_scale_and_have_depth_ready_graphics" if depth_canvas and not runtime_zero_canvas else "zero_scale_canvas_needs_more_runtime_evidence",
        "samples": [r.get("path", "") for r in rows[:8]],
    }


def summarize_actors(rows: list[dict[str, str]], renderers: list[dict[str, str]], cameras: list[dict[str, str]]) -> dict[str, Any]:
    blockers = Counter(r.get("visibilityBlocker", "") for r in rows)
    actor_ids = [r.get("payloadHeroDid", "") for r in rows]
    camera_layer = [r for r in cameras if truthy(r.get("enabled")) and truthy(r.get("activeInHierarchy")) and truthy(r.get("cullingIncludesLayer9"))]
    enabled_renderers = [r for r in renderers if truthy(r.get("enabled")) and truthy(r.get("activeInHierarchy"))]
    return {
        "rows": len(rows),
        "payloadHeroDid": actor_ids,
        "rowsWithEnabledRenderer": sum(1 for r in rows if intv(r.get("enabledRendererCount")) > 0),
        "rowsWithMesh": sum(1 for r in rows if intv(r.get("meshFilterWithMeshCount")) > 0),
        "rowsWithCameraLayerCandidate": sum(1 for r in rows if truthy(r.get("hasCameraIncludingActorLayer"))),
        "rowsWithFrustumCandidate": sum(1 for r in rows if truthy(r.get("hasCameraFrustumCandidate"))),
        "rowsWithCaptureSignal": sum(1 for r in rows if truthy(r.get("captureViewportRectHasNonBackgroundSignal")) and rect_area(r.get("captureSampleRect", "")) > 4),
        "visibilityBlockerCounts": dict(blockers),
        "enabledRendererRows": len(enabled_renderers),
        "enabledCamerasIncludingLayer9": len(camera_layer),
        "primaryConclusion": actor_primary_conclusion(rows),
    }


def actor_primary_conclusion(rows: list[dict[str, str]]) -> str:
    if not rows:
        return "no_active_actor_rows_to_probe"
    if all(intv(r.get("enabledRendererCount")) == 0 for r in rows):
        return "actor_invisibility_primary_blocker_no_enabled_renderer"
    if all(intv(r.get("meshFilterWithMeshCount")) == 0 for r in rows):
        return "actor_invisibility_primary_blocker_no_mesh_filter_mesh"
    if all(not truthy(r.get("hasCameraIncludingActorLayer")) for r in rows):
        return "actor_invisibility_primary_blocker_camera_culling_excludes_actor_layer"
    if all(not truthy(r.get("hasCameraFrustumCandidate")) for r in rows):
        return "actor_invisibility_primary_blocker_actor_bounds_outside_enabled_camera_frustum"
    if all(not truthy(r.get("viewportRectIntersectsScreen")) for r in rows):
        return "actor_invisibility_primary_blocker_actor_projected_offscreen"
    return "actor_render_path_candidates_exist_but_final_visibility_still_not_restored_due_runtime_material_shader_depth_or_composition_uncertainty"


def rect_area(text: str) -> float:
    rect = parse_rect(text)
    if not rect:
        return 0.0
    return max(0.0, rect[2]) * max(0.0, rect[3])


def make_contact(actor_rows: list[dict[str, str]]) -> bool:
    if not CAPTURE.exists():
        return False
    img = Image.open(CAPTURE).convert("RGB")
    draw = ImageDraw.Draw(img)
    colors = ["red", "lime", "cyan", "yellow", "magenta"]
    for idx, row in enumerate(actor_rows):
        rect = parse_rect(row.get("captureSampleRect", ""))
        if not rect:
            continue
        x, y, w, h = rect
        # Unity viewport origin is bottom-left, PIL origin is top-left.
        x0 = max(0, int(x))
        x1 = min(img.width - 1, int(x + w))
        y0 = max(0, int(img.height - (y + h)))
        y1 = min(img.height - 1, int(img.height - y))
        if x1 <= x0 or y1 <= y0:
            continue
        color = colors[idx % len(colors)]
        draw.rectangle([x0, y0, x1, y1], outline=color, width=4)
        draw.text((x0 + 4, y0 + 4), f"{row.get('payloadHeroDid','')} {row.get('visibilityBlocker','')[:36]}", fill=color)
    CONTACT.parent.mkdir(parents=True, exist_ok=True)
    img.save(CONTACT, quality=92)
    return True


def build_report(result: dict[str, Any]) -> str:
    lines = [
        f"# {PREFIX} Result",
        "",
        "**최종 playable battle screen은 아직 아니다.** BATTLE55 validates runtime render/raycast implications of BATTLE54 zero-scale routes and active actor visibility without saving a scene patch.",
        "",
        "## Verdict",
        f"- visual_status: `{result['visual_status']}`",
        f"- final screen claim: `{str(result['isFinalRestoredBattleScreen']).lower()}`",
        f"- patch decision: `{result['patchDecision']}`",
        f"- scene saved: `{str(result['sceneSaved']).lower()}`",
        f"- next blocker: `{result['nextBlocker']}`",
        "",
        "## Zero-Scale Runtime Probe",
        f"- zero-scale rows probed: `{result['zeroScale']['rows']}`",
        f"- zero-scale Canvas rows: `{result['zeroScale']['canvasRows']}`",
        f"- runtime zero local-scale rows: `{result['zeroScale']['runtimeZeroLocalScaleRows']}`",
        f"- runtime zero local-scale Canvas rows: `{result['zeroScale']['runtimeZeroLocalScaleCanvasRows']}`",
        f"- zero-scale Canvas rows with depth-ready descendant Graphics: `{result['zeroScale']['canvasRowsWithDepthReadyDescendantGraphics']}`",
        f"- collapsed graphic route rows: `{result['zeroScale']['collapsedGraphicRoutes']}`",
        f"- conclusion: `{result['zeroScale']['zeroScaleCanvasConclusion']}`",
        "",
        "## Actor Visibility Probe",
        f"- active actor rows probed: `{result['actors']['rows']}`",
        f"- actor ids: `{', '.join(result['actors']['payloadHeroDid'])}`",
        f"- rows with enabled Renderer: `{result['actors']['rowsWithEnabledRenderer']}`",
        f"- rows with MeshFilter mesh: `{result['actors']['rowsWithMesh']}`",
        f"- rows with enabled camera including actor layer: `{result['actors']['rowsWithCameraLayerCandidate']}`",
        f"- rows with camera frustum candidate: `{result['actors']['rowsWithFrustumCandidate']}`",
        f"- rows with capture pixel signal in projected viewport rect: `{result['actors']['rowsWithCaptureSignal']}`",
        f"- conclusion: `{result['actors']['primaryConclusion']}`",
        "",
        "## Constraints Preserved",
        "- No fake actor/card/icon/text/onClick/gameplay handler was added.",
        "- No external xLua package was downloaded/imported.",
        "- No Mask/Stencil/TMP autosize/character-spacing patch was applied.",
        "- No coordinate-only success or final restored claim was made.",
        "",
        "## Outputs",
        f"- result JSON: `{OUT_JSON}`",
        f"- zero-scale runtime CSV: `{OUT_ZERO}`",
        f"- actor visibility CSV: `{OUT_ACTORS}`",
        f"- cameras CSV: `{OUT_CAMERAS}`",
        f"- renderers CSV: `{OUT_RENDERERS}`",
        f"- contact sheet: `{CONTACT}`",
        "",
        "## Command Policy",
        f"- root `.cmd` count: `{result['rootCmdCount']}`",
        f"- `_restore_tools` direct `.cmd` count: `{result['restoreToolsDirectCmdCount']}`",
        f"- `플레이.mp4`: `{'available' if result['referenceVideoAvailable'] else 'missing'}`",
        f"- `참고.mp4`: `{'available, auxiliary only' if result['auxiliaryReferenceVideoAvailable'] else 'missing'}`",
    ]
    return "\n".join(lines) + "\n"


def run(unity_exit: int) -> int:
    REPORT_DIR.mkdir(parents=True, exist_ok=True)
    summary = read_json(UNITY_SUMMARY, {})
    zero_rows = copy_csv(UNITY_ZERO, OUT_ZERO)
    actor_rows = copy_csv(UNITY_ACTORS, OUT_ACTORS)
    camera_rows = copy_csv(UNITY_CAMERAS, OUT_CAMERAS)
    renderer_rows = copy_csv(UNITY_RENDERERS, OUT_RENDERERS)
    b54 = read_json(B54_JSON, {})
    b53 = read_json(B53_JSON, {})
    contact_exists = make_contact(actor_rows)

    result = {
        "generatedAt": "2026-06-26T03:20:00",
        "prefix": PREFIX,
        "unityExitCode": unity_exit,
        "visual_status": "runtime_zero_scale_actor_visibility_probe_complete_no_patch",
        "isFinalRestoredBattleScreen": False,
        "patchDecision": "blocked_no_patch",
        "scene": str(PROJECT / "Assets" / "Scenes" / "Battle51LuaBridgeRaycasterRegistrationCandidate.unity"),
        "sceneOpened": bool(summary.get("sceneOpened", False)),
        "sceneSaved": False,
        "zeroScale": summarize_zero(zero_rows),
        "actors": summarize_actors(actor_rows, renderer_rows, camera_rows),
        "cameraRows": len(camera_rows),
        "rendererRows": len(renderer_rows),
        "b54Carryover": {
            "routeCount": b54.get("summary", {}).get("routeCount"),
            "activeRouteZeroScaleCount": b54.get("summary", {}).get("activeRouteZeroScaleCount"),
            "activeLoadableActorRows": b54.get("summary", {}).get("activeLoadableActorRows"),
            "manifestClassification": b54.get("summary", {}).get("manifestClassification"),
            "textAutosizeCounts": b54.get("summary", {}).get("textAutosizeCounts"),
            "negativeCharacterSpacingRows": b54.get("summary", {}).get("negativeCharacterSpacingRows"),
        },
        "b53Carryover": {
            "verdict": b53.get("verdict"),
            "patchDecision": b53.get("patchDecision"),
            "nextBlocker": b53.get("nextBlocker"),
        },
        "referenceVideoAvailable": PLAY_VIDEO.exists(),
        "referenceVideoPath": str(PLAY_VIDEO),
        "auxiliaryReferenceVideoAvailable": AUX_VIDEO.exists(),
        "auxiliaryReferenceVideoPath": str(AUX_VIDEO),
        "contactSheetExists": contact_exists,
        "nextBlocker": "USER_DECISION_OR_SOURCE_RUNTIME_REQUIRED_FOR_XLUA_GAMEENTRY_BOOTSTRAP_OR_ACTOR_RENDER_SOURCE_PATCH",
        "rootCmdCount": count_cmds(BASE),
        "restoreToolsDirectCmdCount": count_cmds(BASE / "_restore_tools"),
        "outputs": {
            "report": str(OUT_MD),
            "json": str(OUT_JSON),
            "zeroScaleRuntimeCsv": str(OUT_ZERO),
            "actorVisibilityCsv": str(OUT_ACTORS),
            "camerasCsv": str(OUT_CAMERAS),
            "renderersCsv": str(OUT_RENDERERS),
            "contactSheet": str(CONTACT),
            "unitySummary": str(UNITY_SUMMARY),
            "log": str(LOG),
        },
        "notes": [
            "No fake actor/card/icon/text/onClick/gameplay handler was added.",
            "No external xLua package was downloaded/imported.",
            "No Mask/Stencil/TMP autosize/character-spacing patch was applied.",
            "BATTLE_LOCAL_PLAYABLE_PAYLOAD_MANIFEST remains local subset validation context only.",
        ],
    }
    OUT_JSON.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding="utf-8")
    OUT_MD.write_text(build_report(result), encoding="utf-8")
    LOG.write_text(
        "\n".join(
            [
                f"{PREFIX}",
                f"unityExitCode={unity_exit}",
                f"zeroRows={len(zero_rows)}",
                f"actorRows={len(actor_rows)}",
                f"patchDecision={result['patchDecision']}",
                f"isFinalRestoredBattleScreen={result['isFinalRestoredBattleScreen']}",
            ]
        )
        + "\n",
        encoding="utf-8",
    )
    return 0 if unity_exit == 0 else unity_exit


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("mode", nargs="?", default="verify", choices=["verify"])
    parser.add_argument("--unity-exit", type=int, default=0)
    args = parser.parse_args()
    return run(args.unity_exit)


if __name__ == "__main__":
    raise SystemExit(main())
