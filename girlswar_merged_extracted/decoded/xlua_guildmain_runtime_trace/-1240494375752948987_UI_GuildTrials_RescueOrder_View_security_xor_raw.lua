local e=ModulesInit.GuildTrialsMgr
local t={}
local i=0
local o=0
local n=nil
local s=0
function OnInit(t,t)
Image.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildTrials_RescueOrder_View)
end)
btn_jiuyuanJilu.onClick:AddListener(function()
local e=e:reqGuildTrialsHelpRecord()
e.onCompleted=function(t,e)
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildTrials_RescueRecode_View,{recoreds=e.recoreds})
end
end)
ScrollView:InitListView(0,OnGetItemByIndex)
end
function OnOpen(t)
EventSystem.AddListener(CommonEventId.OnRespGuildTrialsHelpList,OnRespGuildTrialsHelpList)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.AddListener(CommonEventId.OnRespGuildTrialsSendHelp,OnRespGuildTrialsSendHelp)
EventSystem.AddListener(CommonEventId.OnEventRespError,OnEventRespError)
EventSystem.AddListener(CommonEventId.OnRespGuildTrialsInfo,OnRespGuildTrialsInfo)
EventSystem.AddListener(SysEventId.OnUpdate,OnUpdate)
SortHelpList(t.helpList)
i=t.giveHelpCount
o=t.giveHelpTotalCount
n=e.nextFightRecoverTime
Refresh(true)
end
function SortHelpList(a)
t={}
local o=e:getGuildTrialsBaseCfg().receivedNum
for e=1,#a do
local e=a[e]
if e.time<=0 then
e.sortTime=1
else
e.sortTime=0
end
if e.count<o then
e.sortCount=1
else
e.sortCount=0
end
table.insert(t,e)
end
if next(t)then
table.sort(t,function(t,e)
if t.sortTime==e.sortTime then
if t.sortCount==e.sortCount then
return t.fight>e.fight
end
return t.sortCount>e.sortCount
end
return t.sortTime>e.sortTime
end)
end
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnRespGuildTrialsHelpList,OnRespGuildTrialsHelpList)
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.RemoveListener(CommonEventId.OnRespGuildTrialsSendHelp,OnRespGuildTrialsSendHelp)
EventSystem.RemoveListener(CommonEventId.OnEventRespError,OnEventRespError)
EventSystem.RemoveListener(CommonEventId.OnRespGuildTrialsInfo,OnRespGuildTrialsInfo)
EventSystem.RemoveListener(SysEventId.OnUpdate,OnUpdate)
end
function OnRespGuildTrialsInfo()
n=e.nextFightRecoverTime
end
function OnEventRespError(t)
if t.errorCode==PROTO_ENUM.ErrCode.GUILD_TRIAL_HELP_NOT_SAME_GUILD then
e:reqGuildTrialsHelpList()
end
end
function OnEventNetReconnectSuccess()
e:reqGuildTrialsHelpList()
end
function OnRespGuildTrialsHelpList(e)
SortHelpList(e.helpList)
i=e.giveHelpCount
o=e.giveHelpTotalCount
Refresh()
end
function OnRespGuildTrialsSendHelp(e)
i=e.giveHelpCount
o=e.giveHelpTotalCount
for a=1,#t do
if t[a].playerId==e.playerId then
t[a]=e.help
break
end
end
SortHelpList(t)
Refresh()
if e and e.drops then
UIUtil.ShowAwardWithServerData(e.drops)
end
end
function Refresh(a)
local n=e:getGuildTrialsBaseCfg().rescueNum
local e=o-i
LuaUtils.SetLabelText(text_change_num_desc,GameTools.GetLocalize("guildTrials_desc_25",LanguageCategory.LangCommon,e,n))
LuaUtils.SetActive(ScrollView.transform,false)
LuaUtils.SetActive(bg_empty.transform,false)
if#t>0 then
LuaUtils.SetActive(ScrollView.transform,true)
else
LuaUtils.SetActive(bg_empty.transform,true)
end
ScrollView:SetListItemCount(#t)
ScrollView:RefreshAllShownItem()
if a then
ScrollView:MovePanelToItemIndex(0)
end
end
function OnGetItemByIndex(o,e)
e=e+1
local a=t[e]
local e=o:NewListViewItem("bg_juese")
local t=LuaUtils.GetLuaComBinder(e.transform)
local t=t:GetComponents()
RefreshHelpInfo(t,a)
return e
end
function RefreshHelpInfo(t,a)
if t==nil or a==nil then
return
end
UIUtil.SetPlayerIconFrame(t["head"],a)
LuaUtils.SetLabelText(t["text_name"],a.name)
local n=a.time
if n<=0 then
LuaUtils.SetTextMeshText(t["text_level_time"],UIUtil.GetDeepGreenTichText(GameTools.GetLocalize("UI.guild.Main.27",LanguageCategory.LangCommon)))
else
n=TimeUtil.GetServerTimeStamp()-n
LuaUtils.SetTextMeshText(t["text_level_time"],UIUtil.GetOrangeTichText(GameTools.GetLocalize("UI.guild.Main.28",LanguageCategory.LangCommon,TimeUtil.toDHMSStr4(n))))
end
LuaUtils.SetLabelText(t["text_zhanli_num"],UIUtil.toBigNum(a.fight))
local n=e:getGuildTrialsBaseCfg().receivedNum
local s=e:getGuildTrialsBaseCfg().rescueNum
LuaUtils.SetLabelText(t["text_shouzen_num"],a.count.."/"..n)
UIUtil.SetGray(t["btn_zhenyu"].transform,false)
if a.count>=n or i>=o then
UIUtil.SetGray(t["btn_zhenyu"].transform,true)
end
t["btn_zhenyu"].onClick:RemoveAllListeners()
t["btn_zhenyu"].onClick:AddListener(function()
if a.count>=n then
UIUtil.ShowCommonTips(GameTools.GetLocalize("guildTrials_desc_26",LanguageCategory.LangCommon))
else
if i>=o then
UIUtil.ShowCommonTips(GameTools.GetLocalize("guildTrials_desc_27",LanguageCategory.LangCommon))
else
e:reqGuildTrialsSendHelp(a.playerId)
end
end
end)
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
if n then
local t=n-TimeUtil.GetServerTimeStamp()
if t<=0 then
e:reqGuildTrialsHelpList()
end
end
end
function OnBeforeDestroy()
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

