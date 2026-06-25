local e=require('DataNode/DataTable/Create/dragon/DTDragonStageDBModel')
local e=require("DataNode/DataTable/Create/constant/DTConstantDBModel")
local e=require('DataNode/DataTable/Create/function/DTFunctionDBModel')
local w=require('DataNode/DataTable/Create/item/DTItemDBModel')
local s=require("Modules/MainInterface/Bubbles")
local e
local d={
[DOCK_TYPE.MAIN_PAGE]={main_on,main_off,sp_mainpage},
[DOCK_TYPE.CAMP]={camp_on,camp_off,sp_camp},
[DOCK_TYPE.BAG]={bag_on,bag_off,sp_bag},
[DOCK_TYPE.EXPEDITION]={expedition_on,expedition_off,sp_expedition},
[DOCK_TYPE.ADVENTURE]={adventureInterface_on,adventureInterface_off,sp_adventureInterface},
[DOCK_TYPE.GUILD]={guild_on,guild_off,sp_guild},
[DOCK_TYPE.MAIN_CITY]={mainCity_on,mainCity_off,sp_maincity},
}
local i
local p=0
local t=nil
local o=nil
local a=nil
local h
local l
local n
local c
local u
local f
local y
local m=nil
local r=false
function OnInit(e,e)
for e=DOCK_TYPE.MAIN_PAGE,DOCK_TYPE.MAIN_CITY do
local t=d[e][2]:GetComponent(typeof(CS.UnityEngine.UI.Button))
self:AddBtnClickListener(t,handler(e,changeTab))
end
i=List.New()
h=s.New({node=jiarutishi,checkFunc=CheckShowGuildTip})
l=s.New({node=jiarutishi2,checkFunc=OnIdleCheckUpdate})
n=s.New({node=jiarutishi3,checkFunc=CheckAndRefreshKillDragonsTip})
c=s.New({node=jiarutishi4,checkFunc=CheckAndRefreshTitanTip})
u=s.New({node=jiarutishi5,checkFunc=CheckAndRefreshGuidWarTip})
f=s.New({node=jiarutishi6,checkFunc=CheckAndRefreshFlowerTip})
ModulesInit.UIPosMgr:setWorldPos(ModulesInit.UIPosMgr.EPosType.Bag,bag_on.transform.position)
end
function OnOpen(a)
EventSystem.AddListener(CommonEventId.OnOpenDockUI,onOpenDockUI)
EventSystem.AddListener(CommonEventId.OnCloseDockAndCurrUI,onCloseDockAndCurrUI)
EventSystem.AddListener(CommonEventId.OnHideDockAndCurrUI,onHideDockAndCurrUI)
EventSystem.AddListener(CommonEventId.OnPlayInfoChange,OnPlayInfoChange)
EventSystem.AddListener(CommonEventId.OnPlayerLoginComplete,OnPlayerLoginComplete)
EventSystem.AddListener(CommonEventId.RedPointInfoChange,RefreshRedPoint)
EventSystem.AddListener(CommonEventId.OnDockShowHide,onDockShowHide)
EventSystem.AddListener(CommonEventId.GetIdleItemsSuccess,OnGetIdleItemsSuccess)
EventSystem.AddListener(CommonEventId.OnEquipCountChange,CheckBagTip)
EventSystem.AddListener(CommonEventId.KillDragonsInfoSync,CheckKillDragonsTip)
EventSystem.AddListener(CommonEventId.KillDragonsExitRoomSync,CheckKillDragonsTip)
EventSystem.AddListener(CommonEventId.BagSizeChange,CheckBagTip)
EventSystem.AddListener(CommonEventId.OnEventTitanDescInfo,OnEventTitanDescInfo)
EventSystem.AddListener(CommonEventId.OnGuideFinishRefreshDock,CheckGuideHandShow)
EventSystem.AddListener(CommonEventId.OnStartGuide,CheckGuideHandShow)
EventSystem.AddListener(CommonEventId.NewShowInfoChange,onNewShowChange)
EventSystem.AddListener(CommonEventId.PlayerLevelUp,OnPlayerLevelUp)
EventSystem.AddListener(SysEventId.OnLoadingClosed,OnLoadingClosed)
EventSystem.AddListener(CommonEventId.OnItemInfoChange,CheckBagTip)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.AddListener(CommonEventId.OnRespFlowerQualification,OnRespFlowerQualification)
r=false
e=a and a.tabIndex or DOCK_TYPE.MAIN_PAGE
if ModulesInit.StoryManager.isStoryCreateName==true then
if ModulesInit.GuideMgr.isOpenGuide and GameFunction:CheckNewGuideByFunc231101()then
LuaUtils.SetActive(transform,false)
else
LuaUtils.SetActive(transform,true)
end
else
LuaUtils.SetActive(transform,true)
end
m=a and a.userData
initEnterTab(m)
CheckBagTip()
RefreshRedPoint()
onNewShowChange()
if t then
t:Stop()
t=nil
end
t=ModulesInit.TimeActionMgr:CreateTimeAction()
t:Init(0,1,-1,nil,function()
l:CheckAndRefresh(e)
end,nil):Run()
ActMgr:checkInitLocalSaveData()
CheckGuideHandShow()
SetAllGrayByTime()
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnOpenDockUI,onOpenDockUI)
EventSystem.RemoveListener(CommonEventId.OnCloseDockAndCurrUI,onCloseDockAndCurrUI)
EventSystem.RemoveListener(CommonEventId.OnHideDockAndCurrUI,onHideDockAndCurrUI)
EventSystem.RemoveListener(CommonEventId.OnPlayInfoChange,OnPlayInfoChange)
EventSystem.RemoveListener(CommonEventId.OnPlayerLoginComplete,OnPlayerLoginComplete)
EventSystem.RemoveListener(CommonEventId.RedPointInfoChange,RefreshRedPoint)
EventSystem.RemoveListener(CommonEventId.OnDockShowHide,onDockShowHide)
EventSystem.RemoveListener(CommonEventId.GetIdleItemsSuccess,OnGetIdleItemsSuccess)
EventSystem.RemoveListener(CommonEventId.OnEquipCountChange,CheckBagTip)
EventSystem.RemoveListener(CommonEventId.KillDragonsInfoSync,CheckKillDragonsTip)
EventSystem.RemoveListener(CommonEventId.KillDragonsExitRoomSync,CheckKillDragonsTip)
EventSystem.RemoveListener(CommonEventId.BagSizeChange,CheckBagTip)
EventSystem.RemoveListener(CommonEventId.OnEventTitanDescInfo,OnEventTitanDescInfo)
EventSystem.RemoveListener(SysEventId.OnLoadingClosed,OnLoadingClosed)
EventSystem.RemoveListener(CommonEventId.OnGuideFinishRefreshDock,CheckGuideHandShow)
EventSystem.RemoveListener(CommonEventId.OnStartGuide,CheckGuideHandShow)
EventSystem.RemoveListener(CommonEventId.NewShowInfoChange,onNewShowChange)
EventSystem.RemoveListener(CommonEventId.OnItemInfoChange,CheckBagTip)
EventSystem.RemoveListener(CommonEventId.PlayerLevelUp,OnPlayerLevelUp)
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.RemoveListener(CommonEventId.OnRespFlowerQualification,OnRespFlowerQualification)
if t then
t:Stop()
t=nil
end
if o then
o:Stop()
o=nil
end
if a then
a:Kill()
a=nil
end
h:Clean()
l:Clean()
n:Clean()
c:Clean()
u:Clean()
f:Clean()
LuaUtils.SetActive(show_mask.transform,false)
end
function OnBeforeDestroy()
end
function initTab()
for t=DOCK_TYPE.MAIN_PAGE,DOCK_TYPE.MAIN_CITY do
local e=t==e
LuaUtils.SetActive(d[t][1].transform,e)
LuaUtils.SetActive(d[t][2].transform,not e)
local t=d[t][3]:GetComponent(typeof(CS.YouYou.UISpineCtr))
if e==true then
t:PlayAnimation(0,"A",true)
else
t:PlayAnimation(0,"B",true)
end
end
end
function CheckFunctionUnLock(t,e)
if t==DOCK_TYPE.GUILD then
if GameFunction.IsFunctionUnLock(GameFunctionType.Guild,e)==false then
return false
end
elseif t==DOCK_TYPE.MAIN_CITY then
if GameFunction.IsFunctionUnLock(GameFunctionType.City,e)==false then
return false
end
elseif t==DOCK_TYPE.ADVENTURE then
if GameFunction.IsFunctionUnLock(GameFunctionType.temp10035,e)==false then
return false
end
end
return true
end
function GetPageReqFunc(t)
if t==DOCK_TYPE.CAMP then
if GameFunction.IsFunctionUnLock(GameFunctionType.Marry)then
return function(e)
local t=ModulesInit.MarryManager:SendRingListRequest()
t.onCompleted=function(a,t)
if e then
e(t)
end
end
end
end
elseif t==DOCK_TYPE.MAIN_CITY then
if GameFunction.IsFunctionUnLock(GameFunctionType.City,false)then
return function(e)
local t=ModulesInit.CityManager:SendCityInfoRequest()
t.onCompleted=function(a,t)
if e then
e(t)
end
end
end
end
end
return nil
end
function initEnterTab(t)
if CheckFunctionUnLock(e,false)==false then
e=DOCK_TYPE.MAIN_PAGE
end
initTab()
local e=GetPageReqFunc(e)
if e then
e(function(e)
r=true
if GameEntry.UI:IsExists(UIFormId.UI_Dock)then
setCurrView(t)
end
end)
else
r=true
setCurrView(t)
end
end
function changeTab(e,t)
t=t or{}
if CheckFunctionUnLock(e,true)==false then
return
end
local a=GetPageReqFunc(e)
if a then
a(function(a)
if GameEntry.UI:IsExists(UIFormId.UI_Dock)then
doChangeTab(e,t)
end
end)
else
doChangeTab(e,t)
end
end
function doChangeTab(a,o)
ModulesInit.ExpeditionManager.tozhengRongIsFormIdle=false
ModulesInit.ExpeditionManager.tozhengRongIsFormBigMap=false
ModulesInit.ExpeditionManager.tozhengRongIsFormEarthStage=false
local t=true
if a==DOCK_TYPE.EXPEDITION then
t=false
ModulesInit.ExpeditionManager:EnterIdle()
elseif a==DOCK_TYPE.GUILD and PlayerMgr.PlayerInfo.guildId<=0 then
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildJoinListNewView)
t=false
elseif a==DOCK_TYPE.MAIN_CITY then
if not GameFunction.IsFunctionUnLock(GameFunctionType.City,true)then
t=false
end
EventSystem.SendEvent(CommonEventId.OnEventNextGuide,{event="CHANGE_MAIN_SUC"})
end
if t==true then
e=a
setCurrView(o)
end
initTab()
end
function setCurrView(t)
local a=i:PopBack()
if a then
GameTools.CloseUIForm(a)
end
if t and t.forbidViewList then
ViewMgr:clostEnableLayerView(t.forbidViewList)
else
ViewMgr:clostEnableLayerView()
end
local a
if e==DOCK_TYPE.MAIN_PAGE then
a=UIFormId.UI_MainPage
GameEntry.UI:OpenUIForm(UIFormId.UI_MainPage,t)
elseif e==DOCK_TYPE.CAMP then
a=UIFormId.UI_Camp
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="DOCK_OPEN_CAMP_SUC"})
GameEntry.UI:OpenUIForm(UIFormId.UI_Camp,t)
elseif e==DOCK_TYPE.BAG then
a=UIFormId.UI_Bag
GameEntry.UI:OpenUIForm(UIFormId.UI_Bag,t)
elseif e==DOCK_TYPE.EXPEDITION then
ModulesInit.EarthMgr:EnterEarth(t)
elseif e==DOCK_TYPE.ADVENTURE then
a=UIFormId.UI_AdventureInterface
GameEntry.UI:OpenUIForm(UIFormId.UI_AdventureInterface,t)
elseif e==DOCK_TYPE.GUILD then
a=UIFormId.UI_GuildMainView
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildMainView,t)
elseif e==DOCK_TYPE.MAIN_CITY then
if not t then
t={}
end
t.isUpLevel=LuaUtils.GetActive(im_city_qipaoup)
GameEntry.UI:OpenUIForm(UIFormId.UI_City,t)
end
i:PushBack(a)
if e==DOCK_TYPE.MAIN_PAGE then
h:CheckAndRefresh(e)
CheckIdleTip()
n:CheckAndRefresh(e)
c:CheckAndRefresh(e)
u:CheckAndRefresh(e)
f:CheckAndRefresh(e)
else
h:Clean()
l:Clean()
n:Clean()
u:Clean()
end
RefreshRedPoint()
onNewShowChange()
end
function onOpenDockUI(e)
if e.openIndex then
changeTab(e.openIndex,e.userData)
end
end
function onCloseDockAndCurrUI(e)
local t=e and e.forbidViewList or{}
local function a(a)
for e=1,#t do
if t[e]==a then
return true
end
end
return false
end
local e=i:PopFront()
while e~=nil and a(e)==false do
GameTools.CloseUIForm(e)
e=i:PopFront()
end
if a(UIFormId.UI_Dock)==false then
GameTools.CloseUIForm(UIFormId.UI_Dock)
end
ViewMgr:clostEnableLayerView(t)
end
function onHideDockAndCurrUI(e)
for t=i.first,i.last do
local t=i[t]
if e then
GameEntry.UI:HideUIForm(t)
else
GameEntry.UI:ShowUIForm(t)
end
end
if e then
GameEntry.UI:HideUIForm(UIFormId.UI_Dock)
else
GameEntry.UI:ShowUIForm(UIFormId.UI_Dock)
end
end
function CheckBagTip()
local e=ModulesInit.BagManager:checkEquipBagIsFull()
LuaUtils.SetActive(spine_bag_full.transform,e)
LuaUtils.SetActive(im_bag_red.transform,false)
if e then
local e=spine_bag_full:GetComponent(typeof(CS.YouYou.UISpineCtr))
e:ClearTracks()
e:PlayAnimation(0,"idle",true)
else
LuaUtils.SetActive(im_bag_red.transform,CheckItemAir())
end
RefreshRedPoint()
end
function CheckItemAir()
local e=ModulesInit.BagManager:GetBagItemDidByType(ModulesInit.BagManager.TAB_TYPE.ITEM)
for t,e in pairs(e)do
local e=w.GetEntity(e)
if e.isExclamation==1 then
return true
end
end
return false
end
function CheckUnderwearAir()
local e=ModulesInit.BagManager:GetUnderwearItemInfos()
for t,e in pairs(e)do
local e=w.GetEntity(e.itemDid)
if e.isExclamation==1 then
return true
end
end
return false
end
function CheckGuideHandShow()
if PlayerMgr.loginComplete==false then
return
end
LuaUtils.SetActive(spine_xiaoshou.transform,false)
LuaUtils.SetActive(dianjigq1.transform,false)
if o then
o:Stop()
o=nil
end
if a then
a:Kill()
a=nil
end
if(not ModulesInit.GuideMgr.isGuide)and not ModulesInit.ExpeditionManager:MapIsThrough(ModulesInit.GuideMgr.firstGuideTipsMapId)then
GuideTimerAction()
end
end
function GuideTimerAction()
LuaUtils.SetActive(spine_xiaoshou.transform,false)
LuaUtils.SetActive(dianjigq1.transform,false)
if(not ModulesInit.GuideMgr.isGuide)and not ModulesInit.ExpeditionManager:MapIsThrough(ModulesInit.GuideMgr.firstGuideTipsMapId)then
if o then
o:Stop()
o=nil
end
o=ModulesInit.TimeActionMgr:CreateTimeAction()
o:Init(4,2,1,nil,function()
LuaUtils.SetActive(dianjigq1.transform,true)
LuaUtils.SetActive(spine_xiaoshou.transform,true)
UIUtil.SpinePlayAnimation(spine_xiaoshou.transform,0,"B",true)
if a then
a:Kill()
a=nil
end
a=CS.DG.Tweening.DOTween.Sequence()
a:AppendInterval(3.5)
a:AppendCallback(function()
LuaUtils.SetActive(spine_xiaoshou.transform,false)
LuaUtils.SetActive(dianjigq1.transform,false)
GuideTimerAction()
end)
end,nil):Run()
end
end
function OnEventTitanDescInfo()
end
function OnLoadingClosed()
PlayerMgr.loginLoadComplete=true

if not ModulesInit.GuideMgr.isGuide then
LuaUtils.SetActive(show_mask.transform,true)
local t=show_mask.transform:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
t.alpha=1
local e=CS.DG.Tweening.DOTween.Sequence()
e:AppendInterval(0.4)
e:Append(t:DOFade(0,1))
e:OnComplete(function()
CheckShowLoginView()
LuaUtils.SetActive(show_mask.transform,false)
end)
else
CheckShowLoginView()
end
end
function OnPlayInfoChange()
h:CheckAndRefresh(e)
CheckIdleTip()
n:CheckAndRefresh(e)
end
function OnGetIdleItemsSuccess()
CheckIdleTip()
end
function CheckIdleTip()
if Time.realtimeSinceStartup-p>2 then
ModulesInit.ExpeditionManager:SendMapIdleInfoRequest()
p=Time.realtimeSinceStartup
end
end
function CheckKillDragonsTip()
n:CheckAndRefresh(e)
end
function OnPlayerLoginComplete()
end
function RefreshRedPoint()
local e=PlayerMgr and PlayerMgr.loginComplete
if not e then return end
if not GameEntry.UI:IsExists(UIFormId.UI_Camp)then
local e=RedPointMgr:checkCampRedPoint()
LuaUtils.SetActive(im_camp_red_point.transform,e)
LuaUtils.SetActive(im_camp_shengji.transform,false)
if not e and RedPointMgr:checkCampGreenUp()then
LuaUtils.SetActive(im_camp_shengji.transform,true)
else
LuaUtils.SetActive(im_camp_underwear_gift.transform,false)
if not e and RedPointMgr:checkCampUnderwearBoxGift()then
LuaUtils.SetActive(im_camp_underwear_gift.transform,true)
end
end
else
LuaUtils.SetActive(im_camp_red_point.transform,false)
LuaUtils.SetActive(im_camp_shengji.transform,false)
LuaUtils.SetActive(im_camp_underwear_gift.transform,false)
end
if not GameEntry.UI:IsExists(UIFormId.UI_GuildMainView)then
LuaUtils.SetActive(guild_rd.transform,RedPointMgr:checkGuildRedPoint())
LuaUtils.SetActive(guild_rd_count.transform,false)
else
LuaUtils.SetActive(guild_rd.transform,false)
end
if not GameEntry.UI:IsExists(UIFormId.UI_AdventureInterface)then
HandleRedPointVisible(adventure_qipao1,RedPointMgr:checkAdventureRedPoint())
else
LuaUtils.SetActive(adventure_qipao1.transform,false)
end
if GameFunction.IsFunctionUnLock(GameFunctionType.City,false)then
local e=false
if GameFunction.IsFunctionUnLock(GameFunctionType.Officer,false)and
not ModulesInit.PhotoArtistMgr:getDataById(527)then
LuaUtils.SetActive(im_city_new.transform,true)
e=true
else
LuaUtils.SetActive(im_city_new.transform,false)
end
local t=false
if not e and GameFunction.IsFunctionUnLock(GameFunctionType.Officer,false)and
RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.OFFICER_UPGRADE)then
LuaUtils.SetActive(im_city_qipaoup2.transform,true)
t=true
else
LuaUtils.SetActive(im_city_qipaoup2.transform,false)
end
local a=false
if not e and not t then
if RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.CITY_LEVEL_UP)then
LuaUtils.SetActive(im_city_qipaoup,true)
a=true
else
LuaUtils.SetActive(im_city_qipaoup,false)
end
end
if not e and not a and not t then
if RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.CITY_DOG)or
RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.CITY_AWARD)or
RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.RING_HAREM_POWER)then
LuaUtils.SetActive(city_point,true)
else
LuaUtils.SetActive(city_point,false)
end
else
LuaUtils.SetActive(city_point,false)
end
end
LuaUtils.SetActive(im_fight_red.transform,RedPointMgr:checkFightRedPoint())
end
function onNewShowChange()
if not GameEntry.UI:IsExists(UIFormId.UI_Camp)then
local e=RedPointMgr:checkCampNew()
LuaUtils.SetActive(im_camp_new.transform,e)
else
LuaUtils.SetActive(im_camp_new.transform,false)
end
if not GameEntry.UI:IsExists(UIFormId.UI_GuildMainView)then
local e=RedPointMgr:checkGuildCanJoin()
local t=RedPointMgr:checkGuildNew()
LuaUtils.SetActive(im_guild_can_join.transform,e)
LuaUtils.SetActive(im_guild_new.transform,not e and t)
else
LuaUtils.SetActive(im_guild_new.transform,false)
LuaUtils.SetActive(im_guild_can_join.transform,false)
end
if not GameEntry.UI:IsExists(UIFormId.UI_AdventureInterface)then
LuaUtils.SetActive(im_adventure_new.transform,RedPointMgr:checkAdventureNew(y))
else
LuaUtils.SetActive(im_adventure_new.transform,false)
end
end
function OnRespFlowerQualification(e)
if e then
y=e.tipState
onNewShowChange()
end
end
function HandleRedPointVisible(e,t)
LuaUtils.SetActive(e.transform,t)
LuaUtils.SetActive(e.transform:Find("text_num"),false)
end
function CheckShowLoginView(e)

if PlayerMgr.loginComplete==false then
return
end

PayMgr:Log("RemoveOldTrans")
CS.YouYou.PayManager.RemoveOldTrans()

ModulesInit.AutoPopViewMgr:start(e)
CheckGuideHandShow()
end
function onDockShowHide(e)
if e then
LuaUtils.AnimtorPlay(UI_Dock,"UI_Dock_out",0,0)
else
LuaUtils.AnimtorPlay(UI_Dock,"UI_Dock_in",0,0)
end
end
function CheckShowGuildTip()
local e=false
if GameFunction.IsFunctionUnLock(GameFunctionType.Guild,false)
and PlayerMgr.PlayerInfo.guildId<=0
and PlayerMgr.PlayerExtInfo.joinGuildAgo==false then
e=true
end
return e
end
function OnIdleCheckUpdate()
local t=false
if ModulesInit.ExpeditionManager.curIdleMapData then
local e=TimeUtil.serverTimeStep-ModulesInit.ExpeditionManager.curIdleMapData.beginSecond
if e>3600*4 then
if not LuaUtils.GetActive(jiarutishi2)then
local e=math.floor(e/3600)
if e>24 then
e=24
end
LuaUtils.SetChildLabelTextMeshText(jiarutishi2,'text_tmp_message',GameTools.GetLocalize('UI.Homepage.Tips.11',LanguageCategory.LangCommon,e))
end
t=true
else
end
end
return t
end
function CheckAndRefreshKillDragonsTip()
local e=false
return e
end
function CheckAndRefreshTitanTip()
local t,e,e=GameFunction.IsFunctionUnLock(GameFunctionType.Titans)
local e=ModulesInit.TitanMgr:GetTitanDescInfo()
if e
and t
and PlayerMgr.PlayerInfo.guildId>0
and e.status==PROTO_ENUM.ENUM_TITANS_STATUS.TT_STATUS_BATTLE then
return true
else
return false
end
end
function CheckAndRefreshGuidWarTip()
local e=false
return e
end
function CheckAndRefreshFlowerTip()
if RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.FLOWER_FINAL)then
return true
end
if RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.FLOWER_PRELIME)then
return true
end
return false
end
function OnPlayerLevelUp(e)
end
function SetAllGrayByTime()
end
function SetAllGray(e)
UIUtil.SetGray3(transform,e)
UIUtil.SetSpineRenderGray(sp_mainpage_gray,e)
UIUtil.SetSpineRenderGray(sp_camp_gray,e)
UIUtil.SetSpineRenderGray(sp_bag_gray,e)
UIUtil.SetSpineRenderGray(sp_expedition_gray,e)
UIUtil.SetSpineRenderGray(sp_adventureInterface_gray,e)
UIUtil.SetSpineRenderGray(sp_guild_gray,e)
UIUtil.SetSpineRenderGray(sp_maincity_gray,e)
UIUtil.SetGray3(im_camp_red_point.transform,false)
UIUtil.SetGray3(guild_rd.transform,false)
UIUtil.SetGray3(adventure_qipao1.transform,false)
UIUtil.SetGray3(im_city_qipaoup2.transform,false)
UIUtil.SetGray3(im_city_qipaoup.transform,false)
UIUtil.SetGray3(city_point.transform,false)
UIUtil.SetGray3(im_fight_red.transform,false)
end
function OnEventMainPageGray()
SetAllGrayByTime()
end
function OnEventNetReconnectSuccess(e)
if r==false then
initEnterTab(m)
end
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

