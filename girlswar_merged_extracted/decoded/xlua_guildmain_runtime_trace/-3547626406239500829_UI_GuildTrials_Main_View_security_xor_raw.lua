local e=ModulesInit.GuildTrialsMgr
local s=0
local a=nil
local m=nil
local i=0
local n=0
local o=0
local f=0
local w=0
local t=nil
local u={}
local l={}
local r={}
local h={}
local c={
{"UIGuildTrials/guildTrials_common_pic_ptd","UIGuildTrials/guildTrials_msz_pt"},
{"UIGuildTrials/guildTrials_common_pic_sld","UIGuildTrials/guildTrials_msz_sl"}
}
local d=nil
function OnInit(t,t)
btn_close.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildTrials_Main_View)
end)
btn_help.onClick:AddListener(function()
GameEntry.UI:OpenUIForm(UIFormId.UI_Help,{helpId="guildTrials"})
end)
buzhenBtn.onClick:AddListener(function()
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildTrials_EmBattle_View)
end)
shilianBoxBtn.onClick:AddListener(function()
local e=e:reqGuildTrialsMapBox()
if e then
e.onCompleted=function(e,e)
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildTrials_DrillBox_View,{})
end
end
end)
zhanbaoBtn.onClick:AddListener(function()
local e=e:reqGuildTrialsFightRecord()
e.onCompleted=function(t,e)
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildTrials_BattleRecode_View,{records=e.records})
end
end)
rankBtn.onClick:AddListener(function()
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildTrials_Rank_View)
end)
rewardBtn.onClick:AddListener(function()
local e=e:ReqGuildTrialsInfo()
e.onCompleted=function(e,e)
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildTrials_PassAward_View)
end
end)
jiuyuanlingBtn.onClick:AddListener(function()
local e=e:reqGuildTrialsHelpList()
if e then
e.onCompleted=function(t,e)
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildTrials_RescueOrder_View,{
helpList=e.helpList,
giveHelpCount=e.giveHelpCount,
giveHelpTotalCount=e.giveHelpTotalCount,
})
end
end
end)
tip1_searchEventBtn.onClick:AddListener(function()
ShowBuffView(true)
end)
btn_buff_close.onClick:AddListener(function()
ShowBuffView(false)
end)
end
function OnOpen(a)
a=a or{}
if not ModulesInit.GuideMgr.isGuide then
LuaUtils.SetLocalPos(btn_close.transform,0,0,0)
end
EventSystem.AddListener(CommonEventId.OnRespGuildTrialsInfo,OnRespGuildTrialsInfo)
EventSystem.AddListener(SysEventId.OnUpdate,OnUpdate)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.AddListener(CommonEventId.RedPointInfoChange,RedPointInfoChange)
EventSystem.AddListener(CommonEventId.OnEventRespError,OnEventRespError)
EventSystem.AddListener(CommonEventId.OnGuildLeave,OnGuildLeave)
EventSystem.AddListener(CommonEventId.NewDay,OnEventNewDay)
OnRespGuildTrialsInfo()
EventSystem.SendEvent(CommonEventId.PlayLoadingCloudAni)
StopDelaySequence()
local t=CS.DG.Tweening.DOTween.Sequence()
t:AppendInterval(0.6)
t:AppendCallback(function()
if ModulesInit.GuideMgr.isGuide then
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="OPEN_GUILDTRIARLSMAIN_SUC"})
end
CheckShowDayTip()
end)
d=t
if a.reqInfo==true then
e:ReqGuildTrialsInfo()
end
end
function OnClose()
DestroySpine()
s=0
a=nil
m=nil
i=0
n=0
o=0
f=0
w=0
t=nil
u={}
l={}
r={}
h={}
EventSystem.RemoveListener(CommonEventId.OnRespGuildTrialsInfo,OnRespGuildTrialsInfo)
EventSystem.RemoveListener(SysEventId.OnUpdate,OnUpdate)
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.RemoveListener(CommonEventId.RedPointInfoChange,RedPointInfoChange)
EventSystem.RemoveListener(CommonEventId.OnEventRespError,OnEventRespError)
EventSystem.RemoveListener(CommonEventId.OnGuildLeave,OnGuildLeave)
EventSystem.RemoveListener(CommonEventId.NewDay,OnEventNewDay)
StopDelaySequence()
end
function OnBeforeDestroy()
end
function OnEventNewDay()
if PlayerMgr.PlayerInfo.guildId>0 then
e:ReqGuildTrialsInfo()
else
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Tips.16",LanguageCategory.LangCommon))
HandleGuildLeave()
end
end
function OnEventNetReconnectSuccess()
if PlayerMgr.PlayerInfo.guildId>0 then
e:ReqGuildTrialsInfo()
else
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Tips.16",LanguageCategory.LangCommon))
HandleGuildLeave()
end
end
function RedPointInfoChange()
LuaUtils.SetChildActive(shilianBoxBtn.transform,"red",false)
if RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.GUILD_TRIAL_BOX)then
LuaUtils.SetChildActive(shilianBoxBtn.transform,"red",true)
end
LuaUtils.SetChildActive(jiuyuanlingBtn.transform,"red",false)
if RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.GUILD_TRIAL_HELP)then
LuaUtils.SetChildActive(jiuyuanlingBtn.transform,"red",true)
end
LuaUtils.SetChildActive(rewardBtn.transform,"red",false)
if RedPointMgr:checkServerRedPoint(PROTO_ENUM.ENUM_REDPOINT_ID.GUILD_TRIAL_PASS)then
LuaUtils.SetChildActive(rewardBtn.transform,"red",true)
end
end
function OnEventRespError(t)
if t.errorCode==PROTO_ENUM.ErrCode.GUILD_NO_GUILD then
EventSystem.SendEvent(CommonEventId.OnSkipGuide2)
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.guild.Tips.16",LanguageCategory.LangCommon))
HandleGuildLeave()
elseif t.errorCode==PROTO_ENUM.ErrCode.GUILD_TRIAL_MAP_PASS then
if PlayerMgr.PlayerInfo.guildId>0 then
e:ReqGuildTrialsInfo()
end
end
end
function OnGuildLeave(e)
HandleGuildLeave()
end
function HandleGuildLeave()
UIUtil.CheckCloseUIForm(UIFormId.UI_GuildTrials_BattleRecode_View)
UIUtil.CheckCloseUIForm(UIFormId.UI_GuildTrials_DrillBox_View)
UIUtil.CheckCloseUIForm(UIFormId.UI_GuildTrials_EmBattle_View)
UIUtil.CheckCloseUIForm(UIFormId.UI_GuildTrials_MonsDesc_View)
UIUtil.CheckCloseUIForm(UIFormId.UI_GuildTrials_PassAward_View)
UIUtil.CheckCloseUIForm(UIFormId.UI_GuildTrials_Rank_View)
UIUtil.CheckCloseUIForm(UIFormId.UI_GuildTrials_RescueOrder_View)
UIUtil.CheckCloseUIForm(UIFormId.UI_GuildTrials_RescueRecode_View)
UIUtil.CheckCloseUIForm(UIFormId.UI_GuildTrials_SurePop_View)
UIUtil.CheckCloseUIForm(UIFormId.UI_GuildTrials_Main_View)
end
function OnRespGuildTrialsInfo()
Refresh()
end
function Refresh()
RefreshData()
RefreshView()
end
function RefreshData()
if a and a~=e.nextResetTime then
EventSystem.SendEvent(CommonEventId.OnSkipGuide2)
end
a=e.nextResetTime
local s=e.nextFightRecoverTime
m=(a<s)and a or s
if i~=0 and i~=e.stage then
EventSystem.SendEvent(CommonEventId.OnSkipGuide2)
h={}
end
i=e.stage
n=e.chapterDid
o=e.fightCount
f=e.fightTotalCount
w=e.maxChapterLv
r=e.mapTabs
t=e.effectEventDids
u,l=e:getTrialEventsDescTab(n)
CheckShowDayTip()
end
function RefreshView()
RefreshTipsView()
RefreshMonssView()
ShowBuffView(false)
RefreshBuffScrollView()
RedPointInfoChange()
end
function RefreshTipsView()
local a=e:getGuildTrialsById(n)
LuaUtils.SetTextMeshText(tip1_title1_txt,GameTools.GetLocalize(a.name,LanguageCategory.LangCommon))
LuaUtils.SetTextMeshText(tip1_trialsHard_txt,GameTools.GetLocalize("guildTrials_desc_5",LanguageCategory.LangCommon,a.lv))
local o=f-o
local e=e:GetGuildTrialsShowFightNum()
LuaUtils.SetTextMeshText(tip1_changeNum_txt,GameTools.GetLocalize("guildTrials_desc_6",LanguageCategory.LangCommon,o,e))
local t=#t
local e=#a.trialEvents
LuaUtils.SetActive(tip1_searchEventBtn.transform,false)
if e>0 and i>1 then
LuaUtils.SetActive(tip1_searchEventBtn.transform,true)
LuaUtils.SetTextMeshText(tip1_trialsEvent_txt,GameTools.GetLocalize("guildTrials_desc_9",LanguageCategory.LangCommon,t,e))
else
LuaUtils.SetTextMeshText(tip1_trialsEvent_txt,GameTools.GetLocalize("guildTrials_desc_9",LanguageCategory.LangCommon,0,0))
end
LuaUtils.SetTextMeshText(tip1_title2_txt,GameTools.GetLocalize("guildTrials_desc_4",LanguageCategory.LangCommon,i))
end
function RefreshMonssView()
local t=e:getGuildTrialsById(n)
local o={}
if i==1 then
o=t.stageOne
else
o=t.stageTwo
end
local t={[1]={}}
for a=1,5 do
if o[a]then
local e=e:getGuildTrialsMapsById(o[a])
local e=e.heroDid
table.add(t[1],tostring(e))
end
end
DynamicModuleRes.CheckResAndDownload(
t,
function()
for a=1,5 do
LuaUtils.SetActive(selfEnv["monsNode"..a].transform,false)
if o[a]then
LuaUtils.SetActive(selfEnv["monsNode"..a].transform,true)
local t=selfEnv["monsNode"..a].transform:Find("guideTrialsMonsNode")
local t=LuaUtils.GetLuaComBinder(t.transform)
local t=t:GetComponents()
local i=e:getGuildTrialsMapsById(o[a])
if i.isBoss==1 then
LuaUtils.SetImageSprite(t["monsDiImg"],c[2][1],false)
LuaUtils.SetImageSprite(t["monsTypeImg"],c[2][2],false)
else
LuaUtils.SetImageSprite(t["monsDiImg"],c[1][1],false)
LuaUtils.SetImageSprite(t["monsTypeImg"],c[1][2],false)
end
local n=false
if r[o[a]]then
local e=tonumber((r[o[a]].score/i.progress)*100)
if e>=100 then
n=true
LuaUtils.SetTextMeshText(t["mons_hurt_txt"],GameTools.GetLocalize("guildTrials_desc_8",LanguageCategory.LangCommon))
else
LuaUtils.SetTextMeshText(t["mons_hurt_txt"],GameTools.GetLocalize("guildTrials_desc_7",LanguageCategory.LangCommon,(math.floor(e).."%")))
end
else
LuaUtils.SetTextMeshText(t["mons_hurt_txt"],GameTools.GetLocalize("guildTrials_desc_7",LanguageCategory.LangCommon,"0%"))
end
if not h[a]then
h[a]=true
t["monsSelectBtn"].onClick:RemoveAllListeners()
t["monsSelectBtn"].onClick:AddListener(function()
if n and i.isBoss==0 then
UIUtil.ShowCommonTips(GameTools.GetLocalize("guildTrials_desc_50",LanguageCategory.LangCommon))
else
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildTrials_MonsDesc_View,{mapId=r[o[a]].mapId,mapDid=i.id})
end
end)
end
LuaUtils.DestroyChildren(t["monsterNode"])
UIUtil.GetUISmallSpinePool(i.heroDid,function(o,a,e)
local s={
}
UIUtil.HandlePoolUISmallRolePrefab(o,a,e,t["monsterNode"],s)
local o=a:GetComponent(typeof(CS.Spine.Unity.SkeletonGraphic))
local t=nil
if e then
t=a:GetComponent(typeof(CS.Spine.Unity.SkeletonGraphic))
end
if n and i.isBoss==0 then
UIUtil.SetSpineRenderGray(a,true)
o.AnimationState.TimeScale=0
if e then
UIUtil.SetSpineRenderGray(e,true)
t.AnimationState.TimeScale=0
end
else
UIUtil.SetSpineRenderGray(a,false)
o.AnimationState.TimeScale=1
if e then
UIUtil.SetSpineRenderGray(e,false)
t.AnimationState.TimeScale=1
end
end
end,
1)
end
end
end
)
end
function DestroySpine()
local t=e:getGuildTrialsById(n)
local e={}
if i==1 then
e=t.stageOne
else
e=t.stageTwo
end
for t=1,5 do
if e[t]then
local e=selfEnv["monsNode"..t].transform:Find("guideTrialsMonsNode")
local e=LuaUtils.GetLuaComBinder(e.transform)
local e=e:GetComponents()
local e=UIUtil.GetChild(e["monsterNode"],0)
if e then
UIUtil.SmallSpinePoolDespawn(e)
end
end
end
end
function OnUpdate()
s=s-Time.deltaTime
if s>0 then
return
end
s=1
local e=Time.deltaTime
UpdateFreeTime(e)
end
function UpdateFreeTime(t)
if a then
local t=a-TimeUtil.GetServerTimeStamp()
local a=m-TimeUtil.GetServerTimeStamp()
if t>0 then
LuaUtils.SetTextMeshText(text_reset_time,GameTools.GetLocalize("guildTrials_desc_3",LanguageCategory.LangCommon,TimeUtil.toDHMSStr2(t)))
else
h={}
end
if a<=0 then
e:ReqGuildTrialsInfo()
end
end
end
function ShowBuffView(e)
if e then
LuaUtils.SetActive(buffShowLayer.transform,true)
else
LuaUtils.SetActive(buffShowLayer.transform,false)
end
RefreshBuffScrollView()
end
function RefreshBuffScrollView()
function getCell(e)
local e=UIUtil.GetChild(grid.transform,e-1)
if not e then
e=LuaUtils.Instantiate(tran_buff_item.transform)
LuaUtils.SetParent(e.transform,grid.transform)
end
LuaUtils.SetActive(e.transform,true)
return e
end
LuaUtils.SetChildrenActive(grid.transform,false)
for a=1,#u do
local i=u[a]
local o=getCell(a)
local t=LuaUtils.GetLuaComBinder(o.transform)
local t=t:GetComponents()
local i=GameTools.GetLocalize(i,LanguageCategory.LangCommon).."\n"
LuaUtils.SetLabelText(t["text_itemname"],i)
if l[a]and e.effectEventDidMaps[l[a]]then
t["text_itemname"].color=Color(1,177/255,39/255,1)
else
t["text_itemname"].color=Color(72/255,61/255,54/255,1)
end
local e=t["text_itemname"].gameObject:GetComponent(typeof(CS.UnityEngine.UI.ContentSizeFitter))
e:SetLayoutVertical()
local e=o.gameObject:GetComponent(typeof(CS.UnityEngine.UI.ContentSizeFitter))
e:SetLayoutVertical()
LuaUtils.RebuildLayout(o.transform)
end
local e=grid.gameObject:GetComponent(typeof(CS.UnityEngine.UI.ContentSizeFitter))
e:SetLayoutVertical()
LuaUtils.RebuildLayout(grid.transform)
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end
function CheckShowDayTip()
if ModulesInit.GuideMgr.isGuide then
return
end
local t=SaveMgr.GetStringForKey("guild_trial_reset_time")
t=tonumber(t)
if t~=a then
SaveMgr.SetStringForKey("guild_trial_reset_time",a)
local t=""
if e.yesterdayChapterDid==0 then
t="guildTrials_desc_32"
else
if e.yesterdayPass then
t="guildTrials_desc_31"
else
t="guildTrials_desc_30"
end
end
local e=e:getGuildTrialsById(e.chapterDid)
local a=GameTools.GetLocalize(e.name,LanguageCategory.LangCommon)
local e={
titleName="guildTrials_desc_41",
text=GameTools.GetLocalize(t,LanguageCategory.LangCommon,UIUtil.GetRedTichText(a),UIUtil.GetRedTichText(e.lv)),
okBtnContent=GameTools.GetLocalize("UI.Campaign.StageSelect.25"),
buttons=MessageBoxButtons.OK,
onOkBtnClick=function()
end
}
UIUtil.ShowMessageBox(e)
end
end
function StopDelaySequence()
if d~=nil then
d:Kill()
d=nil
end
end

