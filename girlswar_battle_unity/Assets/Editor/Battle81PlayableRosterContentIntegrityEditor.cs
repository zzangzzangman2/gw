using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using TMPro;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public static class Battle81PlayableRosterContentIntegrityEditor
{
    private const string ScenePath = "Assets/Scenes/Battle76PlayableRosterCandidate.unity";
    private const string ActorRosterCsvPath = "Assets/RestoreData/battle/Roster/BATTLE_FULL_PAYLOAD_ACTOR_ROSTER.csv";
    private const string SkillRosterCsvPath = "Assets/RestoreData/battle/Roster/BATTLE_FULL_PAYLOAD_SKILL_ROSTER.csv";
    private const string CharacterCatalogCsvPath = "Assets/RestoreData/battle/Roster/GIRLSWAR_CHARACTER_CATALOG.csv";
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_81_PLAYMODE_ROSTER_CONTENT_INTEGRITY.json";
    private const string ReportMdPath = @"C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_81_PLAYMODE_ROSTER_CONTENT_INTEGRITY.md";
    private const double TimeoutSeconds = 45.0;

    private static Result result;
    private static double startedAt;
    private static bool previousEnterPlayModeOptionsEnabled;
    private static EnterPlayModeOptions previousEnterPlayModeOptions;
    private static bool verificationStarted;
    private static int playFrames;

    [MenuItem("GirlsWar/Battle/BATTLE81 Verify Playable Roster Content Integrity")]
    public static void Verify()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        Directory.CreateDirectory(Path.GetDirectoryName(ReportMdPath));

        result = new Result
        {
            generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
            scenePath = ScenePath,
            actorRosterCsvPath = ActorRosterCsvPath,
            skillRosterCsvPath = SkillRosterCsvPath,
            characterCatalogCsvPath = CharacterCatalogCsvPath,
            sceneExists = File.Exists(ProjectPath(ScenePath)),
            actorRosterCsvExists = File.Exists(ProjectPath(ActorRosterCsvPath)),
            skillRosterCsvExists = File.Exists(ProjectPath(SkillRosterCsvPath)),
            characterCatalogCsvExists = File.Exists(ProjectPath(CharacterCatalogCsvPath))
        };

        if (!result.sceneExists || !result.actorRosterCsvExists || !result.skillRosterCsvExists || !result.characterCatalogCsvExists)
        {
            result.status = "blocked_required_file_missing";
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
            result.status = "content_integrity_verification_timeout";
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
            Finish(result.status == "battle81_playmode_roster_content_integrity_verified" ? 0 : 1);
        }
        catch (Exception ex)
        {
            result.status = "content_integrity_verification_exception";
            result.exception = ex.GetType().Name + ": " + ex.Message;
            Finish(1);
        }
    }

    private static void RunRuntimeVerification()
    {
        result.playModeEntered = EditorApplication.isPlaying;
        result.playFrameCountAtVerification = playFrames;
        result.eventSystemPresent = EventSystem.current != null || UnityEngine.Object.FindAnyObjectByType<EventSystem>() != null;

        var actorRows = ReadCsv(ProjectPath(ActorRosterCsvPath));
        var skillRows = ReadCsv(ProjectPath(SkillRosterCsvPath));
        var characterRows = ReadCsv(ProjectPath(CharacterCatalogCsvPath));
        result.expectedActorRows = actorRows.Count;
        result.expectedSkillRows = skillRows.Count;
        result.expectedCharacterRows = characterRows.Count;
        result.expectedTotalRows = actorRows.Count + skillRows.Count + characterRows.Count;

        var controller = UnityEngine.Object.FindAnyObjectByType<BattlePlayableRosterController>();
        result.controllerFound = controller != null;
        if (controller != null)
        {
            result.controllerActorRows = controller.actorRowCount;
            result.controllerSkillRows = controller.skillRowCount;
            result.controllerCharacterRows = controller.characterCatalogRowCount;
            result.controllerCharacterKoreanNameRows = controller.characterCatalogKoreanNameCount;
            result.controllerCharacterHeadImageRows = controller.characterCatalogHeadImageCount;
            result.controllerCharacterBattleBundleRows = controller.characterCatalogBattleBundleCount;
            result.readyLocalActorRows = controller.readyLocalActorCount;
            result.readyLocalSkillRows = controller.readyLocalSkillCount;
        }

        var scroll = FindObject<ScrollRect>("RosterScroll");
        var content = scroll != null ? scroll.content : null;
        result.scrollRectPresent = scroll != null;
        result.scrollViewportPresent = scroll != null && scroll.viewport != null;
        result.scrollContentPresent = content != null;
        result.scrollVertical = scroll != null && scroll.vertical;
        result.scrollHorizontal = scroll != null && scroll.horizontal;
        result.viewportMaskPresent = FindComponentOnObject<Mask>("RosterScroll") != null;
        var mask = FindComponentOnObject<Mask>("RosterScroll");
        result.viewportMaskGraphicHidden = mask != null && !mask.showMaskGraphic;
        if (content != null)
        {
            result.contentChildCount = content.childCount;
            result.contentHeight = content.sizeDelta.y;
            result.expectedContentHeight = ExpectedContentHeight(actorRows.Count, skillRows.Count, characterRows.Count);
        }

        for (var i = 0; i < actorRows.Count; i++)
        {
            var expected = ExpectedActorLabel(actorRows[i]);
            var actual = RowText("ActorRow_" + i);
            result.actorRowsPresent += string.IsNullOrEmpty(actual) ? 0 : 1;
            if (actual == expected)
                result.actorRowsTextMatched++;
            else
                AddMismatch("ActorRow_" + i, expected, actual);
        }

        for (var i = 0; i < skillRows.Count; i++)
        {
            var expected = ExpectedSkillLabel(skillRows[i]);
            var actual = RowText("SkillRow_" + i);
            result.skillRowsPresent += string.IsNullOrEmpty(actual) ? 0 : 1;
            if (actual == expected)
                result.skillRowsTextMatched++;
            else
                AddMismatch("SkillRow_" + i, expected, actual);
        }

        for (var i = 0; i < characterRows.Count; i++)
        {
            var expected = ExpectedCharacterLabel(characterRows[i]);
            var actual = RowText("CharacterRow_" + i);
            result.characterRowsPresent += string.IsNullOrEmpty(actual) ? 0 : 1;
            if (actual == expected)
                result.characterRowsTextMatched++;
            else
                AddMismatch("CharacterRow_" + i, expected, actual);
        }

        foreach (var text in UnityEngine.Object.FindObjectsByType<Text>(FindObjectsInactive.Include))
        {
            if (!IsUnderRosterCanvas(text.transform))
                continue;
            result.rosterUguiTextCount++;
            if (text.resizeTextForBestFit)
                result.rosterUguiTextBestFitCount++;
            if (text.horizontalOverflow == HorizontalWrapMode.Wrap)
                result.rosterUguiTextWrapCount++;
            if (text.verticalOverflow == VerticalWrapMode.Truncate)
                result.rosterUguiTextTruncateCount++;
        }

        foreach (var text in UnityEngine.Object.FindObjectsByType<TMP_Text>(FindObjectsInactive.Include))
        {
            if (!IsUnderRosterCanvas(text.transform))
                continue;
            result.rosterTmpTextCount++;
            if (text.enableAutoSizing)
                result.rosterTmpTextAutoSizeCount++;
            if (text.textWrappingMode == TextWrappingModes.NoWrap ||
                text.textWrappingMode == TextWrappingModes.PreserveWhitespaceNoWrap)
                result.rosterTmpTextNoWrapCount++;
            if (text.overflowMode == TextOverflowModes.Ellipsis ||
                text.overflowMode == TextOverflowModes.Truncate)
                result.rosterTmpTextEllipsisOrTruncateCount++;
            if (!text.raycastTarget)
                result.rosterTmpTextRaycastOffCount++;
        }

        result.rowCountVerified = result.expectedActorRows == 12 &&
            result.expectedSkillRows == 61 &&
            result.expectedCharacterRows == 131 &&
            result.contentChildCount == result.expectedTotalRows &&
            result.actorRowsPresent == result.expectedActorRows &&
            result.skillRowsPresent == result.expectedSkillRows &&
            result.characterRowsPresent == result.expectedCharacterRows;
        result.rowTextVerified = result.actorRowsTextMatched == result.expectedActorRows &&
            result.skillRowsTextMatched == result.expectedSkillRows &&
            result.characterRowsTextMatched == result.expectedCharacterRows &&
            result.mismatchCount == 0;
        result.scrollLayoutVerified = result.scrollRectPresent &&
            result.scrollViewportPresent &&
            result.scrollContentPresent &&
            result.scrollVertical &&
            !result.scrollHorizontal &&
            result.viewportMaskPresent &&
            result.viewportMaskGraphicHidden &&
            Mathf.Abs(result.contentHeight - result.expectedContentHeight) < 0.5f;
        result.tmpTextLayoutVerified = result.rosterTmpTextCount >= result.expectedTotalRows &&
            result.rosterTmpTextAutoSizeCount >= result.expectedTotalRows &&
            result.rosterTmpTextNoWrapCount >= result.expectedTotalRows &&
            result.rosterTmpTextEllipsisOrTruncateCount >= result.expectedTotalRows &&
            result.rosterTmpTextRaycastOffCount >= result.expectedTotalRows;
        result.uguiTextLayoutFallbackVerified = result.rosterUguiTextCount >= result.expectedTotalRows &&
            result.rosterUguiTextBestFitCount == 0 &&
            result.rosterUguiTextWrapCount >= result.expectedTotalRows &&
            result.rosterUguiTextTruncateCount >= result.expectedTotalRows;
        result.textLayoutVerified = result.tmpTextLayoutVerified || result.uguiTextLayoutFallbackVerified;

        result.status = result.playModeEntered &&
            result.eventSystemPresent &&
            result.controllerFound &&
            result.rowCountVerified &&
            result.rowTextVerified &&
            result.scrollLayoutVerified &&
            result.textLayoutVerified
            ? "battle81_playmode_roster_content_integrity_verified"
            : "battle81_playmode_roster_content_integrity_failed";
    }

    private static float ExpectedContentHeight(int actorCount, int skillCount, int characterCount)
    {
        var y = -4f - (actorCount * 34f) - (skillCount * 28f) - (characterCount * 26f);
        return Mathf.Max(420f, -y + 10f);
    }

    private static string ExpectedActorLabel(Dictionary<string, string> row)
    {
        return "ACT " + Get(row, "side") + " w" + Get(row, "waveNo") + " s" + Get(row, "slot") +
            " id " + Get(row, "heroDidOrMonsterId") + " model " + Get(row, "modelId") +
            " - " + Get(row, "battleListCandidateStatus");
    }

    private static string ExpectedSkillLabel(Dictionary<string, string> row)
    {
        return "SKL owner " + Get(row, "ownerHeroDid") + " skill " + Get(row, "skillDid") +
            " prefab " + Get(row, "prefabId") + " - " + Get(row, "battleListCandidateStatus");
    }

    private static string ExpectedCharacterLabel(Dictionary<string, string> row)
    {
        var name = Get(row, "nameKo");
        if (string.IsNullOrEmpty(name))
            name = Get(row, "nameKey");
        return "CAT id " + Get(row, "id") + " " + name +
            " r" + Get(row, "rarity") +
            " model " + Get(row, "modelId") +
            " head " + Get(row, "headImageExists") +
            " battle " + Get(row, "battleActorBundleExists");
    }

    private static string RowText(string rowName)
    {
        var transform = FindTransform(rowName);
        if (transform == null)
            return "";
        var tmpText = transform.GetComponentInChildren<TMP_Text>(true);
        if (tmpText != null)
            return tmpText.text;
        var uguiText = transform.GetComponentInChildren<Text>(true);
        return uguiText != null ? uguiText.text : "";
    }

    private static void AddMismatch(string rowName, string expected, string actual)
    {
        result.mismatchCount++;
        if (result.firstMismatchRowName.Length > 0)
            return;
        result.firstMismatchRowName = rowName;
        result.firstMismatchExpected = expected;
        result.firstMismatchActual = actual;
    }

    private static bool IsUnderRosterCanvas(Transform transform)
    {
        var current = transform;
        while (current != null)
        {
            if (current.name == "BattlePlayableRosterCanvas")
                return true;
            current = current.parent;
        }
        return false;
    }

    private static T FindObject<T>(string objectName) where T : Component
    {
        var transform = FindTransform(objectName);
        return transform != null ? transform.GetComponent<T>() : null;
    }

    private static T FindComponentOnObject<T>(string objectName) where T : Component
    {
        var transform = FindTransform(objectName);
        return transform != null ? transform.GetComponent<T>() : null;
    }

    private static Transform FindTransform(string objectName)
    {
        foreach (var transform in UnityEngine.Object.FindObjectsByType<Transform>(FindObjectsInactive.Include))
            if (transform.name == objectName)
                return transform;
        return null;
    }

    private static List<Dictionary<string, string>> ReadCsv(string path)
    {
        var resultRows = new List<Dictionary<string, string>>();
        var lines = File.ReadAllLines(path, Encoding.UTF8);
        if (lines.Length == 0)
            return resultRows;
        var headers = ParseCsvLine(lines[0]);
        for (var i = 1; i < lines.Length; i++)
        {
            if (string.IsNullOrWhiteSpace(lines[i]))
                continue;
            var values = ParseCsvLine(lines[i]);
            var row = new Dictionary<string, string>();
            for (var h = 0; h < headers.Count; h++)
                row[headers[h]] = h < values.Count ? values[h] : "";
            resultRows.Add(row);
        }
        return resultRows;
    }

    private static List<string> ParseCsvLine(string line)
    {
        var values = new List<string>();
        var current = new StringBuilder();
        var quoted = false;
        for (var i = 0; i < line.Length; i++)
        {
            var c = line[i];
            if (quoted)
            {
                if (c == '"' && i + 1 < line.Length && line[i + 1] == '"')
                {
                    current.Append('"');
                    i++;
                }
                else if (c == '"')
                    quoted = false;
                else
                    current.Append(c);
                continue;
            }
            if (c == '"')
                quoted = true;
            else if (c == ',')
            {
                values.Add(current.ToString());
                current.Length = 0;
            }
            else
                current.Append(c);
        }
        values.Add(current.ToString());
        return values;
    }

    private static string Get(Dictionary<string, string> row, string key)
    {
        string value;
        return row != null && row.TryGetValue(key, out value) ? value : "";
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
        sb.AppendLine("# BATTLE_81_PLAYMODE_ROSTER_CONTENT_INTEGRITY");
        sb.AppendLine();
        sb.AppendLine("- status: `" + output.status + "`");
        sb.AppendLine("- scene: `" + ProjectPath(ScenePath) + "`");
        sb.AppendLine("- expected actor/skill/character/total rows: `" + output.expectedActorRows + " / " + output.expectedSkillRows + " / " + output.expectedCharacterRows + " / " + output.expectedTotalRows + "`");
        sb.AppendLine("- present actor/skill/character/content children: `" + output.actorRowsPresent + " / " + output.skillRowsPresent + " / " + output.characterRowsPresent + " / " + output.contentChildCount + "`");
        sb.AppendLine("- text matched actor/skill/character: `" + output.actorRowsTextMatched + " / " + output.skillRowsTextMatched + " / " + output.characterRowsTextMatched + "`");
        sb.AppendLine("- catalog controller rows/name/head/battleBundle: `" + output.controllerCharacterRows + " / " + output.controllerCharacterKoreanNameRows + " / " + output.controllerCharacterHeadImageRows + " / " + output.controllerCharacterBattleBundleRows + "`");
        sb.AppendLine("- content height actual/expected: `" + output.contentHeight.ToString("0.0") + " / " + output.expectedContentHeight.ToString("0.0") + "`");
        sb.AppendLine("- viewport mask present/hidden: `" + output.viewportMaskPresent + " / " + output.viewportMaskGraphicHidden + "`");
        sb.AppendLine("- roster UGUI text count/bestFit/wrap/truncate: `" + output.rosterUguiTextCount + " / " + output.rosterUguiTextBestFitCount + " / " + output.rosterUguiTextWrapCount + " / " + output.rosterUguiTextTruncateCount + "`");
        sb.AppendLine("- roster TMP text count/autosize/noWrap/ellipsisOrTruncate/raycastOff: `" + output.rosterTmpTextCount + " / " + output.rosterTmpTextAutoSizeCount + " / " + output.rosterTmpTextNoWrapCount + " / " + output.rosterTmpTextEllipsisOrTruncateCount + " / " + output.rosterTmpTextRaycastOffCount + "`");
        sb.AppendLine("- rowCountVerified: `" + output.rowCountVerified + "`");
        sb.AppendLine("- rowTextVerified: `" + output.rowTextVerified + "`");
        sb.AppendLine("- scrollLayoutVerified: `" + output.scrollLayoutVerified + "`");
        sb.AppendLine("- tmpTextLayoutVerified: `" + output.tmpTextLayoutVerified + "`");
        sb.AppendLine("- uguiTextLayoutFallbackVerified: `" + output.uguiTextLayoutFallbackVerified + "`");
        sb.AppendLine("- textLayoutVerified: `" + output.textLayoutVerified + "`");
        if (output.mismatchCount > 0)
        {
            sb.AppendLine("- mismatchCount: `" + output.mismatchCount + "`");
            sb.AppendLine("- firstMismatch: `" + output.firstMismatchRowName + "`");
            sb.AppendLine("- expected: `" + output.firstMismatchExpected + "`");
            sb.AppendLine("- actual: `" + output.firstMismatchActual + "`");
        }
        sb.AppendLine();
        sb.AppendLine("## Notes");
        sb.AppendLine("- This enters PlayMode and verifies every actor/skill payload row plus every full character catalog row label in the generated roster UI against the source CSV rows.");
        sb.AppendLine("- It also checks scroll content height, mask presence, and TMP autosize/no-wrap/overflow/raycast state, with a UGUI fallback for older generated scenes.");
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
        public string actorRosterCsvPath;
        public string skillRosterCsvPath;
        public string characterCatalogCsvPath;
        public bool sceneExists;
        public bool actorRosterCsvExists;
        public bool skillRosterCsvExists;
        public bool characterCatalogCsvExists;
        public bool sceneOpened;
        public bool domainReloadDisabledForVerification;
        public bool playModeEntered;
        public int playFrameCountAtVerification;
        public bool eventSystemPresent;
        public bool controllerFound;
        public int controllerActorRows;
        public int controllerSkillRows;
        public int controllerCharacterRows;
        public int controllerCharacterKoreanNameRows;
        public int controllerCharacterHeadImageRows;
        public int controllerCharacterBattleBundleRows;
        public int readyLocalActorRows;
        public int readyLocalSkillRows;
        public int expectedActorRows;
        public int expectedSkillRows;
        public int expectedCharacterRows;
        public int expectedTotalRows;
        public bool scrollRectPresent;
        public bool scrollViewportPresent;
        public bool scrollContentPresent;
        public bool scrollVertical;
        public bool scrollHorizontal;
        public bool viewportMaskPresent;
        public bool viewportMaskGraphicHidden;
        public int contentChildCount;
        public float contentHeight;
        public float expectedContentHeight;
        public int actorRowsPresent;
        public int skillRowsPresent;
        public int characterRowsPresent;
        public int actorRowsTextMatched;
        public int skillRowsTextMatched;
        public int characterRowsTextMatched;
        public int mismatchCount;
        public string firstMismatchRowName = "";
        public string firstMismatchExpected = "";
        public string firstMismatchActual = "";
        public int rosterUguiTextCount;
        public int rosterUguiTextBestFitCount;
        public int rosterUguiTextWrapCount;
        public int rosterUguiTextTruncateCount;
        public int rosterTmpTextCount;
        public int rosterTmpTextAutoSizeCount;
        public int rosterTmpTextNoWrapCount;
        public int rosterTmpTextEllipsisOrTruncateCount;
        public int rosterTmpTextRaycastOffCount;
        public bool rowCountVerified;
        public bool rowTextVerified;
        public bool scrollLayoutVerified;
        public bool tmpTextLayoutVerified;
        public bool uguiTextLayoutFallbackVerified;
        public bool textLayoutVerified;
        public string exception;
    }
}
