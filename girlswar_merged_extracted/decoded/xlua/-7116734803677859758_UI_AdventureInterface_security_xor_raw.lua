local e=require('DataNode/DataTable/Create/player/DTHeadDBModel')
local e=require('DataNode/DataTable/Create/player/DTLevelUpDBModel')
local e=require('DataNode/DataTable/Create/function/DTFunctionDBModel')
local e=require("DataNode/DataTable/Create/constant/DTConstantDBModel")
local h=require("DataNode/DataManager/DataMgr/DataUtil")
local e=require("DataNode/DataTable/Create/mineBattle/DTMineBattleCfgDBModel")
local o=require('Modules/MainInterface/UI_Adventure_Item')
local s=nil
local i=0
local n=0
local e={}
local a=nil
local t=nil
local d={
'UIAdventure/jjcicon_rk3_1',
'UIAdventure/jjcicon_rk3_2',
'UIAdventure/jjcicon_rk3_3'
}
function OnInit(t,t)
for a=1,LuaUtils.GetChildrenCount(center)do
if GameTools:IsReview()then
local t=o:New(self)
t:SetUI(UIUtil.GetChild(center,a-1),a,ClickItem)
t:SetShow(true)
table.insert(e,t)
local e=UIUtil.GetChild(center,a-1)
if e.name=="bg_huodong5"or e.name=="bg_huodong7"then
LuaUtils.SetActive(e,false)
end
else
local o=o:New(self)
local t=UIUtil.GetChild(center,a-1)
o:SetUI(t,a,ClickItem)
o:SetShow(true)
table.insert(e,o)
if t.name=="bg_huodong6"then
LuaUtils.SetActive(t,false)
elseif t.name=="bg_huodong5"and not ModulesInit.PhotoArtistMgr:IsOpen()then
LuaUtils.SetActive(t,false)
end
end
end
if GameEntry.IsCommittee then
LuaUtils.SetActive(e[4].trans,false)
LuaUtils.SetActive(e[5].trans,false)
LuaUtils.SetActive(e[6].trans,false)
local t=gameObject:GetComponent(typeof(CS.UnityEngine.Animator))
t.enabled=false
LuaUtils.SetLocalPos(e[3].trans,0,-21,0)
end
btn_shop.onClick:AddListener(function()
GameEntry.UI:OpenUIForm(UIFormId.UI_MBShop)
end)
btn_rank.onClick:AddListener(function()
if not ModulesInit.MineMgr:isOpen()then
UIUtil.ShowCommonTips(GameTools.GetLocalize("tips.common_278",LanguageCategory.LangCommon))
return
end
if ModulesInit.MineMgr:isOnlyCheckRank()and ModulesInit.MineMgr.seeRank==false then
UIUtil.ShowCommonTipsForLocalize("mineBattleTips_2")
return
end
GameEntry.UI:OpenUIForm(UIFormId.UI_MBRankAward)
end)
end
function ClickItem(o,i)
if o==1 then
if GameFunction.IsFunctionUnLock(GameFunctionType.Trial,true)then
TowerMgr:GetAllTowerInfo()
end
return
end
if o==2 then
if not GameFunction.IsFunctionUnLock(GameFunctionType.Arena)and not GameFunction.IsFunctionUnLock(GameFunctionType.CrossArena)then
local t,e=GameFunction.GetFunctionUnLockTypeAndParaById(GameFunctionType.Arena)
UIUtil.ShowCommonTips(h.GetConditionUnlockStr(t,e))
return
end
if GameTools:IsReview()then
local e=ModulesInit.ArenaManager:SendArenaInfoRequest()
e.onCompleted=function()
GameEntry.UI:OpenUIForm(UIFormId.UI_Arena)
end
else
local e=ModulesInit.CrossArenaManager:SendCrossArenaStatusRequest()
e.onCompleted=function()
GameEntry.UI:OpenUIForm(UIFormId.UI_ArenaRoot)
end
end
return
end
if o==3 then
if GameFunction.IsFunctionUnLock(GameFunctionType.DragonWar,true)then
GameEntry.UI:OpenUIForm(UIFormId.UI_CommonLoading,{style=LoadingStyle.Cloud,loadResFinish=function()
ModulesInit.KillDragonsManager:Enter()
end})
end
return
end
if o==4 then
ModulesInit.PhotoArtistMgr:setRedStatusSaveID(ModulesInit.PhotoArtistMgr.FirstUI.MazeHelpId)
ModulesInit.MazeMgr:EnterMazeView()
EventSystem.SendEvent(CommonEventId.NewShowInfoChange)
return
end
if o==5 then
if i=="tip"then
local e=e[5]:GetBtnTip()
if e and a then
local o=TimeUtil.timeStampToMD(a.csOpenTime)
local t=a.csOpenTime-TimeUtil.GetServerTimeStamp()
local a=math.ceil(t/86400)
if t>0 then
local e={
imFuncName="UIAdventure/msz_tiphua1",
name=GameTools.GetLocalize("flowerFight_124",LanguageCategory.LangCommon),
name2=GameTools.GetLocalize("flowerFight_125",LanguageCategory.LangCommon),
desc1=GameTools.GetLocalize("flowerFight_123",LanguageCategory.LangCommon,o,a),
desc2=GameTools.GetLocalize("flowerFight_126",LanguageCategory.LangCommon),
worldPos=e.transform.position,
offset=30,
priorPageArr={EHintPageDir.Up},
priorArrowArr={EHintArrowAlign.Vertical_Middle},
}
UIUtil.ShowOpenFuncTip(e)
end
end
else
if GameFunction.IsFunctionUnLock(GameFunctionType.Flower,true)then
ModulesInit.PhotoArtistMgr:setRedStatusSaveID(ModulesInit.PhotoArtistMgr.FirstUI.FlowerFight)
if a==nil then
UIUtil.ShowCommonTips(GameTools.GetLocalize("flowerFight_68",LanguageCategory.LangCommon))
else
if a.upgrade==true then
UIUtil.ShowCommonTips(GameTools.GetLocalize("flowerFight_105",LanguageCategory.LangCommon))
else
if t==nil then
UIUtil.ShowCommonTips(GameTools.GetLocalize("flowerFight_68",LanguageCategory.LangCommon))
else
if t.state==PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_UPGRADE then
local e=t.stateOverTime-TimeUtil.GetServerTimeStamp()
local e=TimeUtil.TimestampToDate2(e)
UIUtil.ShowCommonTips(GameTools.GetLocalize("heFuTip",LanguageCategory.LangCommon,e))
else
if t.state==PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_NONE then
if a.openTime then
local e=a.openTime-TimeUtil:GetServerTimeStamp()
if e>0 then
local e=math.ceil(e/86400)
local e=e..GameTools.GetLocalize("UI.Recharge.Main.02",LanguageCategory.LangCommon)
UIUtil.ShowCommonTips(GameTools.GetLocalize("tips.common_193",LanguageCategory.LangCommon,e))
else
UIUtil.ShowCommonTips(GameTools.GetLocalize("flowerFight_68",LanguageCategory.LangCommon))
end
else
UIUtil.ShowCommonTips(GameTools.GetLocalize("flowerFight_68",LanguageCategory.LangCommon))
end
else
if t.state==PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_SIGN
and not t.isSign
and not t.signMax then
ModulesInit.FlowerFightMgr:ReqFlowerSign(function()
t.isSign=true
UIUtil.ShowCommonTips(GameTools.GetLocalize("flowerFight_106",LanguageCategory.LangCommon,leftDayStr))
RefreshFlowerStateInfo()
EnterFlowerView()
end)
else
EnterFlowerView()
end
end
end
end
end
end
end
end
return
end
if o==6 then
ModulesInit.PhotoArtistMgr:setRedStatusSaveID(ModulesInit.PhotoArtistMgr.FirstUI.SkyCityHelpId)
ModulesInit.SkyCityMgr:EnterSkyCity(nil,{type="DOCK",tabIndex=DOCK_TYPE.ADVENTURE})
EventSystem.SendEvent(CommonEventId.NewShowInfoChange)
return
end
if o==7 then
if not ModulesInit.MineMgr:isOpen()then
UIUtil.ShowCommonTips(GameTools.GetLocalize("tips.common_278",LanguageCategory.LangCommon))
return
end
local e,t,t=GameFunction.IsFunctionUnLock(GameFunctionType.MineWar,true)
if not e then
return
end
local e=ModulesInit.PhotoArtistMgr:checkRedStatusSaveID(ModulesInit.PhotoArtistMgr.FirstUI.MineWar)
ModulesInit.PhotoArtistMgr:setRedStatusSaveID(ModulesInit.PhotoArtistMgr.FirstUI.MineWar)
if e then
LuaUtils.SetActive(im_new_7.transform,false)
end
ModulesInit.MineMgr:entryMine()
if RedPointMgr:checkMineDayRedPoint()then
local e=TimeUtil.GetServerTimeStamp()
SaveMgr.SetStringForKey("minebattle_day_redpoint",e)
RedPointMgr:doNotify()
end
return
end
end
function OnOpen(o)
EventSystem.SendEvent(CommonEventId.RedPointInfoChange)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.AddListener(CommonEventId.RedPointInfoChange,RefreshRedPoint)
EventSystem.AddListener(CommonEventId.OnTowerGetAward,OnCheckRepairStarRedPoint)
EventSystem.AddListener(CommonEventId.NewShowInfoChange,onNewShowChange)
EventSystem.AddListener(CommonEventId.SKY_STATE_CHANGE,RefreshRedPoint)
EventSystem.AddListener(CommonEventId.OnEventRespError,OnEventRespError)
EventSystem.AddListener(CommonEventId.MINE_STATE_CHANGE,OnMineRefresh)
EventSystem.AddListener(CommonEventId.PlayerLevelUp,OnPlayerLevelUp)
EventSystem.AddListener(CommonEventId.OnFlowerMergeServer,OnFlowerMergeServer)
EventSystem.AddListener(CommonEventId.NewDay,OnNewDay)
EventSystem.AddListener(SysEventId.OnUpdate,OnUpdate)
i=5
n=0
a=nil
t=nil
local e=e[4]:GetTrans("maze_layer")
LuaUtils.SetActive(e.transform,false)
Refresh()
RefreshActTip()
local e=CS.DG.Tweening.DOTween.Sequence()
e:AppendInterval(1)
e:AppendCallback(function()
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="OPEN_UI_ADVENTURE_SUC"})
end)
if ModulesInit.MineMgr:isOpen()then
local e,t,t=GameFunction.IsFunctionUnLock(GameFunctionType.MineWar)
if e then
ModulesInit.MineMgr:reqStatus()
end
end
end
function OnEventNetReconnectSuccess()
Refresh()
end
function OnFormBack()
Refresh()
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.RemoveListener(CommonEventId.RedPointInfoChange,RefreshRedPoint)
EventSystem.RemoveListener(CommonEventId.OnTowerGetAward,OnCheckRepairStarRedPoint)
EventSystem.RemoveListener(CommonEventId.NewShowInfoChange,onNewShowChange)
EventSystem.RemoveListener(CommonEventId.SKY_STATE_CHANGE,RefreshRedPoint)
EventSystem.RemoveListener(CommonEventId.OnEventRespError,OnEventRespError)
EventSystem.RemoveListener(CommonEventId.MINE_STATE_CHANGE,OnMineRefresh)
EventSystem.RemoveListener(CommonEventId.PlayerLevelUp,OnPlayerLevelUp)
EventSystem.RemoveListener(CommonEventId.OnFlowerMergeServer,OnFlowerMergeServer)
EventSystem.RemoveListener(CommonEventId.NewDay,OnNewDay)
EventSystem.RemoveListener(SysEventId.OnUpdate,OnUpdate)
a=nil
t=nil
if s then
s:Stop()
s=nil
end
ResetFlowerStatus()
end
function OnBeforeDestroy()
end
function RefreshActTip()
local t=e[3].im_actTip
local e=e[4].im_actTip
local a,o=ModulesInit.ActGoldWeekManager:IsOpenDouble(80)
LuaUtils.SetActive(t.transform,a)
local t,a=ModulesInit.ActGoldWeekManager:IsOpenDouble(501)
LuaUtils.SetActive(e.transform,t)
end
function OnNewDay()
RefreshActTip()
ReqRefreshMine()
ReqFloweServerData(true)
end
function OnUpdate()
UpdateStateInfo()
UpdateLeftTime()
end
function UpdateStateInfo()
i=i+Time.deltaTime
if i<5 then
return
end
i=0
local e,t=GameFunction.IsFunctionUnLock(GameFunctionType.Maze)
if e and GameEntry.UI:IsExists(UIFormId.UI_MazeMainView)==false then
if ModulesInit.MazeMgr.mazeInfo==nil then
ModulesInit.MazeMgr:ReqMazeInfo(false)
else
local e=ModulesInit.MazeMgr.mazeInfo.leftTime-TimeUtil.GetServerTimeStamp()
if e<0 then
ModulesInit.MazeMgr:ReqMazeInfo(false)
end
end
end
RefreshFlowerStatusLock()
end
function RefreshFlowerStatusLock()
local e,o,o=GameFunction.IsFunctionUnLock(GameFunctionType.Flower)
if e then
if a==nil
or(a.upgrade and(a.upgradeEndTimestamp-TimeUtil.GetServerTimeStamp()<0))
or(t and(t.stateOverTime-TimeUtil.GetServerTimeStamp()<0))
then
ReqFloweServerData()
end
end
end
function ReqFloweServerData(e)
if e then
ModulesInit.FlowerFightMgr:ReqFlowerEntranceInfo()
return
end
local e=ModulesInit.FlowerFightMgr:ReqFlowerEntranceInfo(function(e)
a=e
t=e.raceInfo
onNewShowChange()
RefreshUnlock()
end)
end
function OnFlowerMergeServer(e)
a=e.flowerServerInfo
t=e.flowerRaceInfo
onNewShowChange()
RefreshUnlock()
end
function UpdateLeftTime()
n=n+Time.deltaTime
if n<1 then
return
end
n=0
UpdateMazeLeftTime()
UpdateFlowerLeftTime()
RefreshKillDrigon()
UpdateMine()
end
function UpdateMine()
if not ModulesInit.MineMgr:isOpen()then
return
end
local t,a,a=GameFunction.IsFunctionUnLock(GameFunctionType.MineWar)
if not t then
return
end
local t=ModulesInit.MineMgr:showCurrTime()
if t~=""then
e[7]:SetTextPrepare(7,t)
end
end
function UpdateMazeLeftTime()
local t=e[4]:GetTrans("maze_layer")
local a,o=GameFunction.IsFunctionUnLock(GameFunctionType.Maze)
if a==false then
LuaUtils.SetActive(t.transform,false)
return
end
if ModulesInit.MazeMgr.mazeInfo==nil then
e[4]:SetText("")
LuaUtils.SetActive(t.transform,false)
return
end
if ModulesInit.MazeMgr:IsCloseStatus()then
LuaUtils.SetActive(t.transform,false)
end
LuaUtils.SetActive(t.transform,true)
local t=e[4]:GetTrans("maze_layer/maze_layer_num")
local t=t:GetComponent(typeof(CS.TMPro.TextMeshProUGUI))
LuaUtils.SetTextMeshText(t,ModulesInit.MazeMgr.mazeInfo.mapLayer.."/"..Constant.maze_layer_max)
local t=ModulesInit.MazeMgr.mazeInfo.leftTime-TimeUtil.GetServerTimeStamp()
t=math.max(0,t)
local a=TimeUtil.toDHMSStr2(t)
local t="UI.Maze.Main.23"
if ModulesInit.MazeMgr.mazeInfo.status==PROTO_ENUM.ENUM_MAZE_STATUS.MS_STATUS_CLOSE then
t="UI.Maze.Main.22"
end
e[4]:SetText(GameTools.GetLocalize(t,LanguageCategory.LangCommon)..a)
end
function UpdateFlowerLeftTime()
if t==nil then
return
end
if t.state==PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_SIGN_OVER then
local t=t.stateOverTime-TimeUtil.GetServerTimeStamp()
t=math.max(0,t)
local t=TimeUtil.toDHMSStr2(t)
e[5]:SetTextLock(5,GameTools.GetLocalize("tips.common_101",LanguageCategory.LangCommon,tostring(t)))
end
end
function EnterFlowerView()
local e={
isSign=t.isSign,
stage=t.stage,
fromFlowerEntrance=false,
state=t.state,
selfMaxType=t.selfMaxType,
serverType=a.serverType,
serverCount=a.serverCount,
}
ModulesInit.FlowerFightMgr:EnterFlower(e)
end
function ResetFlowerStatus()
e[5]:SetShowBtn1(false)
e[5]:SetShowRepair(false)
e[5]:SetShowImage1(false)
e[5]:SetShowImage2(false)
e[5]:SetShowImage3(false)
e[5]:SetShowSpineState(false)
e[5]:SetShowSpineState2(false)
e[5]:SetBattleServerType(false)
e[5]:SetShowBtnTip(false)
e[5]:SetShowSpineBg(false)
e[5]:SetHeFu(false)
end
function RefreshFlowerStateInfo()
local s,o,u=GameFunction.IsFunctionUnLock(GameFunctionType.Flower)
e[5]:SetUnlock(s)
ResetFlowerStatus()
local i=""
local h=""
local r=""
local o=false
if s and a then
if a.serverType==PROTO_ENUM.ENUM_FLOWER_SERVER_TYPE.SERVER_TYPE_CROSS then
o=true
end
local n=0
local s,n=GetFlowerShowTimeData()
local n=n
local l=s[1]or""
local d=s[2]
local s=s[3]
i=LuaUtils.GetLocalize(l,LanguageCategory.LangCommon)
h=LuaUtils.GetLocalize(d,LanguageCategory.LangCommon)
r=LuaUtils.GetLocalize(s,LanguageCategory.LangCommon)
if a.upgrade==true then
e[5]:SetUnlock(true)
e[5]:SetShowRepair(true)
e[5]:SetTextLock(5,i)
e[5]:SetShowSpineBg(true)
elseif t then
if t.state==PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_UPGRADE then
e[5]:SetHeFu(true,t.stateOverTime)
end
if t.state==PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_NONE then
e[5]:SetUnlock(false)
e[5]:SetTextLock(5,i)
e[5]:SetShowSpineBg(true)
elseif t.state~=PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_UPGRADE then
local t=a.csOpenTime-TimeUtil.GetServerTimeStamp()
local a=ModulesInit.FlowerFightMgr:GetFlowerBaseCfgData()
local a=a.corssPredictionDay*86400
if t>0 and t<a then
e[5]:SetShowBtnTip(true)
end
if n==1 then
e[5]:SetBattleSpine(5,true,"D")
e[5]:SetBattleServerType(true,"UIAdventure/msz_wdhzt07")
elseif n==2 then
e[5]:SetBattleSpine(5,true,"C")
e[5]:SetBattleServerType(true,"UIAdventure/msz_wdhzt07")
elseif n==3 then
e[5]:SetBattleSpine(5,true,"C")
e[5]:SetBattleServerType(true,"UIAdventure/msz_wdhzt08")
elseif n==4 then
if o==false then
e[5]:SetBattleSpine(5,true,"B")
e[5]:SetBattleServerType(true,"UIAdventure/msz_wdhzt07")
else
e[5]:SetBattleSpine(5,true,"B")
e[5]:SetBattleServerType(true,"UIAdventure/msz_wdhzt08")
end
elseif n==0 then
e[5]:SetTextPrepare(5,i,h,r)
end
end
if t.state==PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_SIGN then
if t.isSign then
e[5]:SetShowImage2(true,"UIAdventure/msz_wdhzt04")
else
if t.signMax then
e[5]:SetShowImage1(true,"UIAdventure/msz_wdhzt02")
e[5]:SetShowImage2(true,"UIAdventure/msz_wdhzt03")
else
e[5]:SetShowBtn1(true)
e[5]:SetShowImage3(true,"UIAdventure/msz_wdhzt01")
end
end
elseif t.state==PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_SIGN_OVER then
e[5]:SetShowSpineState2(true,"A")
UpdateFlowerLeftTime()
elseif t.state==PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_FINAL_OVER then
e[5]:SetShowImage2(true,"UIAdventure/msz_wdhzt06")
end
else
e[5]:SetUnlock(false)
e[5]:SetTextLock(5,i)
end
else
if s==false then
i=u
else
i=""
end
e[5]:SetTextLock(5,i)
end
local i=nil
if a and t then
if a.upgrade==false then
i=t.state
end
if a.serverType==PROTO_ENUM.ENUM_FLOWER_SERVER_TYPE.SERVER_TYPE_CROSS then
o=true
end
elseif ModulesInit.FlowerFightMgr.FlowerQualificationProto then
if ModulesInit.FlowerFightMgr.FlowerQualificationProto.normal==true then
i=ModulesInit.FlowerFightMgr.FlowerQualificationProto.tipState
end
if ModulesInit.FlowerFightMgr.FlowerQualificationProto.serverType==PROTO_ENUM.ENUM_FLOWER_SERVER_TYPE.SERVER_TYPE_CROSS then
o=true
end
end
if s and i then
if i<=PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_NONE then
e[5]:SetShowSpineState(false)
elseif i<=PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_PRELIME_OVER then
if o==false then
e[5]:SetShowSpineState(true,"F")
else
e[5]:SetShowSpineState(true,"D")
end
elseif i<=PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_TOP64_OVER then
if o==false then
e[5]:SetShowSpineState(true,"E")
else
e[5]:SetShowSpineState(true,"D")
end
elseif i<=PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_BREAK_OUT_OVER then
if o==false then
else
e[5]:SetShowSpineState(true,"C")
end
elseif i<=PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_FINAL_FIGHT then
if o==false then
e[5]:SetShowSpineState(true,"E")
else
e[5]:SetShowSpineState(true,"C")
end
else
e[5]:SetShowSpineState(false)
end
else
e[5]:SetShowSpineState(false)
end
end
function GetFlowerShowTimeData()
local e={}
local o=0
if a then
if a.upgrade==true then
local t=GameTools.GetLocalize("sky_city_upgradeing",LanguageCategory.LangCommon)
table.insert(e,t)
elseif t then
if t.state==PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_NONE then
if a.openTime then
local e=a.openTime-TimeUtil:GetServerTimeStamp()
if e>0 then
local e=math.ceil(e/86400)
local e=e..GameTools.GetLocalize("UI.Recharge.Main.02",LanguageCategory.LangCommon)
txtContentKey=GameTools.GetLocalize("tips.common_193",LanguageCategory.LangCommon,e)
else
txtContentKey=GameTools.GetLocalize("flowerFight_68",LanguageCategory.LangCommon)
end
else
txtContentKey=GameTools.GetLocalize("flowerFight_68",LanguageCategory.LangCommon)
end
table.insert(e,txtContentKey)
elseif t.state==PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_SIGN then
local a=GameTools.GetLocalize("flowerFight_1",LanguageCategory.LangCommon)
local t=GameTools.GetLocalize("flowerFight_2",LanguageCategory.LangCommon)
table.insert(e,a)
table.insert(e,t)
elseif t.state==PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_SIGN_OVER then
elseif t.state<=PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_PRELIME_OVER then
o=1
elseif t.state<=PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_TOP64_OVER then
o=2
elseif t.state<=PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_BREAK_OUT_OVER then
o=3
elseif t.state<=PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_FINAL_FIGHT then
o=4
elseif t.state<=PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_FINAL_OVER_STOP then
local a=GameTools.GetLocalize("flowerFight_3",LanguageCategory.LangCommon)
local t=GameTools.GetLocalize("flowerFight_5",LanguageCategory.LangCommon)
table.insert(e,a)
table.insert(e,t)
end
else
local t=GameTools.GetLocalize("flowerFight_68",LanguageCategory.LangCommon)
table.insert(e,t)
end
end
return e,o
end
function UpdateSkyCityCountDown()
if ModulesInit.SkyCityMgr.skyState==nil then
return
end
RefreshSkyCityInfo()
end
function RefreshSkyCityInfo()
if ModulesInit.SkyCityMgr.skyState==nil then return end
local t,a,a=GameFunction.IsFunctionUnLock(GameFunctionType.Guild)
if not t then
return
end
if ModulesInit.SkyCityMgr.skyState.status==PROTO_ENUM.ENUM_GVG_STATUS.GVG_STATUS_NOT_OPEN then
local t=""
local a=Constant.citywar_openNum
local o=a<=ModulesInit.SkyCityMgr.skyState.guildCount
if not o then
local e=GameTools.GetLocalize("sky_city_pre_guild_count",LanguageCategory.LangCommon,a)
t=string.format('%s\n%s',t,e)
end
local a=ModulesInit.SkyCityMgr:getEndLeftTime(ModulesInit.SkyCityMgr.skyState.startTime)
if a>0 then
local e=TimeUtil.toDHMSStr2(a)
t=GameTools.GetLocalize("sky_city_pre_open_time",LanguageCategory.LangCommon,e)
end
e[6]:SetTextLock(6,t)
elseif ModulesInit.SkyCityMgr.skyState.status==PROTO_ENUM.ENUM_GVG_STATUS.GVG_STATUS_FIGHTING
or ModulesInit.SkyCityMgr.skyState.status==PROTO_ENUM.ENUM_GVG_STATUS.GVG_STATUS_BULLY_FIGHTING then
e[6]:SetBattleSpine(6,true)
else
local a=GameTools.GetLocalize("tips.common_247",LanguageCategory.LangCommon)
a=string.format("%s %02d:%02d-%02d:%02d",a,Constant.citywar_declareStartHour,Constant.citywar_declareStartMinute,Constant.citywar_declareEndHour,Constant.citywar_declareEndMinute)
local t=GameTools.GetLocalize("tips.common_248",LanguageCategory.LangCommon)
if ModulesInit.SkyCityMgr.skyState.type==PROTO_ENUM.ENUM_GVG_TYPE.GVG_CROSS_SERVER then
t=string.format("%s %02d:%02d-%02d:%02d",t,Constant.citywar_battleStartHour,Constant.citywar_battleStartMinute,Constant.citywar_bullyBattleEndHour,Constant.citywar_bullyBattleEndMinute)
else
t=string.format("%s %02d:%02d-%02d:%02d",t,Constant.citywar_battleStartHour,Constant.citywar_battleStartMinute,Constant.citywar_battleEndHour,Constant.citywar_battleEndMinute)
end
e[6]:SetTextPrepare(6,a,t)
end
end
function RefreshKillDrigon()
if not GameFunction.IsFunctionUnLock(GameFunctionType.DragonWar)then
local a,t=GameFunction.GetFunctionUnLockTypeAndParaById(GameFunctionType.DragonWar)
e[3]:SetTextLock(3,h.GetConditionUnlockStr(a,t))
return
end
local a,t=ModulesInit.KillDragonsManager:CurTimeFunctionIsOpenAndReturnTime()
if t then
local t=TimeUtil.toDHMSStr2(t)
if not a then
local a,t=ModulesInit.KillDragonsManager:GetOpenAndEndTime()
local o=GameTools.GetLocalize("tips.common_249",LanguageCategory.LangCommon)
local t=o.." "..TimeUtil.GetAreaTimeZoneHourMinuteStr(a[1],a[2]).."-"..TimeUtil.GetAreaTimeZoneHourMinuteStr(t[1],t[2])..TimeUtil.getAreaTimeZoneSignStr()
e[3]:SetTextPrepare(3,t)
else
e[3]:SetBattleSpine(3,true)
end
end
end
function Refresh()
RefreshRedPoint()
onNewShowChange()
RefreshUnlock()
OnKillDrigonInfo()
OnMineRefresh()
end
function RefreshUnlock()
if GameFunction.IsFunctionUnLock(GameFunctionType.Trial)then
e[1]:SetLock(true)
e[1]:SetText(GameTools.GetLocalize("UI_AdventureTrialDesc",LanguageCategory.LangCommon))
else
e[1]:SetLock(false)
local a,t=GameFunction.GetFunctionUnLockTypeAndParaById(GameFunctionType.Trial)
e[1]:SetText(h.GetConditionUnlockStr(a,t))
end
if not GameFunction.IsFunctionUnLock(GameFunctionType.Arena)and not GameFunction.IsFunctionUnLock(GameFunctionType.CrossArena)then
e[2]:SetLock(false)
local t,a=GameFunction.GetFunctionUnLockTypeAndParaById(GameFunctionType.Arena)
e[2]:SetText(h.GetConditionUnlockStr(t,a))
else
e[2]:SetLock(true)
e[2]:SetText(GameTools.GetLocalize("UI_AdventureArenaDesc",LanguageCategory.LangCommon))
end
e[3]:SetUnlock(GameFunction.IsFunctionUnLock(GameFunctionType.DragonWar,false))
local t,o,a=GameFunction.IsFunctionUnLock(GameFunctionType.Maze)
e[4]:SetUnlock(t)
if t==false then
e[4]:SetText(a)
else
UpdateMazeLeftTime()
end
RefreshFlowerStateInfo()
if not ModulesInit.MineMgr:isOpen()then
e[7]:SetTextLock(7,GameTools.GetLocalize("tips.common_279"))
else
local a,o,t=GameFunction.IsFunctionUnLock(GameFunctionType.MineWar)
if not a then
e[7]:SetTextLock(7,t)
end
end
end
function RefreshRedPoint()
if GameFunction.IsFunctionUnLock(GameFunctionType.Trial)then
if RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.TOWER)then
e[1]:SetRedPoint(true)
else
e[1]:SetRedPoint(false)
end
else
e[1]:SetRedPoint(false)
end
local t=false
t=RedPointMgr:checkArenaRedPoint()or RedPointMgr:checkCrossArenaRedPoint()
e[2]:SetRedPoint(t)
local t,a=ModulesInit.KillDragonsManager:CurTimeFunctionIsOpenAndReturnTime()
if t and GameFunction.IsFunctionUnLock(GameFunctionType.DragonWar)then
local a=RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.DRAGON_GIFT)
local t=RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.MULTI_ELITE)
local o=ModulesInit.ActDragonBossMgr:IsLimitBossHaveRed()
e[3]:SetRedPoint(a or t or o)
else
e[3]:SetRedPoint(false)
end
e[4]:SetRedPoint(RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.MAZE_RED))
e[5]:SetRedPoint(RedPointMgr:checkFlowerRedPoint())
e[7]:SetRedPoint(RedPointMgr:checkMineBattleRedPoint())
end
function OnEventRespError(e)
if e.protoCode==ProtoId.PRT_FLOWER_SIGN_REQ then
ReqFloweServerData()
end
end
function onNewShowChange()
LuaUtils.SetActive(im_new_1.transform,false)
if GameFunction.IsFunctionUnLock(GameFunctionType.Trial)then
if ModulesInit.PhotoArtistMgr:checkSaveID(ModulesInit.PhotoArtistMgr.FirstUI.TowerHelpId)then
LuaUtils.SetActive(im_new_1.transform,true)
end
end
LuaUtils.SetActive(im_new_2.transform,false)
LuaUtils.SetActive(im_new_3.transform,false)
LuaUtils.SetActive(im_new_4.transform,false)
if GameFunction.IsFunctionUnLock(GameFunctionType.Maze)and
ModulesInit.PhotoArtistMgr:checkRedStatusSaveID(ModulesInit.PhotoArtistMgr.FirstUI.MazeHelpId)then
if ModulesInit.PhotoArtistMgr:checkSaveID(ModulesInit.PhotoArtistMgr.FirstUI.MazeHelpId)then
LuaUtils.SetActive(im_new_4.transform,true)
end
end
LuaUtils.SetActive(im_new_6.transform,false)
if GameFunction.IsFunctionUnLock(GameFunctionType.Guild)and PlayerMgr.PlayerInfo.guildId>0 and
ModulesInit.PhotoArtistMgr:checkRedStatusSaveID(ModulesInit.PhotoArtistMgr.FirstUI.SkyCityHelpId)then
if ModulesInit.PhotoArtistMgr:checkSaveID(ModulesInit.PhotoArtistMgr.FirstUI.SkyCityHelpId)then
LuaUtils.SetActive(im_new_6.transform,true)
end
end
LuaUtils.SetActive(im_new_5.transform,false)
if GameFunction.IsFunctionUnLock(GameFunctionType.Flower)then
if t==nil or t.state==PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_NONE then
LuaUtils.SetActive(im_new_5.transform,false)
else
if ModulesInit.PhotoArtistMgr:checkSaveID(ModulesInit.PhotoArtistMgr.FirstUI.FlowerFight)
and ModulesInit.PhotoArtistMgr:checkSaveID(ModulesInit.PhotoArtistMgr.FirstUI.FlowerFightCross)then
LuaUtils.SetActive(im_new_5.transform,true)
end
end
end
LuaUtils.SetActive(im_new_7.transform,false)
if GameFunction.IsFunctionUnLock(GameFunctionType.MineWar)and
ModulesInit.PhotoArtistMgr:checkRedStatusSaveID(ModulesInit.PhotoArtistMgr.FirstUI.MineWar)and
ModulesInit.MineMgr:isOpen()then
if ModulesInit.PhotoArtistMgr:checkSaveID(ModulesInit.PhotoArtistMgr.FirstUI.MineWar)then
LuaUtils.SetActive(im_new_7.transform,true)
end
end
end
function OnCheckRepairStarRedPoint()
local t=TowerMgr:GetNotGetAwardCount()>0
e[1]:SetRedPoint(t)
end
function OnKillDrigonInfo()
RefreshKillDrigon()
if GameFunction.IsFunctionUnLock(GameFunctionType.DragonWar)then
local t=ModulesInit.KillDragonsManager:SendGetDragonDescRequest()
t.onCompleted=function(a,t)
if t.dragonType==0 then
GameInit.LogError('龙战boss类型不能为0')
else
e[3]:SetIcon(d[t.dragonType])
end
end
end
end
function OnMineRefresh()
local t,a,a=GameFunction.IsFunctionUnLock(GameFunctionType.MineWar)
local a=e[7]:GetTrans("p_btn")
LuaUtils.SetActive(a.transform,t)
if t then
local t=ModulesInit.MineMgr:showCurrTime()
e[7]:SetTextPrepare(7,t)
end
if ModulesInit.MineMgr.MineInfo then
local e=t
local t=ModulesInit.MineMgr.functionStatus
LuaUtils.SetActive(btn_shop.transform,t and e)
LuaUtils.SetActive(btn_rank.transform,t and e)
end
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end
function TestEnterFlowerNextState()
if a==nil then
return
end
a.serverType=PROTO_ENUM.ENUM_FLOWER_SERVER_TYPE.SERVER_TYPE_LOCAL
local function o(o,t)
local e={}
if t==PROTO_ENUM.ENUM_FLOWER_SERVER_TYPE.SERVER_TYPE_LOCAL then
e=ModulesInit.FlowerFightMgr.EFightLocalStateArr
else
e=ModulesInit.FlowerFightMgr.EFightCrossStateArr
end
local t=1
for a=1,#e do
if o==e[a]then
t=a
break
end
end
t=t+1
if t>#e then
t=1
end
return e[t]
end
local e=t.state
if a.upgrade==true then
a.upgrade=false
e=PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_NONE
a.openTime=0
elseif t then
if e==PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_NONE then
if a.openTime==0 then
a.openTime=TimeUtil.GetServerTimeStamp()+3600*math.random(1,100)
else
e=PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_SIGN
t.isSign=false
t.signMax=false
end
elseif e==PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_SIGN then
if t.signMax==false then
t.signMax=true
t.isSign=false
elseif t.isSign==false then
t.isSign=true
elseif t.isSign==true then
e=PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_SIGN_OVER
end
elseif e==PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_FINAL_OVER_STOP then
a.upgrade=true
a.upgradeEndTimestamp=TimeUtil.GetServerTimeStamp()+3600*math.random(1,100)
e=PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_NONE
else
e=o(e,a.serverType)
end
t.state=e
end
;
if t then
;
end
onNewShowChange()
RefreshUnlock()
end
function ReqRefreshMine()
if not ModulesInit.MineMgr:isOpen()then
return
end
local e,t,t=GameFunction.IsFunctionUnLock(GameFunctionType.MineWar)
if e then
ModulesInit.MineMgr:reqStatus()
end
end
function OnPlayerLevelUp()
ReqRefreshMine()
end 
