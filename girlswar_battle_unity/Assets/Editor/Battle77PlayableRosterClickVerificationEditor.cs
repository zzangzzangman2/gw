using System;
using System.IO;
using System.Text;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public static class Battle77PlayableRosterClickVerificationEditor
{
    private const string ScenePath = "Assets/Scenes/Battle76PlayableRosterCandidate.unity";
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_77_PLAYABLE_ROSTER_CLICK_VERIFICATION.json";
    private const string ReportMdPath = @"C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_77_PLAYABLE_ROSTER_CLICK_VERIFICATION.md";

    [MenuItem("GirlsWar/Battle/BATTLE77 Verify Playable Roster Clicks")]
    public static void Verify()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        Directory.CreateDirectory(Path.GetDirectoryName(ReportMdPath));

        var result = new Result
        {
            generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
            scenePath = ScenePath,
            sceneExists = File.Exists(ProjectPath(ScenePath))
        };

        if (!result.sceneExists)
        {
            result.status = "blocked_scene_missing";
            WriteOutputs(result);
            return;
        }

        var scene = EditorSceneManager.OpenScene(ScenePath);
        result.sceneOpened = scene.IsValid();
        var controller = UnityEngine.Object.FindAnyObjectByType<BattlePlayableRosterController>();
        result.controllerFound = controller != null;
        if (controller == null)
        {
            result.status = "blocked_controller_missing";
            WriteOutputs(result);
            return;
        }

        controller.BuildInEditor();
        Canvas.ForceUpdateCanvases();

        result.actorRows = controller.actorRowCount;
        result.skillRows = controller.skillRowCount;
        result.readyLocalActorRows = controller.readyLocalActorCount;
        result.readyLocalSkillRows = controller.readyLocalSkillCount;
        result.initialSelectedActorId = controller.selectedActorId;
        result.initialPlayerHp = controller.playerHpCurrent;
        result.initialEnemyHp = controller.enemyHpCurrent;

        var actorRow0 = FindButton("ActorRow_0");
        var actorRow1 = FindButton("ActorRow_1");
        var actorRow2 = FindButton("ActorRow_2");
        var attackButton = FindButton("AttackButton");
        var skillButton = FindButton("SkillButton");
        var resetButton = FindButton("ResetButton");
        var scroll = UnityEngine.Object.FindAnyObjectByType<ScrollRect>();
        var eventSystem = UnityEngine.Object.FindAnyObjectByType<EventSystem>();

        result.actorRow0Present = actorRow0 != null;
        result.actorRow0Interactable = actorRow0 != null && actorRow0.interactable;
        result.actorRow1Present = actorRow1 != null;
        result.actorRow1Interactable = actorRow1 != null && actorRow1.interactable;
        result.actorRow2Present = actorRow2 != null;
        result.actorRow2Interactable = actorRow2 != null && actorRow2.interactable;
        result.attackButtonPresent = attackButton != null;
        result.skillButtonPresent = skillButton != null;
        result.resetButtonPresent = resetButton != null;
        result.scrollRectPresent = scroll != null;
        result.eventSystemPresent = eventSystem != null;
        result.rosterMaskPresent = FindComponentOnObject<Mask>("RosterScroll") != null;
        result.rosterMaskGraphicHidden = result.rosterMaskPresent && !FindComponentOnObject<Mask>("RosterScroll").showMaskGraphic;
        result.rosterCanvasSortingOrder = ReadRosterCanvasSortingOrder();

        if (actorRow2 != null)
        {
            actorRow2.onClick.Invoke();
            Canvas.ForceUpdateCanvases();
            result.afterActorRow2SelectedActorId = controller.selectedActorId;
        }

        if (actorRow1 != null)
        {
            actorRow1.onClick.Invoke();
            Canvas.ForceUpdateCanvases();
            result.afterActorRow1SelectedActorId = controller.selectedActorId;
        }

        if (attackButton != null)
        {
            attackButton.onClick.Invoke();
            Canvas.ForceUpdateCanvases();
            result.afterAttackPlayerHp = controller.playerHpCurrent;
            result.afterAttackEnemyHp = controller.enemyHpCurrent;
            result.afterAttackLog = controller.lastActionLog;
        }

        if (skillButton != null)
        {
            skillButton.onClick.Invoke();
            Canvas.ForceUpdateCanvases();
            result.afterSkillPlayerHp = controller.playerHpCurrent;
            result.afterSkillEnemyHp = controller.enemyHpCurrent;
            result.afterSkillLog = controller.lastActionLog;
        }

        if (resetButton != null)
        {
            resetButton.onClick.Invoke();
            Canvas.ForceUpdateCanvases();
            result.afterResetPlayerHp = controller.playerHpCurrent;
            result.afterResetEnemyHp = controller.enemyHpCurrent;
            result.afterResetLog = controller.lastActionLog;
        }

        result.rosterDataVerified = result.actorRows == 12 && result.skillRows == 61 &&
            result.readyLocalActorRows == 3 && result.readyLocalSkillRows == 12;
        result.selectionVerified = result.initialSelectedActorId == "1002" &&
            result.afterActorRow2SelectedActorId == "1034" &&
            result.afterActorRow1SelectedActorId == "1002";
        result.clickLoopVerified = result.initialPlayerHp == 1000 &&
            result.initialEnemyHp == 1000 &&
            result.afterAttackPlayerHp == 958 &&
            result.afterAttackEnemyHp == 920 &&
            result.afterSkillPlayerHp == 916 &&
            result.afterSkillEnemyHp == 765 &&
            result.afterResetPlayerHp == 1000 &&
            result.afterResetEnemyHp == 1000;
        result.uiLayerVerified = result.rosterCanvasSortingOrder == 5000 &&
            result.rosterMaskPresent &&
            result.rosterMaskGraphicHidden &&
            result.scrollRectPresent &&
            result.eventSystemPresent;
        result.status = result.rosterDataVerified && result.selectionVerified &&
            result.clickLoopVerified && result.uiLayerVerified
            ? "battle77_click_playability_verified"
            : "battle77_click_playability_failed";

        WriteOutputs(result);
        Debug.Log("[GirlsWarRestore] BATTLE77 playable roster click verification: " + result.status);
    }

    private static Button FindButton(string objectName)
    {
        foreach (var button in UnityEngine.Object.FindObjectsByType<Button>(FindObjectsInactive.Include))
            if (button.name == objectName)
                return button;
        return null;
    }

    private static T FindComponentOnObject<T>(string objectName) where T : Component
    {
        foreach (var transform in UnityEngine.Object.FindObjectsByType<Transform>(FindObjectsInactive.Include))
        {
            if (transform.name != objectName)
                continue;
            return transform.GetComponent<T>();
        }
        return null;
    }

    private static int ReadRosterCanvasSortingOrder()
    {
        foreach (var canvas in UnityEngine.Object.FindObjectsByType<Canvas>(FindObjectsInactive.Include))
            if (canvas.name == "BattlePlayableRosterCanvas")
                return canvas.sortingOrder;
        return int.MinValue;
    }

    private static void WriteOutputs(Result result)
    {
        File.WriteAllText(ProjectPath(ResultJsonPath), JsonUtility.ToJson(result, true), Encoding.UTF8);

        var sb = new StringBuilder();
        sb.AppendLine("# BATTLE_77_PLAYABLE_ROSTER_CLICK_VERIFICATION");
        sb.AppendLine();
        sb.AppendLine("- status: `" + result.status + "`");
        sb.AppendLine("- scene: `" + ProjectPath(ScenePath) + "`");
        sb.AppendLine("- roster rows actor/skill: `" + result.actorRows + " / " + result.skillRows + "`");
        sb.AppendLine("- ready rows actor/skill: `" + result.readyLocalActorRows + " / " + result.readyLocalSkillRows + "`");
        sb.AppendLine("- selection: `" + result.initialSelectedActorId + " -> " + result.afterActorRow2SelectedActorId + " -> " + result.afterActorRow1SelectedActorId + "`");
        sb.AppendLine("- attack HP: `player " + result.afterAttackPlayerHp + ", enemy " + result.afterAttackEnemyHp + "`");
        sb.AppendLine("- skill HP: `player " + result.afterSkillPlayerHp + ", enemy " + result.afterSkillEnemyHp + "`");
        sb.AppendLine("- reset HP: `player " + result.afterResetPlayerHp + ", enemy " + result.afterResetEnemyHp + "`");
        sb.AppendLine("- rosterDataVerified: `" + result.rosterDataVerified + "`");
        sb.AppendLine("- selectionVerified: `" + result.selectionVerified + "`");
        sb.AppendLine("- clickLoopVerified: `" + result.clickLoopVerified + "`");
        sb.AppendLine("- uiLayerVerified: `" + result.uiLayerVerified + "`");
        sb.AppendLine();
        sb.AppendLine("## Notes");
        sb.AppendLine("- This verifies the saved B76 candidate by rebuilding its roster UI in editor memory and invoking real `Button.onClick` handlers.");
        sb.AppendLine("- It proves local playable roster interaction; it does not claim restored original xLua battle timing.");
        File.WriteAllText(ReportMdPath, sb.ToString(), Encoding.UTF8);
    }

    private static string ProjectPath(string projectRelativePath)
    {
        return Path.GetFullPath(Path.Combine(Application.dataPath, "..", projectRelativePath));
    }

    [Serializable]
    private sealed class Result
    {
        public string generatedAt;
        public string status;
        public string scenePath;
        public bool sceneExists;
        public bool sceneOpened;
        public bool controllerFound;
        public int actorRows;
        public int skillRows;
        public int readyLocalActorRows;
        public int readyLocalSkillRows;
        public string initialSelectedActorId;
        public string afterActorRow2SelectedActorId;
        public string afterActorRow1SelectedActorId;
        public int initialPlayerHp;
        public int initialEnemyHp;
        public int afterAttackPlayerHp;
        public int afterAttackEnemyHp;
        public string afterAttackLog;
        public int afterSkillPlayerHp;
        public int afterSkillEnemyHp;
        public string afterSkillLog;
        public int afterResetPlayerHp;
        public int afterResetEnemyHp;
        public string afterResetLog;
        public bool actorRow0Present;
        public bool actorRow0Interactable;
        public bool actorRow1Present;
        public bool actorRow1Interactable;
        public bool actorRow2Present;
        public bool actorRow2Interactable;
        public bool attackButtonPresent;
        public bool skillButtonPresent;
        public bool resetButtonPresent;
        public bool scrollRectPresent;
        public bool eventSystemPresent;
        public bool rosterMaskPresent;
        public bool rosterMaskGraphicHidden;
        public int rosterCanvasSortingOrder;
        public bool rosterDataVerified;
        public bool selectionVerified;
        public bool clickLoopVerified;
        public bool uiLayerVerified;
    }
}
