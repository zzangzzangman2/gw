local e={
}
function e:New(t)
local e={
trans=nil,
ind=0,
bg=nil,
redPoint_trans=nil,
time_trans=nil,
condition_trans=nil,
lock_trans=nil,
reward_trans=nil,
rewardTips_trans=nil,
}
setmetatable(e,self)
self.__index=self
self.Bace=t
return e
end
function e:SetShow(e)
LuaUtils.SetActive(self.redPoint_trans,e)
LuaUtils.SetActive(self.lock_trans,e)
end
function e:SetLock(e)
self.isLock=e
LuaUtils.SetActive(self.lock_trans,not e)
end
function e:IsLock()
if not self.isLock then
UIUtil.ShowCommonTips(GameTools.GetLocalize("errCode28",LanguageCategory.LangCommon))
end
return self.isLock
end
function e:SetTips(e)
LuaUtils.SetActive(self.lock_trans,e)
end
function e:SetIcon(e)
GameTools:SetImageSprite(self.bg,e)
end
function e:SetText(e)
LuaUtils.SetTextMeshText(self.condition_trans,e)
LuaUtils.SetActive(self.im_wbg.transform,e~="")
LuaUtils.SetActive(self.condition_trans.transform,e~="")
end
function e:SetUI(e,t,o,a)
self.trans=e
self.bg=e:GetComponent(typeof(CS.YouYou.YouYouImage))
self.id=t
self.isLock=true
self.redPoint_trans=e:Find("im_hongdian")
self.node_lock=e:Find("node_lock")
self.condition_trans=self.node_lock:Find("text_weijiesuo"):GetComponent(typeof(CS.TMPro.TextMeshProUGUI))
self.lock_trans=self.node_lock:Find("im_suo")
self.im_wbg=self.node_lock:Find("im_wbg")
self.node_battle=e:Find("node_battle")
self.reward_trans=e:Find("itemgroup")
self.rewardTips_trans=e:Find("text_rewardTips"):GetComponent(typeof(CS.TMPro.TextMeshProUGUI))
local a=e:GetComponent(typeof(CS.UnityEngine.UI.Button))
self.Bace:AddBtnClickListener(a,function()
o(self.id)
end
)
self:SetActUI(e,t)
self:SetUIStatus(e,t)
end
function e:SetUIStatus(t,e)
if e~=AdventurePageType.pDragon then return end
self.node_prepare=t:Find("node_prepare")
self.text_time1=self.node_prepare:Find("text_time1"):GetComponent(typeof(CS.TMPro.TextMeshProUGUI))
self.text_time2=self.node_prepare:Find("text_time2"):GetComponent(typeof(CS.TMPro.TextMeshProUGUI))
end
function e:SetTextLock(t,e)
if t~=AdventurePageType.pDragon then return end
LuaUtils.SetActive(self.node_prepare,false)
LuaUtils.SetActive(self.node_battle,false)
LuaUtils.SetActive(self.node_lock,true)
LuaUtils.SetTextMeshText(self.condition_trans,e)
LuaUtils.SetActive(self.im_wbg,e~="")
end
function e:SetTextPrepare(o,a,t,e)
if o~=AdventurePageType.pDragon then return end
LuaUtils.SetActive(self.node_lock,false)
LuaUtils.SetActive(self.node_battle,false)
LuaUtils.SetActive(self.node_prepare,true)
a=a or""
LuaUtils.SetTextMeshText(self.text_time1,a)
LuaUtils.SetActive(self.text_time2.transform,false)
if t and t~=""then
LuaUtils.SetActive(self.text_time2.transform,true)
LuaUtils.SetTextMeshText(self.text_time2,t)
else
LuaUtils.SetTextMeshText(self.text_time2,"")
end
if self.text_time3 then
LuaUtils.SetActive(self.text_time3.transform,false)
if e and e~=""then
LuaUtils.SetActive(self.text_time3.transform,true)
LuaUtils.SetTextMeshText(self.text_time3,e)
else
LuaUtils.SetTextMeshText(self.text_time3,"")
end
end
end
function e:SetBattleSpine(a,t,e)
if a~=AdventurePageType.pDragon then return end
LuaUtils.SetActive(self.node_lock,false)
LuaUtils.SetActive(self.node_prepare,false)
LuaUtils.SetActive(self.node_battle,t)
if e then
local t=self.node_battle:Find("spine_battle"):GetComponent(typeof(CS.YouYou.UISpineCtr))
UIUtil.SpinePlayAnimation(t,0,e,true)
end
end
function e:SetBattleServerType(a,t)
if self.node_battle then
local e=self.node_battle:Find("im_server_type")
if e then
LuaUtils.SetActive(e.transform,a)
if a and t~=nil then
GameTools:SetImageSprite(e,t,true)
end
end
end
end
function e:SetActUI(e,t)
self.im_actTip=e:Find("im_actTip")
if not self.im_actTip then return end
local e
if t==AdventurePageType.pDragon then
e=GameTools.GetLocalize("hyakuniti_dragon_double",LanguageCategory.LangCommon)
elseif t==AdventurePageType.pMaze then
e=GameTools.GetLocalize("hyakuniti_maze_double",LanguageCategory.LangCommon)
end
self.btn_actHelp=self.im_actTip:Find("btn_actHelp")
local t=self.btn_actHelp:GetComponent(typeof(CS.UnityEngine.UI.Button))
t.onClick:AddListener(
function()
local e={
worldPos=t.transform.position,
hintDes=e,
offset=10,
priorPageArr={EHintPageDir.Down},
priorArrowArr={EHintArrowAlign.Horizontal_Center},
textSizeType=EHintSizeType.Standard
}
UIUtil.ShowHint(e)
end
)
end
function e:SetRedPoint(e)
LuaUtils.SetActive(self.redPoint_trans,e)
end
function e:SetUnlock(e)
LuaUtils.SetActive(self.lock_trans,e==false)
self:SetFuncUnlock(e)
end
function e:SetActTip(e)
LuaUtils.SetActive(self.im_actTip,e)
end
function e:GetTrans(e)
local e=self.trans:Find(e)
return e
end
function e:SetRewards(a)
for e=1,4 do
local t=self.reward_trans:Find("itemCell"..e)
if t then
LuaUtils.SetActive(t.transform,false)
if a[e]then
LuaUtils.SetActive(t.transform,true)
local o={
thingDid=a[e][1],
offset=45
}
if not ModulesInit.GuideMgr.isGuide then
UIUtil.SetItemCell(t.transform,{itemDid=a[e][1]},o)
else
UIUtil.SetItemCell(t.transform,{itemDid=a[e][1]})
end
end
end
end
end
function e:SetRewardTips(e)
LuaUtils.SetTextMeshText(self.rewardTips_trans,e)
end
function e:SetIdleTime(e)
local t=self.trans:Find("txt_idle_time"):GetComponent(typeof(CS.TMPro.TextMeshProUGUI))
LuaUtils.SetTextMeshText(t,e)
end
function e:SetIdleTimeShow(t)
local e=self.trans:Find("txt_idle_time")
LuaUtils.SetActive(e,t)
end
function e:SetDispatchStatus(e)
local t=self.trans:Find("im_dispatch")
LuaUtils.SetActive(t,e)
end
function e:SetFuncUnlock(e)
LuaUtils.SetActive(self.lock_trans,false)
LuaUtils.SetActive(self.rewardTips_trans.transform,e)
LuaUtils.SetActive(self.reward_trans.transform,e)
UIUtil.SetGray(self.trans,not e)
end
function e:SetDragonBossValentineActTip(t)
if not IsNil(self.trans)then
local e=self.trans:Find("im_valentineActTip")
if not IsNil(e)then
LuaUtils.SetActive(e.transform,t)
end
end
end
return e 
