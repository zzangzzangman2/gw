local l=require("DataNode/DataTable/Create/constant/DTServerListDBModel")
local m=require("Modules/CSGuildWar/GuildWarBigMap")
local d=require("Common/ServiceSubscribe")
local c=require("Common/cs_coroutine")
local e=340
local e=nil
local u=nil
local s=nil
local o=nil
local a=nil
local t=nil
local n=nil
local i=nil
local h
local e=ModulesInit.CSGuildWarManager
local r=e:GetGuildWarDBCfg()
function OnInit(o,o)
i=m:New()
i:Init(map)
u={
[PROTO_ENUM.ENUM_GUILD_WAR_STATUS.PREPARE]=OnPrepareStage,
[PROTO_ENUM.ENUM_GUILD_WAR_STATUS.COLLECTION]=OnPrepareStage,
[PROTO_ENUM.ENUM_GUILD_WAR_STATUS.FIGHTING]=OnFightingStage,
[PROTO_ENUM.ENUM_GUILD_WAR_STATUS.STOP]=OnPublicityStage
}
btn_fanhui.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildWarBattleGround)
e:CloseMap()
e:ExitWarProcedure()
end)
btn_edit.onClick:AddListener(function()
DynamicModuleRes.EmbattlePrevDownLoad(false,nil,nil,nil,function()
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildWarEmbattleForDef)
end)
end)
report.onClick:AddListener(function()
local t=e:SendSeeBattleRecordRequest(a.battleGroundId)
t.onCompleted=function()
GameEntry.UI:OpenUIForm(UIFormId.UI_CSGuildWarRecord,{records=e.CurReqBattleRecord.records,isDef=false})
end
end)
local e=LuaUtils.GetLuaComBinder(node_mid)
t=e:GetComponents()
end
function OnOpen(e)
n={}
LuaUtils.SetActive(black,true)
i:Open()
d:startSub(
{
[PROTO_ENUM.ENUM_SERVICE_SUBSCRIBE_TYPE.SERVICE_GUILD_WAR_BATTLE_GROUND]={
callback=handler(
self,
function()
SetContent(function()
LuaUtils.SetActive(black,false)
end)
end
)
}
}
)
GameTools:SwitchBGMFadeOutLua(112)
EventSystem.AddListener(CommonEventId.GuildWarBattleInfoSync,OnGuildWarBattleInfoSync)
EventSystem.AddListener(CommonEventId.GuildWarStageSync,OnGuildWarStageSync)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
end
function SetContent(t)
s=e:GetGuildWarStage()
a=e.CurBattleInfo
SetGuildInfos()
SwitchStage()
UpdateTime()
UpdateBattleOrder()
UpdateReportInfo()
CloseMyCoroutine()
EventSystem.SendEvent(CommonEventId.ShowItemDelayTip,{overTime=TimeUtil.GetServerTimeStamp()+10,sourceType=PROTO_ENUM.ENUM_AWARD_SOURCE_TYPE.AST_BOX_WEEK_BOX})
h=i:CreateUnitViews(function()
t()
end)
end
function CloseMyCoroutine()
if h then
c.stop(h)
h=nil
end
end
function UpdateBattleOrder()
local e=e:SelfIsCanJoin()
if not e then
LuaUtils.SetActive(txt_chance.transform,false)
return
end
LuaUtils.SetActive(txt_chance.transform,true)
local e=r.attackTime-a.attCount
if e<0 then
e=0
end
if e==0 then
LuaUtils.SetLabelTextWrap(txt_chance,string.format('<color=red>%d/%d</color>',e,r.attackTime))
else
LuaUtils.SetLabelTextWrap(txt_chance,string.format('%d/%d',e,r.attackTime))
end
end
function SwitchStage()
local e=u[s]
if not e then
GameEntry.LogError('此阶段不能进入战场')
return
end
LuaUtils.SetActive(node_bye,false)
LuaUtils.SetActive(node_mid,false)
LuaUtils.SetActive(btn_edit.transform,false)
LuaUtils.SetActive(node_watch,false)
LuaUtils.SetActive(node_rightbot,false)
LuaUtils.SetActive(report.transform,false)
LuaUtils.SetActive(tip_4,false)
LuaUtils.SetChildActive(tip_4,'fail',false)
LuaUtils.SetChildActive(tip_4,'win',false)
LuaUtils.SetChildActive(tip_4,'no',false)
LuaUtils.SetActive(txt_time.transform,false)
e()
end
function OnPrepareStage()

if e:GuildIsBye()then
LuaUtils.SetActive(node_bye,true)
else
LuaUtils.SetActive(node_mid,true)
if s==PROTO_ENUM.ENUM_GUILD_WAR_STATUS.COLLECTION then
LuaUtils.SetActive(btn_edit.transform,false)
else
LuaUtils.SetActive(btn_edit.transform,true)
end
end
UIUtil.SetTextMeshTextForLocalize(txt_time_des,'UI.guildBattle.main2.23')
LuaUtils.SetActive(txt_time.transform,true)
if not e:SelfIsCanJoin()then
LuaUtils.SetActive(node_watch,true)
end
end
function OnFightingStage()

if e:GuildIsBye()then
LuaUtils.SetActive(node_bye,true)
else
LuaUtils.SetActive(node_mid,true)
LuaUtils.SetActive(node_rightbot,true)
LuaUtils.SetActive(report.transform,true)
end
UIUtil.SetTextMeshTextForLocalize(txt_time_des,'UI.guildBattle.main2.24')
LuaUtils.SetActive(txt_time.transform,true)
if not e:SelfIsCanJoin()then
LuaUtils.SetActive(node_watch,true)
end
end
function OnPublicityStage()

if e:GuildIsBye()then
LuaUtils.SetActive(node_bye,true)
else
LuaUtils.SetActive(node_mid,true)
LuaUtils.SetActive(tip_4,true)
end
local t=a.ownerInfo.guildInfo.grade>a.targetInfo.guildInfo.grade
if t then
LuaUtils.SetChildActive(tip_4,'win',true)
else
if a.ownerInfo.guildInfo.grade==a.targetInfo.guildInfo.grade then
LuaUtils.SetChildActive(tip_4,'no',true)
else
LuaUtils.SetChildActive(tip_4,'fail',true)
end
end
if not e:SelfIsCanJoin()then
LuaUtils.SetActive(node_watch,true)
LuaUtils.SetTextMeshText(txt_time_des,'')
LuaUtils.SetActive(txt_time.transform,false)
else
LuaUtils.SetTextMeshText(txt_time_des,'')
LuaUtils.SetActive(txt_time.transform,false)
end
end
function SetGuildInfos()
local o=a.ownerInfo
local e=l.GetEntity(o.guildInfo.serverId)
LuaUtils.SetTextMeshText(t['txt_power_1'],o.guildInfo.grade)
GameTools:SetImageSprite(t['im_guild_icon_1'],ModulesInit.GuildMgr:getGuildFg(o.guildInfo.fg))
if e then
local e="S"..e.id
LuaUtils.SetLabelTextWrap(t['txt_sever1'],e)
else
LuaUtils.SetLabelTextWrap(t['txt_sever1'],'')
end
LuaUtils.SetTextMeshText(t['txt_sever_name1'],o.guildInfo.name)
local e=a.targetInfo
local a=l.GetEntity(e.guildInfo.serverId)
LuaUtils.SetTextMeshText(t['txt_power_2'],e.guildInfo.grade)
GameTools:SetImageSprite(t['im_guild_icon_2'],ModulesInit.GuildMgr:getGuildFg(e.guildInfo.fg))
if a then
local e="S"..a.id
LuaUtils.SetLabelTextWrap(t['txt_sever2'],e)
else
LuaUtils.SetLabelTextWrap(t['txt_sever2'],'')
end
LuaUtils.SetTextMeshText(t['txt_sever_name2'],e.guildInfo.name)
local t=0
if e then
t=e.guildInfo.grade
end
SetBattleScoreSliderBar(o.guildInfo.grade,t)
end
function SetBattleScoreSliderBar(e,a)
LuaUtils.SetTextMeshText(t["txt_power_1"],e)
LuaUtils.SetTextMeshText(t["txt_power_2"],a)
if e==0 and a==0 then
LuaUtils.SetImageFillAmount(t["slider_bar"],0.5)
else
local a=e+a
local a=e/a
local e=a
LuaUtils.SetImageFillAmount(t["slider_bar"],e)
local o=-(711/2)
local a=o+711*a
LuaUtils.SetRectTransformPos(t["slider_move"],a,0,0)
if e==0 or e==1 then
LuaUtils.SetActive(t["slider_move"].transform,false)
else
LuaUtils.SetActive(t["slider_move"].transform,true)
end
end
end
function UpdateReportInfo()
local t=LuaUtils.GetLuaComBinder(report.transform)
local o=t:GetComponents()
LuaUtils.SetChildrenActive(o['grid'],false)
for t=1,#a.records do
local a=a.records[t]
local t=UIUtil.GetChild(o['grid'],t-1)
LuaUtils.SetActive(t,true)
local o=t:Find('im_tag1')
local i=t:Find('im_tag2')
local e=a.attGuildId==e.CurReqBattleGroundInfo.ownerGuildInfo.guildId
if e then
LuaUtils.SetChildLabelText(t,'txt_1',string.format('<color=#598CF1>%s</color>',a.attPlayer.name))
LuaUtils.SetChildLabelText(t,'txt_2',string.format('<color=#DA324C>%s</color>',a.defPlayer.name))
else
LuaUtils.SetChildLabelText(t,'txt_1',string.format('<color=#DA324C>%s</color>',a.attPlayer.name))
LuaUtils.SetChildLabelText(t,'txt_2',string.format('<color=#598CF1>%s</color>',a.defPlayer.name))
end
if e then
LuaUtils.SetChildLabelTextMeshText(t,'txt_power',string.format('<color=#598CF1>+ %d</color>',a.score))
LuaUtils.SetActive(o,true)
LuaUtils.SetActive(i,false)
else
LuaUtils.SetChildLabelTextMeshText(t,'txt_power',string.format('<color=#DA324C>+ %d</color>',a.score))
LuaUtils.SetActive(o,false)
LuaUtils.SetActive(i,true)
end
end
end
function SeekEnemy()
if#a.targetInfo.players==0 then
return
end
local e=nil
local t=nil
for a,e in pairs(a.ownerInfo.players)do
if e.playerId==PlayerMgr.PlayerInfo.uid then
t=e
end
end
local a=table.deepCopy(a.targetInfo.players)
table.sort(a,function(t,e)
return t.fight<e.fight
end)
local o=0
local s=0
for a,e in pairs(a)do
if e.fight<=t.fight then
o=o+1
else
s=s+1
end
end
local t=function(o)
for a,e in pairs(a)do
if not n[e.playerId]then
if o then
if e.fight<=t.fight then
return e
end
else
if e.fight>t.fight then
return e
end
end
end
end
return nil
end
e=t(true)
if e then
n[e.playerId]=e
else
e=t(false)
if e then
n[e.playerId]=e
else
n={}
e=SeekEnemy()
end
end

if e then
i:SelectUnit(e)
end
return e
end
function UpdateTime()
if o then
o:Stop()
o=nil
end
local e=e:GetGuildWarCountDown()

o=ModulesInit.TimeActionMgr:CreateTimeAction()
o:Init(
0,
1,
e,
nil,
function(e)
LuaUtils.SetTextMeshText(txt_time,TimeUtil.toDHMSStr2(e))
end,
nil
):Run()
end
function OnGuildWarBattleInfoSync()
a=e.CurBattleInfo
i:OnGuildWarBattleInfoSync()
UpdateReportInfo()
end
function OnGuildWarStageSync()
s=e:GetGuildWarStage()
SwitchStage()
UpdateTime()
i:OnGuildWarStageSync()
end
function OnEventNetReconnectSuccess()
local t=e:SendGuildWarStatusInfoRequest()
t.onCompleted=function()
GameTools.CloseUIForm(UIFormId.UI_GuildWarBattleGround)
e:CloseMap()
e:ExitWarProcedure()
end
end
function OnClose()
CloseMyCoroutine()
if o then
o:Stop()
o=nil
end
i:Close()
EventSystem.RemoveListener(CommonEventId.GuildWarBattleInfoSync,OnGuildWarBattleInfoSync)
EventSystem.RemoveListener(CommonEventId.GuildWarStageSync,OnGuildWarStageSync)
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
d:endSub({PROTO_ENUM.ENUM_SERVICE_SUBSCRIBE_TYPE.SERVICE_GUILD_WAR_BATTLE_GROUND})
end
local t=nil
function TriggleStep()
if t==nil then
t=e:GetGuildWarStage()
end
t=t+1
if t>5 then
t=1
end
s=t
SwitchStage()
UpdateTime()
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

