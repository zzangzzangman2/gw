using System;
using System.IO;
using System.Text;
using TMPro;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public static class Battle83MaskStencilTmpScaleAuditEditor
{
    private const string ScenePath = "Assets/Scenes/Battle76PlayableRosterCandidate.unity";
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_83_PLAYMODE_MASK_STENCIL_TMP_SCALE_AUDIT.json";
    private const string ReportMdPath = @"C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_83_PLAYMODE_MASK_STENCIL_TMP_SCALE_AUDIT.md";
    private const int ExpectedActorRows = 12;
    private const int ExpectedSkillRows = 61;
    private const int ExpectedCharacterRows = 131;
    private const int ExpectedTotalRows = ExpectedActorRows + ExpectedSkillRows + ExpectedCharacterRows;
    private const double TimeoutSeconds = 45.0;

    private static Result result;
    private static double startedAt;
    private static bool previousEnterPlayModeOptionsEnabled;
    private static EnterPlayModeOptions previousEnterPlayModeOptions;
    private static bool verificationStarted;
    private static int playFrames;

    [MenuItem("GirlsWar/Battle/BATTLE83 Verify Mask Stencil TMP Scale")]
    public static void Verify()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        Directory.CreateDirectory(Path.GetDirectoryName(ReportMdPath));

        result = new Result
        {
            generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
            scenePath = ScenePath,
            sceneExists = File.Exists(ProjectPath(ScenePath)),
            expectedActorRows = ExpectedActorRows,
            expectedSkillRows = ExpectedSkillRows,
            expectedCharacterRows = ExpectedCharacterRows,
            expectedTotalRows = ExpectedTotalRows
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
            result.status = "mask_stencil_tmp_scale_audit_timeout";
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
            Finish(result.status == "battle83_mask_stencil_tmp_scale_verified" ? 0 : 1);
        }
        catch (Exception ex)
        {
            result.status = "mask_stencil_tmp_scale_audit_exception";
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
        if (controller != null)
        {
            result.controllerActorRows = controller.actorRowCount;
            result.controllerSkillRows = controller.skillRowCount;
            result.controllerCharacterRows = controller.characterCatalogRowCount;
            result.readyLocalActorRows = controller.readyLocalActorCount;
            result.readyLocalSkillRows = controller.readyLocalSkillCount;
        }

        Canvas.ForceUpdateCanvases();

        var canvas = FindObject<Canvas>("BattlePlayableRosterCanvas");
        result.rosterCanvasPresent = canvas != null;
        result.rosterCanvasSortingOrder = canvas != null ? canvas.sortingOrder : int.MinValue;
        result.rosterGraphicRaycasterPresent = canvas != null && canvas.GetComponent<GraphicRaycaster>() != null;

        var scroll = FindObject<ScrollRect>("RosterScroll");
        var mask = FindObject<Mask>("RosterScroll");
        result.scrollRectPresent = scroll != null;
        result.scrollViewportPresent = scroll != null && scroll.viewport != null;
        result.scrollContentPresent = scroll != null && scroll.content != null;
        result.scrollVerticalOnly = scroll != null && scroll.vertical && !scroll.horizontal;
        result.maskPresent = mask != null;
        result.maskEnabled = mask != null && mask.enabled;
        result.maskGraphicHidden = mask != null && !mask.showMaskGraphic;
        result.maskHasGraphic = mask != null && mask.graphic != null;
        result.maskGraphicRaycastTarget = mask != null && mask.graphic != null && mask.graphic.raycastTarget;
        result.contentChildCount = scroll != null && scroll.content != null ? scroll.content.childCount : 0;

        CountRows(scroll != null ? scroll.content : null);
        CountTmpText();
        CountLegacyFallbackText();
        CountMaskedGraphics(mask != null ? mask.transform : null);

        result.rosterDataVerified = result.controllerActorRows == ExpectedActorRows &&
            result.controllerSkillRows == ExpectedSkillRows &&
            result.controllerCharacterRows == ExpectedCharacterRows &&
            result.readyLocalActorRows == 3 &&
            result.readyLocalSkillRows == 12 &&
            result.contentChildCount == ExpectedTotalRows;
        result.rowGeometryVerified = result.rowTransformCount == ExpectedTotalRows &&
            result.rowLocalScaleIdentityCount == ExpectedTotalRows &&
            result.rowNonZeroRectCount == ExpectedTotalRows;
        result.tmpScaleAutosizeVerified = result.rosterTmpTextCount >= ExpectedTotalRows &&
            result.rosterTmpTextEnabledCount >= ExpectedTotalRows &&
            result.rosterTmpTextFontAssignedCount >= ExpectedTotalRows &&
            result.rosterTmpTextMaterialAssignedCount >= ExpectedTotalRows &&
            result.rosterTmpTextAutoSizeCount >= ExpectedTotalRows &&
            result.rosterTmpTextNoWrapCount >= ExpectedTotalRows &&
            result.rosterTmpTextEllipsisOrTruncateCount >= ExpectedTotalRows &&
            result.rosterTmpTextRaycastOffCount >= ExpectedTotalRows &&
            result.rosterTmpTextLocalScaleIdentityCount >= ExpectedTotalRows &&
            result.rosterTmpTextNonZeroRectCount >= ExpectedTotalRows &&
            result.rosterTmpTextFontSizeBoundsValidCount >= ExpectedTotalRows;
        result.maskStencilVerified = result.maskPresent &&
            result.maskEnabled &&
            result.maskGraphicHidden &&
            result.maskHasGraphic &&
            result.maskedGraphicCount >= ExpectedTotalRows &&
            result.maskedGraphicStencilPropertyCount >= ExpectedTotalRows &&
            result.maskedGraphicPositiveStencilRefCount >= ExpectedTotalRows;
        result.routeSiblingVerified = result.rosterCanvasPresent &&
            result.rosterCanvasSortingOrder == 5000 &&
            result.rosterGraphicRaycasterPresent &&
            result.scrollRectPresent &&
            result.scrollViewportPresent &&
            result.scrollContentPresent &&
            result.scrollVerticalOnly;

        result.status = result.playModeEntered &&
            result.eventSystemPresent &&
            result.controllerFound &&
            result.rosterDataVerified &&
            result.routeSiblingVerified &&
            result.rowGeometryVerified &&
            result.tmpScaleAutosizeVerified &&
            result.maskStencilVerified
            ? "battle83_mask_stencil_tmp_scale_verified"
            : "battle83_mask_stencil_tmp_scale_failed";
    }

    private static void CountRows(RectTransform content)
    {
        if (content == null)
            return;

        foreach (Transform child in content)
        {
            if (!IsRosterRow(child.name))
                continue;
            result.rowTransformCount++;
            var rect = child.GetComponent<RectTransform>();
            if (rect != null && IsVectorOne(rect.localScale))
                result.rowLocalScaleIdentityCount++;
            if (rect != null && rect.rect.width > 0.5f && rect.rect.height > 0.5f)
                result.rowNonZeroRectCount++;
        }
    }

    private static void CountTmpText()
    {
        foreach (var text in UnityEngine.Object.FindObjectsByType<TMP_Text>(FindObjectsInactive.Include))
        {
            if (!IsUnderRosterCanvas(text.transform))
                continue;
            result.rosterTmpTextCount++;
            if (text.enabled && text.gameObject.activeInHierarchy)
                result.rosterTmpTextEnabledCount++;
            if (text.font != null)
            {
                result.rosterTmpTextFontAssignedCount++;
                if (result.firstTmpFontName.Length == 0)
                    result.firstTmpFontName = text.font.name;
            }
            if (text.fontSharedMaterial != null || text.materialForRendering != null)
                result.rosterTmpTextMaterialAssignedCount++;
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
            var rect = text.GetComponent<RectTransform>();
            if (rect != null && IsVectorOne(rect.localScale))
                result.rosterTmpTextLocalScaleIdentityCount++;
            if (rect != null && rect.rect.width > 0.5f && rect.rect.height > 0.5f)
                result.rosterTmpTextNonZeroRectCount++;
            if (text.fontSizeMin > 0f && text.fontSizeMax >= text.fontSizeMin && text.fontSize <= text.fontSizeMax + 0.01f)
                result.rosterTmpTextFontSizeBoundsValidCount++;
        }
    }

    private static void CountLegacyFallbackText()
    {
        foreach (var text in UnityEngine.Object.FindObjectsByType<Text>(FindObjectsInactive.Include))
        {
            if (!IsUnderRosterCanvas(text.transform))
                continue;
            result.rosterLegacyTextCount++;
            if (text.name == "LegacyTextFallback")
                result.rosterLegacyFallbackCount++;
            if (text.gameObject.activeInHierarchy && text.enabled)
                result.rosterLegacyEnabledTextCount++;
        }
    }

    private static void CountMaskedGraphics(Transform maskTransform)
    {
        if (maskTransform == null)
            return;

        foreach (var graphic in UnityEngine.Object.FindObjectsByType<Graphic>(FindObjectsInactive.Include))
        {
            if (graphic == null || graphic.transform == maskTransform || !IsChildOf(graphic.transform, maskTransform))
                continue;
            result.maskedGraphicCount++;
            var material = graphic.materialForRendering;
            if (material == null)
                continue;
            if (!material.HasProperty("_Stencil"))
                continue;
            result.maskedGraphicStencilPropertyCount++;
            var stencilRef = material.GetFloat("_Stencil");
            if (result.firstStencilRef < 0f)
                result.firstStencilRef = stencilRef;
            if (stencilRef > 0.5f)
                result.maskedGraphicPositiveStencilRefCount++;
            if (material.HasProperty("_StencilComp"))
            {
                result.maskedGraphicStencilCompPropertyCount++;
                if (result.firstStencilComp < 0f)
                    result.firstStencilComp = material.GetFloat("_StencilComp");
            }
            if (material.HasProperty("_StencilOp"))
                result.maskedGraphicStencilOpPropertyCount++;
            if (material.HasProperty("_StencilReadMask"))
                result.maskedGraphicStencilReadMaskPropertyCount++;
            if (material.HasProperty("_StencilWriteMask"))
                result.maskedGraphicStencilWriteMaskPropertyCount++;
        }
    }

    private static bool IsRosterRow(string name)
    {
        return name.StartsWith("ActorRow_", StringComparison.Ordinal) ||
            name.StartsWith("SkillRow_", StringComparison.Ordinal) ||
            name.StartsWith("CharacterRow_", StringComparison.Ordinal);
    }

    private static bool IsVectorOne(Vector3 value)
    {
        return Mathf.Abs(value.x - 1f) < 0.001f &&
            Mathf.Abs(value.y - 1f) < 0.001f &&
            Mathf.Abs(value.z - 1f) < 0.001f;
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

    private static bool IsChildOf(Transform child, Transform parent)
    {
        var current = child;
        while (current != null)
        {
            if (current == parent)
                return true;
            current = current.parent;
        }
        return false;
    }

    private static T FindObject<T>(string objectName) where T : Component
    {
        foreach (var component in UnityEngine.Object.FindObjectsByType<T>(FindObjectsInactive.Include))
            if (component.name == objectName)
                return component;
        return null;
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
        sb.AppendLine("# BATTLE_83_PLAYMODE_MASK_STENCIL_TMP_SCALE_AUDIT");
        sb.AppendLine();
        sb.AppendLine("- status: `" + output.status + "`");
        sb.AppendLine("- scene: `" + ProjectPath(ScenePath) + "`");
        sb.AppendLine("- roster rows actor/skill/character/total: `" + output.controllerActorRows + " / " + output.controllerSkillRows + " / " + output.controllerCharacterRows + " / " + output.contentChildCount + "`");
        sb.AppendLine("- route canvas/sorting/raycaster/scroll: `" + output.rosterCanvasPresent + " / " + output.rosterCanvasSortingOrder + " / " + output.rosterGraphicRaycasterPresent + " / " + output.scrollRectPresent + "`");
        sb.AppendLine("- mask present/enabled/hidden/hasGraphic/raycastTarget: `" + output.maskPresent + " / " + output.maskEnabled + " / " + output.maskGraphicHidden + " / " + output.maskHasGraphic + " / " + output.maskGraphicRaycastTarget + "`");
        sb.AppendLine("- masked graphics/stencilProperty/positiveStencilRef: `" + output.maskedGraphicCount + " / " + output.maskedGraphicStencilPropertyCount + " / " + output.maskedGraphicPositiveStencilRefCount + "`");
        sb.AppendLine("- first stencil ref/comp: `" + output.firstStencilRef.ToString("0.###") + " / " + output.firstStencilComp.ToString("0.###") + "`");
        sb.AppendLine("- row transforms/scaleOne/nonZeroRect: `" + output.rowTransformCount + " / " + output.rowLocalScaleIdentityCount + " / " + output.rowNonZeroRectCount + "`");
        sb.AppendLine("- TMP count/enabled/font/material/autosize/noWrap/overflow/raycastOff: `" + output.rosterTmpTextCount + " / " + output.rosterTmpTextEnabledCount + " / " + output.rosterTmpTextFontAssignedCount + " / " + output.rosterTmpTextMaterialAssignedCount + " / " + output.rosterTmpTextAutoSizeCount + " / " + output.rosterTmpTextNoWrapCount + " / " + output.rosterTmpTextEllipsisOrTruncateCount + " / " + output.rosterTmpTextRaycastOffCount + "`");
        sb.AppendLine("- TMP scaleOne/nonZeroRect/fontBounds: `" + output.rosterTmpTextLocalScaleIdentityCount + " / " + output.rosterTmpTextNonZeroRectCount + " / " + output.rosterTmpTextFontSizeBoundsValidCount + "`");
        sb.AppendLine("- first TMP font: `" + output.firstTmpFontName + "`");
        sb.AppendLine("- legacy fallback text/fallback/enabled: `" + output.rosterLegacyTextCount + " / " + output.rosterLegacyFallbackCount + " / " + output.rosterLegacyEnabledTextCount + "`");
        sb.AppendLine("- rosterDataVerified: `" + output.rosterDataVerified + "`");
        sb.AppendLine("- routeSiblingVerified: `" + output.routeSiblingVerified + "`");
        sb.AppendLine("- rowGeometryVerified: `" + output.rowGeometryVerified + "`");
        sb.AppendLine("- tmpScaleAutosizeVerified: `" + output.tmpScaleAutosizeVerified + "`");
        sb.AppendLine("- maskStencilVerified: `" + output.maskStencilVerified + "`");
        if (!string.IsNullOrEmpty(output.exception))
            sb.AppendLine("- exception: `" + output.exception + "`");
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
        public int expectedActorRows;
        public int expectedSkillRows;
        public int expectedCharacterRows;
        public int expectedTotalRows;
        public int controllerActorRows;
        public int controllerSkillRows;
        public int controllerCharacterRows;
        public int readyLocalActorRows;
        public int readyLocalSkillRows;
        public bool rosterCanvasPresent;
        public int rosterCanvasSortingOrder;
        public bool rosterGraphicRaycasterPresent;
        public bool scrollRectPresent;
        public bool scrollViewportPresent;
        public bool scrollContentPresent;
        public bool scrollVerticalOnly;
        public bool maskPresent;
        public bool maskEnabled;
        public bool maskGraphicHidden;
        public bool maskHasGraphic;
        public bool maskGraphicRaycastTarget;
        public int contentChildCount;
        public int rowTransformCount;
        public int rowLocalScaleIdentityCount;
        public int rowNonZeroRectCount;
        public int rosterTmpTextCount;
        public int rosterTmpTextEnabledCount;
        public int rosterTmpTextFontAssignedCount;
        public int rosterTmpTextMaterialAssignedCount;
        public int rosterTmpTextAutoSizeCount;
        public int rosterTmpTextNoWrapCount;
        public int rosterTmpTextEllipsisOrTruncateCount;
        public int rosterTmpTextRaycastOffCount;
        public int rosterTmpTextLocalScaleIdentityCount;
        public int rosterTmpTextNonZeroRectCount;
        public int rosterTmpTextFontSizeBoundsValidCount;
        public string firstTmpFontName = "";
        public int rosterLegacyTextCount;
        public int rosterLegacyFallbackCount;
        public int rosterLegacyEnabledTextCount;
        public int maskedGraphicCount;
        public int maskedGraphicStencilPropertyCount;
        public int maskedGraphicPositiveStencilRefCount;
        public int maskedGraphicStencilCompPropertyCount;
        public int maskedGraphicStencilOpPropertyCount;
        public int maskedGraphicStencilReadMaskPropertyCount;
        public int maskedGraphicStencilWriteMaskPropertyCount;
        public float firstStencilRef = -1f;
        public float firstStencilComp = -1f;
        public bool rosterDataVerified;
        public bool routeSiblingVerified;
        public bool rowGeometryVerified;
        public bool tmpScaleAutosizeVerified;
        public bool maskStencilVerified;
        public string exception;
    }
}
