using System;
using System.IO;
using System.Text;
using TMPro;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public static class Battle79PlayableRosterPlayModeVerificationEditor
{
    private const string ScenePath = "Assets/Scenes/Battle76PlayableRosterCandidate.unity";
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_79_PLAYMODE_PLAYABLE_ROSTER_VERIFICATION.json";
    private const string ReportMdPath = @"C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_79_PLAYMODE_PLAYABLE_ROSTER_VERIFICATION.md";
    private const double TimeoutSeconds = 45.0;

    private static Result result;
    private static double startedAt;
    private static bool previousEnterPlayModeOptionsEnabled;
    private static EnterPlayModeOptions previousEnterPlayModeOptions;
    private static bool verificationStarted;
    private static int playFrames;

    [MenuItem("GirlsWar/Battle/BATTLE79 Verify Playable Roster In PlayMode")]
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
            result.status = "playmode_verification_timeout";
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
            Finish(result.status == "battle79_playmode_playability_verified" ? 0 : 1);
        }
        catch (Exception ex)
        {
            result.status = "playmode_verification_exception";
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
        result.initialSelectedActorId = controller.selectedActorId;
        result.initialPlayerHp = controller.playerHpCurrent;
        result.initialEnemyHp = controller.enemyHpCurrent;

        result.rosterCanvasCount = CountNamed<Canvas>("BattlePlayableRosterCanvas");
        result.rosterPanelCount = CountNamed<RectTransform>("BattlePlayableRosterPanel");
        result.rosterRowButtonCount = CountPrefix<Button>("ActorRow_");
        result.rosterSkillRowCount = CountPrefix<RectTransform>("SkillRow_");
        result.rosterSkillRowTextCount = CountTextChildrenUnderPrefix("SkillRow_");
        result.rosterCharacterRowCount = CountPrefix<RectTransform>("CharacterRow_");
        result.rosterCharacterRowTextCount = CountTextChildrenUnderPrefix("CharacterRow_");

        var actorRow0 = FindButton("ActorRow_0");
        var actorRow1 = FindButton("ActorRow_1");
        var actorRow2 = FindButton("ActorRow_2");
        var attackButton = FindButton("AttackButton");
        var skillButton = FindButton("SkillButton");
        var resetButton = FindButton("ResetButton");

        result.actorRow0Present = actorRow0 != null;
        result.actorRow0Interactable = actorRow0 != null && actorRow0.interactable;
        result.actorRow1Present = actorRow1 != null;
        result.actorRow1Interactable = actorRow1 != null && actorRow1.interactable;
        result.actorRow2Present = actorRow2 != null;
        result.actorRow2Interactable = actorRow2 != null && actorRow2.interactable;
        result.attackButtonPresent = attackButton != null;
        result.skillButtonPresent = skillButton != null;
        result.resetButtonPresent = resetButton != null;

        result.actorRow2PointerClickExecuted = ExecutePointerClick(actorRow2);
        Canvas.ForceUpdateCanvases();
        result.afterActorRow2SelectedActorId = controller.selectedActorId;

        result.actorRow1PointerClickExecuted = ExecutePointerClick(actorRow1);
        Canvas.ForceUpdateCanvases();
        result.afterActorRow1SelectedActorId = controller.selectedActorId;

        result.attackPointerClickExecuted = ExecutePointerClick(attackButton);
        Canvas.ForceUpdateCanvases();
        result.afterAttackPlayerHp = controller.playerHpCurrent;
        result.afterAttackEnemyHp = controller.enemyHpCurrent;
        result.afterAttackLog = controller.lastActionLog;

        result.skillPointerClickExecuted = ExecutePointerClick(skillButton);
        Canvas.ForceUpdateCanvases();
        result.afterSkillPlayerHp = controller.playerHpCurrent;
        result.afterSkillEnemyHp = controller.enemyHpCurrent;
        result.afterSkillLog = controller.lastActionLog;

        result.resetPointerClickExecuted = ExecutePointerClick(resetButton);
        Canvas.ForceUpdateCanvases();
        result.afterResetPlayerHp = controller.playerHpCurrent;
        result.afterResetEnemyHp = controller.enemyHpCurrent;
        result.afterResetLog = controller.lastActionLog;

        result.rosterDataVerified = result.actorRows == 12 &&
            result.skillRows == 61 &&
            result.characterCatalogRows == 131 &&
            result.characterCatalogKoreanNameRows == 130 &&
            result.characterCatalogHeadImageRows == 130 &&
            result.characterCatalogBattleBundleRows == 38 &&
            result.readyLocalActorRows == 3 &&
            result.readyLocalSkillRows == 12;
        result.runtimeStartGeneratedUiVerified = result.rosterCanvasCount == 1 &&
            result.rosterPanelCount == 1 &&
            result.rosterRowButtonCount == 12 &&
            result.rosterSkillRowCount == 61 &&
            result.rosterSkillRowTextCount == 61 &&
            result.rosterCharacterRowCount == 131 &&
            result.rosterCharacterRowTextCount == 131;
        result.selectionVerified = result.initialSelectedActorId == "1002" &&
            result.afterActorRow2SelectedActorId == "1034" &&
            result.afterActorRow1SelectedActorId == "1002";
        result.pointerClickLoopVerified = result.actorRow2PointerClickExecuted &&
            result.actorRow1PointerClickExecuted &&
            result.attackPointerClickExecuted &&
            result.skillPointerClickExecuted &&
            result.resetPointerClickExecuted &&
            result.initialPlayerHp == 1000 &&
            result.initialEnemyHp == 1000 &&
            result.afterAttackPlayerHp == 958 &&
            result.afterAttackEnemyHp == 920 &&
            result.afterSkillPlayerHp == 916 &&
            result.afterSkillEnemyHp == 765 &&
            result.afterResetPlayerHp == 1000 &&
            result.afterResetEnemyHp == 1000;

        result.status = result.playModeEntered &&
            result.eventSystemPresent &&
            result.rosterDataVerified &&
            result.runtimeStartGeneratedUiVerified &&
            result.selectionVerified &&
            result.pointerClickLoopVerified
            ? "battle79_playmode_playability_verified"
            : "battle79_playmode_playability_failed";
    }

    private static bool ExecutePointerClick(Button button)
    {
        if (button == null || !button.IsActive() || !button.interactable)
            return false;

        var eventSystem = EventSystem.current ?? UnityEngine.Object.FindAnyObjectByType<EventSystem>();
        if (eventSystem == null)
            return false;

        var eventData = new PointerEventData(eventSystem)
        {
            button = PointerEventData.InputButton.Left,
            pointerId = -1
        };
        ExecuteEvents.Execute(button.gameObject, eventData, ExecuteEvents.pointerClickHandler);
        return true;
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

    private static int CountTextChildrenUnderPrefix(string prefix)
    {
        var count = 0;
        foreach (var transform in UnityEngine.Object.FindObjectsByType<Transform>(FindObjectsInactive.Include))
        {
            if (!transform.name.StartsWith(prefix, StringComparison.Ordinal))
                continue;
            if (transform.GetComponentInChildren<TMP_Text>(true) != null ||
                transform.GetComponentInChildren<Text>(true) != null)
                count++;
        }
        return count;
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
        sb.AppendLine("# BATTLE_79_PLAYMODE_PLAYABLE_ROSTER_VERIFICATION");
        sb.AppendLine();
        sb.AppendLine("- status: `" + output.status + "`");
        sb.AppendLine("- scene: `" + ProjectPath(ScenePath) + "`");
        sb.AppendLine("- playModeEntered: `" + output.playModeEntered + "`");
        sb.AppendLine("- eventSystemPresent: `" + output.eventSystemPresent + "`");
        sb.AppendLine("- roster rows actor/skill/characterCatalog: `" + output.actorRows + " / " + output.skillRows + " / " + output.characterCatalogRows + "`");
        sb.AppendLine("- character catalog name/head/battleBundle rows: `" + output.characterCatalogKoreanNameRows + " / " + output.characterCatalogHeadImageRows + " / " + output.characterCatalogBattleBundleRows + "`");
        sb.AppendLine("- generated runtime UI canvas/panel/actorRows/skillRows/skillTexts/characterRows/characterTexts: `" + output.rosterCanvasCount + " / " + output.rosterPanelCount + " / " + output.rosterRowButtonCount + " / " + output.rosterSkillRowCount + " / " + output.rosterSkillRowTextCount + " / " + output.rosterCharacterRowCount + " / " + output.rosterCharacterRowTextCount + "`");
        sb.AppendLine("- selection: `" + output.initialSelectedActorId + " -> " + output.afterActorRow2SelectedActorId + " -> " + output.afterActorRow1SelectedActorId + "`");
        sb.AppendLine("- attack HP: `player " + output.afterAttackPlayerHp + ", enemy " + output.afterAttackEnemyHp + "`");
        sb.AppendLine("- skill HP: `player " + output.afterSkillPlayerHp + ", enemy " + output.afterSkillEnemyHp + "`");
        sb.AppendLine("- reset HP: `player " + output.afterResetPlayerHp + ", enemy " + output.afterResetEnemyHp + "`");
        sb.AppendLine("- rosterDataVerified: `" + output.rosterDataVerified + "`");
        sb.AppendLine("- runtimeStartGeneratedUiVerified: `" + output.runtimeStartGeneratedUiVerified + "`");
        sb.AppendLine("- selectionVerified: `" + output.selectionVerified + "`");
        sb.AppendLine("- pointerClickLoopVerified: `" + output.pointerClickLoopVerified + "`");
        sb.AppendLine();
        sb.AppendLine("## Notes");
        sb.AppendLine("- This enters Unity PlayMode, lets `BattlePlayableRosterController.Start()` generate the roster UI, then executes pointer-click events through UGUI's event interfaces.");
        sb.AppendLine("- It proves the local roster overlay is playable through runtime UI objects. It still does not claim original xLua battle timing restoration.");
        if (!string.IsNullOrEmpty(output.exception))
        {
            sb.AppendLine();
            sb.AppendLine("## Exception");
            sb.AppendLine("- `" + output.exception + "`");
        }
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
        public int rosterCanvasCount;
        public int rosterPanelCount;
        public int rosterRowButtonCount;
        public int rosterSkillRowCount;
        public int rosterSkillRowTextCount;
        public int rosterCharacterRowCount;
        public int rosterCharacterRowTextCount;
        public bool actorRow0Present;
        public bool actorRow0Interactable;
        public bool actorRow1Present;
        public bool actorRow1Interactable;
        public bool actorRow2Present;
        public bool actorRow2Interactable;
        public bool attackButtonPresent;
        public bool skillButtonPresent;
        public bool resetButtonPresent;
        public bool actorRow2PointerClickExecuted;
        public bool actorRow1PointerClickExecuted;
        public bool attackPointerClickExecuted;
        public bool skillPointerClickExecuted;
        public bool resetPointerClickExecuted;
        public bool rosterDataVerified;
        public bool runtimeStartGeneratedUiVerified;
        public bool selectionVerified;
        public bool pointerClickLoopVerified;
        public string exception;
    }
}
