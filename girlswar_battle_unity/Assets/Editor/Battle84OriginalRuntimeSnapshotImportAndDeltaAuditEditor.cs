using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using UnityEditor;
using UnityEngine;

public static class Battle84OriginalRuntimeSnapshotImportAndDeltaAuditEditor
{
    private const string FilledSnapshotPath = "Assets/RestoreData/battle/BATTLE_84_ORIGINAL_RUNTIME_SNAPSHOT_FILLED.json";
    private const string ResultJsonPath = "Assets/RestoreData/battle/BATTLE_84_ORIGINAL_RUNTIME_SNAPSHOT_IMPORT_AND_DELTA_AUDIT.json";
    private const string CurrentOverlayAuditPath = "Assets/RestoreData/battle/BATTLE_83_PLAYMODE_MASK_STENCIL_TMP_SCALE_AUDIT.json";
    private const string ReportMdPath = @"C:\Users\godho\Downloads\girlswar\reports\battle\BATTLE_84_ORIGINAL_RUNTIME_SNAPSHOT_IMPORT_AND_DELTA_AUDIT.md";

    private const string B75BaseName = "BATTLE_75_ORIGINAL_RUNTIME_SNAPSHOT_APPROVAL_PACKET_FOR_UI_NORMALBATTLE_ROUTE_TMP_MASK_HANDLER_AFTER_B74_NO_EXECUTION_NO_PATCH";
    private static readonly string B75ReportDir = Path.Combine(@"C:\Users\godho\Downloads\girlswar\reports\battle");
    private static readonly string B75TemplatePath = Path.Combine(B75ReportDir, B75BaseName + "_APPROVAL_PACKET_TEMPLATE.json");
    private static readonly string B75ChecklistPath = Path.Combine(B75ReportDir, B75BaseName + "_DEDUPLICATED_MINIMAL_RUNTIME_SNAPSHOT_FIELD_CHECKLIST.csv");
    private static readonly string B75HookMatrixPath = Path.Combine(B75ReportDir, B75BaseName + "_HOOK_SOURCE_CANDIDATE_MATRIX.csv");
    private static readonly string B75ResidualBlockerPath = Path.Combine(B75ReportDir, B75BaseName + "_RESIDUAL_BLOCKER_SEPARATION_MATRIX.csv");

    [MenuItem("GirlsWar/Battle/BATTLE84 Import Original Runtime Snapshot And Delta Audit")]
    public static void Run()
    {
        Directory.CreateDirectory(ProjectPath("Assets/RestoreData/battle"));
        Directory.CreateDirectory(Path.GetDirectoryName(ReportMdPath));

        var result = new Result
        {
            generatedAt = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
            filledSnapshotPath = FilledSnapshotPath,
            b75TemplatePath = B75TemplatePath,
            b75ChecklistPath = B75ChecklistPath,
            b75HookMatrixPath = B75HookMatrixPath,
            b75ResidualBlockerPath = B75ResidualBlockerPath,
            currentOverlayAuditPath = CurrentOverlayAuditPath,
            filledSnapshotExists = File.Exists(ProjectPath(FilledSnapshotPath)),
            b75TemplateExists = File.Exists(B75TemplatePath),
            b75ChecklistExists = File.Exists(B75ChecklistPath),
            b75HookMatrixExists = File.Exists(B75HookMatrixPath),
            b75ResidualBlockerExists = File.Exists(B75ResidualBlockerPath),
            currentOverlayAuditExists = File.Exists(ProjectPath(CurrentOverlayAuditPath))
        };

        try
        {
            AuditB75Checklist(result);
            AuditHookMatrix(result);
            AuditResidualBlockers(result);
            AuditCurrentOverlay(result);
            AuditSnapshotJson(result);
            DecideStatus(result);
        }
        catch (Exception ex)
        {
            result.status = "battle84_original_runtime_snapshot_import_exception";
            result.exception = ex.GetType().Name + ": " + ex.Message;
        }

        WriteOutputs(result);
        EditorApplication.Exit(result.status == "battle84_original_runtime_snapshot_import_ready_for_delta_review" ? 0 : 1);
    }

    private static void AuditB75Checklist(Result result)
    {
        if (!result.b75ChecklistExists)
            return;

        var rows = ReadCsv(B75ChecklistPath);
        result.b75ChecklistRows = rows.Count;

        foreach (var row in rows)
        {
            var category = Get(row, "category");
            var requirementLevel = Get(row, "requirementLevel");
            var allowedAcquisition = Get(row, "allowedAcquisition");
            var unblockCategory = Get(row, "unblockCategory");
            var safeToPatchNow = Get(row, "safeToPatchNow");

            if (category.IndexOf("active", StringComparison.OrdinalIgnoreCase) >= 0)
                result.b75ActiveChainRows++;
            if (requirementLevel.IndexOf("component-rehydration", StringComparison.OrdinalIgnoreCase) >= 0)
                result.b75ComponentRehydrationRows++;
            if (allowedAcquisition.IndexOf("approved runtime snapshot", StringComparison.OrdinalIgnoreCase) >= 0 ||
                allowedAcquisition.IndexOf("runtime snapshot", StringComparison.OrdinalIgnoreCase) >= 0)
                result.b75ApprovedRuntimeSnapshotRows++;
            if (unblockCategory.IndexOf("handler", StringComparison.OrdinalIgnoreCase) >= 0 ||
                category.IndexOf("handler", StringComparison.OrdinalIgnoreCase) >= 0)
                result.b75HandlerOrLifecycleRows++;
            if (string.Equals(safeToPatchNow, "true", StringComparison.OrdinalIgnoreCase))
                result.b75SafeToPatchNowRows++;
        }
    }

    private static void AuditHookMatrix(Result result)
    {
        if (!result.b75HookMatrixExists)
            return;

        var rows = ReadCsv(B75HookMatrixPath);
        result.b75HookCandidateRows = rows.Count;
        foreach (var row in rows)
        {
            if (string.Equals(Get(row, "approvalRequired"), "true", StringComparison.OrdinalIgnoreCase))
                result.b75HookApprovalRequiredRows++;
            if (string.Equals(Get(row, "executionInBattle75"), "true", StringComparison.OrdinalIgnoreCase))
                result.b75HookExecutedRows++;
        }
    }

    private static void AuditResidualBlockers(Result result)
    {
        if (!result.b75ResidualBlockerExists)
            return;

        var rows = ReadCsv(B75ResidualBlockerPath);
        result.b75ResidualBlockerRows = rows.Count;
        foreach (var row in rows)
        {
            var status = Get(row, "status");
            var blocker = Get(row, "blocker");
            if (string.Equals(status, "blocked", StringComparison.OrdinalIgnoreCase))
                result.b75ResidualBlockedRows++;
            if (blocker.IndexOf("xlua", StringComparison.OrdinalIgnoreCase) >= 0 ||
                blocker.IndexOf("handler", StringComparison.OrdinalIgnoreCase) >= 0)
                result.b75ResidualXluaOrHandlerRows++;
        }
    }

    private static void AuditCurrentOverlay(Result result)
    {
        if (!result.currentOverlayAuditExists)
            return;

        var text = File.ReadAllText(ProjectPath(CurrentOverlayAuditPath), Encoding.UTF8);
        result.currentOverlayStatus = ExtractJsonString(text, "status");
        result.currentOverlayRouteSiblingVerified = ContainsJsonBool(text, "routeSiblingVerified", true);
        result.currentOverlayMaskStencilVerified = ContainsJsonBool(text, "maskStencilVerified", true);
        result.currentOverlayTmpScaleAutosizeVerified = ContainsJsonBool(text, "tmpScaleAutosizeVerified", true);
        result.currentOverlayRosterDataVerified = ContainsJsonBool(text, "rosterDataVerified", true);
    }

    private static void AuditSnapshotJson(Result result)
    {
        var filledPath = ProjectPath(FilledSnapshotPath);
        var sourcePath = result.filledSnapshotExists ? filledPath : B75TemplatePath;
        result.snapshotSourcePathUsed = sourcePath;
        result.snapshotSourceIsFilledCandidate = result.filledSnapshotExists;
        result.snapshotSourceExists = File.Exists(sourcePath);
        if (!result.snapshotSourceExists)
            return;

        var text = File.ReadAllText(sourcePath, Encoding.UTF8);
        result.snapshotRuntimeValueKeyCount = Regex.Matches(text, "\"runtimeValue\"\\s*:").Count;
        result.snapshotRuntimeValueNullCount = Regex.Matches(text, "\"runtimeValue\"\\s*:\\s*null").Count;
        result.snapshotRuntimeValueStringCount = Regex.Matches(text, "\"runtimeValue\"\\s*:\\s*\"").Count;
        result.snapshotRuntimeValueNumberOrBoolCount = Regex.Matches(text, "\"runtimeValue\"\\s*:\\s*(-?\\d|true|false)", RegexOptions.IgnoreCase).Count;
        result.snapshotObjectPathKeyCount = Regex.Matches(text, "\"objectPath\"\\s*:").Count;
        result.snapshotFieldNameKeyCount = Regex.Matches(text, "\"fieldName\"\\s*:").Count;
        result.snapshotHasSafetyNotes = text.IndexOf("safetyNotes", StringComparison.OrdinalIgnoreCase) >= 0;
        result.snapshotForbidsFakeHandlers = text.IndexOf("fake", StringComparison.OrdinalIgnoreCase) >= 0 &&
            text.IndexOf("handler", StringComparison.OrdinalIgnoreCase) >= 0;
        result.snapshotTimingMentionsOpenRefresh = text.IndexOf("UI_NormalBattle", StringComparison.OrdinalIgnoreCase) >= 0 &&
            (text.IndexOf("Open", StringComparison.OrdinalIgnoreCase) >= 0 || text.IndexOf("Refresh", StringComparison.OrdinalIgnoreCase) >= 0);
    }

    private static void DecideStatus(Result result)
    {
        result.b75PacketPresent = result.b75TemplateExists &&
            result.b75ChecklistExists &&
            result.b75HookMatrixExists &&
            result.b75ResidualBlockerExists;
        result.currentOverlayVerified = result.currentOverlayStatus == "battle83_mask_stencil_tmp_scale_verified" &&
            result.currentOverlayRouteSiblingVerified &&
            result.currentOverlayMaskStencilVerified &&
            result.currentOverlayTmpScaleAutosizeVerified &&
            result.currentOverlayRosterDataVerified;
        result.snapshotTemplateCompleteEnough = result.snapshotRuntimeValueKeyCount > 0 &&
            result.snapshotObjectPathKeyCount > 0 &&
            result.snapshotFieldNameKeyCount > 0 &&
            result.snapshotHasSafetyNotes &&
            result.snapshotForbidsFakeHandlers;
        result.filledSnapshotComplete = result.filledSnapshotExists &&
            result.snapshotRuntimeValueKeyCount > 0 &&
            result.snapshotRuntimeValueNullCount == 0 &&
            result.snapshotRuntimeValueKeyCount == result.snapshotObjectPathKeyCount &&
            result.snapshotRuntimeValueKeyCount == result.snapshotFieldNameKeyCount;
        result.originalRuntimeGapStillOpen = !result.filledSnapshotComplete;
        result.safeToApplyOriginalRuntimePatch = result.filledSnapshotComplete &&
            result.b75PacketPresent &&
            result.currentOverlayVerified;

        if (!result.b75PacketPresent)
            result.status = "battle84_blocked_b75_packet_missing";
        else if (!result.currentOverlayVerified)
            result.status = "battle84_blocked_current_overlay_audit_not_verified";
        else if (!result.filledSnapshotExists)
            result.status = "battle84_blocked_original_runtime_snapshot_missing";
        else if (!result.filledSnapshotComplete)
            result.status = "battle84_blocked_original_runtime_snapshot_incomplete";
        else
            result.status = "battle84_original_runtime_snapshot_import_ready_for_delta_review";
    }

    private static List<Dictionary<string, string>> ReadCsv(string path)
    {
        var rows = new List<Dictionary<string, string>>();
        var lines = File.ReadAllLines(path, Encoding.UTF8);
        if (lines.Length == 0)
            return rows;

        var headers = ParseCsvLine(lines[0]);
        for (var i = 1; i < lines.Length; i++)
        {
            if (string.IsNullOrWhiteSpace(lines[i]))
                continue;

            var values = ParseCsvLine(lines[i]);
            var row = new Dictionary<string, string>();
            for (var h = 0; h < headers.Count; h++)
                row[headers[h]] = h < values.Count ? values[h] : "";
            rows.Add(row);
        }
        return rows;
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

    private static bool ContainsJsonBool(string text, string key, bool value)
    {
        return Regex.IsMatch(text, "\"" + Regex.Escape(key) + "\"\\s*:\\s*" + (value ? "true" : "false"), RegexOptions.IgnoreCase);
    }

    private static string ExtractJsonString(string text, string key)
    {
        var match = Regex.Match(text, "\"" + Regex.Escape(key) + "\"\\s*:\\s*\"([^\"]*)\"");
        return match.Success ? match.Groups[1].Value : "";
    }

    private static void WriteOutputs(Result output)
    {
        File.WriteAllText(ProjectPath(ResultJsonPath), JsonUtility.ToJson(output, true), Encoding.UTF8);

        var sb = new StringBuilder();
        sb.AppendLine("# BATTLE_84_ORIGINAL_RUNTIME_SNAPSHOT_IMPORT_AND_DELTA_AUDIT");
        sb.AppendLine();
        sb.AppendLine("- status: `" + output.status + "`");
        sb.AppendLine("- filled snapshot path: `" + ProjectPath(FilledSnapshotPath) + "`");
        sb.AppendLine("- snapshot source used: `" + output.snapshotSourcePathUsed + "`");
        sb.AppendLine("- B75 packet present: `" + output.b75PacketPresent + "`");
        sb.AppendLine("- B75 checklist rows / hooks / residual blockers: `" + output.b75ChecklistRows + " / " + output.b75HookCandidateRows + " / " + output.b75ResidualBlockerRows + "`");
        sb.AppendLine("- B75 approved runtime snapshot rows: `" + output.b75ApprovedRuntimeSnapshotRows + "`");
        sb.AppendLine("- B75 component rehydration rows: `" + output.b75ComponentRehydrationRows + "`");
        sb.AppendLine("- B75 hook approval required/executed: `" + output.b75HookApprovalRequiredRows + " / " + output.b75HookExecutedRows + "`");
        sb.AppendLine("- B75 residual blocked/xLua-or-handler rows: `" + output.b75ResidualBlockedRows + " / " + output.b75ResidualXluaOrHandlerRows + "`");
        sb.AppendLine("- current overlay status: `" + output.currentOverlayStatus + "`");
        sb.AppendLine("- current overlay route/mask/TMP/roster verified: `" + output.currentOverlayRouteSiblingVerified + " / " + output.currentOverlayMaskStencilVerified + " / " + output.currentOverlayTmpScaleAutosizeVerified + " / " + output.currentOverlayRosterDataVerified + "`");
        sb.AppendLine("- runtimeValue keys/null/string/numberOrBool: `" + output.snapshotRuntimeValueKeyCount + " / " + output.snapshotRuntimeValueNullCount + " / " + output.snapshotRuntimeValueStringCount + " / " + output.snapshotRuntimeValueNumberOrBoolCount + "`");
        sb.AppendLine("- objectPath/fieldName keys: `" + output.snapshotObjectPathKeyCount + " / " + output.snapshotFieldNameKeyCount + "`");
        sb.AppendLine("- template safety/fake-handler guard/open-refresh timing: `" + output.snapshotHasSafetyNotes + " / " + output.snapshotForbidsFakeHandlers + " / " + output.snapshotTimingMentionsOpenRefresh + "`");
        sb.AppendLine("- filled snapshot complete: `" + output.filledSnapshotComplete + "`");
        sb.AppendLine("- original runtime gap still open: `" + output.originalRuntimeGapStillOpen + "`");
        sb.AppendLine("- safe to apply original runtime patch: `" + output.safeToApplyOriginalRuntimePatch + "`");
        sb.AppendLine();
        sb.AppendLine("## Decision");
        if (output.status == "battle84_original_runtime_snapshot_import_ready_for_delta_review")
        {
            sb.AppendLine("- A filled original-runtime snapshot is present and complete enough for the next delta audit.");
            sb.AppendLine("- The next step is to compare each filled B75 runtime value against the current candidate and patch only source-backed, runtime-confirmed route/HUD/TMP/mask fields.");
        }
        else
        {
            sb.AppendLine("- This is not a restoration proof. It is a gate report.");
            sb.AppendLine("- Original `UI_NormalBattle` route active state, sibling order, TMP, mask/stencil, and handler ownership remain unproven until the filled snapshot exists.");
            sb.AppendLine("- The generated playable roster overlay remains verified separately by B77/B79/B80/B81/B83.");
        }
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
        public string filledSnapshotPath;
        public string b75TemplatePath;
        public string b75ChecklistPath;
        public string b75HookMatrixPath;
        public string b75ResidualBlockerPath;
        public string currentOverlayAuditPath;
        public string snapshotSourcePathUsed;
        public bool filledSnapshotExists;
        public bool b75TemplateExists;
        public bool b75ChecklistExists;
        public bool b75HookMatrixExists;
        public bool b75ResidualBlockerExists;
        public bool currentOverlayAuditExists;
        public bool snapshotSourceIsFilledCandidate;
        public bool snapshotSourceExists;
        public int b75ChecklistRows;
        public int b75ActiveChainRows;
        public int b75ComponentRehydrationRows;
        public int b75ApprovedRuntimeSnapshotRows;
        public int b75HandlerOrLifecycleRows;
        public int b75SafeToPatchNowRows;
        public int b75HookCandidateRows;
        public int b75HookApprovalRequiredRows;
        public int b75HookExecutedRows;
        public int b75ResidualBlockerRows;
        public int b75ResidualBlockedRows;
        public int b75ResidualXluaOrHandlerRows;
        public string currentOverlayStatus;
        public bool currentOverlayRouteSiblingVerified;
        public bool currentOverlayMaskStencilVerified;
        public bool currentOverlayTmpScaleAutosizeVerified;
        public bool currentOverlayRosterDataVerified;
        public int snapshotRuntimeValueKeyCount;
        public int snapshotRuntimeValueNullCount;
        public int snapshotRuntimeValueStringCount;
        public int snapshotRuntimeValueNumberOrBoolCount;
        public int snapshotObjectPathKeyCount;
        public int snapshotFieldNameKeyCount;
        public bool snapshotHasSafetyNotes;
        public bool snapshotForbidsFakeHandlers;
        public bool snapshotTimingMentionsOpenRefresh;
        public bool b75PacketPresent;
        public bool currentOverlayVerified;
        public bool snapshotTemplateCompleteEnough;
        public bool filledSnapshotComplete;
        public bool originalRuntimeGapStillOpen;
        public bool safeToApplyOriginalRuntimePatch;
        public string exception;
    }
}
