local e=require('DataNode/DataTable/Create/player/DTHeadDBModel')
local e=require('DataNode/DataTable/Create/player/DTLevelUpDBModel')
local e=require('DataNode/DataTable/Create/function/DTFunctionDBModel')
local e=require("DataNode/DataTable/Create/constant/DTConstantDBModel")
local a=require("DataNode/DataTable/Create/worldMap/DTMainInterfaceDBModel")
local l=require("DataNode/DataManager/DataMgr/DataUtil")
local u=require('Modules/MainInterface/UI_Adventure_Item_New')
local r=nil
local n=0
local s=0
local e={}
local d={
'UIAdventure/pve_banner_longji1',
'UIAdventure/pve_banner_longji2',
'UIAdventure/pve_banner_longji3',
[11001]='UIAdventure/pve_banner_longji4',
[11002]='UIAdventure/pve_banner_longji5',
[11003]='UIAdventure/pve_banner_longji6',
}
local t=nil
local i,h=nil,nil
local o
function OnInit(t,t)
btn_fanhui.onClick:AddListener(function()
if not GameEntry.UI:IsExists(UIFormId.UI_MainPage)then
GameEntry.UI:OpenUIForm(UIFormId.UI_MainPage)
end
GameTools.CloseUIForm(UIFormId.UI_Adventure_RootView)
ModulesInit.GuideMgr:CheckCloseTowerMainGuide()
if ModulesInit.GuideMgr.isGuide then
local e=CS.DG.Tweening.DOTween.Sequence()
e:AppendInterval(0.5)
e:AppendCallback(
function()
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="OPEN_MAINPAGE_SUC"})
end
)
end
end)
for t=1,LuaUtils.GetChildrenCount(Content.transform)do
local a=u:New(self)
local o=Content.transform:Find('bg_huodong'..t)
a:SetUI(o,t,ClickItem)
a:SetShow(true)
table.insert(e,a)
if GameTools:IsReview()then
if t==AdventurePageType.pCruiseShip
or t==AdventurePageType.pDragon
or t==AdventurePageType.pMaze
or t==AdventurePageType.pCollectibles then
LuaUtils.SetActive(o,false)
end
end
end
local t=a.GetList()
local e={}
for o=1,LuaUtils.GetChildrenCount(Content.transform)do
local t=t[o].id
local i=Content.transform:Find('bg_huodong'..t)
local t=0
if PlayerMgr:CheckIsNewPlayerByLevelOptimize()then
t=a.GetEntity(o).newList
else
t=a.GetEntity(o).list
end
table.insert(e,{trans=i,index=t})
end
table.sort(e,function(t,e)
return t.index<e.index
end)
for t=1,#e do
e[t].trans.transform:SetSiblingIndex(t)
end
i=UI_currency1:GetComponents()
h=UI_currency2:GetComponents()
i['btn_jia'].onClick:AddListener(function()
ActMgr:CheckJumpViewById(301)
end)
h['btn_jia'].onClick:AddListener(function()
GameEntry.UI:OpenUIForm(UIFormId.UI_GoldChange)
end)
end
function ClickItem(e,t)
if e==AdventurePageType.pTower then
if GameFunction.IsFunctionUnLock(GameFunctionType.Trial,true)then
if not ModulesInit.GuideMgr.isGuide then
TowerMgr.isQuickEnterNow=true
end
TowerMgr:GetAllTowerInfo()
end
return
end
if e==AdventurePageType.pMagicOrchard then
ModulesInit.MagicOrchardMgr:EnterMagicOrchardMainView()
return
end
if e==AdventurePageType.PDeepSea then
if GameFunction.IsFunctionUnLock(GameFunctionType.DeepSea,true)then
ModulesInit.DeepSeaMgr:EnterView()
end
return
end
if GameTools:IsReview()==false then
if e==AdventurePageType.pDragon then
if GameFunction.IsFunctionUnLock(GameFunctionType.DragonWar,true)then
GameEntry.UI:OpenUIForm(UIFormId.UI_CommonLoading,{style=LoadingStyle.Cloud,loadResFinish=function()
ModulesInit.KillDragonsManager:Enter()
end})
end
return
end
if e==AdventurePageType.pMaze then
ModulesInit.PhotoArtistMgr:setRedStatusSaveID(ModulesInit.PhotoArtistMgr.FirstUI.MazeHelpId)
ModulesInit.MazeMgr:EnterMazeView()
EventSystem.SendEvent(CommonEventId.NewShowInfoChange)
return
end
if e==AdventurePageType.pCruiseShip then
if GameFunction.IsFunctionUnLock(GameFunctionType.CruiseShip,true)then
ModulesInit.CruiseShipMgr:EnterCuriseMainView()
end
return
end
if e==AdventurePageType.pCollectibles then
if GameFunction.IsFunctionUnLock(GameFunctionType.Collectibles,true)then
ModulesInit.GuideMgr:CheckCollectiblesGuide()
ModulesInit.CollectiblesMgr:EnterView()
if ModulesInit.PhotoArtistMgr:checkShowNew(ModulesInit.PhotoArtistMgr.NEW_ID.Collectibles)then
ModulesInit.PhotoArtistMgr:SaveShowNew(ModulesInit.PhotoArtistMgr.NEW_ID.Collectibles)
end
end
return
end
end
end
function OnOpen(a)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.AddListener(CommonEventId.RedPointInfoChange,RefreshRedPoint)
EventSystem.AddListener(CommonEventId.OnTowerGetAward,OnCheckRepairStarRedPoint)
EventSystem.AddListener(CommonEventId.NewShowInfoChange,onNewShowChange)
EventSystem.AddListener(CommonEventId.OnPlayCurrencyRefresh,OnPlayCurrencyRefresh)
EventSystem.AddListener(CommonEventId.OnActFoolsDollRefreshInfo,OnActFoolsDollRefreshInfo)
EventSystem.AddListener(CommonEventId.NewDay,OnNewDay)
EventSystem.AddListener(SysEventId.OnUpdate,OnUpdate)
n=5
s=0
local e=e[AdventurePageType.pMaze]:GetTrans("maze_layer")
LuaUtils.SetActive(e.transform,false)
Refresh()
RefreshActTip()
if ModulesInit.GuideMgr.isGuide then
if ModulesInit.GuideMgr.unit==ModulesInit.GuideMgr.EGuideCfg.LevelUp_46_Second_Half_MagicOrchard then
MoveItem2Pos(AdventurePageType.pMagicOrchard)
elseif ModulesInit.GuideMgr.unit==ModulesInit.GuideMgr.EGuideCfg.EarthChapter_6_1_Second_DeepSea then
MoveItem2Pos(AdventurePageType.PDeepSea)
elseif ModulesInit.GuideMgr.unit==ModulesInit.GuideMgr.EGuideCfg.Maze_Guide then
MoveItem2Pos(AdventurePageType.pMaze)
elseif ModulesInit.GuideMgr.unit==ModulesInit.GuideMgr.EGuideCfg.LevelUp_34_Second_Half_Dragon then
MoveItem2Pos(AdventurePageType.pDragon)
else
local e=Content.transform.localPosition
LuaUtils.SetLocalPos(Content.transform,0,e.y,0)
end
else
local e=Content.transform.localPosition
LuaUtils.SetLocalPos(Content.transform,0,e.y,0)
end
if t then
t:Kill()
t=nil
end
t=CS.DG.Tweening.DOTween.Sequence()
t:AppendInterval(1)
t:AppendCallback(function()
local e=Content.transform:GetComponent(typeof(CS.UnityEngine.UI.HorizontalLayoutGroup))
local t=Content.transform:GetComponent(typeof(CS.UnityEngine.UI.ContentSizeFitter))
if ModulesInit.GuideMgr.isGuide then
t.enabled=false
e.enabled=false
else
t.enabled=true
e.enabled=true
end
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="OPEN_UI_ADVENTURE_SUC"})
end)
InitFoolsDollSpineBtnShow()
end
function OnEventNetReconnectSuccess()
Refresh()
NewDayReqDollMsg()
end
function OnFormBack()
Refresh()
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.RemoveListener(CommonEventId.RedPointInfoChange,RefreshRedPoint)
EventSystem.RemoveListener(CommonEventId.OnTowerGetAward,OnCheckRepairStarRedPoint)
EventSystem.RemoveListener(CommonEventId.NewShowInfoChange,onNewShowChange)
EventSystem.RemoveListener(CommonEventId.OnPlayCurrencyRefresh,OnPlayCurrencyRefresh)
EventSystem.RemoveListener(CommonEventId.NewDay,OnNewDay)
EventSystem.RemoveListener(SysEventId.OnUpdate,OnUpdate)
EventSystem.RemoveListener(CommonEventId.OnActFoolsDollRefreshInfo,OnActFoolsDollRefreshInfo)
if r then
r:Stop()
r=nil
end
if t then
t:Kill()
t=nil
end
RemoveFoolsDollSpineBtn()
end
function OnBeforeDestroy()
end
function RefreshCurrencyView()
if i then
LuaUtils.SetTextMeshText(i['txt_act_name'],UIUtil.toBigNum3(PlayerMgr:getCurrencyCount(Currency.Diamond)))
LuaUtils.SetTextMeshText(h['txt_act_name'],UIUtil.toBigNum(PlayerMgr:getCurrencyCount(Currency.Gold)))
local e=ModulesInit.BagManager:GetBaseInfo(PROTO_ENUM.ENUM_CURRENCY.HOLY_CRYSTAL)
GameTools:SetImageSprite(i["im_zuanshi"],e.icon,false)
local e=ModulesInit.BagManager:GetBaseInfo(PROTO_ENUM.ENUM_CURRENCY.GOLD)
GameTools:SetImageSprite(h["im_zuanshi"],e.icon,false)
end
end
function RefreshActTip()
local a=e[AdventurePageType.pDragon].im_actTip
local e=e[AdventurePageType.pMaze].im_actTip
local t,o=ModulesInit.ActGoldWeekManager:IsOpenDouble(80)
LuaUtils.SetActive(a.transform,t)
local t,a=ModulesInit.ActGoldWeekManager:IsOpenDouble(501)
LuaUtils.SetActive(e.transform,t)
end
function OnNewDay()
RefreshActTip()
NewDayReqDollMsg()
OnKillDrigonInfo()
end
function OnUpdate()
UpdateStateInfo()
UpdateLeftTime()
end
function UpdateStateInfo()
n=n+Time.deltaTime
if n<5 then
return
end
n=0
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
end
function UpdateLeftTime()
s=s+Time.deltaTime
if s<1 then
return
end
s=0
UpdateMazeLeftTime()
end
function UpdateMazeLeftTime()
local t=e[AdventurePageType.pMaze]:GetTrans("maze_layer")
local a,o=GameFunction.IsFunctionUnLock(GameFunctionType.Maze)
if a==false then
LuaUtils.SetActive(t.transform,false)
return
end
if ModulesInit.MazeMgr.mazeInfo==nil then
e[AdventurePageType.pMaze]:SetText("")
LuaUtils.SetActive(t.transform,false)
return
end
if ModulesInit.MazeMgr:IsCloseStatus()then
LuaUtils.SetActive(t.transform,false)
end
LuaUtils.SetActive(t.transform,true)
local t=e[AdventurePageType.pMaze]:GetTrans("maze_layer/maze_layer_num")
local t=t:GetComponent(typeof(CS.TMPro.TextMeshProUGUI))
LuaUtils.SetTextMeshText(t,ModulesInit.MazeMgr.mazeInfo.mapLayer.."/"..Constant.maze_layer_max)
local t=ModulesInit.MazeMgr.mazeInfo.leftTime-TimeUtil.GetServerTimeStamp()
t=math.max(0,t)
local a=TimeUtil.toDHMSStr2(t)
local t="UI.Maze.Main.23"
if ModulesInit.MazeMgr.mazeInfo.status==PROTO_ENUM.ENUM_MAZE_STATUS.MS_STATUS_CLOSE then
t="UI.Maze.Main.22"
end
e[AdventurePageType.pMaze]:SetText(GameTools.GetLocalize(t,LanguageCategory.LangCommon)..a)
end
function RefreshKillDrigon()
if not GameFunction.IsFunctionUnLock(GameFunctionType.DragonWar)then
local t,a=GameFunction.GetFunctionUnLockTypeAndParaById(GameFunctionType.DragonWar)
e[AdventurePageType.pDragon]:SetTextLock(AdventurePageType.pDragon,l.GetConditionUnlockStr(t,a))
return
end
local o=""
local a,t=ModulesInit.KillDragonsManager:CurTimeFunctionIsOpenAndReturnTime()
if t then
local t=TimeUtil.toDHMSStr2(t)
if not a then
local a,t=ModulesInit.KillDragonsManager:GetOpenAndEndTime()
local i=GameTools.GetLocalize("tips.common_249",LanguageCategory.LangCommon)
local t=string.format("%s %02d:%02d-%02d:%02d%s",i,a[1],a[2],t[1],t[2],o)
e[AdventurePageType.pDragon]:SetTextPrepare(AdventurePageType.pDragon,t)
else
e[AdventurePageType.pDragon]:SetBattleSpine(AdventurePageType.pDragon,true)
end
end
end
function OnPlayCurrencyRefresh()
RefreshCurrencyView()
end
function Refresh()
RefreshRedPoint()
onNewShowChange()
RefreshUnlock()
OnKillDrigonInfo()
RefreshRewardIcon()
RefreshCurrencyView()
end
function RefreshUnlock()
local t,o,a=GameFunction.IsFunctionUnLock(GameFunctionType.Trial,false)
e[AdventurePageType.pTower]:SetLock(t)
e[AdventurePageType.pTower]:SetUnlock(t)
if t==false then
e[AdventurePageType.pTower]:SetText(a)
else
e[AdventurePageType.pTower]:SetText("")
end
local t,o,a=GameFunction.IsFunctionUnLock(GameFunctionType.MagicOrchard)
e[AdventurePageType.pMagicOrchard]:SetUnlock(t)
if t==false then
e[AdventurePageType.pMagicOrchard]:SetText(a)
else
e[AdventurePageType.pMagicOrchard]:SetText("")
end
local i,s,n=GameFunction.IsFunctionUnLock(GameFunctionType.DeepSea)
e[AdventurePageType.PDeepSea]:SetUnlock(i)
if i==false then
e[AdventurePageType.PDeepSea]:SetText(n)
else
e[AdventurePageType.PDeepSea]:SetText("")
end
if GameTools:IsReview()==false then
t,o,a=GameFunction.IsFunctionUnLock(GameFunctionType.DragonWar,false)
e[AdventurePageType.pDragon]:SetUnlock(t)
if t==false then
e[AdventurePageType.pDragon]:SetText(a)
else
e[AdventurePageType.pDragon]:SetText("")
end
local i,s,n=GameFunction.IsFunctionUnLock(GameFunctionType.Maze)
e[AdventurePageType.pMaze]:SetUnlock(i)
if i==false then
e[AdventurePageType.pMaze]:SetText(n)
else
UpdateMazeLeftTime()
end
t,o,a=GameFunction.IsFunctionUnLock(GameFunctionType.CruiseShip)
e[AdventurePageType.pCruiseShip]:SetUnlock(t)
if t==false then
e[AdventurePageType.pCruiseShip]:SetText(a)
else
e[AdventurePageType.pCruiseShip]:SetText("")
end
t,o,a=GameFunction.IsFunctionUnLock(GameFunctionType.Collectibles)
e[AdventurePageType.pCollectibles]:SetUnlock(t)
if t==false then
e[AdventurePageType.pCollectibles]:SetText(a)
else
e[AdventurePageType.pCollectibles]:SetText("")
end
end
end
function RefreshRewardIcon()
local t=a.GetEntity(AdventurePageType.pTower)
e[AdventurePageType.pTower]:SetRewards(t.pointlink)
e[AdventurePageType.pTower]:SetRewardTips(GameTools.GetLocalize(t.pointType,LanguageCategory.LangCommon))
local t=a.GetEntity(AdventurePageType.pMagicOrchard)
e[AdventurePageType.pMagicOrchard]:SetRewards(t.pointlink)
e[AdventurePageType.pMagicOrchard]:SetRewardTips(GameTools.GetLocalize(t.pointType,LanguageCategory.LangCommon))
local t=a.GetEntity(AdventurePageType.PDeepSea)
e[AdventurePageType.PDeepSea]:SetRewards(t.pointlink)
e[AdventurePageType.PDeepSea]:SetRewardTips(GameTools.GetLocalize(t.pointType,LanguageCategory.LangCommon))
if GameTools:IsReview()==false then
local t=a.GetEntity(AdventurePageType.pDragon)
e[AdventurePageType.pDragon]:SetRewards(t.pointlink)
e[AdventurePageType.pDragon]:SetRewardTips(GameTools.GetLocalize(t.pointType,LanguageCategory.LangCommon))
local t=a.GetEntity(AdventurePageType.pMaze)
e[AdventurePageType.pMaze]:SetRewards(t.pointlink)
e[AdventurePageType.pMaze]:SetRewardTips(GameTools.GetLocalize(t.pointType,LanguageCategory.LangCommon))
local t=a.GetEntity(AdventurePageType.pCruiseShip)
e[AdventurePageType.pCruiseShip]:SetRewards(t.pointlink)
e[AdventurePageType.pCruiseShip]:SetRewardTips(GameTools.GetLocalize(t.pointType,LanguageCategory.LangCommon))
local t=a.GetEntity(AdventurePageType.pCollectibles)
e[AdventurePageType.pCollectibles]:SetRewards(t.pointlink)
e[AdventurePageType.pCollectibles]:SetRewardTips(GameTools.GetLocalize(t.pointType,LanguageCategory.LangCommon))
end
end
function RefreshRedPoint()
if GameFunction.IsFunctionUnLock(GameFunctionType.Trial)then
if RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.TOWER)then
e[AdventurePageType.pTower]:SetRedPoint(true)
else
e[AdventurePageType.pTower]:SetRedPoint(false)
end
else
e[AdventurePageType.pTower]:SetRedPoint(false)
end
local t,a=ModulesInit.KillDragonsManager:CurTimeFunctionIsOpenAndReturnTime()
if t and GameFunction.IsFunctionUnLock(GameFunctionType.DragonWar)then
local t=RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.DRAGON_GIFT)
local o=RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.MULTI_ELITE)
local a=ModulesInit.ActDragonBossMgr:IsLimitBossHaveRed()
e[AdventurePageType.pDragon]:SetRedPoint(t or o or a)
else
e[AdventurePageType.pDragon]:SetRedPoint(false)
end
e[AdventurePageType.pMaze]:SetRedPoint(RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.MAZE_RED))
e[AdventurePageType.pMagicOrchard]:SetRedPoint(RedPointMgr:checkMagicOrchardRed())
e[AdventurePageType.PDeepSea]:SetRedPoint(RedPointMgr:checkDeepSeaRedPoint())
if GameTools:IsReview()==false then
e[AdventurePageType.pCruiseShip]:SetRedPoint(RedPointMgr:checkCruiseShipRed())
e[AdventurePageType.pCollectibles]:SetRedPoint(RedPointMgr:checkCollectiblesRed())
end
end
function onNewShowChange()
local t=e[AdventurePageType.pTower]:GetTrans("im_new")
LuaUtils.SetActive(t.transform,false)
if GameFunction.IsFunctionUnLock(GameFunctionType.Trial)then
if ModulesInit.PhotoArtistMgr:checkSaveID(ModulesInit.PhotoArtistMgr.FirstUI.TowerHelpId)then
LuaUtils.SetActive(t.transform,true)
end
end
local t=e[AdventurePageType.pDragon]:GetTrans("im_new")
LuaUtils.SetActive(t.transform,false)
local t=e[AdventurePageType.pMaze]:GetTrans("im_new")
LuaUtils.SetActive(t.transform,false)
if GameFunction.IsFunctionUnLock(GameFunctionType.Maze)and
ModulesInit.PhotoArtistMgr:checkRedStatusSaveID(ModulesInit.PhotoArtistMgr.FirstUI.MazeHelpId)then
if ModulesInit.PhotoArtistMgr:checkSaveID(ModulesInit.PhotoArtistMgr.FirstUI.MazeHelpId)then
LuaUtils.SetActive(t.transform,true)
end
end
local t=e[AdventurePageType.pCruiseShip]:GetTrans("im_new")
LuaUtils.SetActive(t.transform,false)
local e=e[AdventurePageType.pCollectibles]:GetTrans("im_new")
LuaUtils.SetActive(e.transform,false)
if GameFunction.IsFunctionUnLock(GameFunctionType.Collectibles)then
if ModulesInit.PhotoArtistMgr:checkShowNew(ModulesInit.PhotoArtistMgr.NEW_ID.Collectibles)then
LuaUtils.SetActive(e.transform,true)
end
end
end
function OnCheckRepairStarRedPoint()
local t=TowerMgr:GetNotGetAwardCount()>0
e[AdventurePageType.pTower]:SetRedPoint(t)
end
function OnKillDrigonInfo()
RefreshKillDrigon()
if GameFunction.IsFunctionUnLock(GameFunctionType.DragonWar)then
local t=ModulesInit.KillDragonsManager:SendGetDragonDescRequest()
t.onCompleted=function(a,t)
if t.dragonType==0 then
GameInit.LogError('龙战boss类型不能为0')
else
local a=d[t.dragonType]
local o=ModulesInit.ActDragonBossMgr:IsActOpen(ModulesInit.ActDragonBossMgr.ActType.RootAct,true)
if o then
a=d[11000+t.dragonType]
end
if e[AdventurePageType.pDragon]and not IsNil(e[AdventurePageType.pDragon].trans)then
e[AdventurePageType.pDragon]:SetIcon(a)
e[AdventurePageType.pDragon]:SetDragonBossValentineActTip(o)
end
end
end
end
end
function MoveItem2Pos(a)
local t=1
local o=e[a].trans
local e=LuaUtils.GetChildrenCount(Content.transform)
for e=1,e do
local a=UIUtil.GetChild(Content.transform,e-1)
if a==o then
t=e
break
end
end
local e=389
local a=root_wanfa.transform.rect
LuaUtils.RebuildLayout(Content.transform)
local o=Content.transform:GetComponent(typeof(CS.UnityEngine.UI.HorizontalLayoutGroup))
local n=Content.transform.rect
local i=Content.transform.localPosition
local o=o.spacing
local e=-(e+o)*(t-1)
e=math.min(e,0)
e=math.max(e,a.width-n.width)
LuaUtils.SetLocalPos(Content.transform,e,i.y,0)
end
function InitFoolsDollSpineBtnShow()
if not ActMgr:IsOpen(ModulesInit.ActFoolsDollMgr.actId)then
return
end
RefreshFoolsDollSpineBtnShowByData()
end
function NewDayReqDollMsg()
if not ActMgr:IsOpen(ModulesInit.ActFoolsDollMgr.actId)then
RemoveFoolsDollSpineBtn()
return
end
ModulesInit.ActFoolsDollMgr:ReqActFoolsDollInfo()
RefreshFoolsDollSpineBtnShowByData()
end
function OnActFoolsDollRefreshInfo()
RefreshFoolsDollSpineBtnShowByData()
end
function RefreshFoolsDollSpineBtnShowByData()
ModulesInit.ActFoolsDollMgr:RefreshFoolsDollSpineBtnShowByData(o,self.UIFormId,foolsDollNoed,function(e)
o=e
end)
end
function RemoveFoolsDollSpineBtn()
if o~=nil then
o:Close()
GameEntry.Pool:GameObjectDespawn(o.transform)
o=nil
end
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

