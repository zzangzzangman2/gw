local e=require('DataNode/DataTable/Create/function/DTFunctionDBModel')
local f=require("DataNode/DataManager/DataMgr/DataUtil")
local l=nil
local d=0
local u=0
local o=nil
local a=nil
local r,c=nil,nil
local n=nil
local s=nil
local t=nil
local e=nil
local i=nil
local h=nil
local m=false
function OnInit(d,u)
btn_fanhui.onClick:AddListener(function()
if not GameEntry.UI:IsExists(UIFormId.UI_MainPage)then
GameEntry.UI:OpenUIForm(UIFormId.UI_MainPage)
end
GameTools.CloseUIForm(UIFormId.UI_JingjiFrame_View)
ModulesInit.GuideMgr:CheckCloseJingjiFrmGuide()
end)
r=UI_currency1:GetComponents()
c=UI_currency2:GetComponents()
r['btn_jia'].onClick:AddListener(function()
ActMgr:CheckJumpViewById(301)
end)
c['btn_jia'].onClick:AddListener(function()
GameEntry.UI:OpenUIForm(UIFormId.UI_GoldChange)
end)
n=JingjichangPannel:GetComponents()
n["img_bg_btn"].onClick:AddListener(function()
if not GameFunction.IsFunctionUnLock(GameFunctionType.Arena)then
local e,t=GameFunction.GetFunctionUnLockTypeAndParaById(GameFunctionType.Arena)
UIUtil.ShowCommonTips(f.GetConditionUnlockStr(e,t))
return
end
local e=ModulesInit.ArenaManager:SendArenaInfoRequest()
e.onCompleted=function()
GameEntry.UI:OpenUIForm(UIFormId.UI_Arena)
end
end)
if GameEntry.IsReview then
LuaUtils.SetActive(ciyuanJIngjiPannel.transform,false)
end
s=ciyuanJIngjiPannel:GetComponents()
s["img_bg_btn"].onClick:AddListener(function()
local e=ModulesInit.CrossArenaManager:SendCrossArenaStatusRequest()
e.onCompleted=function()
if not GameFunction.IsFunctionUnLock(GameFunctionType.CrossArena)then
local e,t=GameFunction.GetFunctionUnLockTypeAndParaById(GameFunctionType.CrossArena)
UIUtil.ShowCommonTips(f.GetConditionUnlockStr(e,t))
return
end
l=ModulesInit.CrossArenaManager.ArenaData
if l.groupStatus==PROTO_ENUM.ENUM_CSGROUP_STATUS.GROUP_CLOSE then
local e=Constant.crossArena_open_server_num-l.groupServerCount
if e<0 then
e=0
end
if e~=0 then
UIUtil.ShowCommonTipsForLocalize('tips.common_122',LanguageCategory.LangCommon,e)
return
end
if l.groupOpenTime~=0 then
local e=l.groupOpenTime-TimeUtil.serverTimeStep
UIUtil.ShowCommonTipsForLocalize('tips.common_123',LanguageCategory.LangCommon,TimeUtil.TimestampToDate3(e))
return
end
end
local e=ModulesInit.CrossArenaManager:SendCrossArenaInfoRequest()
e.onCompleted=function()
GameEntry.UI:OpenUIForm(UIFormId.UI_CrossArena)
end
end
end)
t=tianxiaPannel:GetComponents()
t["img_bg_btn"].onClick:AddListener(function()
if GameFunction:CheckTodayOpenSkyCity()then
ModulesInit.PhotoArtistMgr:setRedStatusSaveID(ModulesInit.PhotoArtistMgr.FirstUI.SkyCityHelpId)
ModulesInit.SkyCityMgr:EnterSkyCity(nil,{from=UIFormId.UI_JingjiFrame_View})
EventSystem.SendEvent(CommonEventId.NewShowInfoChange)
else
ModulesInit.PhotoArtistMgr:setRedStatusSaveID(ModulesInit.PhotoArtistMgr.FirstUI.FSBHelpId)
ModulesInit.FullServerBattleMgr:enterFSBMMain()
end
end)
if GameEntry.IsReview then
LuaUtils.SetActive(tianxiaPannel.transform,false)
end
e=wenquanPannel:GetComponents()
if GameEntry.IsReview then
local e=d:Find("middle/wenquanPannel")
LuaUtils.SetActive(e,false)
end
e["btn_actHelp"].onClick:AddListener(function()
local t=GameTools.GetLocalize("hyakuniti_minebattle_double",LanguageCategory.LangCommon)
local e={
worldPos=e["btn_actHelp"].transform.position,
hintDes=t,
}
UIUtil.ShowHint(e)
end)
e["img_bg_btn"].onClick:AddListener(function()
if not ModulesInit.MineMgr:isOpen()then
UIUtil.ShowCommonTips(GameTools.GetLocalize("tips.common_278",LanguageCategory.LangCommon))
return
end
local t,a,a=GameFunction.IsFunctionUnLock(GameFunctionType.MineWar,true)
if not t then
return
end
local t=ModulesInit.PhotoArtistMgr:checkRedStatusSaveID(ModulesInit.PhotoArtistMgr.FirstUI.MineWar)
ModulesInit.PhotoArtistMgr:setRedStatusSaveID(ModulesInit.PhotoArtistMgr.FirstUI.MineWar)
if t then
LuaUtils.SetActive(e["im_New"].transform,true)
end
ModulesInit.MineMgr:entryMine()
if RedPointMgr:checkMineDayRedPoint()then
local e=TimeUtil.GetServerTimeStamp()
SaveMgr.SetStringForKey("minebattle_day_redpoint",e)
RedPointMgr:doNotify()
end
end)
i=baihuaPannel:GetComponents()
i["img_bg_btn"].onClick:AddListener(function()
if GameFunction.IsFunctionUnLock(GameFunctionType.Flower,true)then
ModulesInit.PhotoArtistMgr:setRedStatusSaveID(ModulesInit.PhotoArtistMgr.FirstUI.FlowerFight)
if o==nil then
UIUtil.ShowCommonTips(GameTools.GetLocalize("flowerFight_68",LanguageCategory.LangCommon))
else
if o.upgrade==true then
UIUtil.ShowCommonTips(GameTools.GetLocalize("flowerFight_105",LanguageCategory.LangCommon))
else
if a==nil then
UIUtil.ShowCommonTips(GameTools.GetLocalize("flowerFight_68",LanguageCategory.LangCommon))
else
if a.state==PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_NONE then
if o.openTime then
local e=o.openTime-TimeUtil:GetServerTimeStamp()
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
if a.state==PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_SIGN
and not a.isSign
and not a.signMax then
ModulesInit.FlowerFightMgr:ReqFlowerSign(function()
a.isSign=true
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
end)
h=warOfAttritionPannel:GetComponents()
h["img_bg_btn"].onClick:AddListener(function()
if GameFunction.IsFunctionUnLock(GameFunctionType.WarOfAttrition,true)then
ModulesInit.WarOfAttritionMgr:OnEnterMainUI()
end
end)
end
function OnOpen(e)
m=false
EventSystem.SendEvent(CommonEventId.RedPointInfoChange)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.AddListener(CommonEventId.RedPointInfoChange,RefreshRedPoint)
EventSystem.AddListener(CommonEventId.NewShowInfoChange,onNewShowChange)
EventSystem.AddListener(CommonEventId.SKY_STATE_CHANGE,RefreshRedPoint)
EventSystem.AddListener(CommonEventId.OnEventRespError,OnEventRespError)
EventSystem.AddListener(CommonEventId.MINE_STATE_CHANGE,OnMineRefresh)
EventSystem.AddListener(CommonEventId.PlayerLevelUp,OnPlayerLevelUp)
EventSystem.AddListener(CommonEventId.OnPlayCurrencyRefresh,OnPlayCurrencyRefresh)
EventSystem.AddListener(CommonEventId.NewDay,OnNewDay)
EventSystem.AddListener(SysEventId.OnUpdate,OnUpdate)
d=5
u=0
o=nil
a=nil
local e=CS.DG.Tweening.DOTween.Sequence()
e:AppendInterval(1)
e:AppendCallback(function()
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="OPEN_UI_JINGJIFRAME_SUC"})
end)
Refresh()
ModulesInit.MineMgr:CheckAndReqStatus()
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
EventSystem.RemoveListener(CommonEventId.OnPlayCurrencyRefresh,OnPlayCurrencyRefresh)
EventSystem.RemoveListener(CommonEventId.NewShowInfoChange,onNewShowChange)
EventSystem.RemoveListener(CommonEventId.SKY_STATE_CHANGE,RefreshRedPoint)
EventSystem.RemoveListener(CommonEventId.OnEventRespError,OnEventRespError)
EventSystem.RemoveListener(CommonEventId.MINE_STATE_CHANGE,OnMineRefresh)
EventSystem.RemoveListener(CommonEventId.PlayerLevelUp,OnPlayerLevelUp)
EventSystem.RemoveListener(CommonEventId.NewDay,OnNewDay)
EventSystem.RemoveListener(SysEventId.OnUpdate,OnUpdate)
o=nil
a=nil
m=true
end
function OnBeforeDestroy()
end
function OnNewDay()
ReqRefreshMine()
RereshSkyCityAndFSB()
RefreshFlowerAndWarOpen()
end
function RereshSkyCityAndFSB()
local o=t["img_bg_btn"].transform:GetComponent(typeof(CS.YouYou.YouYouImage))
local i=t["Image"].transform:GetComponent(typeof(CS.YouYou.YouYouImage))
LuaUtils.SetActive(t["text_title"].transform,false)
if GameFunction:CheckTodayOpenSkyCity()then
GameTools:SetImageSprite(o,"UIJingjiFrame/pvp_banner_zhengba",false)
GameTools:SetImageSprite(i,"UIJingjiFrame/pvp_banner_zhengba2",true)
elseif GameFunction:CheckTodayOpenFSB()then
local e
local e=ModulesInit.FullServerBattleMgr.loginShowInfo
if e then
LuaUtils.SetActive(t["text_title"].transform,true)
local a
if e.cupType==1 then
a="fsb_matchesbrave_brave"
GameTools:SetImageSprite(o,"UIJingjiFrame/pvp_banner_yanchang1",false)
else
a="fsb_matchesbrave_king"
GameTools:SetImageSprite(o,"UIJingjiFrame/pvp_banner_yanchang3",false)
end
LuaUtils.SetTextMeshText(t["text_title"],GameTools.GetLocalize(a,LanguageCategory.LangCommon,e.bigSeason,e.raceNum))
end
GameTools:SetImageSprite(i,"UIJingjiFrame/pvp_banner_yanchang2",true)
end
end
function OnUpdate()
UpdateStateInfo()
UpdateLeftTime()
end
function UpdateStateInfo()
d=d+Time.deltaTime
if d<5 then
return
end
d=0
RefreshFlowerStatusLock()
end
function RefreshFlowerStatusLock()
local e,t,t=GameFunction.IsFunctionUnLock(GameFunctionType.Flower)
if e then
if o==nil
or(o.upgrade and(o.upgradeEndTimestamp-TimeUtil.GetServerTimeStamp()<0))
or(a and(a.stateOverTime-TimeUtil.GetServerTimeStamp()<0))
then
ReqFloweServerData()
end
end
end
function ReqFloweServerData()
local e=ModulesInit.FlowerFightMgr:ReqFlowerEntranceInfo(function(e)
o=e
a=e.raceInfo
if not m then
onNewShowChange()
RefreshUnlock()
end
end)
end
function UpdateLeftTime()
u=u+Time.deltaTime
if u<1 then
return
end
u=0
UpdateFlowerLeftTime()
UpdateMine()
end
function UpdateMine()
if not ModulesInit.MineMgr:isOpen()then
return
end
local e,t,t=GameFunction.IsFunctionUnLock(GameFunctionType.MineWar)
if not e then
return
end
end
function UpdateFlowerLeftTime()
if a==nil then
return
end
end
function EnterFlowerView()
local e={
isSign=a.isSign,
stage=a.stage,
fromFlowerEntrance=false,
state=a.state,
selfMaxType=a.selfMaxType,
serverType=o.serverType,
serverCount=o.serverCount,
from=UIFormId.UI_JingjiFrame_View,
}
ModulesInit.FlowerFightMgr:EnterFlower(e)
end
function RefreshFlowerStateInfo()
end
function GetFlowerShowTimeData()
end
function Refresh()
RefreshRedPoint()
onNewShowChange()
RefreshUnlock()
OnMineRefresh()
RefreshCurrencyView()
RereshSkyCityAndFSB()
end
function OnPlayCurrencyRefresh()
RefreshCurrencyView()
end
function RefreshCurrencyView()
if r then
LuaUtils.SetTextMeshText(r['txt_act_name'],UIUtil.toBigNum3(PlayerMgr:getCurrencyCount(Currency.Diamond)))
LuaUtils.SetTextMeshText(c['txt_act_name'],UIUtil.toBigNum(PlayerMgr:getCurrencyCount(Currency.Gold)))
local e=ModulesInit.BagManager:GetBaseInfo(PROTO_ENUM.ENUM_CURRENCY.HOLY_CRYSTAL)
GameTools:SetImageSprite(r["im_zuanshi"],e.icon,false)
local e=ModulesInit.BagManager:GetBaseInfo(PROTO_ENUM.ENUM_CURRENCY.GOLD)
GameTools:SetImageSprite(c["im_zuanshi"],e.icon,false)
end
end
function RefreshFlowerAndWarOpen()
if GameEntry.IsReview or not ModulesInit.FlowerFightMgr:IsOpen()then
LuaUtils.SetActive(baihuaPannel.transform,false)
else
LuaUtils.SetActive(baihuaPannel.transform,true)
end
if GameEntry.IsReview or ModulesInit.WarOfAttritionMgr:IsHideShowState()then
LuaUtils.SetActive(warOfAttritionPannel.transform,false)
else
LuaUtils.SetActive(warOfAttritionPannel.transform,true)
end
if i then
local e,a,t=GameFunction.IsFunctionUnLock(GameFunctionType.Flower)
if e then
LuaUtils.SetActive(i["Img_unLock"].transform,false)
else
LuaUtils.SetTextMeshText(i["text_unLock"],t)
LuaUtils.SetActive(i["Img_unLock"].transform,true)
end
end
if h then
local e,a,t=GameFunction.IsFunctionUnLock(GameFunctionType.WarOfAttrition)
if e then
LuaUtils.SetActive(h["Img_unLock"].transform,false)
else
LuaUtils.SetTextMeshText(h["text_unLock"],t)
LuaUtils.SetActive(h["Img_unLock"].transform,true)
end
end
end
function RefreshUnlock()
if n then
local e,a,t=GameFunction.IsFunctionUnLock(GameFunctionType.Arena)
if e then
LuaUtils.SetActive(n["Img_unLock"].transform,false)
else
LuaUtils.SetTextMeshText(n["text_unLock"],t)
LuaUtils.SetActive(n["Img_unLock"].transform,true)
end
end
if s then
local t,a,e=GameFunction.IsFunctionUnLock(GameFunctionType.CrossArena)
if t then
LuaUtils.SetActive(s["Img_unLock"].transform,false)
else
LuaUtils.SetTextMeshText(s["text_unLock"],e)
LuaUtils.SetActive(s["Img_unLock"].transform,true)
end
end
RefreshFlowerAndWarOpen()
if t then
local a,o,e=GameFunction.IsFunctionUnLock(GameFunctionType.Guild)
if a then
LuaUtils.SetActive(t["Img_unLock"].transform,false)
else
LuaUtils.SetTextMeshText(t["text_unLock"],e)
LuaUtils.SetActive(t["Img_unLock"].transform,true)
end
end
if e then
if not ModulesInit.MineMgr:isOpen()or not ModulesInit.MineMgr:IsSelfOpen()then
LuaUtils.SetActive(e["Img_unLock"].transform,true)
LuaUtils.SetTextMeshText(e["text_unLock"],GameTools.GetLocalize("tips.common_279"))
else
local a,o,t=GameFunction.IsFunctionUnLock(GameFunctionType.MineWar)
if not a then
LuaUtils.SetActive(e["Img_unLock"].transform,true)
LuaUtils.SetTextMeshText(e["text_unLock"],t)
else
LuaUtils.SetActive(e["Img_unLock"].transform,false)
end
end
end
end
function RefreshRedPoint()
if n then
LuaUtils.SetActive(n["im_red"].transform,RedPointMgr:checkArenaRedPoint())
end
if s then
LuaUtils.SetActive(s["im_red"].transform,RedPointMgr:checkCrossArenaRedPoint())
end
if i then
LuaUtils.SetActive(i["im_red"].transform,RedPointMgr:checkFlowerRedPoint())
end
if e then
LuaUtils.SetActive(e["im_red"].transform,RedPointMgr:checkMineBattleRedPoint())
end
if t then
if GameFunction:CheckTodayOpenSkyCity()then
LuaUtils.SetActive(t["im_red"].transform,RedPointMgr:checkSkyCityRedPoint())
elseif GameFunction:CheckTodayOpenFSB()then
LuaUtils.SetActive(t["im_red"].transform,RedPointMgr:CheckFSBRedPoint()or RedPointMgr:CheckFSBTaskRedPoint())
end
end
end
function OnEventRespError(e)
if e.protoCode==ProtoId.PRT_FLOWER_SIGN_REQ then
ReqFloweServerData()
end
end
function onNewShowChange()
if n then
LuaUtils.SetActive(n["im_New"].transform,false)
if GameFunction.IsFunctionUnLock(GameFunctionType.Arena)then
if ModulesInit.PhotoArtistMgr:checkSaveID(ModulesInit.PhotoArtistMgr.FirstUI.ArenaHelpId)then
LuaUtils.SetActive(n["im_New"].transform,true)
end
end
end
if t then
LuaUtils.SetActive(t["im_New"].transform,false)
if GameFunction:CheckTodayOpenSkyCity()then
if GameFunction.IsFunctionUnLock(GameFunctionType.Guild)and PlayerMgr.PlayerInfo.guildId>0 and
ModulesInit.PhotoArtistMgr:checkRedStatusSaveID(ModulesInit.PhotoArtistMgr.FirstUI.SkyCityHelpId)then
if ModulesInit.PhotoArtistMgr:checkSaveID(ModulesInit.PhotoArtistMgr.FirstUI.SkyCityHelpId)then
LuaUtils.SetActive(t["im_New"].transform,true)
end
end
else
if GameFunction.IsFunctionUnLock(GameFunctionType.Guild)and PlayerMgr.PlayerInfo.guildId>0 and
ModulesInit.PhotoArtistMgr:checkRedStatusSaveID(ModulesInit.PhotoArtistMgr.FirstUI.FSBHelpId)then
if ModulesInit.PhotoArtistMgr:checkSaveID(ModulesInit.PhotoArtistMgr.FirstUI.FSBHelpId)then
LuaUtils.SetActive(t["im_New"].transform,true)
end
end
end
end
if i then
LuaUtils.SetActive(i["im_New"].transform,false)
if GameFunction.IsFunctionUnLock(GameFunctionType.Flower)then
if a==nil or a.state==PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_NONE then
LuaUtils.SetActive(i["im_New"].transform,false)
else
if ModulesInit.PhotoArtistMgr:checkSaveID(ModulesInit.PhotoArtistMgr.FirstUI.FlowerFight)
and ModulesInit.PhotoArtistMgr:checkSaveID(ModulesInit.PhotoArtistMgr.FirstUI.FlowerFightCross)then
LuaUtils.SetActive(i["im_New"].transform,true)
end
end
end
end
if e then
LuaUtils.SetActive(e["im_New"].transform,false)
if GameFunction.IsFunctionUnLock(GameFunctionType.MineWar)and
ModulesInit.MineMgr:IsSelfOpen()and
ModulesInit.PhotoArtistMgr:checkRedStatusSaveID(ModulesInit.PhotoArtistMgr.FirstUI.MineWar)and
ModulesInit.MineMgr:isOpen()then
if ModulesInit.PhotoArtistMgr:checkSaveID(ModulesInit.PhotoArtistMgr.FirstUI.MineWar)then
LuaUtils.SetActive(e["im_New"].transform,true)
end
end
local t,a=ModulesInit.ActGoldWeekManager:IsOpenDouble(152)
LuaUtils.SetActive(e["im_actTip"].transform,t)
local t=ModulesInit.ActGoldWeekManager:IsShowTip(152)
LuaUtils.SetActive(e["btn_actHelp"].transform,t)
end
end
function OnMineRefresh()
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
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end 
