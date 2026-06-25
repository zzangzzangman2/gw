local h=require('DataNode/DataTable/Create/hero/DTHeroDBModel')
local t=ModulesInit.GuildTrialsMgr
local i={
{"UIGuildTrials/guildTrials_common_pic_ptd","UIGuildTrials/guildTrials_msz_pt"},
{"UIGuildTrials/guildTrials_common_pic_sld","UIGuildTrials/guildTrials_msz_sl"}
}
local a={
kSimple=1,
kNormal=2,
kHard=3,
}
local l=0
local c=nil
local e=nil
local o=a.kNormal
local u=0
local d=0
local s={}
local n=nil
function OnInit(i,i)
btnClose.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_GuildTrials_MonsDesc_View)
end)
toggle1.onClick:AddListener(function()
if o==a.kSimple then
return
end
if a.kSimple<e.passLv then
UIUtil.ShowCommonTips(GameTools.GetLocalize("guildTrials_desc_20",LanguageCategory.LangCommon))
return
end
o=a.kSimple
SelectToggleView()
end)
toggle2.onClick:AddListener(function()
if o==a.kNormal then
return
end
if a.kNormal<e.passLv then
UIUtil.ShowCommonTips(GameTools.GetLocalize("guildTrials_desc_20",LanguageCategory.LangCommon))
return
end
o=a.kNormal
SelectToggleView()
end)
toggle3.onClick:AddListener(function()
if o==a.kHard then
return
end
o=a.kHard
SelectToggleView()
end)
btn_tiaozhan.onClick:RemoveAllListeners()
btn_tiaozhan.onClick:AddListener(function()
if not e then
return
end
local t=t:getGuildTrialsMapsById(n.mapDid)
if e.score>=t.progress and t.isBoss==0 then
UIUtil.ShowCommonTips(GameTools.GetLocalize("guildTrials_desc_50",LanguageCategory.LangCommon))
else
ClickTiaoZhanBtnView()
end
end)
end
function OnOpen(e)
n=e
EventSystem.AddListener(SysEventId.OnUpdate,OnUpdate)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.AddListener(CommonEventId.RedPointInfoChange,RedPointInfoChange)
EventSystem.AddListener(CommonEventId.OnRespGuildTrialsInfo,OnRespGuildTrialsInfo)
EventSystem.AddListener(CommonEventId.OnRespGuildTrialsFastFightData,OnRespGuildTrialsFastFightData)
Refresh()
end
function OnClose()
DestroySpine()
l=0
c=nil
e=nil
o=a.kNormal
u=0
d=0
s={}
n=nil
EventSystem.RemoveListener(SysEventId.OnUpdate,OnUpdate)
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
EventSystem.RemoveListener(CommonEventId.RedPointInfoChange,RedPointInfoChange)
EventSystem.RemoveListener(CommonEventId.OnRespGuildTrialsInfo,OnRespGuildTrialsInfo)
EventSystem.RemoveListener(CommonEventId.OnRespGuildTrialsFastFightData,OnRespGuildTrialsFastFightData)
end
function DestroySpine()
LuaUtils.SetActive(monsSpineNode.transform,false)
local e=UIUtil.GetChild(monsSpineNode,0)
if e then
UIUtil.SmallSpinePoolDespawn(e)
end
end
function OnBeforeDestroy()
end
function OnEventNetReconnectSuccess()
if PlayerMgr.PlayerInfo.guildId>0 then
t:ReqGuildTrialsInfo()
end
end
function RedPointInfoChange()
end
function OnRespGuildTrialsInfo()
Refresh()
end
function OnRespGuildTrialsFastFightData(e)
if e and e.drops then
UIUtil.ShowAwardWithServerData(e.drops)
end
end
function Refresh()
RefreshData()
RefreshView()
end
function RefreshData()
c=t.nextResetTime
s=t.mapTabs
e=s[n.mapDid]
if not e then
EventSystem.SendEvent(CommonEventId.OnSkipGuide2)
GameTools.CloseUIForm(UIFormId.UI_GuildTrials_MonsDesc_View)
return
end
u=t.fightCount
d=t.fightTotalCount
if e.passLv>0 then
o=e.passLv
end
end
function RefreshView()
if not e then
return
end
RefreshMonsDescView()
RefreshLeftProgressView()
SelectToggleView()
end
function RefreshMonsDescView()
local t=t:getGuildTrialsMapsById(n.mapDid)
if t.isBoss==1 then
LuaUtils.SetImageSprite(monsDiImg,i[2][1],false)
LuaUtils.SetImageSprite(monsTypeImg,i[2][2],false)
else
LuaUtils.SetImageSprite(monsDiImg,i[1][1],false)
LuaUtils.SetImageSprite(monsTypeImg,i[1][2],false)
end
local a=t.heroDid
local a=h.GetEntity(a)
LuaUtils.SetTextMeshText(mons_name_txt,GameTools.GetLocalize(a.heroName,LanguageCategory.LangBattle))
local a=false
local e=tonumber(e.score/t.progress)*100
UIUtil.SetGray(btn_tiaozhan.transform,false)
if e>=100 and t.isBoss==0 then
a=true
UIUtil.SetGray(btn_tiaozhan.transform,true)
end
DestroySpine()
LuaUtils.SetActive(monsSpineNode.transform,true)
UIUtil.GetUISmallSpinePool(t.heroDid,
function(e,a,t)
local o={
scale=Vector3(-1.4,1.4,1.4),
localPos=Vector3(220,-50,0),
timeScale=0
}
UIUtil.HandlePoolUISmallRolePrefab(e,a,t,monsSpineNode,o)
end,
1
)
end
function RefreshLeftProgressView()
local t=t:getGuildTrialsMapsById(n.mapDid)
local e=e.score
if e>t.progress then
e=t.progress
end
local a=e.."/"..t.progress
LuaUtils.SetTextMeshText(text_num_exp,a)
local e=e/t.progress
im_jindutiao_exp.fillAmount=e
end
function SelectToggleView()
for t=1,3 do
local e=selfEnv["toggle"..t].transform
if o==t then
LuaUtils.SetChildActive(e,'im_on',true)
LuaUtils.SetChildActive(e,'im_off',false)
else
LuaUtils.SetChildActive(e,'im_on',false)
LuaUtils.SetChildActive(e,'im_off',true)
end
end
RefreshRightDescView()
end
function RefreshRightDescView()
local h={}
local r=0
local s=0
local i=t:getGuildTrialsMapsById(n.mapDid)
if o==a.kSimple then
h=i.award1
r=i.passFight1
if t:CheckNewAwardReset()then
s=i.progressAward1New
else
s=i.progressAward1
end
elseif o==a.kNormal then
h=i.award2
r=i.passFight2
if t:CheckNewAwardReset()then
s=i.progressAward2New
else
s=i.progressAward2
end
elseif o==a.kHard then
h=i.award3
r=i.passFight3
if t:CheckNewAwardReset()then
s=i.progressAward3New
else
s=i.progressAward3
end
end
if o<=e.passLv then
LuaUtils.SetTextMeshText(text_tiaozhan,GameTools.GetLocalize("guildTrials_desc_53",LanguageCategory.LangCommon))
else
LuaUtils.SetTextMeshText(text_tiaozhan,GameTools.GetLocalize("guildTrials_desc_52",LanguageCategory.LangCommon))
end
for e=1,2 do
LuaUtils.SetActive(selfEnv["itemImg"..e].transform,false)
LuaUtils.SetActive(selfEnv["text_item"..e.."_num"].transform,false)
if h[e]then
LuaUtils.SetActive(selfEnv["itemImg"..e].transform,true)
LuaUtils.SetActive(selfEnv["text_item"..e.."_num"].transform,true)
local t=ModulesInit.BagManager:GetBaseInfo(h[e][1])
LuaUtils.SetImageSprite(selfEnv["itemImg"..e],t.iconSmall,false)
LuaUtils.SetTextMeshText(selfEnv["text_item"..e.."_num"],"x"..h[e][2])
end
end
LuaUtils.SetTextMeshText(text_yazhi_num,"+"..s)
local e=ModulesInit.FormationManager:GetFormationFightValue(PROTO_ENUM.FormationNO.FN_GUILD_TRIAL)
if e==0 then
e=ModulesInit.FormationManager:GetFormationFightValue(PROTO_ENUM.FormationNO.FN_MAIN)
end
if e>=(r*1.5)then
LuaUtils.SetTextMeshText(text_change_desc,GameTools.GetLocalize("guildTrials_desc_10",LanguageCategory.LangCommon))
elseif e>=(r*0.8)then
LuaUtils.SetTextMeshText(text_change_desc,GameTools.GetLocalize("guildTrials_desc_11",LanguageCategory.LangCommon))
else
LuaUtils.SetTextMeshText(text_change_desc,GameTools.GetLocalize("guildTrials_desc_12",LanguageCategory.LangCommon))
end
local e=d-u
LuaUtils.SetTextMeshText(text_change_num,GameTools.GetLocalize("guildTrials_desc_6",LanguageCategory.LangCommon,e,d))
end
function OnUpdate()
l=l-Time.deltaTime
if l>0 then
return
end
l=1
local e=Time.deltaTime
UpdateFreeTime(e)
end
function UpdateFreeTime(e)
if c then
local e=c-TimeUtil.GetServerTimeStamp()
if e<=0 then
GameTools.CloseUIForm(UIFormId.UI_GuildTrials_MonsDesc_View)
end
end
end
function ClickTiaoZhanBtnView()
local a=d-u
if a<=0 then
UIUtil.ShowCommonTips(GameTools.GetLocalize("guildTrials_desc_13",LanguageCategory.LangCommon))
return
end
if e.passLv>=o then
if not t:GetGuildTrialsTipsStatus()then
local a=""
if e.passLv==1 then
a=GameTools.GetLocalize("guildTrials_desc_16",LanguageCategory.LangCommon)
elseif e.passLv==2 then
a=GameTools.GetLocalize("guildTrials_desc_17",LanguageCategory.LangCommon)
elseif e.passLv==3 then
a=GameTools.GetLocalize("guildTrials_desc_18",LanguageCategory.LangCommon)
end
local a=GameTools.GetLocalize("guildTrials_desc_15",LanguageCategory.LangCommon,a)
local e={
onOkBtnClick=function(a)
t:SetGuildTrialsTipsStatus(a.tipsStatus)
t:reqGuildTrialsFastFight(e.mapId,e.passLv)
end,
onCancelBtnClick=function(e)
end,
titleText=GameTools.GetLocalize("guildTrials_desc_14",LanguageCategory.LangCommon),
okBtnText=GameTools.GetLocalize("UI.Equip.Wear.13",LanguageCategory.LangCommon),
cancelBtnText=GameTools.GetLocalize("UI.Equip.Wear.12",LanguageCategory.LangCommon),
messageText=a,
tipsStatus=not t:GetGuildTrialsTipsStatus(),
}
if not GameEntry.UI:IsExists(UIFormId.UI_GuildTrials_SurePop_View)then
GameEntry.UI:OpenUIForm(UIFormId.UI_GuildTrials_SurePop_View,e)
end
else
t:reqGuildTrialsFastFight(e.mapId,e.passLv)
end
return
end
battleFightCallBack()
end
function battleFightCallBack()
local s=t:getGuildTrialsMapsById(n.mapDid)
local n=ModulesInit.FormationManager:GetFormationFightValue(PROTO_ENUM.FormationNO.FN_GUILD_TRIAL)
local i=0
if o<a.kNormal then
if n>s.passFight3 then
i=a.kHard
elseif n>s.passFight2 then
i=a.kNormal
end
elseif o<a.kHard then
if n>s.passFight3 then
i=a.kHard
end
end
local t=function()
t:ReqGuildTrialsFightBefore(e.mapId,o,e.mapDid)
end
if i>0 and(not ModulesInit.GuideMgr.isGuide)then
local e=""
if i==2 then
e=GameTools.GetLocalize("guildTrials_desc_17",LanguageCategory.LangCommon)
elseif i==3 then
e=GameTools.GetLocalize("guildTrials_desc_18",LanguageCategory.LangCommon)
end
local e=GameTools.GetLocalize("guildTrials_desc_19",LanguageCategory.LangCommon,e)
local e={
text=e,
okBtnContent=GameTools.GetLocalize("UI.Equip.Wear.13",LanguageCategory.LangCommon),
buttons=MessageBoxButtons.OKCancel,
cancelBtnContext=GameTools.GetLocalize("UI.Equip.Wear.12",LanguageCategory.LangCommon),
onOkBtnClick=function()
t()
end,
onCancelBtnClick=function()
end,
onBgBtnClick=function()
end
}
UIUtil.ShowMessageBox(e)
else
t()
end
end
function OnWillClose()
LuaUtils.SetActive(monsSpineNode.transform,false)
ViewMgr:OnWillClose(self.UIFormId)
end

