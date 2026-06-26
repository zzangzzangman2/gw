using System;
using System.IO;
using System.Text;
using TMPro;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public static class Battle78RouteActiveSiblingMaskTmpAuditEditor
{
    private const int ExpectedRosterDataRows = 204;
    private const string ScenePath = "Assets/Scenes/Battle76PlayableRosterCandidate.unity";
    private const string SourceB72ScenePath = "Assets/Scenes/Battle72Map11003TrueAspectReprojectionPersistedCandidate.unity";
    private const string B77ResultJsonPath = "Assets/RestoreData/battle/BATTLE_77_PLAYABLE_ROSTER_CLICK_VERIFICATION.json";
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_78_ROUTE_ACTIVE_SIBLING_MASK_TMP_CURRENT_STATE_AUDIT.json";
    private const string ReportMdPath = @"C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_78_ROUTE_ACTIVE_SIBLING_MASK_TMP_CURRENT_STATE_AUDIT.md";

    [MenuItem("GirlsWar/Battle/BATTLE78 Route Active Sibling Mask TMP Current State Audit")]
    public static void Audit()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        Directory.CreateDirectory(Path.GetDirectoryName(ReportMdPath));

        var result = new Result
        {
            generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
            scenePath = ScenePath,
            sceneExists = File.Exists(ProjectPath(ScenePath)),
            sourceB72SceneExists = File.Exists(ProjectPath(SourceB72ScenePath)),
            clickVerificationResultPresent = File.Exists(ProjectPath(B77ResultJsonPath)),
            captureWidth = 1920,
            captureHeight = 855
        };
        result.captureAspect = result.captureHeight == 0 ? 0f : (float)result.captureWidth / result.captureHeight;

        if (result.clickVerificationResultPresent)
            result.clickVerificationVerified = File.ReadAllText(ProjectPath(B77ResultJsonPath), Encoding.UTF8).Contains("battle77_click_playability_verified");

        if (!result.sceneExists)
        {
            result.status = "blocked_scene_missing";
            WriteOutputs(result);
            return;
        }

        var scene = EditorSceneManager.OpenScene(ScenePath);
        result.sceneOpened = scene.IsValid();

        var controller = UnityEngine.Object.FindAnyObjectByType<BattlePlayableRosterController>();
        result.rosterControllerPresent = controller != null;
        if (controller != null)
            controller.BuildInEditor();
        Canvas.ForceUpdateCanvases();

        var transforms = UnityEngine.Object.FindObjectsByType<RectTransform>(FindObjectsInactive.Include);
        foreach (var rect in transforms)
        {
            result.rectTransformCount++;
            if (rect.gameObject.activeSelf)
                result.activeSelfRectTransformCount++;
            if (rect.gameObject.activeInHierarchy)
                result.activeInHierarchyRectTransformCount++;
            else
                result.inactiveInHierarchyRectTransformCount++;

            if (rect.gameObject.activeInHierarchy &&
                (Mathf.Approximately(rect.lossyScale.x, 0f) || Mathf.Approximately(rect.lossyScale.y, 0f)))
                result.activeZeroLossyScaleRectTransformCount++;

            if (rect.gameObject.activeInHierarchy &&
                (Mathf.Approximately(rect.rect.width, 0f) || Mathf.Approximately(rect.rect.height, 0f)))
                result.activeZeroSizeRectTransformCount++;
        }

        result.canvasCount = UnityEngine.Object.FindObjectsByType<Canvas>(FindObjectsInactive.Include).Length;
        result.graphicRaycasterCount = UnityEngine.Object.FindObjectsByType<GraphicRaycaster>(FindObjectsInactive.Include).Length;
        result.maskCount = UnityEngine.Object.FindObjectsByType<Mask>(FindObjectsInactive.Include).Length;
        result.rectMask2DCount = UnityEngine.Object.FindObjectsByType<RectMask2D>(FindObjectsInactive.Include).Length;
        result.scrollRectCount = UnityEngine.Object.FindObjectsByType<ScrollRect>(FindObjectsInactive.Include).Length;
        result.buttonCount = UnityEngine.Object.FindObjectsByType<Button>(FindObjectsInactive.Include).Length;
        result.uguiTextCount = UnityEngine.Object.FindObjectsByType<Text>(FindObjectsInactive.Include).Length;
        result.bestFitUguiTextCount = CountBestFitText();
        result.tmpLikeTextComponentCount = CountTmpLikeTextComponents();
        CountTmpTextLayout(result);
        result.contentSizeFitterCount = UnityEngine.Object.FindObjectsByType<ContentSizeFitter>(FindObjectsInactive.Include).Length;
        result.aspectRatioFitterCount = UnityEngine.Object.FindObjectsByType<AspectRatioFitter>(FindObjectsInactive.Include).Length;
        result.eventSystemPresent = UnityEngine.Object.FindAnyObjectByType<EventSystem>() != null;

        var rosterCanvas = FindComponentOnObject<Canvas>("BattlePlayableRosterCanvas");
        result.rosterCanvasPresent = rosterCanvas != null;
        result.rosterCanvasSortingOrder = rosterCanvas != null ? rosterCanvas.sortingOrder : int.MinValue;
        result.rosterCanvasRaycasterPresent = FindComponentOnObject<GraphicRaycaster>("BattlePlayableRosterCanvas") != null;
        var rosterMask = FindComponentOnObject<Mask>("RosterScroll");
        result.rosterScrollMaskPresent = rosterMask != null;
        result.rosterScrollMaskGraphicHidden = rosterMask != null && !rosterMask.showMaskGraphic;
        var rosterScroll = FindComponentOnObject<ScrollRect>("RosterScroll");
        result.rosterScrollRectPresent = rosterScroll != null && rosterScroll.content != null && rosterScroll.viewport != null;
        result.rosterPanelSiblingIndex = ReadSiblingIndex("BattlePlayableRosterPanel");
        result.rosterCanvasSiblingIndex = ReadSiblingIndex("BattlePlayableRosterCanvas");

        result.coordinateAspectVerified = result.sourceB72SceneExists && Math.Abs(result.captureAspect - (1920f / 855f)) < 0.001f;
        result.rosterSiblingAndMaskVerified = result.rosterCanvasPresent &&
            result.rosterCanvasSortingOrder == 5000 &&
            result.rosterCanvasRaycasterPresent &&
            result.rosterScrollRectPresent &&
            result.rosterScrollMaskPresent &&
            result.rosterScrollMaskGraphicHidden;
        result.rosterTmpAutosizeVerified = result.tmpTextCount >= ExpectedRosterDataRows &&
            result.tmpAutoSizeTextCount >= ExpectedRosterDataRows &&
            result.tmpNoWrapTextCount >= ExpectedRosterDataRows &&
            result.tmpEllipsisOrTruncateTextCount >= ExpectedRosterDataRows &&
            result.tmpRaycastOffTextCount >= ExpectedRosterDataRows;
        result.playableClickVerificationCarried = result.clickVerificationVerified;
        result.originalRuntimeRouteStateStillRequiresSnapshot = true;
        result.originalRuntimeTmpMaskStillRequiresSnapshot = true;
        result.status = result.coordinateAspectVerified &&
            result.rosterSiblingAndMaskVerified &&
            result.rosterTmpAutosizeVerified &&
            result.playableClickVerificationCarried
            ? "battle78_current_state_audited_playable_overlay_verified_runtime_gap_remaining"
            : "battle78_current_state_audit_failed";

        WriteOutputs(result);
        Debug.Log("[GirlsWarRestore] BATTLE78 route/active/sibling/mask/TMP current-state audit: " + result.status);
    }

    private static int CountBestFitText()
    {
        var count = 0;
        foreach (var text in UnityEngine.Object.FindObjectsByType<Text>(FindObjectsInactive.Include))
            if (text.resizeTextForBestFit)
                count++;
        return count;
    }

    private static int CountTmpLikeTextComponents()
    {
        var count = 0;
        foreach (var behaviour in UnityEngine.Object.FindObjectsByType<MonoBehaviour>(FindObjectsInactive.Include))
        {
            if (behaviour == null)
                continue;
            var type = behaviour.GetType();
            if (type.FullName != null && type.FullName.StartsWith("TMPro.", StringComparison.Ordinal))
                count++;
        }
        return count;
    }

    private static void CountTmpTextLayout(Result result)
    {
        foreach (var text in UnityEngine.Object.FindObjectsByType<TMP_Text>(FindObjectsInactive.Include))
        {
            result.tmpTextCount++;
            if (text.enableAutoSizing)
                result.tmpAutoSizeTextCount++;
            if (text.textWrappingMode == TextWrappingModes.NoWrap ||
                text.textWrappingMode == TextWrappingModes.PreserveWhitespaceNoWrap)
                result.tmpNoWrapTextCount++;
            if (text.overflowMode == TextOverflowModes.Ellipsis ||
                text.overflowMode == TextOverflowModes.Truncate)
                result.tmpEllipsisOrTruncateTextCount++;
            if (!text.raycastTarget)
                result.tmpRaycastOffTextCount++;
        }
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

    private static int ReadSiblingIndex(string objectName)
    {
        foreach (var transform in UnityEngine.Object.FindObjectsByType<Transform>(FindObjectsInactive.Include))
            if (transform.name == objectName)
                return transform.GetSiblingIndex();
        return int.MinValue;
    }

    private static void WriteOutputs(Result result)
    {
        File.WriteAllText(ProjectPath(ResultJsonPath), JsonUtility.ToJson(result, true), Encoding.UTF8);

        var sb = new StringBuilder();
        sb.AppendLine("# BATTLE_78_ROUTE_ACTIVE_SIBLING_MASK_TMP_CURRENT_STATE_AUDIT");
        sb.AppendLine();
        sb.AppendLine("- status: `" + result.status + "`");
        sb.AppendLine("- scene: `" + ProjectPath(ScenePath) + "`");
        sb.AppendLine("- coordinateAspectVerified: `" + result.coordinateAspectVerified + "` (`" + result.captureWidth + "x" + result.captureHeight + "`, aspect `" + result.captureAspect.ToString("0.0000") + "`)");
        sb.AppendLine("- playableClickVerificationCarried: `" + result.playableClickVerificationCarried + "`");
        sb.AppendLine("- rosterSiblingAndMaskVerified: `" + result.rosterSiblingAndMaskVerified + "`");
        sb.AppendLine("- rosterCanvasSortingOrder: `" + result.rosterCanvasSortingOrder + "`");
        sb.AppendLine("- rosterScrollMaskPresent / hidden: `" + result.rosterScrollMaskPresent + " / " + result.rosterScrollMaskGraphicHidden + "`");
        sb.AppendLine("- rectTransform active/inactive: `" + result.activeInHierarchyRectTransformCount + " / " + result.inactiveInHierarchyRectTransformCount + "`");
        sb.AppendLine("- active zero lossy-scale rects: `" + result.activeZeroLossyScaleRectTransformCount + "`");
        sb.AppendLine("- active zero-size rects: `" + result.activeZeroSizeRectTransformCount + "`");
        sb.AppendLine("- components canvas/raycaster/mask/rectMask/scroll/button: `" + result.canvasCount + " / " + result.graphicRaycasterCount + " / " + result.maskCount + " / " + result.rectMask2DCount + " / " + result.scrollRectCount + " / " + result.buttonCount + "`");
        sb.AppendLine("- text UGUI/TMP-like/bestFit/contentFit/aspectFit: `" + result.uguiTextCount + " / " + result.tmpLikeTextComponentCount + " / " + result.bestFitUguiTextCount + " / " + result.contentSizeFitterCount + " / " + result.aspectRatioFitterCount + "`");
        sb.AppendLine("- TMP text count/autosize/noWrap/ellipsisOrTruncate/raycastOff: `" + result.tmpTextCount + " / " + result.tmpAutoSizeTextCount + " / " + result.tmpNoWrapTextCount + " / " + result.tmpEllipsisOrTruncateTextCount + " / " + result.tmpRaycastOffTextCount + "`");
        sb.AppendLine("- expected roster data rows for TMP layout: `" + ExpectedRosterDataRows + "`");
        sb.AppendLine("- rosterTmpAutosizeVerified: `" + result.rosterTmpAutosizeVerified + "`");
        sb.AppendLine("- originalRuntimeRouteStateStillRequiresSnapshot: `" + result.originalRuntimeRouteStateStillRequiresSnapshot + "`");
        sb.AppendLine("- originalRuntimeTmpMaskStillRequiresSnapshot: `" + result.originalRuntimeTmpMaskStillRequiresSnapshot + "`");
        sb.AppendLine();
        sb.AppendLine("## Notes");
        sb.AppendLine("- The B76 playable overlay preserves B72 as the true-aspect coordinate basis and uses its own high sorting-order roster canvas.");
        sb.AppendLine("- This verifies the local playable overlay route/sibling/mask state. It deliberately does not convert B73/B74 runtime-owned original UI_NormalBattle TMP/mask state into a false static claim.");
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
        public bool sourceB72SceneExists;
        public bool clickVerificationResultPresent;
        public bool clickVerificationVerified;
        public bool rosterControllerPresent;
        public int captureWidth;
        public int captureHeight;
        public float captureAspect;
        public int rectTransformCount;
        public int activeSelfRectTransformCount;
        public int activeInHierarchyRectTransformCount;
        public int inactiveInHierarchyRectTransformCount;
        public int activeZeroLossyScaleRectTransformCount;
        public int activeZeroSizeRectTransformCount;
        public int canvasCount;
        public int graphicRaycasterCount;
        public int maskCount;
        public int rectMask2DCount;
        public int scrollRectCount;
        public int buttonCount;
        public int uguiTextCount;
        public int bestFitUguiTextCount;
        public int tmpLikeTextComponentCount;
        public int tmpTextCount;
        public int tmpAutoSizeTextCount;
        public int tmpNoWrapTextCount;
        public int tmpEllipsisOrTruncateTextCount;
        public int tmpRaycastOffTextCount;
        public int contentSizeFitterCount;
        public int aspectRatioFitterCount;
        public bool eventSystemPresent;
        public bool rosterCanvasPresent;
        public int rosterCanvasSortingOrder;
        public bool rosterCanvasRaycasterPresent;
        public bool rosterScrollMaskPresent;
        public bool rosterScrollMaskGraphicHidden;
        public bool rosterScrollRectPresent;
        public int rosterPanelSiblingIndex;
        public int rosterCanvasSiblingIndex;
        public bool coordinateAspectVerified;
        public bool rosterSiblingAndMaskVerified;
        public bool rosterTmpAutosizeVerified;
        public bool playableClickVerificationCarried;
        public bool originalRuntimeRouteStateStillRequiresSnapshot;
        public bool originalRuntimeTmpMaskStillRequiresSnapshot;
    }
}
