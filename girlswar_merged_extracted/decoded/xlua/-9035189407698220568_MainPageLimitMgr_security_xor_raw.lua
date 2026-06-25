local o=require('DataNode/DataTable/Create/worldMap/DTMainLimitTimeDBModel')
local i=require('DataNode/DataTable/Create/worldMap/DTMainActivityJumpDBModel')
local n=require('DataNode/DataTable/Create/constant/DTConstantDBModel')
local e={
mFlowerServerInfo={},
mFlowerRaceInfo={},
mMainActivityJumpList={},
mMainActivityJumpIndex=0,
mMainActivityJumpDelayTime=0,
mMainActivityShowLimitDelayTime=0,
mMainActivityShowLimitList={},
mMainActivityShowLimitIndex=0,
}
e.EShowLimitPage={
kFirstDayAct=1,
kTitan=2,
kSailongzhou=4,
kSkyCity=5,
kFlowerFight=6,
kNewMarketUR=7,
kNewMarketUnderwear=8,
kNewMarketEquip=9,
kNewMarketTreasure=10,
}
e.EShowLimitData={
[1]={
clickHandler=function()
e:ClickDragonHandler()
end,
},
[2]={
clickHandler=function()
e:ClickDragonHandler()
end,
},
[3]={
clickHandler=function()
if not GameFunction.IsFunctionUnLock(GameFunctionType.Titans,true)then
return
end
if PlayerMgr.PlayerInfo.guildId<=0 then
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildJoinListNewView)
return
end
ModulesInit.TitanMgr:EnterTitan(false)
end,
checkShowFunc=function()
local e=TimeUtil.GetServerToDHMS()
local t=e.hour*3600+e.minute*60
local e=ModulesInit.MainPageLimitMgr:getLimitTimeCfgById(3)
if ModulesInit.MainPageLimitMgr:CheckLimitCfg(e,t)then
return true
end
return false
end,
},
[4]={
clickHandler=function()
e:ClickDragonHandler()
end,
},
[5]={
clickHandler=function()
e:ClickDragonHandler()
end,
},
[6]={
clickHandler=function()
if not GameFunction.IsFunctionUnLock(GameFunctionType.Titans,true)then
return
end
if PlayerMgr.PlayerInfo.guildId<=0 then
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildJoinListNewView)
return
end
ModulesInit.TitanMgr:EnterTitan(false)
end,
checkShowFunc=function()
local e=TimeUtil.GetServerToDHMS()
local e=e.hour*3600+e.minute*60
local t=ModulesInit.MainPageLimitMgr:getLimitTimeCfgById(6)
if ModulesInit.MainPageLimitMgr:CheckLimitCfg(t,e)then
return true
end
return false
end,
},
[7]={
clickHandler=function()
if PlayerMgr.PlayerInfo.guildId<=0 then
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildJoinListNewView)
return
end
e:ClickSkyCityHandler()
end,
getTipText=function()
return e:GetSkyCityTipText(7)
end,
checkShowFunc=function()
if not GameFunction:CheckTodayOpenSkyCity()then
return false
end
local e=TimeUtil.GetServerToDHMS()
local e=e.hour*3600+e.minute*60
local t=ModulesInit.MainPageLimitMgr:getLimitTimeCfgById(7)
if ModulesInit.MainPageLimitMgr:CheckLimitCfg(t,e)then
return true
end
return false
end,
},
[8]={
clickHandler=function()
if PlayerMgr.PlayerInfo.guildId<=0 then
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildJoinListNewView)
return
end
e:ClickSkyCityHandler()
end,
getTipText=function()
return e:GetSkyCityTipText(8)
end,
checkShowFunc=function()
if not GameFunction:CheckTodayOpenSkyCity()then
return false
end
local e=TimeUtil.GetServerToDHMS()
local t=e.hour*3600+e.minute*60
local e=ModulesInit.MainPageLimitMgr:getLimitTimeCfgById(8)
if ModulesInit.MainPageLimitMgr:CheckLimitCfg(e,t)then
return true
end
return false
end,
},
[9]={
clickHandler=function()
e:ClickFlowerHandler()
end,
},
[10]={
clickHandler=function()
e:ClickFlowerHandler()
end,
},
[11]={
clickHandler=function()
e:ClickFlowerHandler()
end,
},
[12]={
clickHandler=function()
e:ClickFlowerHandler()
end,
},
[13]={
clickHandler=function()
e:ClickDragonHandler()
end,
},
[14]={
clickHandler=function()
e:ClickDragonHandler()
end,
},
[15]={
clickHandler=function()
e:ClickDragonHandler()
end,
},
[16]={
clickHandler=function()
GameEntry.UI:OpenUIForm(UIFormId.UI_ActFirstDayReward)
end,
getTipText=function()
local e=ModulesInit.ActFirstDayRewardMgr:GetRewardStatus()
if e==ModulesInit.ActFirstDayRewardMgr.REWARD_STATUS.DISABLE then
return GameTools.GetLocalize("ui_new_main_tips19",LanguageCategory.LangCommon)
else
return GameTools.GetLocalize("ui_new_main_tips20",LanguageCategory.LangCommon)
end
end,
checkShowFunc=function()
local e=ModulesInit.ActFirstDayRewardMgr:GetRewardStatus()
if e==ModulesInit.ActFirstDayRewardMgr.REWARD_STATUS.DISABLE or e==ModulesInit.ActFirstDayRewardMgr.REWARD_STATUS.ABLE then
return true
end
return false
end
},
[17]={
clickHandler=function()
EventSystem.SendEvent(CommonEventId.OnClickNewMarketNotice,550)
end,
getTipText=function()
return e:GetNewMarketTipText(550)
end,
checkShowFunc=function()
return e:CheckNewMarketShow(550)
end
},
[18]={
clickHandler=function()
EventSystem.SendEvent(CommonEventId.OnClickNewMarketNotice,552)
end,
getTipText=function()
return e:GetNewMarketTipText(552)
end,
checkShowFunc=function()
return e:CheckNewMarketShow(552)
end
},
[19]={
clickHandler=function()
EventSystem.SendEvent(CommonEventId.OnClickNewMarketNotice,551)
end,
getTipText=function()
return e:GetNewMarketTipText(551)
end,
checkShowFunc=function()
return e:CheckNewMarketShow(551)
end
},
[20]={
clickHandler=function()
EventSystem.SendEvent(CommonEventId.OnClickNewMarketNotice,553)
end,
getTipText=function()
return e:GetNewMarketTipText(553)
end,
checkShowFunc=function()
return e:CheckNewMarketShow(553)
end
},
[21]={
clickHandler=function()
if PlayerMgr.PlayerInfo.guildId<=0 then
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildJoinListNewView)
return
end
if ModulesInit.FullServerBattleMgr.FSBInfo==nil then
ModulesInit.FullServerBattleMgr:getFSBState()
return
end
if ModulesInit.FullServerBattleMgr.FSBInfo.mapId==0 then
UIUtil.ShowCommonTipsForLocalize("fsb_unavailable_tips1")
return
end
ModulesInit.FullServerBattleMgr:enterFSBMap(ModulesInit.FullServerBattleMgr.FSBInfo.mapId)
end,
checkShowFunc=function()
if e:IsInLimitCfgTime(21)==false then
return false
end
if ModulesInit.FullServerBattleYearMgr:IsOpen()then
if ModulesInit.FullServerBattleMgr.FSBInfo~=nil and ModulesInit.FullServerBattleMgr.FSBInfo.isGuildJoinYear==true then
return false
end
end
return e:CanShowFSB(PROTO_ENUM.ENUM_FSB_STATUS.FSB_NORMAL_REVIEW)
end,
getTipText=function()
if ModulesInit.FullServerBattleMgr.FSBInfo==nil or ModulesInit.FullServerBattleMgr.FSBInfo.mapId==0 then
return GameTools.GetLocalize("fsb_unavailable_tips1")
end
local e=ModulesInit.MainPageLimitMgr:getLimitTimeCfgById(21)
return GameTools.GetLocalize(e.tipsDesc,LanguageCategory.LangCommon)
end,
getShowLimitIcon=function()
local t
local a=ModulesInit.FullServerBattleMgr.loginShowInfo
if a then
if a.cupType==1 then
t="UIMainInterface2/zhuye_yanchang1"
else
t="UIMainInterface2/zhuye_yanchang2"
end
return t
else
local e=e:getLimitTimeCfgById(21)
return e.showLimitIcon
end
end,
getTitleText=function()
local a
local t=ModulesInit.FullServerBattleMgr.loginShowInfo
if t then
if t.cupType==1 then
a="fsb_matchesbrave_brave"
else
a="fsb_matchesbrave_king"
end
return GameTools.GetLocalize(a,LanguageCategory.LangCommon,t.bigSeason,t.raceNum)
else
local e=e:getLimitTimeCfgById(21)
return GameTools.GetLocalize(e.pageName,LanguageCategory.LangCommon)
end
end
},
[22]={
clickHandler=function()
if PlayerMgr.PlayerInfo.guildId<=0 then
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildJoinListNewView)
return
end
if ModulesInit.FullServerBattleMgr.FSBInfo==nil then
ModulesInit.FullServerBattleMgr:getFSBState()
return
end
if ModulesInit.FullServerBattleMgr.FSBInfo.mapId==0 then
UIUtil.ShowCommonTipsForLocalize("fsb_unavailable_tips1")
return
end
ModulesInit.FullServerBattleMgr:enterFSBMap(ModulesInit.FullServerBattleMgr.FSBInfo.mapId)
end,
checkShowFunc=function()
if e:IsInLimitCfgTime(22)==false then
return false
end
if ModulesInit.FullServerBattleYearMgr:IsOpen()then
if ModulesInit.FullServerBattleMgr.FSBInfo~=nil and ModulesInit.FullServerBattleMgr.FSBInfo.isGuildJoinYear==true then
return false
end
end
return e:CanShowFSB(PROTO_ENUM.ENUM_FSB_STATUS.FSB_NORMAL_RUNNING)
end,
getShowLimitIcon=function()
local t
local a=ModulesInit.FullServerBattleMgr.loginShowInfo
if a then
if a.cupType==1 then
t="UIMainInterface2/zhuye_yanchang1"
else
t="UIMainInterface2/zhuye_yanchang2"
end
return t
else
local e=e:getLimitTimeCfgById(21)
return e.showLimitIcon
end
end,
getTipText=function()
if ModulesInit.FullServerBattleMgr.FSBInfo==nil or ModulesInit.FullServerBattleMgr.FSBInfo.mapId==0 then
return GameTools.GetLocalize("fsb_unavailable_tips1")
end
local e=ModulesInit.MainPageLimitMgr:getLimitTimeCfgById(22)
return GameTools.GetLocalize(e.tipsDesc,LanguageCategory.LangCommon)
end,
getTitleText=function()
local a
local t=ModulesInit.FullServerBattleMgr.loginShowInfo
if t then
if t.cupType==1 then
a="fsb_matchesbrave_brave"
else
a="fsb_matchesbrave_king"
end
return GameTools.GetLocalize(a,LanguageCategory.LangCommon,t.bigSeason,t.raceNum)
else
local e=e:getLimitTimeCfgById(22)
return GameTools.GetLocalize(e.pageName,LanguageCategory.LangCommon)
end
end
},
[23]={
clickHandler=function()
e:ClickGreatBossHandler()
end,
checkShowFunc=function()
if ModulesInit.GreatBossMgr:GreatBossIsOpen()==false then
return false
end
local e=TimeUtil.GetServerToDHMS()
local t=e.hour*3600+e.minute*60
local e=ModulesInit.MainPageLimitMgr:getLimitTimeCfgById(23)
local e=e.showTime[1]*3600+e.showTime[2]*60
if t<e then
return true
end
return false
end,
},
[24]={
clickHandler=function()
e:ClickGreatBossHandler()
end,
checkShowFunc=function()
if ModulesInit.GreatBossMgr:GreatBossIsOpen()==false then
return false
end
if e:IsInLimitCfgTime(24)then
return true
end
return false
end,
},
[25]={
clickHandler=function()
e:ClickGreatBossHandler()
end,
checkShowFunc=function()
if ModulesInit.GreatBossMgr:GreatBossIsOpen()==false then
return false
end
if e:IsInLimitCfgTime(25)then
return true
end
return false
end,
},
[26]={
clickHandler=function()
ModulesInit.WarOfAttritionMgr:OnEnterMainUI()
end,
},
[27]={
clickHandler=function()
ModulesInit.WarOfAttritionMgr:OnEnterMainUI()
end,
},
}
function e:InitData()
e.mMainActivityShowLimitList=e:CreateShowLimitPageData()
end
function e:IsInLimitCfgTime(a)
local e=TimeUtil.GetServerToDHMS()
local t=e.hour*3600+e.minute*60
local e=ModulesInit.MainPageLimitMgr:getLimitTimeCfgById(a)
if ModulesInit.MainPageLimitMgr:CheckLimitCfg(e,t)then
return true
end
return false
end
function e:getLimitTimeCfg()
local e=o.GetList()
return e
end
function e:getLimitTimeCfgById(e)
local e=o.GetEntity(e)
return e
end
function e:getActivityJumpCfg()
local e=i.GetList()
return e
end
function e:getActivityJumpCfgById(e)
local e=i.GetEntity(e)
return e
end
function e:CreateShowLimitPageData()
local t=e:getLimitTimeCfg()
local t=table.deepCopy(t)
table.sort(t,function(e,t)
if e.sortid~=t.sortid then
return e.sortid>t.sortid
end
return e.id<t.id
end)
local i={}
for a=1,#t do
local o={
cfgData=t[a],
isUnlock=false
}
if e:CheckLimitPageUnlock(t[a])then
o.isUnlock=true
end
table.insert(i,o)
end
return i
end
function e:CheckLimitPageUnlock(e)
if e.funcId<=0 or GameFunction.IsFunctionUnLock(e.funcId)then
if e.mapId<=0 or ModulesInit.ExpeditionManager:MapIsThrough(e.mapId)then
return true
end
end
return false
end
function e:CheckLimitPageShow(a,o)
if a==nil then
return false
end
local t=a.cfgData
if a.isUnlock==true or e:CheckLimitPageUnlock(t)then
a.isUnlock=true
if self.EShowLimitData[t.id]and self.EShowLimitData[t.id].checkShowFunc then
if self.EShowLimitData[t.id].checkShowFunc()then
return true
end
else
if self:CheckLimitCfg(t,o)then
return true
end
end
end
return false
end
function e:checkCanShowLimitPage()
local t=TimeUtil.GetServerToDHMS()
local o=t.hour*3600+t.minute*60
local t=self.mMainActivityShowLimitDelayTime-TimeUtil.GetServerTimeStamp()
if t>0 then
local t=e.mMainActivityShowLimitList[e.mMainActivityShowLimitIndex]
if e:CheckLimitPageShow(t,o)then
return t.cfgData.showPageIndex,t.cfgData.id
end
end
local i=tonumber(n.GetEntity("Main.Jump.delay").data)
local a=#e.mMainActivityShowLimitList
for t=1,a do
local t=e.mMainActivityShowLimitIndex+t
if t>a then
t=t-a
end
local a=e.mMainActivityShowLimitList[t]
if e:CheckLimitPageShow(a,o)then
self.mMainActivityShowLimitDelayTime=TimeUtil.GetServerTimeStamp()+i
e.mMainActivityShowLimitIndex=t
return a.cfgData.showPageIndex,a.cfgData.id
end
end
return nil
end
function e:CheckLimitCfg(e,t)
local a=e.showTime[1]*3600+e.showTime[2]*60
local e=e.closeTime[1]*3600+e.closeTime[2]*60
if e<a then
if t>=a or t<e then
return true
end
else
if t>=a and t<e then
return true
end
end
return false
end
function e:checkCanShowActJumpPage()
local t=self.mMainActivityJumpDelayTime-TimeUtil.GetServerTimeStamp()
if self.mMainActivityJumpDelayTime~=0 and t>0 then
local e=e:GetCanMainActivityJump()
if e and ActMgr:IsOpen(e.activityId)then
return e
end
end
local t=e:getActivityJumpCfg()
local a=table.deepCopy(t)
table.sort(a,function(e,t)
local a=ActMgr:IsOpen(e.activityId)and 1 or 0
local o=ActMgr:IsOpen(t.activityId)and 1 or 0
if a==1 and o==1 then
local a=ActMgr:GetActServerData(e.activityId)
local o=ActMgr:GetActServerData(t.activityId)
if a.openSecond~=o.openSecond then
return a.openSecond>o.openSecond
else
return e.order<t.order
end
else
if a~=o then
return a>o
else
return e.order<t.order
end
end
end)
self.mMainActivityJumpList=a
self.mMainActivityJumpDelayTime=TimeUtil.GetServerTimeStamp()+tonumber(n.GetEntity("Main.Jump.delay").data)
return e:GetShowActJump(a)
end
function e:GetCanMainActivityJump()
return self.mMainActivityJumpList[self.mMainActivityJumpIndex]
end
function e:GetShowActJump(e)
if#e<=self.mMainActivityJumpIndex then
self.mMainActivityJumpIndex=0
elseif self.mMainActivityJumpIndex<0 then
self.mMainActivityJumpIndex=0
end
for t=self.mMainActivityJumpIndex+1,#e do
local e=e[t]
if ActMgr:IsOpen(e.activityId)then
self.mMainActivityJumpIndex=t
return e
end
end
for t=1,#e do
local e=e[t]
if ActMgr:IsOpen(e.activityId)then
self.mMainActivityJumpIndex=t
return e
end
end
return nil
end
function e:GetLimitTipText(e)
if self.EShowLimitData[e.id]and self.EShowLimitData[e.id].getTipText then
return self.EShowLimitData[e.id].getTipText()
else
return GameTools.GetLocalize(e.tipsDesc,LanguageCategory.LangCommon)
end
end
function e:GetLimitTitleText(e)
if self.EShowLimitData[e.id]and self.EShowLimitData[e.id].getTitleText then
return self.EShowLimitData[e.id].getTitleText()
else
return GameTools.GetLocalize(e.pageName,LanguageCategory.LangCommon)
end
end
function e:GetLimitWanfaImg(e)
if self.EShowLimitData[e.id]and self.EShowLimitData[e.id].getShowLimitIcon then
return self.EShowLimitData[e.id].getShowLimitIcon()
else
return e.showLimitIcon
end
end
function e:LimitClickHandler(e)
if self.EShowLimitData[e]and self.EShowLimitData[e].clickHandler then
return self.EShowLimitData[e].clickHandler()
end
end
function e:GetNewMarketTipText(e)
local t=ModulesInit.ActNewMarketNoticeMgr:GetNewMarketNoticeCfg(e)
local e=ModulesInit.ActNewMarketNoticeMgr:GetNewMarketOpenTime(e)
local e=TimeUtil.timeStampToMD(e)
return GameTools.GetLocalize(t.noticeTips,LanguageCategory.LangCommon,e)
end
function e:GetSkyCityTipText(e)
local e=ModulesInit.MainPageLimitMgr:getLimitTimeCfgById(e)
local e=GameTools.GetLocalize(e.tipsDesc,LanguageCategory.LangCommon)
if PlayerMgr.PlayerInfo.guildId and PlayerMgr.PlayerInfo.guildId>0 then
if PlayerMgr.openServerDay<=tonumber(Constant.citywar_unlockDay)then
local t=(tonumber(Constant.citywar_unlockDay)+1)-PlayerMgr.openServerDay
e=GameTools.GetLocalize("sky_city_new_desc_6",LanguageCategory.LangCommon,t)
end
if ModulesInit.SkyCityMgr.skyBattleOpenStatus then
if RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.GVG_DECLARE_NOT_DISPATCH)then
if PlayerMgr.PlayerInfo.guildPos==PROTO_ENUM.ENUM_MEM_POSITION.MEM_LEADER_DEPUTY or
PlayerMgr.PlayerInfo.guildPos==PROTO_ENUM.ENUM_MEM_POSITION.MEM_LEADER then
e="<color=#d32a2a>"..GameTools.GetLocalize("ui_new_main_tips16").."</color>"
end
elseif RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.GVG_DECLARE_DISPATCH)then
if PlayerMgr.PlayerInfo.guildPos==PROTO_ENUM.ENUM_MEM_POSITION.MEM_LEADER_DEPUTY or
PlayerMgr.PlayerInfo.guildPos==PROTO_ENUM.ENUM_MEM_POSITION.MEM_LEADER then
e="<color=#d32a2a>"..GameTools.GetLocalize("ui_new_main_tips16").."</color>"
else
e=GameTools.GetLocalize("ui_new_main_tips14")
end
elseif RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.GVG_NOT_DECLARE_DISPATCH)then
e=GameTools.GetLocalize("ui_new_main_tips14")
elseif RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.GVG_DISPATCH)then
e=GameTools.GetLocalize("ui_new_main_tips14")
end
end
end
return e
end
function e:CheckNewMarketShow(e)
if not ActMgr:IsOpen(e)then
return false
end
local t=ModulesInit.ActNewMarketNoticeMgr:GetNewMarketOpenTime(e)
local a=TimeUtil.GetServerTimeStamp()
if a>=t then
return false
end
local t=TimeUtil.GetServerToDHMS().day
local e=SaveMgr.GetStringByAccServerId("ACT_"..e.."_NOTICE")
local e=t~=tonumber(e)
if not e then
return false
end
return true
end
function e:ClickDragonHandler()
if GameFunction.IsFunctionUnLock(GameFunctionType.Guild,true)then
if PlayerMgr.PlayerInfo.guildId<=0 then
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildJoinListNewView)
return
end
ModulesInit.DragonBoatMgr:EnterView()
end
end
function e:ClickGreatBossHandler()
if GameFunction.IsFunctionUnLock(GameFunctionType.Guild,true)then
if PlayerMgr.PlayerInfo.guildId<=0 then
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildJoinListNewView)
return
end
ModulesInit.GreatBossMgr:ClickEnterGame()
end
end
function e:ClickSkyCityHandler()
if ModulesInit.SkyCityMgr.skyState and ModulesInit.SkyCityMgr.skyState.status and ModulesInit.SkyCityMgr.skyState.status==PROTO_ENUM.ENUM_GVG_STATUS.GVG_STATUS_NOT_OPEN then
GameEntry.UI:OpenUIForm(UIFormId.UI_SkyCityNoOpenQualify)
else
local e=GameEntry.UI:IsExists(UIFormId.UI_SkyCityRoot)
if e then
else
ModulesInit.SkyCityMgr:EnterSkyCity(nil,{from=UIFormId.UI_MainPage})
end
end
end
function e:ClickFlowerHandler()
if not GameFunction.IsFunctionUnLock(GameFunctionType.Flower,true)then
return
end
ModulesInit.PhotoArtistMgr:setRedStatusSaveID(ModulesInit.PhotoArtistMgr.FirstUI.FlowerFight)
if self.mFlowerServerInfo==nil then
UIUtil.ShowCommonTips(GameTools.GetLocalize("flowerFight_68",LanguageCategory.LangCommon))
return
end
if self.mFlowerServerInfo.upgrade==true then
UIUtil.ShowCommonTips(GameTools.GetLocalize("flowerFight_105",LanguageCategory.LangCommon))
return
end
if self.mFlowerRaceInfo==nil then
UIUtil.ShowCommonTips(GameTools.GetLocalize("flowerFight_68",LanguageCategory.LangCommon))
return
end
if self.mFlowerRaceInfo.state==PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_NONE then
if self.mFlowerServerInfo.openTime then
local e=self.mFlowerServerInfo.openTime-TimeUtil:GetServerTimeStamp()
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
if self.mFlowerRaceInfo.state==PROTO_ENUM.ENUM_FLOWER_FIGHT_STATE.FLOWER_FIGHT_STAGE_SIGN
and not self.mFlowerRaceInfo.isSign
and not self.mFlowerRaceInfo.signMax then
ModulesInit.FlowerFightMgr:ReqFlowerSign(function()
self.mFlowerRaceInfo.isSign=true
UIUtil.ShowCommonTips(GameTools.GetLocalize("flowerFight_106",LanguageCategory.LangCommon,leftDayStr))
self:EnterFlowerView({from=UIFormId.UI_MainPage})
end)
else
self:EnterFlowerView()
end
end
end
function e:EnterFlowerView()
local e={
isSign=self.mFlowerRaceInfo.isSign,
stage=self.mFlowerRaceInfo.stage,
fromFlowerEntrance=false,
state=self.mFlowerRaceInfo.state,
selfMaxType=self.mFlowerRaceInfo.selfMaxType,
serverType=self.mFlowerServerInfo.serverType,
serverCount=self.mFlowerServerInfo.serverCount,
}
ModulesInit.FlowerFightMgr:EnterFlower(e)
end
function e:CanShowFSB(e)
if ModulesInit.FullServerBattleMgr.fsbShowStatus==nil then
return false
end
if ModulesInit.FullServerBattleMgr.fsbShowStatus~=e then
return false
end
return true
end
return e 
