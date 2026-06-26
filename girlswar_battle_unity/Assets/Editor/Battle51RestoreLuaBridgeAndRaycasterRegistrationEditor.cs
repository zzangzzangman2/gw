using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;

public static class Battle51RestoreLuaBridgeAndRaycasterRegistrationEditor
{
    private const string SourceScenePath = "Assets/Scenes/Battle50OriginalLuaIl2cppButtonHandlerTrace.unity";
    private const string ScenePath = "Assets/Scenes/Battle51LuaBridgeRaycasterRegistrationCandidate.unity";
    private const string B50RowsCsvPath = "Assets/RestoreData/battle/BATTLE_50_TRACE_ORIGINAL_LUA_IL2CPP_BUTTON_HANDLER_BINDING_AND_MISSING_SCRIPTS_EVENTSYSTEM.csv";
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_51_RESTORE_SOURCE_BACKED_LUAUNIT_UIEVENTLISTENER_AND_EVENTSYSTEM_RAYCASTER_REGISTRATION_UNITY.json";
    private const string RowsCsvPath = "Assets/RestoreData/battle/BATTLE_51_RESTORE_SOURCE_BACKED_LUAUNIT_UIEVENTLISTENER_AND_EVENTSYSTEM_RAYCASTER_REGISTRATION_COMPONENTS.csv";
    private const string BridgeCsvPath = "Assets/RestoreData/battle/BATTLE_51_RESTORE_SOURCE_BACKED_LUAUNIT_UIEVENTLISTENER_AND_EVENTSYSTEM_RAYCASTER_REGISTRATION_BRIDGE.csv";
    private const string CapturePath = "Assets/RestoreCaptures/battle_actor/Battle51LuaBridgeRaycasterRegistrationCandidate_1920x1080.png";

    private static readonly string[] ButtonOrder = { "btnAuto", "btnBuff", "btnTwoSpeed", "btnFastSkill", "btn_box" };

    [MenuItem("GirlsWar/Battle/BATTLE51 Restore Lua Bridge And Raycaster Registration")]
    public static void Build()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        Directory.CreateDirectory(ProjectPath("Assets/RestoreCaptures/battle_actor"));
        var result = new Result();
        var rows = new List<Row>();
        var bridgeRows = new List<BridgeRow>();
        result.status = "battle51_restore_source_backed_luaunit_uieventlistener_and_eventsystem_raycaster_registration";
        result.isFinalRestoredBattleScreen = false;
        result.sourceScene = SourceScenePath;
        result.scene = ScenePath;
        result.capture = CapturePath;

        if (!File.Exists(ProjectPath(SourceScenePath)))
        {
            result.failReason = "source_scene_file_not_found";
            WriteOutputs(result, rows, bridgeRows);
            return;
        }

        var inputRows = LoadInputRows(ProjectPath(B50RowsCsvPath));
        result.b50InputRows = inputRows.Count;
        var scene = EditorSceneManager.OpenScene(SourceScenePath, OpenSceneMode.Single);
        result.sourceSceneOpened = scene.IsValid();
        var camera = FindCaptureCamera();
        if (camera != null) ConfigureCamera(camera);
        PrepareDepth(camera);
        Snapshot(result, "before");
        FillEventSystemSummary(result);
        result.raycasterManagerBefore = RaycasterManagerSummary();

        RestoreBridgeComponents(bridgeRows);
        PrepareDepth(camera);
        Snapshot(result, "after");
        result.raycasterManagerAfterBridge = RaycasterManagerSummary();

        foreach (var input in inputRows)
        {
            var buttonTransform = FindTransform(input.buttonScenePath);
            if (buttonTransform == null) continue;
            var button = buttonTransform.GetComponent<Button>();
            if (button == null) continue;
            rows.Add(ProbeRow(input, button, "after_bridge_before_forced_raycaster", false));
        }

        ForceRegisterRaycasters();
        result.raycasterManagerAfterForcedRegistration = RaycasterManagerSummary();
        foreach (var row in rows)
        {
            var buttonTransform = FindTransform(row.buttonScenePath);
            var button = buttonTransform != null ? buttonTransform.GetComponent<Button>() : null;
            if (button == null) continue;
            ProbeRaycastIntoExistingRow(row, button, "forced");
        }

        Summarize(result, rows, bridgeRows);
        EditorSceneManager.SaveScene(scene, ScenePath);
        result.sceneSaved = File.Exists(ProjectPath(ScenePath));
        Capture(camera, ProjectPath(CapturePath));
        result.captureExists = File.Exists(ProjectPath(CapturePath));

        var reopened = EditorSceneManager.OpenScene(ScenePath, OpenSceneMode.Single);
        result.reopenValid = reopened.IsValid();
        camera = FindCaptureCamera();
        if (camera != null) ConfigureCamera(camera);
        PrepareDepth(camera);
        Snapshot(result, "reopen");
        result.raycasterManagerReopenBeforeForced = RaycasterManagerSummary();
        ForceRegisterRaycasters();
        result.raycasterManagerReopenAfterForced = RaycasterManagerSummary();

        WriteOutputs(result, rows, bridgeRows);
        AssetDatabase.Refresh();
        Debug.Log("BATTLE51 complete. forcedEventTargets=" + result.forcedEventSystemTargetIncludedCount + ", bridgeAdded=" + result.bridgeAddedCount);
    }

    private static void RestoreBridgeComponents(List<BridgeRow> bridgeRows)
    {
        var normal = FindTransform("BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle");
        if (normal != null)
        {
            var form = EnsureComponent<YouYou.LuaForm>(normal.gameObject, bridgeRows, "UI_NormalBattle", "YouYou.LuaForm", "8347263561838679580", "original UI_NormalBattle root bridge");
            form.enumActive = 0;
            form.isPopAnim = false;
            form.seqActionStauts = 1;
            form.LuaScriptPath = "/Download/xLuaLogic/Modules/MainCity/UI_NormalBattle.bytes";
            form.m_LuaComGroups = new[]
            {
                new YouYou.LuaComGroup { Name = "Buttons", LuaComs = new[]
                    {
                        LuaCom("btnAuto", 4, FindComponent<Button>("BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_opra/btnAuto")),
                        LuaCom("btnTwoSpeed", 4, FindComponent<Button>("BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_opra/btnTwoSpeed")),
                        LuaCom("btnFastSkill", 4, FindComponent<Button>("BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_opra/btnFastSkill")),
                    }
                },
                new YouYou.LuaComGroup { Name = "buff_group_left", LuaComs = new[]
                    {
                        LuaCom("btnBuff", 4, FindComponent<Button>("BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle/root_opra/btnBuff")),
                    }
                },
            };
            AddBridgeEvidence(bridgeRows, "UI_NormalBattle", HierarchyPath(normal), "LuaScriptPath", form.LuaScriptPath, "source-backed from original LuaForm typetree");
        }

        var battle3d = FindTransform("BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_02_ui_battle3dui");
        if (battle3d != null)
        {
            var unit = EnsureComponent<YouYou.LuaUnit>(battle3d.gameObject, bridgeRows, "UI_Battle3DUI", "YouYou.LuaUnit", "3319520142972745523", "original UI_Battle3DUI root bridge");
            unit.LuaScriptPath = "/Download/xLuaLogic/Modules/MainCity/UI_Battle3DUI.bytes";
            unit.m_LuaComGroups = new[]
            {
                new YouYou.LuaComGroup { Name = "common", LuaComs = new[]
                    {
                        LuaCom("root_battle", 15, FindComponent<CanvasGroup>("BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_02_ui_battle3dui/root_battle")),
                        LuaCom("UI_BattleBoxPage", 3, FindTransform("BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_02_ui_battle3dui/root_battle/UI_BattleBoxPage")),
                    }
                },
            };
            AddBridgeEvidence(bridgeRows, "UI_Battle3DUI", HierarchyPath(battle3d), "LuaScriptPath", unit.LuaScriptPath, "source-backed from original LuaUnit typetree");
        }

        var boxPage = FindTransform("BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_02_ui_battle3dui/root_battle/UI_BattleBoxPage");
        if (boxPage != null)
        {
            var unit = EnsureComponent<YouYou.LuaUnit>(boxPage.gameObject, bridgeRows, "UI_BattleBoxPage", "YouYou.LuaUnit", "3319520142972745523", "original UI_BattleBoxPage bridge");
            unit.LuaScriptPath = "/Download/xLuaLogic/Modules/MainCity/UI_BattleBoxPage.bytes";
            unit.m_LuaComGroups = new[]
            {
                new YouYou.LuaComGroup { Name = "common", LuaComs = new[]
                    {
                        LuaCom("box_item", 24, FindComponent<LuaComponentBinder.LuaComBinder>("BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_02_ui_battle3dui/root_battle/UI_BattleBoxPage/pop_Content/box_item")),
                        LuaCom("node_box", 3, FindTransform("BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_02_ui_battle3dui/root_battle/UI_BattleBoxPage/pop_Content/node_box")),
                    }
                },
            };
            AddBridgeEvidence(bridgeRows, "UI_BattleBoxPage", HierarchyPath(boxPage), "LuaScriptPath", unit.LuaScriptPath, "source-backed from original LuaUnit typetree");
        }

        var boxItem = FindTransform("BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_02_ui_battle3dui/root_battle/UI_BattleBoxPage/pop_Content/box_item");
        if (boxItem != null)
        {
            var binder = EnsureComponent<LuaComponentBinder.LuaComBinder>(boxItem.gameObject, bridgeRows, "UI_BattleBoxPage.box_item", "LuaComponentBinder.LuaComBinder", "1924290018182821150", "original box_item LuaComBinder");
            binder.LuaComs = new[]
            {
                LuaCom("sp_box", 25, FirstNonTransformComponent("BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_02_ui_battle3dui/root_battle/UI_BattleBoxPage/pop_Content/box_item/sp_box")),
                LuaCom("btn_box", 4, FindComponent<Button>("BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_02_ui_battle3dui/root_battle/UI_BattleBoxPage/pop_Content/box_item/btn_box")),
            };
            AddBridgeEvidence(bridgeRows, "UI_BattleBoxPage.box_item", HierarchyPath(boxItem), "LuaComs", "sp_box Type25; btn_box Type4", "source-backed from original LuaComBinder typetree");
        }

        var btnBox = FindTransform("BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_02_ui_battle3dui/root_battle/UI_BattleBoxPage/pop_Content/box_item/btn_box");
        if (btnBox != null)
        {
            EnsureComponent<YouYou.UIEventListener>(btnBox.gameObject, bridgeRows, "btn_box", "YouYou.UIEventListener", "-6333827617915679503", "original btn_box UIEventListener");
        }
    }

    private static T EnsureComponent<T>(GameObject go, List<BridgeRow> rows, string role, string originalType, string originalScriptPathId, string evidence) where T : Component
    {
        var before = go.GetComponent<T>() != null;
        var component = go.GetComponent<T>();
        if (component == null) component = go.AddComponent<T>();
        rows.Add(new BridgeRow
        {
            role = role,
            scenePath = HierarchyPath(go.transform),
            componentType = typeof(T).FullName,
            originalType = originalType,
            originalScriptPathId = originalScriptPathId,
            added = !before,
            evidence = evidence
        });
        return component;
    }

    private static YouYou.LuaCom LuaCom(string name, int type, UnityEngine.Object obj)
    {
        return new YouYou.LuaCom { Name = name, Type = type, ComObj = obj };
    }

    private static void AddBridgeEvidence(List<BridgeRow> rows, string role, string path, string field, string value, string evidence)
    {
        rows.Add(new BridgeRow { role = role, scenePath = path, componentType = field, originalType = value, originalScriptPathId = "", added = false, evidence = evidence });
    }

    private static Row ProbeRow(InputRow input, Button button, string phase, bool forced)
    {
        var row = new Row();
        row.buttonName = button.name;
        row.pointerPosition = input.pointerPosition;
        row.buttonScenePath = HierarchyPath(button.transform);
        row.originalButtonPath = input.originalButtonPath;
        row.luaHandlerCandidate = input.luaHandlerCandidate;
        row.phase = phase;
        FillButtonState(row, button);
        ProbeRaycastIntoExistingRow(row, button, forced ? "forced" : "beforeForced");
        row.patchDecision = "candidate_bridge_patch_no_fake_handler";
        return row;
    }

    private static void ProbeRaycastIntoExistingRow(Row row, Button button, string prefix)
    {
        var eventSystem = UnityEngine.Object.FindObjectOfType<EventSystem>(true);
        if (eventSystem != null)
        {
            EventSystem.current = eventSystem;
            try { eventSystem.UpdateModules(); } catch { }
        }
        var canvas = button.GetComponentInParent<Canvas>(true);
        var raycaster = canvas != null ? canvas.GetComponent<GraphicRaycaster>() : null;
        var pointer = new PointerEventData(eventSystem);
        pointer.position = ParseVec2(row.pointerPosition);
        pointer.button = PointerEventData.InputButton.Left;
        pointer.pointerId = -1;
        pointer.clickCount = 1;
        pointer.clickTime = Time.unscaledTime;

        if (eventSystem != null)
        {
            var eventHits = new List<RaycastResult>();
            eventSystem.RaycastAll(pointer, eventHits);
            if (prefix == "forced")
            {
                row.eventSystemRaycastAllForcedCount = eventHits.Count;
                row.eventTargetIncludedForced = TargetIncluded(row, eventHits);
                row.eventHitPathsForced = HitPaths(eventHits);
            }
            else
            {
                row.eventSystemRaycastAllCount = eventHits.Count;
                row.eventTargetIncluded = TargetIncluded(row, eventHits);
                row.eventHitPaths = HitPaths(eventHits);
            }
        }
        if (raycaster != null)
        {
            var directHits = new List<RaycastResult>();
            raycaster.Raycast(pointer, directHits);
            row.directGraphicRaycasterHitCount = directHits.Count;
            row.directTargetIncluded = TargetIncluded(row, directHits);
            row.directHitPaths = HitPaths(directHits);
        }
        row.raycasterManagerCount = GetRaycasterManagerList().Count;
        row.currentRaycasterRegistered = raycaster != null && GetRaycasterManagerList().Contains(raycaster);
        row.raycasterManagerSummary = RaycasterManagerSummary();
    }

    private static void FillButtonState(Row row, Button button)
    {
        row.eventSystemPresent = UnityEngine.Object.FindObjectOfType<EventSystem>(true) != null;
        row.eventSystemCurrentMatches = row.eventSystemPresent && EventSystem.current == UnityEngine.Object.FindObjectOfType<EventSystem>(true);
        row.buttonInteractable = button.interactable;
        row.buttonOnClickPersistentCount = button.onClick.GetPersistentEventCount();
        row.buttonOnClickRuntimeCount = RuntimeListenerCount(button.onClick);
        row.eventTriggerCount = button.GetComponents<EventTrigger>().Length;
        row.uiEventListenerPresent = button.GetComponent<YouYou.UIEventListener>() != null;
        row.uiEventListenerHasDelegate = row.uiEventListenerPresent && button.GetComponent<YouYou.UIEventListener>().onClick != null;
        row.luaFormPresent = FindTransform("BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle") != null && FindTransform("BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_01_ui_normalbattle").GetComponent<YouYou.LuaForm>() != null;
        row.battle3dLuaUnitPresent = FindTransform("BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_02_ui_battle3dui") != null && FindTransform("BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_02_ui_battle3dui").GetComponent<YouYou.LuaUnit>() != null;
        row.boxPageLuaUnitPresent = FindTransform("BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_02_ui_battle3dui/root_battle/UI_BattleBoxPage") != null && FindTransform("BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_02_ui_battle3dui/root_battle/UI_BattleBoxPage").GetComponent<YouYou.LuaUnit>() != null;
        row.boxItemBinderPresent = FindTransform("BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_02_ui_battle3dui/root_battle/UI_BattleBoxPage/pop_Content/box_item") != null && FindTransform("BattleHudSpriteAtlasTextureRuntimeBindingClip05Root/CanvasLuaStateHUD_02_ui_battle3dui/root_battle/UI_BattleBoxPage/pop_Content/box_item").GetComponent<LuaComponentBinder.LuaComBinder>() != null;
        row.missingOnButton = CountMissingOnTransform(button.transform);
        row.missingOnParents = CountMissingOnParents(button.transform);
        row.missingComponentChain = MissingChain(button.transform);
    }

    private static bool TargetIncluded(Row row, List<RaycastResult> hits)
    {
        foreach (var hit in hits)
        {
            if (hit.gameObject == null) continue;
            string path = HierarchyPath(hit.gameObject.transform);
            if (path == row.buttonScenePath || path.StartsWith(row.buttonScenePath + "/")) return true;
        }
        return false;
    }

    private static string HitPaths(List<RaycastResult> hits)
    {
        var paths = new List<string>();
        for (int i = 0; i < hits.Count && paths.Count < 8; i++)
        {
            if (hits[i].gameObject == null) continue;
            paths.Add(HierarchyPath(hits[i].gameObject.transform) + "#depth=" + hits[i].depth + "#module=" + (hits[i].module != null ? hits[i].module.GetType().Name : ""));
        }
        return string.Join(" | ", paths.ToArray());
    }

    private static void ForceRegisterRaycasters()
    {
        var add = FindRaycasterManagerMethod("AddRaycaster");
        if (add == null) return;
        foreach (var raycaster in UnityEngine.Object.FindObjectsOfType<BaseRaycaster>(true))
        {
            if (raycaster == null || !raycaster.isActiveAndEnabled) continue;
            try { add.Invoke(null, new object[] { raycaster }); } catch { }
        }
    }

    private static List<BaseRaycaster> GetRaycasterManagerList()
    {
        var list = new List<BaseRaycaster>();
        try
        {
            var m = FindRaycasterManagerMethod("GetRaycasters");
            var value = m != null ? m.Invoke(null, null) as System.Collections.IEnumerable : null;
            if (value != null)
                foreach (var item in value)
                    if (item is BaseRaycaster br && br != null) list.Add(br);
        }
        catch { }
        return list;
    }

    private static MethodInfo FindRaycasterManagerMethod(string method)
    {
        var assemblies = new[] { typeof(EventSystem).Assembly, typeof(BaseRaycaster).Assembly, typeof(GraphicRaycaster).Assembly };
        foreach (var assembly in assemblies)
        {
            var t = assembly.GetType("UnityEngine.EventSystems.RaycasterManager");
            var m = t != null ? t.GetMethod(method, BindingFlags.Static | BindingFlags.Public | BindingFlags.NonPublic) : null;
            if (m != null) return m;
        }
        return null;
    }

    private static string RaycasterManagerSummary()
    {
        bool typeFound = FindRaycasterManagerMethod("GetRaycasters") != null;
        var parts = new List<string>();
        foreach (var r in GetRaycasterManagerList())
            if (r != null) parts.Add(HierarchyPath(r.transform) + ":" + r.GetType().FullName + ":enabled=" + r.enabled + ":active=" + r.IsActive());
        return "typeFound=" + Bool(typeFound) + " | count=" + parts.Count + " | " + string.Join(" ; ", parts.ToArray());
    }

    private static List<InputRow> LoadInputRows(string path)
    {
        var rows = new List<InputRow>();
        if (!File.Exists(path)) return rows;
        var lines = File.ReadAllLines(path, new UTF8Encoding(true));
        if (lines.Length < 2) return rows;
        var headers = SplitCsvLine(lines[0]);
        for (int i = 1; i < lines.Length; i++)
        {
            var map = RowMap(headers, SplitCsvLine(lines[i]));
            string button = Get(map, "buttonName");
            if (Array.IndexOf(ButtonOrder, button) < 0) continue;
            rows.Add(new InputRow
            {
                buttonName = button,
                pointerPosition = Get(map, "pointerPosition"),
                buttonScenePath = Get(map, "buttonScenePath"),
                originalButtonPath = Get(map, "originalButtonPath"),
                luaHandlerCandidate = HandlerFor(button)
            });
        }
        return rows;
    }

    private static string HandlerFor(string button)
    {
        if (button == "btnAuto") return "UI_NormalBattle:86-110 ChangeToAuto(true)/ChangeToManual";
        if (button == "btnBuff") return "UI_NormalBattle:180-184 ShowBuffView(f==false)";
        if (button == "btnTwoSpeed") return "UI_NormalBattle:111-131 SetGameSpeed";
        if (button == "btnFastSkill") return "UI_NormalBattle:132-146 ChangeGameFastSkill/CheckFastSkill";
        if (button == "btn_box") return "UI_BattleBoxPage:162-178 UIEventListener.onClick showFlyAction/RecycleBoxInstance";
        return "";
    }

    private static void Summarize(Result result, List<Row> rows, List<BridgeRow> bridgeRows)
    {
        result.rowCount = rows.Count;
        result.bridgeRowCount = bridgeRows.Count;
        foreach (var br in bridgeRows) if (br.added) result.bridgeAddedCount++;
        foreach (var row in rows)
        {
            if (row.directTargetIncluded) result.directGraphicTargetIncludedCount++;
            if (row.eventTargetIncluded) result.eventSystemTargetIncludedCount++;
            if (row.eventTargetIncludedForced) result.forcedEventSystemTargetIncludedCount++;
            if (row.currentRaycasterRegistered) result.currentRaycasterRegisteredCount++;
            if (row.buttonOnClickPersistentCount + row.buttonOnClickRuntimeCount > 0 || row.uiEventListenerHasDelegate) result.handlerBoundCount++;
        }
        result.patchDecision = "candidate_bridge_patch_no_fake_handler";
        result.nextBlocker = "BATTLE_52_CONNECT_XLUA_RUNTIME_GAMEENTRY_MODULESINIT_PROCEDURE_NORMAL_BATTLE_OR_BLOCK";
    }

    private static void FillEventSystemSummary(Result result)
    {
        var systems = UnityEngine.Object.FindObjectsOfType<EventSystem>(true);
        result.eventSystemCount = systems.Length;
        var modules = UnityEngine.Object.FindObjectsOfType<BaseInputModule>(true);
        result.inputModuleCount = modules.Length;
        var parts = new List<string>();
        foreach (var module in modules)
            if (module != null) parts.Add(HierarchyPath(module.transform) + ":" + module.GetType().FullName + ":enabled=" + module.enabled + ":active=" + module.isActiveAndEnabled);
        result.inputModuleSummary = string.Join(" | ", parts.ToArray());
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
            try { CanvasUpdateRegistry.RegisterCanvasElementForGraphicRebuild(graphic); } catch { }
            try { graphic.Rebuild(CanvasUpdate.PreRender); } catch { }
        }
        Canvas.ForceUpdateCanvases();
        DestroyTexture(RenderCamera(camera, 640, 480, null));
        Canvas.ForceUpdateCanvases();
    }

    private static void Snapshot(Result result, string phase)
    {
        int canvas = UnityEngine.Object.FindObjectsOfType<Canvas>(true).Length;
        int raycaster = UnityEngine.Object.FindObjectsOfType<GraphicRaycaster>(true).Length;
        int button = UnityEngine.Object.FindObjectsOfType<Button>(true).Length;
        int missing = CountMissingScripts();
        int luaForm = UnityEngine.Object.FindObjectsOfType<YouYou.LuaForm>(true).Length;
        int luaUnit = UnityEngine.Object.FindObjectsOfType<YouYou.LuaUnit>(true).Length;
        int binder = UnityEngine.Object.FindObjectsOfType<LuaComponentBinder.LuaComBinder>(true).Length;
        int listener = UnityEngine.Object.FindObjectsOfType<YouYou.UIEventListener>(true).Length;
        if (phase == "before")
        {
            result.beforeCanvasCount = canvas; result.beforeGraphicRaycasterCount = raycaster; result.beforeButtonCount = button; result.beforeMissingScriptCount = missing; result.beforeLuaFormCount = luaForm; result.beforeLuaUnitCount = luaUnit; result.beforeLuaComBinderCount = binder; result.beforeUIEventListenerCount = listener;
        }
        else if (phase == "after")
        {
            result.afterCanvasCount = canvas; result.afterGraphicRaycasterCount = raycaster; result.afterButtonCount = button; result.afterMissingScriptCount = missing; result.afterLuaFormCount = luaForm; result.afterLuaUnitCount = luaUnit; result.afterLuaComBinderCount = binder; result.afterUIEventListenerCount = listener;
        }
        else
        {
            result.reopenCanvasCount = canvas; result.reopenGraphicRaycasterCount = raycaster; result.reopenButtonCount = button; result.reopenMissingScriptCount = missing; result.reopenLuaFormCount = luaForm; result.reopenLuaUnitCount = luaUnit; result.reopenLuaComBinderCount = binder; result.reopenUIEventListenerCount = listener;
        }
    }

    private static int CountMissingScripts()
    {
        int count = 0;
        foreach (var transform in UnityEngine.Object.FindObjectsOfType<Transform>(true))
            foreach (var component in transform.GetComponents<Component>())
                if (component == null) count++;
        return count;
    }

    private static string MissingChain(Transform start)
    {
        var parts = new List<string>();
        var cursor = start;
        while (cursor != null)
        {
            int missing = CountMissingOnTransform(cursor);
            if (missing > 0) parts.Add(HierarchyPath(cursor) + ":missing=" + missing + ":components=" + ComponentTypes(cursor));
            cursor = cursor.parent;
        }
        return string.Join(" | ", parts.ToArray());
    }

    private static int CountMissingOnTransform(Transform transform)
    {
        int count = 0;
        foreach (var c in transform.GetComponents<Component>()) if (c == null) count++;
        return count;
    }

    private static int CountMissingOnParents(Transform transform)
    {
        int count = 0;
        var cursor = transform;
        while (cursor != null)
        {
            count += CountMissingOnTransform(cursor);
            cursor = cursor.parent;
        }
        return count;
    }

    private static string ComponentTypes(Transform transform)
    {
        var parts = new List<string>();
        foreach (var c in transform.GetComponents<Component>()) parts.Add(c == null ? "<missing>" : c.GetType().FullName);
        return string.Join(";", parts.ToArray());
    }

    private static int RuntimeListenerCount(UnityEngine.Events.UnityEvent evt)
    {
        try
        {
            var baseType = typeof(UnityEngine.Events.UnityEventBase);
            var callsField = baseType.GetField("m_Calls", BindingFlags.Instance | BindingFlags.NonPublic);
            var calls = callsField != null ? callsField.GetValue(evt) : null;
            if (calls == null) return 0;
            var runtimeField = calls.GetType().GetField("m_RuntimeCalls", BindingFlags.Instance | BindingFlags.NonPublic);
            var runtime = runtimeField != null ? runtimeField.GetValue(calls) as System.Collections.ICollection : null;
            return runtime != null ? runtime.Count : 0;
        }
        catch { return 0; }
    }

    private static T FindComponent<T>(string path) where T : Component
    {
        var transform = FindTransform(path);
        return transform != null ? transform.GetComponent<T>() : null;
    }

    private static UnityEngine.Object FirstNonTransformComponent(string path)
    {
        var transform = FindTransform(path);
        if (transform == null) return null;
        foreach (var component in transform.GetComponents<Component>())
            if (component != null && !(component is Transform)) return component;
        return transform;
    }

    private static Transform FindTransform(string path)
    {
        foreach (var transform in UnityEngine.Object.FindObjectsOfType<Transform>(true))
            if (HierarchyPath(transform) == path) return transform;
        return null;
    }

    private static Camera FindCaptureCamera()
    {
        foreach (var cam in UnityEngine.Object.FindObjectsOfType<Camera>(true))
            if (cam != null && cam.name.IndexOf("BattleHudSpriteAtlasTextureRuntimeBindingClip05Camera", StringComparison.OrdinalIgnoreCase) >= 0) return cam;
        foreach (var cam in UnityEngine.Object.FindObjectsOfType<Camera>(true))
            if (cam != null && cam.gameObject.activeInHierarchy) return cam;
        return null;
    }

    private static void ConfigureCamera(Camera camera)
    {
        camera.gameObject.SetActive(true);
        camera.enabled = true;
        camera.clearFlags = CameraClearFlags.SolidColor;
        camera.backgroundColor = Color.black;
        camera.orthographic = true;
        if (camera.orthographicSize < 1f) camera.orthographicSize = 540f;
        camera.targetTexture = null;
        camera.ResetAspect();
        camera.ResetProjectionMatrix();
        camera.ResetWorldToCameraMatrix();
    }

    private static void Capture(Camera camera, string path)
    {
        if (camera == null) return;
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        DestroyTexture(RenderCamera(camera, 1920, 1080, path));
    }

    private static Texture2D RenderCamera(Camera camera, int width, int height, string optionalPath)
    {
        if (camera == null) return null;
        var rt = new RenderTexture(width, height, 24, RenderTextureFormat.ARGB32);
        var previousTarget = camera.targetTexture;
        var previousActive = RenderTexture.active;
        camera.targetTexture = rt;
        RenderTexture.active = rt;
        camera.Render();
        var texture = new Texture2D(width, height, TextureFormat.RGB24, false);
        texture.ReadPixels(new Rect(0, 0, width, height), 0, 0);
        texture.Apply();
        if (!string.IsNullOrEmpty(optionalPath)) File.WriteAllBytes(optionalPath, texture.EncodeToPNG());
        camera.targetTexture = previousTarget;
        RenderTexture.active = previousActive;
        UnityEngine.Object.DestroyImmediate(rt);
        return texture;
    }

    private static void DestroyTexture(Texture2D texture)
    {
        if (texture != null) UnityEngine.Object.DestroyImmediate(texture);
    }

    private static Dictionary<string, string> RowMap(List<string> headers, List<string> values)
    {
        var map = new Dictionary<string, string>();
        for (int i = 0; i < headers.Count && i < values.Count; i++) map[headers[i]] = values[i];
        return map;
    }

    private static List<string> SplitCsvLine(string line)
    {
        var values = new List<string>();
        var sb = new StringBuilder();
        bool quote = false;
        for (int i = 0; i < line.Length; i++)
        {
            char c = line[i];
            if (quote && c == '"' && i + 1 < line.Length && line[i + 1] == '"') { sb.Append('"'); i++; }
            else if (c == '"') quote = !quote;
            else if (c == ',' && !quote) { values.Add(sb.ToString()); sb.Length = 0; }
            else sb.Append(c);
        }
        values.Add(sb.ToString());
        return values;
    }

    private static Vector2 ParseVec2(string value)
    {
        var parts = (value ?? "0/0").Split('/');
        float x = 0, y = 0;
        if (parts.Length > 0) float.TryParse(parts[0], System.Globalization.NumberStyles.Float, System.Globalization.CultureInfo.InvariantCulture, out x);
        if (parts.Length > 1) float.TryParse(parts[1], System.Globalization.NumberStyles.Float, System.Globalization.CultureInfo.InvariantCulture, out y);
        return new Vector2(x, y);
    }

    private static string Get(Dictionary<string, string> map, string key) { return map.ContainsKey(key) ? map[key] : ""; }
    private static string HierarchyPath(Transform transform) { var names = new List<string>(); var cursor = transform; while (cursor != null) { names.Add(cursor.name); cursor = cursor.parent; } names.Reverse(); return string.Join("/", names.ToArray()); }
    private static string ProjectPath(string assetPath) { return Path.Combine(Application.dataPath, "..", assetPath.Replace("/", "\\")); }
    private static string Bool(bool value) { return value ? "true" : "false"; }
    private static string Json(string value) { return (value ?? "").Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", " ").Replace("\n", " "); }
    private static string Csv(string value) { return "\"" + (value ?? "").Replace("\"", "\"\"") + "\""; }

    private static void WriteOutputs(Result result, List<Row> rows, List<BridgeRow> bridgeRows)
    {
        WriteRowsCsv(ProjectPath(RowsCsvPath), rows);
        WriteBridgeCsv(ProjectPath(BridgeCsvPath), bridgeRows);
        WriteJson(ProjectPath(ResultJsonPath), result);
    }

    private static void WriteRowsCsv(string path, List<Row> rows)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        var sb = new StringBuilder();
        sb.AppendLine("buttonName,pointerPosition,buttonScenePath,originalButtonPath,luaHandlerCandidate,phase,eventSystemPresent,eventSystemCurrentMatches,buttonInteractable,buttonOnClickPersistentCount,buttonOnClickRuntimeCount,eventTriggerCount,uiEventListenerPresent,uiEventListenerHasDelegate,luaFormPresent,battle3dLuaUnitPresent,boxPageLuaUnitPresent,boxItemBinderPresent,missingOnButton,missingOnParents,eventSystemRaycastAllCount,eventTargetIncluded,eventHitPaths,directGraphicRaycasterHitCount,directTargetIncluded,directHitPaths,raycasterManagerCount,currentRaycasterRegistered,raycasterManagerSummary,eventSystemRaycastAllForcedCount,eventTargetIncludedForced,eventHitPathsForced,missingComponentChain,patchDecision");
        foreach (var r in rows)
        {
            sb.AppendLine(string.Join(",", new[]
            {
                Csv(r.buttonName), Csv(r.pointerPosition), Csv(r.buttonScenePath), Csv(r.originalButtonPath), Csv(r.luaHandlerCandidate), Csv(r.phase),
                Bool(r.eventSystemPresent), Bool(r.eventSystemCurrentMatches), Bool(r.buttonInteractable), r.buttonOnClickPersistentCount.ToString(), r.buttonOnClickRuntimeCount.ToString(), r.eventTriggerCount.ToString(),
                Bool(r.uiEventListenerPresent), Bool(r.uiEventListenerHasDelegate), Bool(r.luaFormPresent), Bool(r.battle3dLuaUnitPresent), Bool(r.boxPageLuaUnitPresent), Bool(r.boxItemBinderPresent),
                r.missingOnButton.ToString(), r.missingOnParents.ToString(), r.eventSystemRaycastAllCount.ToString(), Bool(r.eventTargetIncluded), Csv(r.eventHitPaths),
                r.directGraphicRaycasterHitCount.ToString(), Bool(r.directTargetIncluded), Csv(r.directHitPaths), r.raycasterManagerCount.ToString(), Bool(r.currentRaycasterRegistered), Csv(r.raycasterManagerSummary),
                r.eventSystemRaycastAllForcedCount.ToString(), Bool(r.eventTargetIncludedForced), Csv(r.eventHitPathsForced), Csv(r.missingComponentChain), Csv(r.patchDecision)
            }));
        }
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static void WriteBridgeCsv(string path, List<BridgeRow> rows)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        var sb = new StringBuilder();
        sb.AppendLine("role,scenePath,componentType,originalType,originalScriptPathId,added,evidence");
        foreach (var r in rows)
            sb.AppendLine(string.Join(",", new[] { Csv(r.role), Csv(r.scenePath), Csv(r.componentType), Csv(r.originalType), Csv(r.originalScriptPathId), Bool(r.added), Csv(r.evidence) }));
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private static void WriteJson(string path, Result r)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path));
        var sb = new StringBuilder();
        sb.AppendLine("{");
        sb.AppendLine("  \"status\": \"" + Json(r.status) + "\",");
        sb.AppendLine("  \"isFinalRestoredBattleScreen\": false,");
        sb.AppendLine("  \"sourceScene\": \"" + Json(r.sourceScene) + "\",");
        sb.AppendLine("  \"scene\": \"" + Json(r.scene) + "\",");
        sb.AppendLine("  \"capture\": \"" + Json(r.capture) + "\",");
        sb.AppendLine("  \"sourceSceneOpened\": " + Bool(r.sourceSceneOpened) + ",");
        sb.AppendLine("  \"sceneSaved\": " + Bool(r.sceneSaved) + ",");
        sb.AppendLine("  \"captureExists\": " + Bool(r.captureExists) + ",");
        sb.AppendLine("  \"reopenValid\": " + Bool(r.reopenValid) + ",");
        sb.AppendLine("  \"b50InputRows\": " + r.b50InputRows + ",");
        sb.AppendLine("  \"rowCount\": " + r.rowCount + ",");
        sb.AppendLine("  \"bridgeRowCount\": " + r.bridgeRowCount + ",");
        sb.AppendLine("  \"bridgeAddedCount\": " + r.bridgeAddedCount + ",");
        sb.AppendLine("  \"eventSystemCount\": " + r.eventSystemCount + ",");
        sb.AppendLine("  \"inputModuleCount\": " + r.inputModuleCount + ",");
        sb.AppendLine("  \"inputModuleSummary\": \"" + Json(r.inputModuleSummary) + "\",");
        sb.AppendLine("  \"directGraphicTargetIncludedCount\": " + r.directGraphicTargetIncludedCount + ",");
        sb.AppendLine("  \"eventSystemTargetIncludedCount\": " + r.eventSystemTargetIncludedCount + ",");
        sb.AppendLine("  \"forcedEventSystemTargetIncludedCount\": " + r.forcedEventSystemTargetIncludedCount + ",");
        sb.AppendLine("  \"currentRaycasterRegisteredCount\": " + r.currentRaycasterRegisteredCount + ",");
        sb.AppendLine("  \"handlerBoundCount\": " + r.handlerBoundCount + ",");
        sb.AppendLine("  \"raycasterManagerBefore\": \"" + Json(r.raycasterManagerBefore) + "\",");
        sb.AppendLine("  \"raycasterManagerAfterBridge\": \"" + Json(r.raycasterManagerAfterBridge) + "\",");
        sb.AppendLine("  \"raycasterManagerAfterForcedRegistration\": \"" + Json(r.raycasterManagerAfterForcedRegistration) + "\",");
        sb.AppendLine("  \"raycasterManagerReopenBeforeForced\": \"" + Json(r.raycasterManagerReopenBeforeForced) + "\",");
        sb.AppendLine("  \"raycasterManagerReopenAfterForced\": \"" + Json(r.raycasterManagerReopenAfterForced) + "\",");
        sb.AppendLine("  \"before\": {\"canvas\":" + r.beforeCanvasCount + ",\"graphicRaycaster\":" + r.beforeGraphicRaycasterCount + ",\"button\":" + r.beforeButtonCount + ",\"missingScript\":" + r.beforeMissingScriptCount + ",\"luaForm\":" + r.beforeLuaFormCount + ",\"luaUnit\":" + r.beforeLuaUnitCount + ",\"luaComBinder\":" + r.beforeLuaComBinderCount + ",\"uiEventListener\":" + r.beforeUIEventListenerCount + "},");
        sb.AppendLine("  \"after\": {\"canvas\":" + r.afterCanvasCount + ",\"graphicRaycaster\":" + r.afterGraphicRaycasterCount + ",\"button\":" + r.afterButtonCount + ",\"missingScript\":" + r.afterMissingScriptCount + ",\"luaForm\":" + r.afterLuaFormCount + ",\"luaUnit\":" + r.afterLuaUnitCount + ",\"luaComBinder\":" + r.afterLuaComBinderCount + ",\"uiEventListener\":" + r.afterUIEventListenerCount + "},");
        sb.AppendLine("  \"reopen\": {\"canvas\":" + r.reopenCanvasCount + ",\"graphicRaycaster\":" + r.reopenGraphicRaycasterCount + ",\"button\":" + r.reopenButtonCount + ",\"missingScript\":" + r.reopenMissingScriptCount + ",\"luaForm\":" + r.reopenLuaFormCount + ",\"luaUnit\":" + r.reopenLuaUnitCount + ",\"luaComBinder\":" + r.reopenLuaComBinderCount + ",\"uiEventListener\":" + r.reopenUIEventListenerCount + "},");
        sb.AppendLine("  \"patchDecision\": \"" + Json(r.patchDecision) + "\",");
        sb.AppendLine("  \"nextBlocker\": \"" + Json(r.nextBlocker) + "\",");
        sb.AppendLine("  \"failReason\": \"" + Json(r.failReason) + "\"");
        sb.AppendLine("}");
        File.WriteAllText(path, sb.ToString(), new UTF8Encoding(false));
    }

    private sealed class InputRow
    {
        public string buttonName = "", pointerPosition = "", buttonScenePath = "", originalButtonPath = "", luaHandlerCandidate = "";
    }

    private sealed class BridgeRow
    {
        public string role = "", scenePath = "", componentType = "", originalType = "", originalScriptPathId = "", evidence = "";
        public bool added;
    }

    private sealed class Result
    {
        public string status = "", sourceScene = "", scene = "", capture = "", failReason = "", inputModuleSummary = "", raycasterManagerBefore = "", raycasterManagerAfterBridge = "", raycasterManagerAfterForcedRegistration = "", raycasterManagerReopenBeforeForced = "", raycasterManagerReopenAfterForced = "", patchDecision = "", nextBlocker = "";
        public bool isFinalRestoredBattleScreen, sourceSceneOpened, sceneSaved, captureExists, reopenValid;
        public int b50InputRows, rowCount, bridgeRowCount, bridgeAddedCount, eventSystemCount, inputModuleCount, directGraphicTargetIncludedCount, eventSystemTargetIncludedCount, forcedEventSystemTargetIncludedCount, currentRaycasterRegisteredCount, handlerBoundCount;
        public int beforeCanvasCount, beforeGraphicRaycasterCount, beforeButtonCount, beforeMissingScriptCount, beforeLuaFormCount, beforeLuaUnitCount, beforeLuaComBinderCount, beforeUIEventListenerCount;
        public int afterCanvasCount, afterGraphicRaycasterCount, afterButtonCount, afterMissingScriptCount, afterLuaFormCount, afterLuaUnitCount, afterLuaComBinderCount, afterUIEventListenerCount;
        public int reopenCanvasCount, reopenGraphicRaycasterCount, reopenButtonCount, reopenMissingScriptCount, reopenLuaFormCount, reopenLuaUnitCount, reopenLuaComBinderCount, reopenUIEventListenerCount;
    }

    private sealed class Row
    {
        public string buttonName = "", pointerPosition = "", buttonScenePath = "", originalButtonPath = "", luaHandlerCandidate = "", phase = "", eventHitPaths = "", directHitPaths = "", raycasterManagerSummary = "", eventHitPathsForced = "", missingComponentChain = "", patchDecision = "";
        public bool eventSystemPresent, eventSystemCurrentMatches, buttonInteractable, uiEventListenerPresent, uiEventListenerHasDelegate, luaFormPresent, battle3dLuaUnitPresent, boxPageLuaUnitPresent, boxItemBinderPresent, eventTargetIncluded, directTargetIncluded, currentRaycasterRegistered, eventTargetIncludedForced;
        public int buttonOnClickPersistentCount, buttonOnClickRuntimeCount, eventTriggerCount, missingOnButton, missingOnParents, eventSystemRaycastAllCount, directGraphicRaycasterHitCount, raycasterManagerCount, eventSystemRaycastAllForcedCount;
    }
}
