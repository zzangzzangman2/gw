using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using TMPro;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public sealed class BattlePlayableRosterController : MonoBehaviour
{
    private static readonly string[] TmpFontResourceNames =
    {
        "GirlsWarGeneratedTMPFontAsset",
        "Fonts & Materials/LiberationSans SDF"
    };
    public string actorRosterCsvPath = "Assets/RestoreData/battle/Roster/BATTLE_FULL_PAYLOAD_ACTOR_ROSTER.csv";
    public string skillRosterCsvPath = "Assets/RestoreData/battle/Roster/BATTLE_FULL_PAYLOAD_SKILL_ROSTER.csv";
    public string characterCatalogCsvPath = "Assets/RestoreData/battle/Roster/GIRLSWAR_CHARACTER_CATALOG.csv";
    public string proposalJsonPath = "Assets/RestoreData/battle/Roster/BATTLE_FULL_PAYLOAD_LIST_CANDIDATE_PROPOSAL.json";
    public bool buildOnStart = true;

    public int actorRowCount;
    public int skillRowCount;
    public int characterCatalogRowCount;
    public int characterCatalogKoreanNameCount;
    public int characterCatalogHeadImageCount;
    public int characterCatalogBattleBundleCount;
    public int readyLocalActorCount;
    public int readyLocalSkillCount;
    public string selectedActorId = "";
    public int playerHpCurrent;
    public int enemyHpCurrent;
    public string lastActionLog = "";

    private readonly List<Dictionary<string, string>> actorRows = new List<Dictionary<string, string>>();
    private readonly List<Dictionary<string, string>> skillRows = new List<Dictionary<string, string>>();
    private readonly List<Dictionary<string, string>> characterRows = new List<Dictionary<string, string>>();
    private static TMP_FontAsset cachedTmpFontAsset;
    private static bool tmpFontAssetLookupAttempted;
    private TMP_Text selectedText;
    private TMP_Text logText;
    private TMP_Text hpText;
    private int selectedActorIndex = -1;
    private int playerHp = 1000;
    private int enemyHp = 1000;

    private void Start()
    {
        if (buildOnStart)
            BuildPlayableRosterUi();
    }

    public void BuildPlayableRosterUi()
    {
        LoadRoster();
        EnsureEventSystem();
        ClearGeneratedUi();

        var camera = Camera.main ?? UnityEngine.Object.FindAnyObjectByType<Camera>();
        var canvasGo = new GameObject("BattlePlayableRosterCanvas", typeof(Canvas), typeof(CanvasScaler), typeof(GraphicRaycaster));
        canvasGo.transform.SetParent(transform, false);

        var canvas = canvasGo.GetComponent<Canvas>();
        canvas.renderMode = RenderMode.ScreenSpaceCamera;
        canvas.worldCamera = camera;
        canvas.planeDistance = 1f;
        canvas.sortingOrder = 5000;

        var scaler = canvasGo.GetComponent<CanvasScaler>();
        scaler.uiScaleMode = CanvasScaler.ScaleMode.ScaleWithScreenSize;
        scaler.referenceResolution = new Vector2(1920f, 855f);
        scaler.matchWidthOrHeight = 0.5f;

        var root = CreatePanel(canvasGo.transform, "BattlePlayableRosterPanel", new Color(0.05f, 0.05f, 0.065f, 0.78f));
        SetRect(root, new Vector2(0f, 1f), new Vector2(0f, 1f), new Vector2(14f, -86f), new Vector2(520f, 650f), new Vector2(0f, 1f));

        CreateText(root, "Title", "Battle payload roster", 22, FontStyle.Bold, TextAnchor.MiddleLeft, new Vector2(16f, -18f), new Vector2(488f, 34f), Color.white);
        var summary = "actors " + actorRowCount + " (" + readyLocalActorCount + " ready) / skills " + skillRowCount + " (" + readyLocalSkillCount + " ready) / characters " + characterCatalogRowCount;
        CreateText(root, "Summary", summary, 15, FontStyle.Normal, TextAnchor.MiddleLeft, new Vector2(16f, -50f), new Vector2(488f, 28f), new Color(0.78f, 0.86f, 1f, 1f));

        var scroll = CreateScroll(root, new Vector2(16f, -88f), new Vector2(488f, 398f));
        BuildRosterRows(scroll.content);

        selectedText = CreateText(root, "SelectedActor", "Select a ready row", 16, FontStyle.Bold, TextAnchor.MiddleLeft, new Vector2(16f, -504f), new Vector2(488f, 28f), Color.white);
        hpText = CreateText(root, "Hp", "HP 1000 / Enemy 1000", 15, FontStyle.Normal, TextAnchor.MiddleLeft, new Vector2(16f, -534f), new Vector2(488f, 24f), new Color(1f, 0.93f, 0.62f, 1f));

        var attack = CreateButton(root, "AttackButton", "Attack", new Vector2(16f, -570f), new Vector2(112f, 34f));
        attack.onClick.AddListener(delegate { UseAction(false); });
        var skill = CreateButton(root, "SkillButton", "Skill", new Vector2(138f, -570f), new Vector2(112f, 34f));
        skill.onClick.AddListener(delegate { UseAction(true); });
        var reset = CreateButton(root, "ResetButton", "Reset", new Vector2(260f, -570f), new Vector2(112f, 34f));
        reset.onClick.AddListener(ResetBattleState);

        logText = CreateText(root, "BattleLog", "Ready. Missing and unresolved rows stay visible but are not promoted as playable actors.", 13, FontStyle.Normal, TextAnchor.UpperLeft, new Vector2(16f, -612f), new Vector2(488f, 34f), new Color(0.86f, 0.89f, 0.92f, 1f));
        UpdateHp();
        SelectFirstReadyActor();
    }

    public void BuildInEditor()
    {
        BuildPlayableRosterUi();
    }

    public void LoadRoster()
    {
        actorRows.Clear();
        skillRows.Clear();
        characterRows.Clear();
        actorRows.AddRange(ReadCsv(ProjectPath(actorRosterCsvPath)));
        skillRows.AddRange(ReadCsv(ProjectPath(skillRosterCsvPath)));
        characterRows.AddRange(ReadCsv(ProjectPath(characterCatalogCsvPath)));

        actorRowCount = actorRows.Count;
        skillRowCount = skillRows.Count;
        characterCatalogRowCount = characterRows.Count;
        characterCatalogKoreanNameCount = CountNonEmptyRows(characterRows, "nameKo");
        characterCatalogHeadImageCount = CountRows(characterRows, "headImageExists", "True");
        characterCatalogBattleBundleCount = CountRows(characterRows, "battleActorBundleExists", "True");
        readyLocalActorCount = CountRows(actorRows, "battleListCandidateStatus", "ready_local");
        readyLocalSkillCount = CountRows(skillRows, "battleListCandidateStatus", "ready_local");
    }

    private void BuildRosterRows(RectTransform content)
    {
        var y = -4f;
        for (var i = 0; i < actorRows.Count; i++)
        {
            var row = actorRows[i];
            var index = i;
            var status = Get(row, "battleListCandidateStatus");
            var label = "ACT " + Get(row, "side") + " w" + Get(row, "waveNo") + " s" + Get(row, "slot") + " id " + Get(row, "heroDidOrMonsterId") +
                " model " + Get(row, "modelId") + " - " + status;
            var button = CreateRowButton(content, "ActorRow_" + i, label, y, StatusColor(status));
            button.interactable = status == "ready_local";
            button.onClick.AddListener(delegate { SelectActor(index); });
            y -= 34f;
        }

        for (var i = 0; i < skillRows.Count; i++)
        {
            var row = skillRows[i];
            var status = Get(row, "battleListCandidateStatus");
            var label = "SKL owner " + Get(row, "ownerHeroDid") + " skill " + Get(row, "skillDid") + " prefab " + Get(row, "prefabId") + " - " + status;
            CreateRowLabel(content, "SkillRow_" + i, label, y, StatusColor(status));
            y -= 28f;
        }

        for (var i = 0; i < characterRows.Count; i++)
        {
            var row = characterRows[i];
            CreateRowLabel(content, "CharacterRow_" + i, CharacterCatalogLabel(row), y, CharacterCatalogColor(row));
            y -= 26f;
        }
        content.sizeDelta = new Vector2(content.sizeDelta.x, Mathf.Max(420f, -y + 10f));
    }

    private void SelectFirstReadyActor()
    {
        for (var i = 0; i < actorRows.Count; i++)
        {
            if (Get(actorRows[i], "battleListCandidateStatus") == "ready_local")
            {
                SelectActor(i);
                return;
            }
        }
    }

    private void SelectActor(int index)
    {
        if (index < 0 || index >= actorRows.Count)
            return;
        selectedActorIndex = index;
        var row = actorRows[index];
        selectedActorId = Get(row, "heroDidOrMonsterId");
        var skills = CountOwnerSkills(selectedActorId, true);
        SetGeneratedText(selectedText, "Selected " + selectedActorId + " / " + Get(row, "nameKey") + " / ready skills " + skills);
        lastActionLog = "Selected source-backed playable actor " + selectedActorId + ".";
        SetGeneratedText(logText, lastActionLog);
    }

    private void UseAction(bool skill)
    {
        if (selectedActorIndex < 0 || selectedActorIndex >= actorRows.Count)
            return;
        var row = actorRows[selectedActorIndex];
        if (Get(row, "battleListCandidateStatus") != "ready_local")
            return;

        var actorId = Get(row, "heroDidOrMonsterId");
        var readySkills = CountOwnerSkills(actorId, true);
        var damage = skill && readySkills > 0 ? 155 : 80;
        enemyHp = Mathf.Max(0, enemyHp - damage);
        if (enemyHp > 0)
            playerHp = Mathf.Max(0, playerHp - 42);
        UpdateHp();
        lastActionLog = actorId + (skill ? " skill" : " attack") + " dealt " + damage + ". This local loop uses source-backed roster readiness, not original xLua timing.";
        SetGeneratedText(logText, lastActionLog);
    }

    private void ResetBattleState()
    {
        playerHp = 1000;
        enemyHp = 1000;
        UpdateHp();
        lastActionLog = "Battle state reset.";
        SetGeneratedText(logText, lastActionLog);
    }

    private void UpdateHp()
    {
        playerHpCurrent = playerHp;
        enemyHpCurrent = enemyHp;
        SetGeneratedText(hpText, "HP " + playerHp + " / Enemy " + enemyHp);
    }

    private int CountOwnerSkills(string owner, bool readyOnly)
    {
        var count = 0;
        foreach (var row in skillRows)
        {
            if (Get(row, "ownerHeroDid") != owner)
                continue;
            if (readyOnly && Get(row, "battleListCandidateStatus") != "ready_local")
                continue;
            count++;
        }
        return count;
    }

    private void ClearGeneratedUi()
    {
        var children = new List<GameObject>();
        foreach (Transform child in transform)
            if (child.name == "BattlePlayableRosterCanvas")
                children.Add(child.gameObject);
        foreach (var child in children)
            DestroyGeneratedObject(child);
    }

    private static void EnsureEventSystem()
    {
        if (UnityEngine.Object.FindAnyObjectByType<EventSystem>() != null)
            return;
        var go = new GameObject("EventSystem", typeof(EventSystem), typeof(StandaloneInputModule));
        go.transform.SetAsLastSibling();
    }

    private static ScrollRect CreateScroll(Transform parent, Vector2 anchoredPosition, Vector2 size)
    {
        var viewport = CreatePanel(parent, "RosterScroll", new Color(0f, 0f, 0f, 0.22f));
        SetRect(viewport, new Vector2(0f, 1f), new Vector2(0f, 1f), anchoredPosition, size, new Vector2(0f, 1f));
        var mask = viewport.gameObject.AddComponent<Mask>();
        mask.showMaskGraphic = false;
        var scroll = viewport.gameObject.AddComponent<ScrollRect>();
        scroll.horizontal = false;
        scroll.vertical = true;
        scroll.movementType = ScrollRect.MovementType.Clamped;

        var content = new GameObject("Content", typeof(RectTransform));
        content.transform.SetParent(viewport, false);
        var contentRect = content.GetComponent<RectTransform>();
        contentRect.anchorMin = new Vector2(0f, 1f);
        contentRect.anchorMax = new Vector2(1f, 1f);
        contentRect.pivot = new Vector2(0f, 1f);
        contentRect.anchoredPosition = Vector2.zero;
        contentRect.sizeDelta = new Vector2(0f, size.y);
        scroll.viewport = viewport;
        scroll.content = contentRect;
        return scroll;
    }

    private static RectTransform CreatePanel(Transform parent, string name, Color color)
    {
        var go = new GameObject(name, typeof(RectTransform), typeof(Image));
        go.transform.SetParent(parent, false);
        var image = go.GetComponent<Image>();
        image.color = color;
        image.raycastTarget = true;
        return go.GetComponent<RectTransform>();
    }

    private static Button CreateButton(Transform parent, string name, string label, Vector2 anchoredPosition, Vector2 size)
    {
        var rect = CreatePanel(parent, name, new Color(0.96f, 0.72f, 0.2f, 0.92f));
        SetRect(rect, new Vector2(0f, 1f), new Vector2(0f, 1f), anchoredPosition, size, new Vector2(0f, 1f));
        var button = rect.gameObject.AddComponent<Button>();
        var text = CreateText(rect, "Label", label, 15, FontStyle.Bold, TextAnchor.MiddleCenter, Vector2.zero, size, new Color(0.12f, 0.08f, 0.02f, 1f));
        text.raycastTarget = false;
        return button;
    }

    private static Button CreateRowButton(Transform parent, string name, string label, float y, Color color)
    {
        var rect = CreatePanel(parent, name, color);
        SetRect(rect, new Vector2(0f, 1f), new Vector2(1f, 1f), new Vector2(0f, y), new Vector2(0f, 30f), new Vector2(0f, 1f));
        var button = rect.gameObject.AddComponent<Button>();
        var text = CreateText(rect, "Text", label, 12, FontStyle.Normal, TextAnchor.MiddleLeft, new Vector2(8f, 0f), new Vector2(-16f, 28f), Color.white);
        text.raycastTarget = false;
        return button;
    }

    private static void CreateRowLabel(Transform parent, string name, string label, float y, Color color)
    {
        var rect = CreatePanel(parent, name, new Color(color.r, color.g, color.b, 0.42f));
        SetRect(rect, new Vector2(0f, 1f), new Vector2(1f, 1f), new Vector2(0f, y), new Vector2(0f, 24f), new Vector2(0f, 1f));
        CreateText(rect, "Text", label, 11, FontStyle.Normal, TextAnchor.MiddleLeft, new Vector2(8f, 0f), new Vector2(-16f, 22f), new Color(0.86f, 0.88f, 0.9f, 1f));
    }

    private static TMP_Text CreateText(Transform parent, string name, string value, int fontSize, FontStyle style, TextAnchor anchor, Vector2 anchoredPosition, Vector2 size, Color color)
    {
        var go = new GameObject(name, typeof(RectTransform), typeof(TextMeshProUGUI));
        go.transform.SetParent(parent, false);
        var rect = go.GetComponent<RectTransform>();
        var anchorMax = size.x < 0f ? new Vector2(1f, 1f) : new Vector2(0f, 1f);
        SetRect(rect, new Vector2(0f, 1f), anchorMax, anchoredPosition, size, new Vector2(0f, 1f));
        var text = go.GetComponent<TextMeshProUGUI>();
        var fontAsset = GetTmpFontAsset();
        if (fontAsset != null)
        {
            text.font = fontAsset;
            if (fontAsset.material != null)
                text.fontSharedMaterial = fontAsset.material;
        }
        text.text = value;
        text.fontSize = fontSize;
        text.fontStyle = ToTmpFontStyle(style);
        text.alignment = ToTmpAlignment(anchor);
        text.color = color;
        text.richText = false;
        text.enableAutoSizing = true;
        text.fontSizeMin = Mathf.Max(8f, fontSize - 6f);
        text.fontSizeMax = fontSize;
        text.textWrappingMode = TextWrappingModes.NoWrap;
        text.overflowMode = TextOverflowModes.Ellipsis;
        text.raycastTarget = false;
        if (fontAsset != null)
            text.ForceMeshUpdate(true, true);
        else
        {
            text.enabled = false;
            CreateLegacyTextFallback(go.transform, value, fontSize, style, anchor, color);
        }
        return text;
    }

    private static TMP_FontAsset GetTmpFontAsset()
    {
        if (cachedTmpFontAsset != null)
            return cachedTmpFontAsset;
        if (tmpFontAssetLookupAttempted)
            return null;
        tmpFontAssetLookupAttempted = true;

        foreach (var existingText in UnityEngine.Object.FindObjectsByType<TMP_Text>(FindObjectsInactive.Include, FindObjectsSortMode.None))
        {
            if (existingText == null || existingText.font == null || existingText.font.material == null)
                continue;
            cachedTmpFontAsset = existingText.font;
            return cachedTmpFontAsset;
        }

        var settings = TMP_Settings.LoadDefaultSettings();
        if (settings != null && TMP_Settings.defaultFontAsset != null)
        {
            cachedTmpFontAsset = TMP_Settings.defaultFontAsset;
            return cachedTmpFontAsset;
        }

        foreach (var fontResourceName in TmpFontResourceNames)
        {
            var resourceFontAsset = Resources.Load<TMP_FontAsset>(fontResourceName);
            if (resourceFontAsset == null || resourceFontAsset.material == null)
                continue;
            cachedTmpFontAsset = resourceFontAsset;
            return cachedTmpFontAsset;
        }

        return null;
    }

    private static void CreateLegacyTextFallback(Transform parent, string value, int fontSize, FontStyle style, TextAnchor anchor, Color color)
    {
        var go = new GameObject("LegacyTextFallback", typeof(RectTransform), typeof(Text));
        go.transform.SetParent(parent, false);
        var rect = go.GetComponent<RectTransform>();
        rect.anchorMin = Vector2.zero;
        rect.anchorMax = Vector2.one;
        rect.pivot = new Vector2(0.5f, 0.5f);
        rect.offsetMin = Vector2.zero;
        rect.offsetMax = Vector2.zero;
        rect.localScale = Vector3.one;
        rect.localRotation = Quaternion.identity;

        var text = go.GetComponent<Text>();
        text.text = value;
        text.font = GetLegacyFont();
        text.fontSize = fontSize;
        text.fontStyle = style;
        text.alignment = anchor;
        text.color = color;
        text.horizontalOverflow = HorizontalWrapMode.Wrap;
        text.verticalOverflow = VerticalWrapMode.Truncate;
        text.raycastTarget = false;
    }

    private static void SetGeneratedText(TMP_Text text, string value)
    {
        if (text == null)
            return;
        text.text = value;
        var fallback = text.GetComponentInChildren<Text>(true);
        if (fallback != null)
            fallback.text = value;
        if (text.font != null)
            text.ForceMeshUpdate(true, true);
    }

    private static Font GetLegacyFont()
    {
        return Resources.GetBuiltinResource<Font>("LegacyRuntime.ttf");
    }

    private static void SetRect(RectTransform rect, Vector2 anchorMin, Vector2 anchorMax, Vector2 anchoredPosition, Vector2 sizeDelta, Vector2 pivot)
    {
        rect.anchorMin = anchorMin;
        rect.anchorMax = anchorMax;
        rect.pivot = pivot;
        rect.anchoredPosition = anchoredPosition;
        rect.sizeDelta = sizeDelta;
        rect.localScale = Vector3.one;
        rect.localRotation = Quaternion.identity;
    }

    private static Color StatusColor(string status)
    {
        if (status == "ready_local")
            return new Color(0.11f, 0.42f, 0.24f, 0.72f);
        if (status == "source_known_missing_bundle")
            return new Color(0.55f, 0.37f, 0.08f, 0.72f);
        return new Color(0.28f, 0.28f, 0.34f, 0.72f);
    }

    private static string CharacterCatalogLabel(Dictionary<string, string> row)
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

    private static Color CharacterCatalogColor(Dictionary<string, string> row)
    {
        if (Get(row, "battleActorBundleExists") == "True")
            return new Color(0.09f, 0.34f, 0.38f, 0.58f);
        if (Get(row, "headImageExists") == "True")
            return new Color(0.18f, 0.25f, 0.38f, 0.50f);
        return new Color(0.28f, 0.25f, 0.30f, 0.50f);
    }

    private static int CountRows(List<Dictionary<string, string>> rows, string key, string expected)
    {
        var count = 0;
        foreach (var row in rows)
            if (Get(row, key) == expected)
                count++;
        return count;
    }

    private static int CountNonEmptyRows(List<Dictionary<string, string>> rows, string key)
    {
        var count = 0;
        foreach (var row in rows)
            if (!string.IsNullOrEmpty(Get(row, key)))
                count++;
        return count;
    }

    private static string Get(Dictionary<string, string> row, string key)
    {
        string value;
        return row != null && row.TryGetValue(key, out value) ? value : "";
    }

    private static string ProjectPath(string projectRelativePath)
    {
        return Path.GetFullPath(Path.Combine(Application.dataPath, "..", projectRelativePath));
    }

    private static List<Dictionary<string, string>> ReadCsv(string path)
    {
        var result = new List<Dictionary<string, string>>();
        var fullPath = ProjectPath(path);
        if (!File.Exists(fullPath))
            return result;
        var lines = File.ReadAllLines(fullPath, Encoding.UTF8);
        if (lines.Length == 0)
            return result;
        var headers = ParseCsvLine(lines[0]);
        for (var i = 1; i < lines.Length; i++)
        {
            if (string.IsNullOrWhiteSpace(lines[i]))
                continue;
            var values = ParseCsvLine(lines[i]);
            var row = new Dictionary<string, string>();
            for (var h = 0; h < headers.Count; h++)
                row[headers[h]] = h < values.Count ? values[h] : "";
            result.Add(row);
        }
        return result;
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

    private static FontStyles ToTmpFontStyle(FontStyle style)
    {
        switch (style)
        {
            case FontStyle.Bold:
                return FontStyles.Bold;
            case FontStyle.Italic:
                return FontStyles.Italic;
            case FontStyle.BoldAndItalic:
                return FontStyles.Bold | FontStyles.Italic;
            default:
                return FontStyles.Normal;
        }
    }

    private static TextAlignmentOptions ToTmpAlignment(TextAnchor anchor)
    {
        switch (anchor)
        {
            case TextAnchor.UpperLeft:
                return TextAlignmentOptions.TopLeft;
            case TextAnchor.UpperCenter:
                return TextAlignmentOptions.Top;
            case TextAnchor.UpperRight:
                return TextAlignmentOptions.TopRight;
            case TextAnchor.MiddleLeft:
                return TextAlignmentOptions.MidlineLeft;
            case TextAnchor.MiddleCenter:
                return TextAlignmentOptions.Midline;
            case TextAnchor.MiddleRight:
                return TextAlignmentOptions.MidlineRight;
            case TextAnchor.LowerLeft:
                return TextAlignmentOptions.BottomLeft;
            case TextAnchor.LowerCenter:
                return TextAlignmentOptions.Bottom;
            case TextAnchor.LowerRight:
                return TextAlignmentOptions.BottomRight;
            default:
                return TextAlignmentOptions.MidlineLeft;
        }
    }

    private static void DestroyGeneratedObject(UnityEngine.Object obj)
    {
        if (Application.isPlaying)
            Destroy(obj);
        else
            DestroyImmediate(obj);
    }
}
