from __future__ import annotations

import json
import shutil
import csv
from pathlib import Path


BASE = Path(r"C:\Users\godho\Downloads\girlswar")
REPORT_DIR = BASE / "reports" / "battle"
UNITY_DIR = BASE / "girlswar_battle_unity"
ASSETS_DIR = UNITY_DIR / "Assets"
RESTORE_DATA_DIR = ASSETS_DIR / "RestoreData" / "battle"
SCENES_DIR = ASSETS_DIR / "Scenes"
EDITOR_DIR = ASSETS_DIR / "Editor"


def copy_if_exists(src: Path, dst: Path) -> bool:
    if not src.exists():
        return False
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(src, dst)
    return True


def main() -> None:
    UNITY_DIR.mkdir(parents=True, exist_ok=True)
    RESTORE_DATA_DIR.mkdir(parents=True, exist_ok=True)
    SCENES_DIR.mkdir(parents=True, exist_ok=True)
    EDITOR_DIR.mkdir(parents=True, exist_ok=True)
    copied = {
        "manifest": copy_if_exists(REPORT_DIR / "BATTLE_PROTOTYPE_MANIFEST.json", RESTORE_DATA_DIR / "BATTLE_PROTOTYPE_MANIFEST.json"),
        "payload": copy_if_exists(REPORT_DIR / "BATTLE_TEST_PAYLOAD.json", RESTORE_DATA_DIR / "BATTLE_TEST_PAYLOAD.json"),
        "actors": copy_if_exists(REPORT_DIR / "BATTLE_PROTOTYPE_ACTORS.csv", RESTORE_DATA_DIR / "BATTLE_PROTOTYPE_ACTORS.csv"),
        "skills": copy_if_exists(REPORT_DIR / "BATTLE_PROTOTYPE_SKILLS.csv", RESTORE_DATA_DIR / "BATTLE_PROTOTYPE_SKILLS.csv"),
        "bundles": copy_if_exists(REPORT_DIR / "BATTLE_PROTOTYPE_BUNDLES.csv", RESTORE_DATA_DIR / "BATTLE_PROTOTYPE_BUNDLES.csv"),
    }
    manifest_path = REPORT_DIR / "BATTLE_PROTOTYPE_MANIFEST.json"
    resource_stats = write_resource_index(manifest_path, RESTORE_DATA_DIR / "resource_index.csv")
    write_readme(resource_stats, copied)
    write_battle07_editor_skeleton()
    (RESTORE_DATA_DIR / "copy_status.json").write_text(
        json.dumps({"copied": copied, "resourceIndex": resource_stats}, indent=2),
        encoding="utf-8",
    )
    print(f"Prepared {UNITY_DIR}")
    print(json.dumps({"copied": copied, "resourceIndex": resource_stats}, indent=2))


def write_resource_index(manifest_path: Path, out_path: Path) -> dict[str, int]:
    out_path.parent.mkdir(parents=True, exist_ok=True)
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    bundles = manifest.get("bundles", [])
    fields = ["kind", "bundle", "exists", "referenced_by", "source"]
    with out_path.open("w", encoding="utf-8-sig", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        for row in bundles:
            writer.writerow({field: row.get(field, "") for field in fields})
    return {
        "bundleReferences": len(bundles),
        "existing": sum(1 for row in bundles if bool(row.get("exists"))),
        "missing": sum(1 for row in bundles if not bool(row.get("exists"))),
    }


def write_readme(resource_stats: dict[str, int], copied: dict[str, bool]) -> None:
    readme = UNITY_DIR / "README_BATTLE_PROTOTYPE.md"
    lines = [
        "# GirlsWar Battle Prototype",
        "",
        "Battle-only prototype scaffold. Do not place MainInterface restore outputs here.",
        "",
        "## Data",
        "- `Assets/RestoreData/battle/BATTLE_PROTOTYPE_MANIFEST.json`",
        "- `Assets/RestoreData/battle/BATTLE_TEST_PAYLOAD.json`",
        "- `Assets/RestoreData/battle/resource_index.csv`",
        "",
        "## Current Verification",
        f"- Copied files: `{sum(1 for ok in copied.values() if ok)}` / `{len(copied)}`",
        f"- Referenced bundles: `{resource_stats['existing']}` existing / `{resource_stats['bundleReferences']}` total",
        f"- Missing bundles: `{resource_stats['missing']}`",
        "",
        "## Next Command",
        "- `_restore_tools\\BATTLE_07_BUILD_MINIMAL_BATTLE_SCENE.cmd`",
    ]
    readme.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_battle07_editor_skeleton() -> None:
    script = EDITOR_DIR / "BattlePrototypeSceneBuilder.cs"
    if script.exists():
        return
    script.write_text(
        """using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;

public static class BattlePrototypeSceneBuilder
{
    [MenuItem("GirlsWar/Battle/Build Minimal Prototype Scene")]
    public static void Build()
    {
        var scene = EditorSceneManager.NewScene(NewSceneSetup.EmptyScene, NewSceneMode.Single);
        var root = new GameObject("BattlePrototypeRoot");
        var manifest = new GameObject("ManifestSource");
        manifest.transform.SetParent(root.transform);
        manifest.AddComponent<BattlePrototypeManifestMarker>();

        var cameraObject = new GameObject("BattleCamera");
        var camera = cameraObject.AddComponent<Camera>();
        camera.orthographic = true;
        camera.orthographicSize = 6f;
        cameraObject.transform.position = new Vector3(0f, 0f, -10f);

        EditorSceneManager.SaveScene(scene, "Assets/Scenes/BattlePrototype.unity");
        AssetDatabase.Refresh();
    }
}

public sealed class BattlePrototypeManifestMarker : MonoBehaviour
{
    public string manifestPath = "Assets/RestoreData/battle/BATTLE_PROTOTYPE_MANIFEST.json";
    public string payloadPath = "Assets/RestoreData/battle/BATTLE_TEST_PAYLOAD.json";
}
""",
        encoding="utf-8",
    )


if __name__ == "__main__":
    main()
