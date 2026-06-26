using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Reflection;
using System.Text;

public static class Battle58TraceXluaGameEntryModulesInitHandlerBindingEditor
{
    private const string Prefix = "BATTLE_58_TRACE_XLUA_GAMEENTRY_MODULESINIT_HANDLER_BINDING_WITH_BATTLE57_ACTORS_NO_FAKE_HANDLER";
    private const string ScenePath = "Assets/Scenes/Battle57RuntimeRehydratedAssetBundleActorsCandidate.unity";
    private const string FallbackScenePath = "Assets/Scenes/Battle51LuaBridgeRaycasterRegistrationCandidate.unity";
    private const string SummaryPath = "Assets/RestoreData/battle/BATTLE_58_TRACE_XLUA_GAMEENTRY_MODULESINIT_HANDLER_BINDING_WITH_BATTLE57_ACTORS_NO_FAKE_HANDLER_UNITY_SUMMARY.json";
    private const string ButtonAuditCsvPath = "Assets/RestoreData/battle/BATTLE_58_TRACE_XLUA_GAMEENTRY_MODULESINIT_HANDLER_BINDING_WITH_BATTLE57_ACTORS_NO_FAKE_HANDLER_HUD_BUTTON_HANDLER_AUDIT.csv";
    private const string ClickValidationCsvPath = "Assets/RestoreData/battle/BATTLE_58_TRACE_XLUA_GAMEENTRY_MODULESINIT_HANDLER_BINDING_WITH_BATTLE57_ACTORS_NO_FAKE_HANDLER_CLICK_VALIDATION.csv";

    private static readonly TargetButton[] Targets = new[]
    {
        new TargetButton("btnAuto", "BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_opra/btnAuto", "UI_NormalBattle:86-110", "ChangeToAuto(true)/ChangeToManual"),
        new TargetButton("btnBuff", "BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_opra/btnBuff", "UI_NormalBattle:180-184", "ShowBuffView(f==false)"),
        new TargetButton("btnTwoSpeed", "BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_opra/btnTwoSpeed", "UI_NormalBattle:111-131", "ProcedureNormalBattle.SetGameSpeed"),
        new TargetButton("btnFastSkill", "BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_opra/btnFastSkill", "UI_NormalBattle:132-146", "ChangeGameFastSkill/CheckFastSkill"),
        new TargetButton("btn_box", "BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_02_ui_battle3dui/root_battle/UI_BattleBoxPage/pop_Content/box_item/btn_box", "UI_BattleBoxPage:162-178", "UIEventListener.onClick showFlyAction/RecycleBoxInstance"),
    };

    [MenuItem("GirlsWar/Battle/BATTLE58 Trace xLua GameEntry ModulesInit Handler Binding")]
    public static void Build()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        var result = new Summary();
        result.prefix = Prefix;
        result.scene = ScenePath;
        result.isFinalRestoredBattleScreen = false;
        result.handlerBindingApplied = false;
        result.sceneSaved = false;
        result.patchDecision = "blocked_no_patch";
        result.nextBlocker = "SOURCE_BACKED_XLUA_GAMEENTRY_LUAMANAGER_RUNTIME_REQUIRED_FOR_ORIGINAL_HANDLER_BINDING_AND_FULL_PAYLOAD_GAPS";

        if (File.Exists(ProjectPath(ScenePath)))
        {
            EditorSceneManager.OpenScene(ScenePath, OpenSceneMode.Single);
            result.sceneOpened = true;
        }
        else if (File.Exists(ProjectPath(FallbackScenePath)))
        {
            EditorSceneManager.OpenScene(FallbackScenePath, OpenSceneMode.Single);
            result.scene = FallbackScenePath;
            result.sceneOpened = true;
        }
        else
        {
            result.sceneOpened = false;
            result.failReason = "candidate_scene_not_found";
        }

        PrepareDepth(FindCaptureCamera());
        result.canvasCount = UnityEngine.Object.FindObjectsOfType<Canvas>(true).Length;
        result.graphicRaycasterCount = UnityEngine.Object.FindObjectsOfType<GraphicRaycaster>(true).Length;
        result.buttonCount = UnityEngine.Object.FindObjectsOfType<Button>(true).Length;
        result.eventSystemCount = UnityEngine.Object.FindObjectsOfType<EventSystem>(true).Length;
        result.inputModuleCount = UnityEngine.Object.FindObjectsOfType<BaseInputModule>(true).Length;
        result.luaFormCount = UnityEngine.Object.FindObjectsOfType<YouYou.LuaForm>(true).Length;
        result.luaUnitCount = UnityEngine.Object.FindObjectsOfType<YouYou.LuaUnit>(true).Length;
        result.luaComBinderCount = UnityEngine.Object.FindObjectsOfType<LuaComponentBinder.LuaComBinder>(true).Length;
        result.uiEventListenerCount = UnityEngine.Object.FindObjectsOfType<YouYou.UIEventListener>(true).Length;
        result.missingScriptCount = CountMissingScripts();
        result.raycasterManagerBefore = RaycasterManagerSummary();

        var rows = new List<Dictionary<string, string>>();
        foreach (var target in Targets)
            rows.Add(AuditButton(target, false));

        ForceRegisterRaycasters();
        PrepareDepth(FindCaptureCamera());
        result.raycasterManagerAfterForced = RaycasterManagerSummary();
        foreach (var target in Targets)
            rows.Add(AuditButton(target, true));

        var clicks = new List<Dictionary<string, string>>();
        foreach (var target in Targets)
            clicks.Add(ClickValidationRow(target));

        Summarize(result, rows, clicks);
        WriteCsv(ProjectPath(ButtonAuditCsvPath), rows, ButtonHeaders());
        WriteCsv(ProjectPath(ClickValidationCsvPath), clicks, ClickHeaders());
        WriteSummary(ProjectPath(SummaryPath), result);
        AssetDatabase.Refresh();
        Debug.Log("BATTLE58 handler binding trace complete. handlerBound=" + result.handlerBoundRows + " eventForced=" + result.eventTargetIncludedForcedRows);
    }

    private static Dictionary<string, string> AuditButton(TargetButton target, bool forcedPhase)
    {
        var row = NewRow(ButtonHeaders());
        row["phase"] = forcedPhase ? "after_forced_raycaster_registration" : "before_forced_raycaster_registration";
        row["buttonName"] = target.name;
        row["buttonPath"] = target.path;
        row["handlerSource"] = target.handlerSource;
        row["handlerCandidate"] = target.handlerCandidate;
        row["luaLifecycleExecuted"] = "False";
        row["gameplayHandlerExecution"] = "blocked_missing_xlua_gameentry_modulesinit_bootstrap";
        row["patchDecision"] = "blocked_no_patch";
        var transform = FindTransform(target.path);
        row["buttonFound"] = Bool(transform != null);
        if (transform == null) return row;
        var button = transform.GetComponent<Button>();
        row["buttonComponentPresent"] = Bool(button != null);
        if (button == null) return row;

        var es = UnityEngine.Object.FindObjectOfType<EventSystem>(true);
        if (es != null)
        {
            EventSystem.current = es;
            try { es.UpdateModules(); } catch { }
        }
        row["eventSystemPresent"] = Bool(es != null);
        row["eventSystemCurrentMatches"] = Bool(es != null && EventSystem.current == es);
        row["activeSelf"] = Bool(button.gameObject.activeSelf);
        row["activeInHierarchy"] = Bool(button.gameObject.activeInHierarchy);
        row["interactable"] = Bool(button.interactable);
        row["onClickPersistentCount"] = button.onClick.GetPersistentEventCount().ToString(CultureInfo.InvariantCulture);
        row["onClickRuntimeCount"] = RuntimeListenerCount(button.onClick).ToString(CultureInfo.InvariantCulture);
        row["onClickKnownCount"] = (button.onClick.GetPersistentEventCount() + RuntimeListenerCount(button.onClick)).ToString(CultureInfo.InvariantCulture);
        var listener = button.GetComponent<YouYou.UIEventListener>();
        row["uiEventListenerPresent"] = Bool(listener != null);
        row["uiEventListenerHasDelegate"] = Bool(listener != null && listener.onClick != null);
        row["eventTriggerCount"] = button.GetComponents<EventTrigger>().Length.ToString(CultureInfo.InvariantCulture);
        row["missingOnButton"] = CountMissing(button.gameObject).ToString(CultureInfo.InvariantCulture);
        row["missingOnParents"] = CountMissingParents(button.transform).ToString(CultureInfo.InvariantCulture);
        row["buttonComponentTypes"] = ComponentTypes(button.gameObject);
        row["bridgeComponentSummary"] = BridgeSummary();
        row["parentMissingChain"] = MissingParentChain(button.transform);

        var canvas = button.GetComponentInParent<Canvas>(true);
        var raycaster = canvas != null ? canvas.GetComponent<GraphicRaycaster>() : null;
        var graphic = button.targetGraphic;
        row["canvasPath"] = canvas != null ? HierarchyPath(canvas.transform) : "";
        row["canvasRenderMode"] = canvas != null ? canvas.renderMode.ToString() : "";
        row["targetGraphicPath"] = graphic != null ? HierarchyPath(graphic.transform) : "";
        row["targetGraphicType"] = graphic != null ? graphic.GetType().FullName : "";
        row["targetGraphicActive"] = Bool(graphic != null && graphic.gameObject.activeInHierarchy);
        row["targetGraphicEnabled"] = Bool(graphic != null && graphic.enabled);
        row["targetGraphicRaycastTarget"] = Bool(graphic != null && graphic.raycastTarget);
        row["targetGraphicDepth"] = graphic != null ? graphic.depth.ToString(CultureInfo.InvariantCulture) : "";
        row["raycasterManagerCount"] = GetRaycasterManagerList().Count.ToString(CultureInfo.InvariantCulture);
        row["currentRaycasterRegistered"] = Bool(raycaster != null && GetRaycasterManagerList().Contains(raycaster));

        var camera = canvas != null ? canvas.worldCamera : null;
        var pointer = new PointerEventData(es);
        pointer.position = TargetScreenPoint(button, camera);
        pointer.button = PointerEventData.InputButton.Left;
        row["pointerPosition"] = pointer.position.x.ToString("0.##", CultureInfo.InvariantCulture) + "/" + pointer.position.y.ToString("0.##", CultureInfo.InvariantCulture);

        if (es != null)
        {
            var hits = new List<RaycastResult>();
            es.RaycastAll(pointer, hits);
            row["eventSystemRaycastAllCount"] = hits.Count.ToString(CultureInfo.InvariantCulture);
            row["eventTargetIncluded"] = Bool(TargetIncluded(button.transform, hits));
            row["eventHitPaths"] = HitPaths(hits);
        }
        if (raycaster != null)
        {
            var hits = new List<RaycastResult>();
            raycaster.Raycast(pointer, hits);
            row["directGraphicRaycasterHitCount"] = hits.Count.ToString(CultureInfo.InvariantCulture);
            row["directTargetIncluded"] = Bool(TargetIncluded(button.transform, hits));
            row["directHitPaths"] = HitPaths(hits);
        }
        row["handlerBound"] = Bool(int.Parse(row["onClickKnownCount"]) > 0 || row["uiEventListenerHasDelegate"] == "True");
        return row;
    }

    private static Dictionary<string, string> ClickValidationRow(TargetButton target)
    {
        var row = NewRow(ClickHeaders());
        row["buttonName"] = target.name;
        row["buttonPath"] = target.path;
        row["handlerSource"] = target.handlerSource;
        row["validationKind"] = "no_execute_no_fake_handler";
        row["sourceBackedBindingApplied"] = "False";
        row["executeEventsInvoked"] = "False";
        row["reason"] = "blocked_missing_xlua_gameentry_modulesinit_bootstrap";
        var transform = FindTransform(target.path);
        row["buttonFound"] = Bool(transform != null);
        if (transform == null) return row;
        var clickReceiver = ExecuteEvents.GetEventHandler<IPointerClickHandler>(transform.gameObject);
        var downReceiver = ExecuteEvents.GetEventHandler<IPointerDownHandler>(transform.gameObject);
        var upReceiver = ExecuteEvents.GetEventHandler<IPointerUpHandler>(transform.gameObject);
        row["pointerClickReceiver"] = clickReceiver != null ? HierarchyPath(clickReceiver.transform) : "";
        row["pointerDownReceiver"] = downReceiver != null ? HierarchyPath(downReceiver.transform) : "";
        row["pointerUpReceiver"] = upReceiver != null ? HierarchyPath(upReceiver.transform) : "";
        row["wouldReachButtonOrUIEventListener"] = Bool(clickReceiver == transform.gameObject || transform.GetComponent<YouYou.UIEventListener>() != null);
        return row;
    }

    private static Vector2 TargetScreenPoint(Button button, Camera camera)
    {
        var graphic = button.targetGraphic;
        var rt = graphic != null ? graphic.rectTransform : button.transform as RectTransform;
        if (rt == null) return Vector2.zero;
        var center = rt.TransformPoint(rt.rect.center);
        return RectTransformUtility.WorldToScreenPoint(camera, center);
    }

    private static void ForceRegisterRaycasters()
    {
        var type = typeof(BaseRaycaster).Assembly.GetType("UnityEngine.EventSystems.RaycasterManager");
        var method = type != null ? type.GetMethod("AddRaycaster", BindingFlags.Static | BindingFlags.Public | BindingFlags.NonPublic) : null;
        if (method == null) return;
        foreach (var raycaster in UnityEngine.Object.FindObjectsOfType<BaseRaycaster>(true))
            if (raycaster != null && raycaster.isActiveAndEnabled)
                try { method.Invoke(null, new object[] { raycaster }); } catch { }
    }

    private static List<BaseRaycaster> GetRaycasterManagerList()
    {
        var list = new List<BaseRaycaster>();
        var type = typeof(BaseRaycaster).Assembly.GetType("UnityEngine.EventSystems.RaycasterManager");
        var field = type != null ? type.GetField("s_Raycasters", BindingFlags.Static | BindingFlags.NonPublic) : null;
        var value = field != null ? field.GetValue(null) as System.Collections.IEnumerable : null;
        if (value == null) return list;
        foreach (var item in value)
        {
            var raycaster = item as BaseRaycaster;
            if (raycaster != null) list.Add(raycaster);
        }
        return list;
    }

    private static string RaycasterManagerSummary()
    {
        var list = GetRaycasterManagerList();
        var parts = new List<string>();
        foreach (var r in list)
            parts.Add(HierarchyPath(r.transform) + ":" + r.GetType().FullName + ":enabled=" + Bool(r.enabled) + ":active=" + Bool(r.gameObject.activeInHierarchy));
        return "count=" + list.Count + " | " + string.Join(" ; ", parts.ToArray());
    }

    private static void Summarize(Summary result, List<Dictionary<string, string>> rows, List<Dictionary<string, string>> clicks)
    {
        foreach (var row in rows)
        {
            if (row["phase"] == "before_forced_raycaster_registration")
            {
                if (row["directTargetIncluded"] == "True") result.directTargetIncludedRows++;
                if (row["eventTargetIncluded"] == "True") result.eventTargetIncludedRows++;
            }
            else
            {
                if (row["eventTargetIncluded"] == "True") result.eventTargetIncludedForcedRows++;
            }
            if (row["handlerBound"] == "True") result.handlerBoundRows++;
            if (row["uiEventListenerHasDelegate"] == "True") result.uiEventListenerDelegateRows++;
        }
        result.buttonAuditRows = rows.Count;
        result.clickValidationRows = clicks.Count;
        result.luaLifecycleExecutedRows = CountLuaLifecycleExecuted();
        result.xluaRuntimeAvailable = Type.GetType("XLua.LuaEnv, Assembly-CSharp") != null || Type.GetType("XLua.LuaEnv, XLua") != null;
        result.gameEntryAvailable = Type.GetType("YouYou.GameEntry, Assembly-CSharp") != null;
        result.luaManagerAvailable = Type.GetType("YouYou.LuaManager, Assembly-CSharp") != null;
    }

    private static Camera FindCaptureCamera()
    {
        var named = GameObject.Find("BattleHudSpriteAtlasTextureRuntimeBindingClip05Camera");
        if (named != null)
        {
            var camera = named.GetComponent<Camera>();
            if (camera != null) return camera;
        }
        if (Camera.main != null) return Camera.main;
        var cameras = UnityEngine.Object.FindObjectsOfType<Camera>(true);
        return cameras != null && cameras.Length > 0 ? cameras[0] : null;
    }

    private static void PrepareDepth(Camera camera)
    {
        Canvas.ForceUpdateCanvases();
        foreach (var graphic in UnityEngine.Object.FindObjectsOfType<Graphic>(true))
        {
            if (graphic == null) continue;
            graphic.SetLayoutDirty();
            graphic.SetVerticesDirty();
            graphic.SetMaterialDirty();
        }
        Canvas.ForceUpdateCanvases();
        if (camera != null) DestroyTexture(RenderCamera(camera, 640, 480));
        Canvas.ForceUpdateCanvases();
    }

    private static Texture2D RenderCamera(Camera camera, int width, int height)
    {
        var rt = new RenderTexture(width, height, 24, RenderTextureFormat.ARGB32);
        var prevTarget = camera.targetTexture;
        var prevActive = RenderTexture.active;
        camera.targetTexture = rt;
        RenderTexture.active = rt;
        camera.Render();
        var tex = new Texture2D(width, height, TextureFormat.RGB24, false);
        tex.ReadPixels(new Rect(0, 0, width, height), 0, 0);
        tex.Apply();
        camera.targetTexture = prevTarget;
        RenderTexture.active = prevActive;
        UnityEngine.Object.DestroyImmediate(rt);
        return tex;
    }

    private static void DestroyTexture(Texture2D texture)
    {
        if (texture != null) UnityEngine.Object.DestroyImmediate(texture);
    }

    private static int CountLuaLifecycleExecuted()
    {
        int count = 0;
        foreach (var unit in UnityEngine.Object.FindObjectsOfType<YouYou.LuaUnit>(true))
            if (unit.InitCalled || unit.OpenCalled) count++;
        return count;
    }

    private static string BridgeSummary()
    {
        return "LuaForm=" + UnityEngine.Object.FindObjectsOfType<YouYou.LuaForm>(true).Length
            + ";LuaUnit=" + UnityEngine.Object.FindObjectsOfType<YouYou.LuaUnit>(true).Length
            + ";LuaComBinder=" + UnityEngine.Object.FindObjectsOfType<LuaComponentBinder.LuaComBinder>(true).Length
            + ";UIEventListener=" + UnityEngine.Object.FindObjectsOfType<YouYou.UIEventListener>(true).Length;
    }

    private static bool TargetIncluded(Transform target, List<RaycastResult> hits)
    {
        foreach (var hit in hits)
            if (hit.gameObject != null && (hit.gameObject.transform == target || hit.gameObject.transform.IsChildOf(target) || target.IsChildOf(hit.gameObject.transform)))
                return true;
        return false;
    }

    private static string HitPaths(List<RaycastResult> hits)
    {
        var parts = new List<string>();
        foreach (var hit in hits)
            if (hit.gameObject != null) parts.Add(HierarchyPath(hit.gameObject.transform));
        return string.Join(" | ", parts.ToArray());
    }

    private static int RuntimeListenerCount(UnityEngine.Events.UnityEvent evt)
    {
        try
        {
            var baseType = typeof(UnityEngine.Events.UnityEventBase);
            var callsField = baseType.GetField("m_Calls", BindingFlags.Instance | BindingFlags.NonPublic);
            var calls = callsField != null ? callsField.GetValue(evt) : null;
            var runtimeCallsField = calls != null ? calls.GetType().GetField("m_RuntimeCalls", BindingFlags.Instance | BindingFlags.NonPublic) : null;
            var runtimeCalls = runtimeCallsField != null ? runtimeCallsField.GetValue(calls) as System.Collections.ICollection : null;
            return runtimeCalls != null ? runtimeCalls.Count : 0;
        }
        catch { return 0; }
    }

    private static int CountMissingScripts()
    {
        int count = 0;
        foreach (var transform in UnityEngine.Object.FindObjectsOfType<Transform>(true))
            count += CountMissing(transform.gameObject);
        return count;
    }

    private static int CountMissing(GameObject go)
    {
        int count = 0;
        foreach (var component in go.GetComponents<Component>())
            if (component == null) count++;
        return count;
    }

    private static int CountMissingParents(Transform transform)
    {
        int count = 0;
        var t = transform.parent;
        while (t != null) { count += CountMissing(t.gameObject); t = t.parent; }
        return count;
    }

    private static string MissingParentChain(Transform transform)
    {
        var parts = new List<string>();
        var t = transform;
        while (t != null)
        {
            int missing = CountMissing(t.gameObject);
            if (missing > 0) parts.Add(HierarchyPath(t) + ":missing=" + missing + ":components=" + ComponentTypes(t.gameObject));
            t = t.parent;
        }
        return string.Join(" | ", parts.ToArray());
    }

    private static string ComponentTypes(GameObject go)
    {
        var parts = new List<string>();
        foreach (var component in go.GetComponents<Component>())
            parts.Add(component == null ? "<missing>" : component.GetType().FullName);
        return string.Join(";", parts.ToArray());
    }

    private static Transform FindTransform(string path)
    {
        foreach (var transform in UnityEngine.Object.FindObjectsOfType<Transform>(true))
            if (HierarchyPath(transform) == path) return transform;
        return null;
    }

    private static string HierarchyPath(Transform transform)
    {
        var names = new List<string>();
        var t = transform;
        while (t != null) { names.Add(t.name); t = t.parent; }
        names.Reverse();
        return string.Join("/", names.ToArray());
    }

    private static void WriteCsv(string path, List<Dictionary<string, string>> rows, string[] headers)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        var sb = new StringBuilder();
        sb.AppendLine(string.Join(",", headers));
        foreach (var row in rows)
        {
            for (int i = 0; i < headers.Length; i++)
            {
                if (i > 0) sb.Append(",");
                sb.Append(Csv(row.ContainsKey(headers[i]) ? row[headers[i]] : ""));
            }
            sb.AppendLine();
        }
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(true));
    }

    private static void WriteSummary(string path, Summary s)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        var sb = new StringBuilder();
        sb.AppendLine("{");
        Add(sb, "prefix", s.prefix, true);
        Add(sb, "scene", s.scene, true);
        Add(sb, "sceneOpened", s.sceneOpened, true);
        Add(sb, "sceneSaved", s.sceneSaved, true);
        Add(sb, "isFinalRestoredBattleScreen", s.isFinalRestoredBattleScreen, true);
        Add(sb, "handlerBindingApplied", s.handlerBindingApplied, true);
        Add(sb, "patchDecision", s.patchDecision, true);
        Add(sb, "canvasCount", s.canvasCount, true);
        Add(sb, "graphicRaycasterCount", s.graphicRaycasterCount, true);
        Add(sb, "buttonCount", s.buttonCount, true);
        Add(sb, "eventSystemCount", s.eventSystemCount, true);
        Add(sb, "inputModuleCount", s.inputModuleCount, true);
        Add(sb, "luaFormCount", s.luaFormCount, true);
        Add(sb, "luaUnitCount", s.luaUnitCount, true);
        Add(sb, "luaComBinderCount", s.luaComBinderCount, true);
        Add(sb, "uiEventListenerCount", s.uiEventListenerCount, true);
        Add(sb, "missingScriptCount", s.missingScriptCount, true);
        Add(sb, "buttonAuditRows", s.buttonAuditRows, true);
        Add(sb, "clickValidationRows", s.clickValidationRows, true);
        Add(sb, "directTargetIncludedRows", s.directTargetIncludedRows, true);
        Add(sb, "eventTargetIncludedRows", s.eventTargetIncludedRows, true);
        Add(sb, "eventTargetIncludedForcedRows", s.eventTargetIncludedForcedRows, true);
        Add(sb, "handlerBoundRows", s.handlerBoundRows, true);
        Add(sb, "uiEventListenerDelegateRows", s.uiEventListenerDelegateRows, true);
        Add(sb, "luaLifecycleExecutedRows", s.luaLifecycleExecutedRows, true);
        Add(sb, "xluaRuntimeAvailable", s.xluaRuntimeAvailable, true);
        Add(sb, "gameEntryAvailable", s.gameEntryAvailable, true);
        Add(sb, "luaManagerAvailable", s.luaManagerAvailable, true);
        Add(sb, "raycasterManagerBefore", s.raycasterManagerBefore, true);
        Add(sb, "raycasterManagerAfterForced", s.raycasterManagerAfterForced, true);
        Add(sb, "nextBlocker", s.nextBlocker, true);
        Add(sb, "failReason", s.failReason, false);
        sb.AppendLine("}");
        File.WriteAllText(path, sb.ToString(), Encoding.UTF8);
    }

    private static string[] ButtonHeaders()
    {
        return new[] { "phase", "buttonName", "buttonPath", "buttonFound", "buttonComponentPresent", "handlerSource", "handlerCandidate", "eventSystemPresent", "eventSystemCurrentMatches", "activeSelf", "activeInHierarchy", "interactable", "canvasPath", "canvasRenderMode", "targetGraphicPath", "targetGraphicType", "targetGraphicActive", "targetGraphicEnabled", "targetGraphicRaycastTarget", "targetGraphicDepth", "pointerPosition", "eventSystemRaycastAllCount", "eventTargetIncluded", "eventHitPaths", "directGraphicRaycasterHitCount", "directTargetIncluded", "directHitPaths", "raycasterManagerCount", "currentRaycasterRegistered", "onClickPersistentCount", "onClickRuntimeCount", "onClickKnownCount", "eventTriggerCount", "uiEventListenerPresent", "uiEventListenerHasDelegate", "handlerBound", "luaLifecycleExecuted", "gameplayHandlerExecution", "missingOnButton", "missingOnParents", "buttonComponentTypes", "bridgeComponentSummary", "parentMissingChain", "patchDecision" };
    }

    private static string[] ClickHeaders()
    {
        return new[] { "buttonName", "buttonPath", "buttonFound", "handlerSource", "validationKind", "sourceBackedBindingApplied", "executeEventsInvoked", "pointerClickReceiver", "pointerDownReceiver", "pointerUpReceiver", "wouldReachButtonOrUIEventListener", "reason" };
    }

    private static Dictionary<string, string> NewRow(string[] headers)
    {
        var row = new Dictionary<string, string>();
        foreach (var h in headers) row[h] = "";
        return row;
    }

    private static string Csv(string value)
    {
        value = value ?? "";
        if (value.IndexOfAny(new[] { ',', '"', '\n', '\r' }) >= 0) return "\"" + value.Replace("\"", "\"\"") + "\"";
        return value;
    }

    private static void Add(StringBuilder sb, string name, string value, bool comma) { sb.AppendLine("  \"" + name + "\": \"" + Json(value) + "\"" + (comma ? "," : "")); }
    private static void Add(StringBuilder sb, string name, bool value, bool comma) { sb.AppendLine("  \"" + name + "\": " + (value ? "true" : "false") + (comma ? "," : "")); }
    private static void Add(StringBuilder sb, string name, int value, bool comma) { sb.AppendLine("  \"" + name + "\": " + value.ToString(CultureInfo.InvariantCulture) + (comma ? "," : "")); }
    private static string Json(string value) { return (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\""); }
    private static string Bool(bool value) { return value ? "True" : "False"; }
    private static string ProjectPath(string assetPath) { return Path.Combine(Application.dataPath, "..", assetPath.Replace("/", "\\")); }

    private sealed class TargetButton
    {
        public string name, path, handlerSource, handlerCandidate;
        public TargetButton(string name, string path, string handlerSource, string handlerCandidate)
        {
            this.name = name; this.path = path; this.handlerSource = handlerSource; this.handlerCandidate = handlerCandidate;
        }
    }

    private sealed class Summary
    {
        public string prefix = "", scene = "", patchDecision = "", nextBlocker = "", failReason = "", raycasterManagerBefore = "", raycasterManagerAfterForced = "";
        public bool sceneOpened, sceneSaved, isFinalRestoredBattleScreen, handlerBindingApplied, xluaRuntimeAvailable, gameEntryAvailable, luaManagerAvailable;
        public int canvasCount, graphicRaycasterCount, buttonCount, eventSystemCount, inputModuleCount, luaFormCount, luaUnitCount, luaComBinderCount, uiEventListenerCount, missingScriptCount;
        public int buttonAuditRows, clickValidationRows, directTargetIncludedRows, eventTargetIncludedRows, eventTargetIncludedForcedRows, handlerBoundRows, uiEventListenerDelegateRows, luaLifecycleExecutedRows;
    }
}
