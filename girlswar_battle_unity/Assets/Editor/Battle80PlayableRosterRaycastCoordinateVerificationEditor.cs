using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public static class Battle80PlayableRosterRaycastCoordinateVerificationEditor
{
    private const string ScenePath = "Assets/Scenes/Battle76PlayableRosterCandidate.unity";
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_80_PLAYMODE_RAYCAST_COORDINATE_VERIFICATION.json";
    private const string ReportMdPath = @"C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_80_PLAYMODE_RAYCAST_COORDINATE_VERIFICATION.md";
    private const double TimeoutSeconds = 45.0;

    private static Result result;
    private static double startedAt;
    private static bool previousEnterPlayModeOptionsEnabled;
    private static EnterPlayModeOptions previousEnterPlayModeOptions;
    private static bool verificationStarted;
    private static int playFrames;

    [MenuItem("GirlsWar/Battle/BATTLE80 Verify Playable Roster Raycast Coordinates")]
    public static void Verify()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        Directory.CreateDirectory(Path.GetDirectoryName(ReportMdPath));

        result = new Result
        {
            generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
            scenePath = ScenePath,
            sceneExists = File.Exists(ProjectPath(ScenePath))
        };

        if (!result.sceneExists)
        {
            result.status = "blocked_scene_missing";
            WriteOutputs(result);
            EditorApplication.Exit(1);
            return;
        }

        previousEnterPlayModeOptionsEnabled = EditorSettings.enterPlayModeOptionsEnabled;
        previousEnterPlayModeOptions = EditorSettings.enterPlayModeOptions;
        EditorSettings.enterPlayModeOptionsEnabled = true;
        EditorSettings.enterPlayModeOptions = EnterPlayModeOptions.DisableDomainReload;
        result.domainReloadDisabledForVerification = true;

        var scene = EditorSceneManager.OpenScene(ScenePath);
        result.sceneOpened = scene.IsValid();
        startedAt = EditorApplication.timeSinceStartup;
        verificationStarted = false;
        playFrames = 0;

        EditorApplication.update -= OnUpdate;
        EditorApplication.update += OnUpdate;
        EditorApplication.EnterPlaymode();
    }

    private static void OnUpdate()
    {
        if (result == null)
            return;

        if (EditorApplication.timeSinceStartup - startedAt > TimeoutSeconds)
        {
            result.status = "raycast_coordinate_verification_timeout";
            Finish(1);
            return;
        }

        if (!EditorApplication.isPlaying)
            return;

        playFrames++;
        if (!verificationStarted && playFrames < 5)
            return;
        if (verificationStarted)
            return;

        verificationStarted = true;
        try
        {
            RunRuntimeVerification();
            Finish(result.status == "battle80_playmode_raycast_coordinate_verified" ? 0 : 1);
        }
        catch (Exception ex)
        {
            result.status = "raycast_coordinate_verification_exception";
            result.exception = ex.GetType().Name + ": " + ex.Message;
            Finish(1);
        }
    }

    private static void RunRuntimeVerification()
    {
        result.playModeEntered = EditorApplication.isPlaying;
        result.playFrameCountAtVerification = playFrames;
        result.eventSystemPresent = EventSystem.current != null || UnityEngine.Object.FindAnyObjectByType<EventSystem>() != null;

        var controller = UnityEngine.Object.FindAnyObjectByType<BattlePlayableRosterController>();
        result.controllerFound = controller != null;
        if (controller == null)
        {
            result.status = "blocked_controller_missing_in_playmode";
            return;
        }

        result.actorRows = controller.actorRowCount;
        result.skillRows = controller.skillRowCount;
        result.characterCatalogRows = controller.characterCatalogRowCount;
        result.characterCatalogKoreanNameRows = controller.characterCatalogKoreanNameCount;
        result.characterCatalogHeadImageRows = controller.characterCatalogHeadImageCount;
        result.characterCatalogBattleBundleRows = controller.characterCatalogBattleBundleCount;
        result.readyLocalActorRows = controller.readyLocalActorCount;
        result.readyLocalSkillRows = controller.readyLocalSkillCount;
        result.rosterDataVerified = result.actorRows == 12 &&
            result.skillRows == 61 &&
            result.characterCatalogRows == 131 &&
            result.characterCatalogKoreanNameRows == 130 &&
            result.characterCatalogHeadImageRows == 130 &&
            result.characterCatalogBattleBundleRows == 38 &&
            result.readyLocalActorRows == 3 &&
            result.readyLocalSkillRows == 12;
        result.runtimeStartGeneratedUiVerified = CountNamed<Canvas>("BattlePlayableRosterCanvas") == 1 &&
            CountNamed<RectTransform>("BattlePlayableRosterPanel") == 1 &&
            CountPrefix<Button>("ActorRow_") == 12 &&
            CountPrefix<RectTransform>("SkillRow_") == 61 &&
            CountPrefix<RectTransform>("CharacterRow_") == 131;

        result.initialSelectedActorId = controller.selectedActorId;
        result.initialPlayerHp = controller.playerHpCurrent;
        result.initialEnemyHp = controller.enemyHpCurrent;

        result.actorRow2 = ProbeAndClick("ActorRow_2");
        Canvas.ForceUpdateCanvases();
        result.afterActorRow2SelectedActorId = controller.selectedActorId;

        result.actorRow1 = ProbeAndClick("ActorRow_1");
        Canvas.ForceUpdateCanvases();
        result.afterActorRow1SelectedActorId = controller.selectedActorId;

        result.attackButton = ProbeAndClick("AttackButton");
        Canvas.ForceUpdateCanvases();
        result.afterAttackPlayerHp = controller.playerHpCurrent;
        result.afterAttackEnemyHp = controller.enemyHpCurrent;

        result.skillButton = ProbeAndClick("SkillButton");
        Canvas.ForceUpdateCanvases();
        result.afterSkillPlayerHp = controller.playerHpCurrent;
        result.afterSkillEnemyHp = controller.enemyHpCurrent;

        result.resetButton = ProbeAndClick("ResetButton");
        Canvas.ForceUpdateCanvases();
        result.afterResetPlayerHp = controller.playerHpCurrent;
        result.afterResetEnemyHp = controller.enemyHpCurrent;

        result.selectionVerified = result.initialSelectedActorId == "1002" &&
            result.afterActorRow2SelectedActorId == "1034" &&
            result.afterActorRow1SelectedActorId == "1002";
        result.hpLoopVerified = result.initialPlayerHp == 1000 &&
            result.initialEnemyHp == 1000 &&
            result.afterAttackPlayerHp == 958 &&
            result.afterAttackEnemyHp == 920 &&
            result.afterSkillPlayerHp == 916 &&
            result.afterSkillEnemyHp == 765 &&
            result.afterResetPlayerHp == 1000 &&
            result.afterResetEnemyHp == 1000;
        result.allCoordinateRaycastsVerified =
            ProbeOk(result.actorRow2) &&
            ProbeOk(result.actorRow1) &&
            ProbeOk(result.attackButton) &&
            ProbeOk(result.skillButton) &&
            ProbeOk(result.resetButton);

        result.status = result.playModeEntered &&
            result.eventSystemPresent &&
            result.rosterDataVerified &&
            result.runtimeStartGeneratedUiVerified &&
            result.allCoordinateRaycastsVerified &&
            result.selectionVerified &&
            result.hpLoopVerified
            ? "battle80_playmode_raycast_coordinate_verified"
            : "battle80_playmode_raycast_coordinate_failed";
    }

    private static Probe ProbeAndClick(string buttonName)
    {
        var probe = new Probe { buttonName = buttonName };
        var button = FindButton(buttonName);
        probe.buttonPresent = button != null;
        if (button == null)
            return probe;

        probe.activeInHierarchy = button.gameObject.activeInHierarchy;
        probe.interactable = button.interactable;

        var rect = button.GetComponent<RectTransform>();
        var canvas = button.GetComponentInParent<Canvas>();
        var raycaster = canvas != null ? canvas.GetComponent<GraphicRaycaster>() : null;
        var eventSystem = EventSystem.current ?? UnityEngine.Object.FindAnyObjectByType<EventSystem>();
        var camera = canvas != null && canvas.renderMode != RenderMode.ScreenSpaceOverlay ? canvas.worldCamera : null;

        probe.canvasName = canvas != null ? canvas.name : "";
        probe.canvasSortingOrder = canvas != null ? canvas.sortingOrder : int.MinValue;
        probe.raycasterPresent = raycaster != null;
        probe.eventCameraName = camera != null ? camera.name : "";

        if (rect == null || raycaster == null || eventSystem == null)
            return probe;

        var worldCenter = rect.TransformPoint(rect.rect.center);
        var screen = RectTransformUtility.WorldToScreenPoint(camera, worldCenter);
        probe.screenX = screen.x;
        probe.screenY = screen.y;

        var eventData = new PointerEventData(eventSystem)
        {
            position = screen,
            button = PointerEventData.InputButton.Left,
            pointerId = -1
        };

        var hits = new List<RaycastResult>();
        raycaster.Raycast(eventData, hits);
        probe.hitCount = hits.Count;
        if (hits.Count > 0)
        {
            probe.topHitName = hits[0].gameObject.name;
            probe.topHitPath = PathOf(hits[0].gameObject.transform);
            probe.topHitIsButtonOrChild = IsSelfOrChildOf(hits[0].gameObject.transform, button.transform);
        }

        for (var i = 0; i < hits.Count; i++)
        {
            if (!IsSelfOrChildOf(hits[i].gameObject.transform, button.transform))
                continue;
            probe.targetIncludedInHits = true;
            probe.targetHitIndex = i;
            probe.targetHitName = hits[i].gameObject.name;
            break;
        }

        if (!probe.activeInHierarchy || !probe.interactable || !probe.targetIncludedInHits)
            return probe;

        var clickTarget = hits.Count > 0 ? hits[0].gameObject : button.gameObject;
        probe.executeHierarchyClickSent = ExecuteEvents.ExecuteHierarchy(clickTarget, eventData, ExecuteEvents.pointerClickHandler) != null;
        return probe;
    }

    private static bool ProbeOk(Probe probe)
    {
        return probe != null &&
            probe.buttonPresent &&
            probe.activeInHierarchy &&
            probe.interactable &&
            probe.raycasterPresent &&
            probe.hitCount > 0 &&
            probe.topHitIsButtonOrChild &&
            probe.targetIncludedInHits &&
            probe.targetHitIndex == 0 &&
            probe.executeHierarchyClickSent;
    }

    private static Button FindButton(string objectName)
    {
        foreach (var button in UnityEngine.Object.FindObjectsByType<Button>(FindObjectsInactive.Include))
            if (button.name == objectName)
                return button;
        return null;
    }

    private static int CountNamed<T>(string objectName) where T : Component
    {
        var count = 0;
        foreach (var component in UnityEngine.Object.FindObjectsByType<T>(FindObjectsInactive.Include))
            if (component.name == objectName)
                count++;
        return count;
    }

    private static int CountPrefix<T>(string prefix) where T : Component
    {
        var count = 0;
        foreach (var component in UnityEngine.Object.FindObjectsByType<T>(FindObjectsInactive.Include))
            if (component.name.StartsWith(prefix, StringComparison.Ordinal))
                count++;
        return count;
    }

    private static bool IsSelfOrChildOf(Transform candidate, Transform parent)
    {
        var current = candidate;
        while (current != null)
        {
            if (current == parent)
                return true;
            current = current.parent;
        }
        return false;
    }

    private static string PathOf(Transform transform)
    {
        var path = transform.name;
        var current = transform.parent;
        while (current != null)
        {
            path = current.name + "/" + path;
            current = current.parent;
        }
        return path;
    }

    private static void Finish(int exitCode)
    {
        EditorApplication.update -= OnUpdate;
        RestoreEnterPlayModeSettings();
        WriteOutputs(result);
        if (EditorApplication.isPlaying)
            EditorApplication.ExitPlaymode();
        EditorApplication.Exit(exitCode);
    }

    private static void RestoreEnterPlayModeSettings()
    {
        EditorSettings.enterPlayModeOptionsEnabled = previousEnterPlayModeOptionsEnabled;
        EditorSettings.enterPlayModeOptions = previousEnterPlayModeOptions;
    }

    private static void WriteOutputs(Result output)
    {
        File.WriteAllText(ProjectPath(ResultJsonPath), JsonUtility.ToJson(output, true), Encoding.UTF8);

        var sb = new StringBuilder();
        sb.AppendLine("# BATTLE_80_PLAYMODE_RAYCAST_COORDINATE_VERIFICATION");
        sb.AppendLine();
        sb.AppendLine("- status: `" + output.status + "`");
        sb.AppendLine("- scene: `" + ProjectPath(ScenePath) + "`");
        sb.AppendLine("- playModeEntered: `" + output.playModeEntered + "`");
        sb.AppendLine("- roster rows actor/skill/characterCatalog: `" + output.actorRows + " / " + output.skillRows + " / " + output.characterCatalogRows + "`");
        sb.AppendLine("- character catalog name/head/battleBundle rows: `" + output.characterCatalogKoreanNameRows + " / " + output.characterCatalogHeadImageRows + " / " + output.characterCatalogBattleBundleRows + "`");
        sb.AppendLine("- runtimeStartGeneratedUiVerified: `" + output.runtimeStartGeneratedUiVerified + "`");
        sb.AppendLine("- allCoordinateRaycastsVerified: `" + output.allCoordinateRaycastsVerified + "`");
        sb.AppendLine("- selection: `" + output.initialSelectedActorId + " -> " + output.afterActorRow2SelectedActorId + " -> " + output.afterActorRow1SelectedActorId + "`");
        sb.AppendLine("- HP loop: `attack " + output.afterAttackPlayerHp + "/" + output.afterAttackEnemyHp + ", skill " + output.afterSkillPlayerHp + "/" + output.afterSkillEnemyHp + ", reset " + output.afterResetPlayerHp + "/" + output.afterResetEnemyHp + "`");
        sb.AppendLine();
        sb.AppendLine("## Raycast Probes");
        AppendProbe(sb, output.actorRow2);
        AppendProbe(sb, output.actorRow1);
        AppendProbe(sb, output.attackButton);
        AppendProbe(sb, output.skillButton);
        AppendProbe(sb, output.resetButton);
        sb.AppendLine();
        sb.AppendLine("## Notes");
        sb.AppendLine("- This computes each target button center in screen coordinates, verifies the top `GraphicRaycaster` hit is that button, then dispatches pointer-click through `ExecuteEvents.ExecuteHierarchy`.");
        sb.AppendLine("- It directly covers coordinate/raycast/sibling blocker behavior for the playable roster overlay.");
        if (!string.IsNullOrEmpty(output.exception))
        {
            sb.AppendLine();
            sb.AppendLine("## Exception");
            sb.AppendLine("- `" + output.exception + "`");
        }
        File.WriteAllText(ReportMdPath, sb.ToString(), Encoding.UTF8);
    }

    private static void AppendProbe(StringBuilder sb, Probe probe)
    {
        if (probe == null)
            return;
        sb.AppendLine("- `" + probe.buttonName + "` screen=`" + probe.screenX.ToString("0.0") + "," + probe.screenY.ToString("0.0") +
            "` hits=`" + probe.hitCount + "` top=`" + probe.topHitName + "` targetIndex=`" + probe.targetHitIndex +
            "` clicked=`" + probe.executeHierarchyClickSent + "`");
    }

    private static string ProjectPath(string projectRelativePath)
    {
        return Path.GetFullPath(Path.Combine(Application.dataPath, "..", projectRelativePath));
    }

    [Serializable]
    private sealed class Probe
    {
        public string buttonName;
        public bool buttonPresent;
        public bool activeInHierarchy;
        public bool interactable;
        public string canvasName;
        public int canvasSortingOrder;
        public bool raycasterPresent;
        public string eventCameraName;
        public float screenX;
        public float screenY;
        public int hitCount;
        public string topHitName;
        public string topHitPath;
        public bool topHitIsButtonOrChild;
        public bool targetIncludedInHits;
        public int targetHitIndex = -1;
        public string targetHitName;
        public bool executeHierarchyClickSent;
    }

    [Serializable]
    private sealed class Result
    {
        public string generatedAt;
        public string status;
        public string scenePath;
        public bool sceneExists;
        public bool sceneOpened;
        public bool domainReloadDisabledForVerification;
        public bool playModeEntered;
        public int playFrameCountAtVerification;
        public bool eventSystemPresent;
        public bool controllerFound;
        public int actorRows;
        public int skillRows;
        public int characterCatalogRows;
        public int characterCatalogKoreanNameRows;
        public int characterCatalogHeadImageRows;
        public int characterCatalogBattleBundleRows;
        public int readyLocalActorRows;
        public int readyLocalSkillRows;
        public bool rosterDataVerified;
        public bool runtimeStartGeneratedUiVerified;
        public string initialSelectedActorId;
        public string afterActorRow2SelectedActorId;
        public string afterActorRow1SelectedActorId;
        public int initialPlayerHp;
        public int initialEnemyHp;
        public int afterAttackPlayerHp;
        public int afterAttackEnemyHp;
        public int afterSkillPlayerHp;
        public int afterSkillEnemyHp;
        public int afterResetPlayerHp;
        public int afterResetEnemyHp;
        public bool selectionVerified;
        public bool hpLoopVerified;
        public bool allCoordinateRaycastsVerified;
        public Probe actorRow2;
        public Probe actorRow1;
        public Probe attackButton;
        public Probe skillButton;
        public Probe resetButton;
        public string exception;
    }
}
