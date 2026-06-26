# MAININTERFACE_129 Required Runtime Snapshot Schema

This schema lists the minimum data needed before activity slots, labels, redpoints, and activity spines can be restored without guessing.

```json
{
  "purpose": "Minimum runtime snapshot needed to source-back UI_MainInterface_old normal-home activity/text reconstruction.",
  "activitys": [
    {
      "activityId": "number; server activity id used by ActMgr:GetAllActInfo",
      "show": "boolean; server show flag checked by IsActShowInMain",
      "openSecond": "number/string; open timestamp if present",
      "closeSecond": "number/string; close timestamp if present",
      "stageId": "number/string; stage/state if present",
      "activityTimes": "object/list; runtime counters used by act managers",
      "extraServerFields": "object; raw packet fields retained for client callbacks"
    }
  ],
  "playerInfo": {
    "level": "number; checked against activity onMainLv",
    "vip": "number; vip>0 bypasses onMainLv filter",
    "playerId": "number/string",
    "name": "string",
    "head": "number/string",
    "headFrame": "number/string"
  },
  "redPointState": {
    "serverRedPointIds": [
      "number/string; RedPointMgr:checkServerRedPoint ids"
    ],
    "actSpecificRedPoints": "object keyed by act id for ActCfgData mainPageRedPointFunc/haveRedFunc callbacks"
  },
  "reviewState": {
    "GameTools_IsReview": "boolean",
    "GameEntry_IsReview": "boolean",
    "GameEntry_IsCommittee": "boolean"
  },
  "guideState": {
    "ModulesInit_GuideMgr_isGuide": "boolean",
    "CurrGuidEnterActId": "number/null"
  },
  "timeState": {
    "serverTimeStep": "number",
    "serverMillTimeStamp": "number"
  },
  "clientCallbackOutputs": {
    "showInMainFunc": "map activityId -> boolean",
    "clientCheckIsOpen": "map activityId -> boolean",
    "getActNewName": "map activityId -> localized/string override",
    "mainPageTouchJumpId": "map activityId -> target act id"
  },
  "localization": {
    "language": "LangCommon Korean",
    "keys": "map of activityname_*, activitysamllname_*, Funtionname_* keys to resolved text"
  },
  "resources": {
    "activitySpine": "map tbSpine/mainPageSpineId -> bundle/prefab/skeleton resource",
    "tmpFontMaterial": "map UI text path -> TMP font asset/shared material"
  }
}
```
