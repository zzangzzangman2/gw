local o=require('DataNode/DataTable/Create/guild/DTGuildDBModel')
local n=require('DataNode/DataTable/Create/guild/DTGuildFrameDBModel')
local h=require('DataNode/DataTable/Create/guild/DTGuildGiftDBModel')
local s=require('DataNode/DataTable/Create/guild/DTGuildGiftinfoDBModel')
local i=require('DataNode/DataTable/Create/guild/DTGuildLogoDBModel')
local a=require('DataNode/DataTable/Create/guild/DTGuildTreasureDBModel')
local e={
}
e.EGuildNameError={
SAME_NAME=1,
VALID_CHAR=2,
EMPTY_NAME=3,
NAME_TOO_LANG=4,
ALREADY_YOUR_NAME=5,
CONSUME_NOT_ENOUGH=6,
HAVE_GUILD=7,
LEVEL_NOT_ENOUGH=8,
FIGHT_NOT_ENOUGH=9,
FULL_MEMBER=10,
FUNCTION_NOT_UNLOCK=11,
}
e.EGuildManageType={
CHANGE_NAME=1,
CHANGE_ICON=2,
MANAGE_APPLY=3,
EDIT_GUILD_MAIL=4,
SET_JOIN_CONDITON=5,
EDIT_GUILD_NOTICE=6,
EDIT_RECRUIT_NOTICE=7,
APPOINT_LEADER_DEPUTY=8,
REMOVE_LEADER_DEPUTY=9,
KICK_MEMBER=10,
LEADER_TRANSFER=11,
}
function e:Init()
e.guildInfo=nil
e.pos=PROTO_ENUM.ENUM_MEM_POSITION.MEM_NORMAL
e.availableSendMailTimestamp=0
e.quitCD=0
e.recruitCD=0
e.GuildNameMaxLength=Constant.guild_name_limit
e.GuildIdMaxLength=Constant.guild_find_limit
e.GuildFightCondMaxLength=Constant.guild_power_limit
e.GuildNoticeMaxLength=Constant.guild_notice_limit
e.GuildRecruitNoticeMaxLength=Constant.guild_recruit_limit
e.GuildMailMaxLength=Constant.guild_mail_limit
e.GuildMaxRankCount=Constant.rank_guild_show_num
e.isGuildGiftCharge=false
end
function e:Dispose()
e.guildInfo=nil
e.pos=PROTO_ENUM.ENUM_MEM_POSITION.MEM_NORMAL
e.availableSendMailTimestamp=0
e.quitCD=0
e.recruitCD=0
end
function e:synData(t)
e.guildInfo=t.guildInfo
e.pos=t.pos
e.availableSendMailTimestamp=t.availableSendMailTimestamp
e.quitCD=t.quitCD
e.recruitCD=t.sendRecruitMS
local e={
guildId=e.guildInfo.guildId,
guildName=e.guildInfo.name,
guildPos=e.pos,
}
PlayerMgr:syncGuildInfo(e)
EventSystem.SendEvent(CommonEventId.GuildInfoChange)
end
function e:synDataKickOnePlayer()
if e.guildInfo==nil then
return
end
e.guildInfo.curMemCount=e.guildInfo.curMemCount-1
EventSystem.SendEvent(CommonEventId.GuildInfoChange)
end
function e:synIconData(t)
if e.guildInfo==nil then
return
end
e.guildInfo.bg=t.bg
e.guildInfo.fg=t.fg
EventSystem.SendEvent(CommonEventId.GuildInfoChange)
EventSystem.SendEvent(CommonEventId.GuildRespChangeIcon,t)
end
function e:synLimitData(t)
if e.guildInfo==nil then
return
end
e.guildInfo.joinFightLimit=t.fight
e.guildInfo.joinNeedApprove=t.needApprove
EventSystem.SendEvent(CommonEventId.GuildInfoChange)
EventSystem.SendEvent(CommonEventId.OnEventGuildRespLimit,t)
end
function e:synNoticeData(t)
if e.guildInfo==nil then
return
end
e.guildInfo.notice=t.notice
EventSystem.SendEvent(CommonEventId.GuildInfoChange)
EventSystem.SendEvent(CommonEventId.OnGuildRespSetNotice,t)
end
function e:synRecruitNoticeData(t)
if e.guildInfo==nil then
return
end
e.guildInfo.recruitMsg=t.recruitMsg
EventSystem.SendEvent(CommonEventId.GuildInfoChange)
EventSystem.SendEvent(CommonEventId.OnGuildRespSetRecruitNotice,t)
end
function e:synGuildMailData(t)
if e.guildInfo==nil then
return
end
e.availableSendMailTimestamp=t.availableSendMailTimestamp
EventSystem.SendEvent(CommonEventId.GuildInfoChange)
EventSystem.SendEvent(CommonEventId.OnGuildRespMail,t)
end
function e:getGuildIconBg(e)
local e=n.GetEntity(e)
return'UIGuildIcon/'..tostring(e.frame)
end
function e:getGuildFg(e)
local e=i.GetEntity(e)
return'UIGuildIcon/'..tostring(e.icon)
end
function e:getAllGuildIcon()
local e=i.GetList()
table.sort(e,function(e,t)
return e.id<t.id
end)
return e
end
function e:getAllGuildIconBg()
local e=n.GetList()
table.sort(e,function(t,e)
return t.id<e.id
end)
return e
end
function e:getGuildNotice(e)
if e==""then
e=GameTools.GetLocalize("UI.guild.Manage.47",LanguageCategory.LangCommon)
end
return e
end
function e:getGuildRecruitNotice(e)
if e==""then
e=GameTools.GetLocalize("UI.guild.Manage.48",LanguageCategory.LangCommon)
end
return e
end
function e:getJoinGuildLeftTime()
return TimeUtil.toDHMSStr3(e.quitCD/1000)
end
function e:getGuildDataLevel(e)
local e=o.GetEntity(e)
return e
end
function e:getGuildMaxExpByLevel(e)
local e=o.GetEntity(e)
if e then
return e.exp
end
end
function e:getMaxLevel()
local e=o.GetList()
return#e
end
function e:getGuildGiftData(e)
return h.GetEntity(e)
end
function e:GuildGiftShowGiftTips()
if self.GuildGiftShowGiftId then
local t=self:getGuildGiftData(self.GuildGiftShowGiftId)
local e=string.len(t.giftIcon1)
local e=string.sub(t.giftIcon1,e-4,e)
local e=ModulesInit.BagManager:GetCfg(tonumber(e))
local e=GameTools.GetLocalize(e.itemName,LanguageCategory.LangItem)
local e=GameTools.GetLocalize("tips.common_buyTips",LanguageCategory.LangCommon,e)
self.GuildGiftShowGiftId=nil
return e
end
return
end
function e:getGuildGiftInfoData(a,t,e)
if t==0 then
local e=s.GetList()
for t,e in ipairs(e)do
if string.find(e.id,a.."_")==1 then
return e
end
end
else
local e=a.."_"..t
local t=s.GetEntity(e)
if t==nil then
GameInit.LogError("同盟充值宝箱表DTGuildGiftinfo未配置礼包id为："..e.."的宝箱")
end
return t
end
end
function e:CheckGuildGiftShwoName(e)
if ModulesInit.GuildMgr.GuildGiftChargeId==true then

local t=SaveMgr.GetBoolForKey("isShowedGuildGift",false)
if t==false then

UIUtil.ShowMessageBox({
onOkBtnClick=function()
local t={}
table.insert(t,{id=PROTO_ENUM.ENUM_SETTING_ID.SID_CLOSE_GUILD_GIFT_SHOW_NAME,value=0})
PlayerMgr:sendSetting(t)
e()
end,
onCancelBtnClick=function()
local t={}
table.insert(t,{id=PROTO_ENUM.ENUM_SETTING_ID.SID_CLOSE_GUILD_GIFT_SHOW_NAME,value=1})
PlayerMgr:sendSetting(t)
e()
end,
onBgBtnClick=function()
local t={}
table.insert(t,{id=PROTO_ENUM.ENUM_SETTING_ID.SID_CLOSE_GUILD_GIFT_SHOW_NAME,value=1})
PlayerMgr:sendSetting(t)
e()
end,
buttons=MessageBoxButtons.OKCancel,
cancelBtnContext=GameTools.GetLocalize("tips.common_107",LanguageCategory.LangCommon),
okBtnContent=GameTools.GetLocalize("tips.common_108",LanguageCategory.LangCommon),
text=GameTools.GetLocalize("tips.common_106",LanguageCategory.LangCommon),
}
)
else
e()
end
SaveMgr.SetBoolForKey("isShowedGuildGift",true)

else
e()
end
ModulesInit.GuildMgr.GuildGiftChargeId=false

end
function e:getGuildTreasureData(e)
return a.GetEntity(e)
end
function e:getGuildTreasureDataExp(t)
local e=e:gettGuildTreasureMaxLevel()
t=math.min(e,t)
local e=a.GetEntity(t)
return e and e.exp or 0
end
function e:isGuildTreasureMaxLevel(t)
local e=e:gettGuildTreasureMaxLevel()
return e==t
end
function e:getGuildTreasureNeedKey(t)
local e=e:gettGuildTreasureMaxLevel()
t=math.min(e,t)
local e=a.GetEntity(t)
return e and e.needKeys or 0
end
function e:gettGuildTreasureMaxLevel()
local e=a.GetList()
return#e
end
function e:isMaxLevel()
if e.guildInfo==nil then
return false
end
if e.guildInfo.level<e:getMaxLevel()then
return false
end
return true
end
function e:ShowGuildNameErrorTip(t)

if t==e.EGuildNameError.SAME_NAME then
elseif t==e.EGuildNameError.VALID_CHAR then
elseif t==e.EGuildNameError.EMPTY_NAME then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Creat.01"))
elseif t==e.EGuildNameError.NAME_TOO_LANG then
elseif t==e.EGuildNameError.ALREADY_YOUR_NAME then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Tips.17"))
elseif t==e.EGuildNameError.CONSUME_NOT_ENOUGH then
GameTools:GotoWays({id=PROTO_ENUM.ENUM_CURRENCY.HOLY_CRYSTAL})
elseif t==e.EGuildNameError.HAVE_GUILD then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Join.33"))
elseif t==e.EGuildNameError.LEVEL_NOT_ENOUGH then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Creat.03"))
elseif t==e.EGuildNameError.FIGHT_NOT_ENOUGH then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Join.12"))
elseif t==e.EGuildNameError.FULL_MEMBER then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Join.19",LanguageCategory.LangCommon))
elseif t==e.EGuildNameError.FUNCTION_NOT_UNLOCK then
UIUtil.ShowCommonTips(GameTools.GetLocalize("errCode"..tostring(SysCode.FUNCTION_NOT_UNLOCK),LanguageCategory.LangCommon))
end
end
function e:checkApplyGuild(t)
if PlayerMgr.PlayerInfo.guildId>0 then
return false,e.EGuildNameError.HAVE_GUILD
end
if t.curMemCount>=t.maxMemCount then
return false,e.EGuildNameError.FULL_MEMBER
end
local a=ModulesInit.FormationManager:GetFormationFightValue(PROTO_ENUM.FormationNO.FN_MAIN)
if a<t.joinFightLimit then
return false,e.EGuildNameError.FIGHT_NOT_ENOUGH
end
if GameFunction.IsFunctionUnLock(GameFunctionType.Guild,false)==false then
return false,e.EGuildNameError.FUNCTION_NOT_UNLOCK
end
return true
end
function e:checkCreateGuild(a,t)
if GameFunction.IsFunctionUnLock(GameFunctionType.Guild,false)==false then
return false,e.EGuildNameError.LEVEL_NOT_ENOUGH
end
if PlayerMgr.PlayerInfo.guildId>0 then
return false,e.EGuildNameError.HAVE_GUILD
end
local a,o=e:checkGuildNameValid(a)
if a==false then
return false,o
end
if PlayerMgr:getCurrencyCount(Constant.guild_create_diamond_expensive[1])<t then
return false,e.EGuildNameError.CONSUME_NOT_ENOUGH
end
return true
end
function e:checkShowManageBtn()
if PlayerMgr.PlayerInfo.guildPos==PROTO_ENUM.ENUM_MEM_POSITION.MEM_LEADER
or PlayerMgr.PlayerInfo.guildPos==PROTO_ENUM.ENUM_MEM_POSITION.MEM_LEADER_DEPUTY then
return true
end
return false
end
function e:checkCanManageGuild(t)
if t==e.EGuildManageType.CHANGE_NAME then
if PlayerMgr.PlayerInfo.guildPos==PROTO_ENUM.ENUM_MEM_POSITION.MEM_LEADER then
return true
end
elseif t==e.EGuildManageType.CHANGE_ICON then
if PlayerMgr.PlayerInfo.guildPos==PROTO_ENUM.ENUM_MEM_POSITION.MEM_LEADER then
return true
end
elseif t==e.EGuildManageType.MANAGE_APPLY then
if PlayerMgr.PlayerInfo.guildPos==PROTO_ENUM.ENUM_MEM_POSITION.MEM_LEADER
or PlayerMgr.PlayerInfo.guildPos==PROTO_ENUM.ENUM_MEM_POSITION.MEM_LEADER_DEPUTY then
return true
end
elseif t==e.EGuildManageType.EDIT_GUILD_MAIL then
if PlayerMgr.PlayerInfo.guildPos==PROTO_ENUM.ENUM_MEM_POSITION.MEM_LEADER
or PlayerMgr.PlayerInfo.guildPos==PROTO_ENUM.ENUM_MEM_POSITION.MEM_LEADER_DEPUTY then
return true
end
elseif t==e.EGuildManageType.SET_JOIN_CONDITON then
if PlayerMgr.PlayerInfo.guildPos==PROTO_ENUM.ENUM_MEM_POSITION.MEM_LEADER then
return true
end
elseif t==e.EGuildManageType.EDIT_GUILD_NOTICE then
if PlayerMgr.PlayerInfo.guildPos==PROTO_ENUM.ENUM_MEM_POSITION.MEM_LEADER
or PlayerMgr.PlayerInfo.guildPos==PROTO_ENUM.ENUM_MEM_POSITION.MEM_LEADER_DEPUTY then
return true
end
elseif t==e.EGuildManageType.EDIT_RECRUIT_NOTICE then
if PlayerMgr.PlayerInfo.guildPos==PROTO_ENUM.ENUM_MEM_POSITION.MEM_LEADER
or PlayerMgr.PlayerInfo.guildPos==PROTO_ENUM.ENUM_MEM_POSITION.MEM_LEADER_DEPUTY then
return true
end
elseif t==e.EGuildManageType.APPOINT_LEADER_DEPUTY then
if PlayerMgr.PlayerInfo.guildPos==PROTO_ENUM.ENUM_MEM_POSITION.MEM_LEADER then
return true
end
elseif t==e.EGuildManageType.REMOVE_LEADER_DEPUTY then
if PlayerMgr.PlayerInfo.guildPos==PROTO_ENUM.ENUM_MEM_POSITION.MEM_LEADER then
return true
end
elseif t==e.EGuildManageType.KICK_MEMBER then
if PlayerMgr.PlayerInfo.guildPos==PROTO_ENUM.ENUM_MEM_POSITION.MEM_LEADER then
return true
end
elseif t==e.EGuildManageType.LEADER_TRANSFER then
if PlayerMgr.PlayerInfo.guildPos==PROTO_ENUM.ENUM_MEM_POSITION.MEM_LEADER then
return true
end
end
return false
end
function e:checkChangeName(t)
local a,t=e:checkGuildNameValid(t)
if a==false then
return false,t
end
if PlayerMgr:getCurrencyCount(Constant.guild_rename_diamond[1])<Constant.guild_rename_diamond[2]then
return false,e.EGuildNameError.CONSUME_NOT_ENOUGH
end
return true
end
function e:checkGuildNameValid(t)
if t==""then
return false,e.EGuildNameError.EMPTY_NAME
end
if PlayerMgr.PlayerInfo.guildId>0 then
if t==PlayerMgr.PlayerInfo.guildName then
return false,e.EGuildNameError.ALREADY_YOUR_NAME
end
end
local a,t=string.str2List(t)
if t>e.GuildNameMaxLength then
return false,e.EGuildNameError.NAME_TOO_LANG
end
return true
end
function e:ReqCreateGuildConsume()
return NetManager.Send(ProtoId.PRT_GUILD_CREATE_CONSUME_REQ,{})
end
function e:ReqCreateGuild(e)
return NetManager.Send(ProtoId.PRT_GUILD_CREATE_REQ,e)
end
function e:ReqSearchGuild(e)
return NetManager.Send(ProtoId.PRT_GUILD_SEARCH_REQ,e)
end
function e:ReqGuildRecommandList(e)
local t=NetManager.SendEmpty(ProtoId.PRT_GUILD_RECOMMAND_REQ,true)
t.onCompleted=function(a,t)
if e then
e(t)
end
end
end
function e:ReqGuildRecommandAllList(t,e)
local t=NetManager.Send(ProtoId.PRT_GUILD_RECOMMAND_ALL_REQ,{recommandFull=t})
t.onCompleted=function(a,t)
if e then
e(t)
end
end
end
function e:ReqGuildRecommandRmdList(t,e)
local t=NetManager.Send(ProtoId.PRT_GUILD_RECOMMAND_RMD_REQ,{recommandFull=t})
t.onCompleted=function(a,t)
if e then
e(t)
end
end
end
function e:ReqGuildRecommandRankList(e,t)
NetManager.Send(ProtoId.PRT_GUILD_RECOMMAND_RANK_REQ,{rankPage=e})
end
function e:ReqGuildApply(e,t)
if t then
local e={
text=GameTools.GetLocalize("UI.guild.Tips.21",LanguageCategory.LangCommon),
buttons=MessageBoxButtons.OKCancel,
onOkBtnClick=function()
NetManager.Send(ProtoId.PRT_GUILD_APPLY_REQ,e)
end
}
UIUtil.ShowMessageBox(e)
else
NetManager.Send(ProtoId.PRT_GUILD_APPLY_REQ,e)
end
end
function e:ReqGuildEnter()
NetManager.SendEmpty(ProtoId.PRT_GUILD_ENTER_REQ)
end
function e:ReqGuildChangeName(e)
NetManager.Send(ProtoId.PRT_GUILD_MODIFY_NAME_REQ,e)
end
function e:ReqGuildChangeIcon(e)
NetManager.Send(ProtoId.PRT_GUILD_ICON_SET_REQ,e)
end
function e:ReqGuildJoinCond(e)
NetManager.Send(ProtoId.PRT_GUILD_APPLY_LIMIT_SET_REQ,e)
end
function e:ReqGuildSetNotice(e)
NetManager.Send(ProtoId.PRT_GUILD_NOTICE_SET_REQ,e)
end
function e:ReqGuildSetRecruitChatNotice(e)
return NetManager.Send(ProtoId.PRT_GUILD_SEND_RECRUIT_CHAT_REQ,e)
end
function e:ReqGuildSetRecruitNotice(e)
NetManager.Send(ProtoId.PRT_GUILD_SET_RECRUIT_REQ,e)
end
function e:ReqGuildSetMail(e)
NetManager.Send(ProtoId.PRT_GUILD_MAIL_REQ,e)
end
function e:ReqGuildApplyList(e)
NetManager.Send(ProtoId.PRT_GUILD_APPLY_LIST_REQ,e)
end
function e:ReqGuildApplyApprove(e)
NetManager.Send(ProtoId.PRT_GUILD_APPLY_APPROVE_REQ,e)
end
function e:ReqGuildMemberList()
NetManager.Send(ProtoId.PRT_GUILD_MEMBER_LIST_REQ,{})
end
function e:ReqGuildManage(e)
NetManager.Send(ProtoId.PRT_GUILD_MANAGE_REQ,e)
end
function e:ReqGuildRankList()
NetManager.Send(ProtoId.PRT_RANK_GUILD_LIST_REQ,{})
end
function e:ReqGuildGiftList(t,e)
NetManager.Send(ProtoId.PRT_GUILD_GIFT_REQ,t,nil,e)
end
function e:ReqGuildTreasureTimeOut()
NetManager.Send(ProtoId.PRT_GUILD_TRESURE_TIMEOUT_REQ,{})
end
function e:ReqGuildGiftAward(e)
NetManager.Send(ProtoId.PRT_GUILD_GIFT_AWARD_REQ,e)
end
function e:ReqGuildGiftBox()
NetManager.Send(ProtoId.PRT_GUILD_TREASURE_AWARD_REQ,{})
end
function e:ReqGuildGiftDelete()
NetManager.Send(ProtoId.PRT_GUILD_GIFT_REMOVE_REQ,{})
end
function e:ReqGuildNormalGiftAward()
NetManager.Send(ProtoId.PRT_GUILD_NORMAL_GIFT_AWARD_REQ,{})
end
function e:ReqGuildQuestInfo()
NetManager.Send(ProtoId.PRT_GUILD_QUEST_INFO_REQ,{})
end
function e:ReqGuildQuestWeekAward(e)
NetManager.Send(ProtoId.PRT_GUILD_WEEK_QUEST_AWARD_REQ,{questId=e})
end
function e:ReqGuildQuestAllAward(e)
NetManager.Send(ProtoId.PRT_GUILD_QUEST_AWARD_REQ,{questId=e})
end
function e:CheckNewShow(e)
return ModulesInit.PhotoArtistMgr:checkSaveID(e)and not SaveMgr.GetBoolForKey("main_guild_status_new_"..e,false)
end
function e:SetNewShow(e)
SaveMgr.SetBoolForKey("main_guild_status_new_"..e,true)
end
function e:CheckWarFightRed()
local e=TimeUtil.GetServerToDHMS().day
local t=SaveMgr.GetStringForKey("GuildCheckWarFightRed","")
return not(t==tostring(e))
end
function e:ClearWarFightRed()
if e:CheckWarFightRed()then
local e=TimeUtil.GetServerToDHMS().day
SaveMgr.SetStringForKey("GuildCheckWarFightRed",tostring(e))
RedPointMgr:doNotify()
end
end
return e 
