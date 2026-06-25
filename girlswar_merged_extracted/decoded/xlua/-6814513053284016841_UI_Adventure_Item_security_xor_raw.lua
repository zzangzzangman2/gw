local e={
}
function e:New(t)
local e={
trans=nil,
ind=0,
icon=nil,
tips_trans=nil,
name_trans=nil,
time_trans=nil,
condition_trans=nil,
lock_trans=nil,
}
setmetatable(e,self)
self.__index=self
self.Bace=t
return e
end
function e:SetShow(e)
LuaUtils.SetActive(self.tips_trans,e)
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
GameTools:SetImageSprite(self.icon,e)
end
function e:SetText(e)
LuaUtils.SetTextMeshText(self.condition_trans,e)
end
function e:SetUI(e,a,t,o)
self.trans=e
self.icon=e:GetComponent(typeof(CS.YouYou.YouYouImage))
self.id=a
self.isLock=true
self.tips_trans=e:Find("im_hongdian")
self.name_trans=e:Find("im_name")
self.node_lock=e:Find("node_lock")
self.condition_trans=self.node_lock:Find("text_weijiesuo"):GetComponent(typeof(CS.TMPro.TextMeshProUGUI))
self.lock_trans=self.node_lock:Find("im_suo")
self.im_wbg=self.node_lock:Find("im_wbg")
self.node_battle=e:Find("node_battle")
self.showNode=e:Find("showNode")
local o=e:GetComponent(typeof(CS.UnityEngine.UI.Button))
self.Bace:AddBtnClickListener(o,function()
t(self.id)
end
)
if self.showNode then
local e=self.showNode:Find("btn_enter_1")
if e then
local e=e:GetComponent(typeof(CS.UnityEngine.UI.Button))
self.Bace:AddBtnClickListener(e,function()
t(self.id)
end
)
end
end
self.btn_enter_tip=e:Find("btn_enter_tip")
if self.btn_enter_tip then
local e=self.btn_enter_tip:GetComponent(typeof(CS.UnityEngine.UI.Button))
self.Bace:AddBtnClickListener(e,function()
t(self.id,"tip")
end
)
end
self:SetActUI(e,a)
self:SetUIStatus(e,a)
end
function e:SetUIStatus(t,e)
if e~=3 and e~=5 and e~=6 and e~=7 then return end
self.node_prepare=t:Find("node_prepare")
if e==5 then
self.text_time1=self.node_prepare:Find("labgrid/text_time1"):GetComponent(typeof(CS.TMPro.TextMeshProUGUI))
self.text_time2=self.node_prepare:Find("labgrid/text_time2"):GetComponent(typeof(CS.TMPro.TextMeshProUGUI))
self.text_time3=self.node_prepare:Find("labgrid/text_time3"):GetComponent(typeof(CS.TMPro.TextMeshProUGUI))
else
self.text_time1=self.node_prepare:Find("text_time1"):GetComponent(typeof(CS.TMPro.TextMeshProUGUI))
self.text_time2=self.node_prepare:Find("text_time2"):GetComponent(typeof(CS.TMPro.TextMeshProUGUI))
end
end
function e:SetTextLock(e,t)
if e~=3 and e~=5 and e~=6 and e~=7 then return end
LuaUtils.SetActive(self.node_prepare,false)
LuaUtils.SetActive(self.node_battle,false)
LuaUtils.SetActive(self.node_lock,true)
LuaUtils.SetTextMeshText(self.condition_trans,t)
LuaUtils.SetActive(self.im_wbg,t~="")
end
function e:SetTextPrepare(e,o,a,t)
if e~=3 and e~=5 and e~=6 and e~=7 then return end
LuaUtils.SetActive(self.node_lock,false)
LuaUtils.SetActive(self.node_battle,false)
LuaUtils.SetActive(self.node_prepare,true)
o=o or""
LuaUtils.SetTextMeshText(self.text_time1,o)
LuaUtils.SetActive(self.text_time2.transform,false)
if a and a~=""then
LuaUtils.SetActive(self.text_time2.transform,true)
LuaUtils.SetTextMeshText(self.text_time2,a)
else
LuaUtils.SetTextMeshText(self.text_time2,"")
end
if self.text_time3 then
LuaUtils.SetActive(self.text_time3.transform,false)
if t and t~=""then
LuaUtils.SetActive(self.text_time3.transform,true)
LuaUtils.SetTextMeshText(self.text_time3,t)
else
LuaUtils.SetTextMeshText(self.text_time3,"")
end
end
end
function e:SetBattleSpine(e,a,t)
if e~=3 and e~=5 and e~=6 then return end
LuaUtils.SetActive(self.node_lock,false)
LuaUtils.SetActive(self.node_prepare,false)
LuaUtils.SetActive(self.node_battle,a)
if t then
local e=self.node_battle:Find("spine_battle"):GetComponent(typeof(CS.YouYou.UISpineCtr))
UIUtil.SpinePlayAnimation(e,0,t,true)
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
function e:SetShowSpineState(t,a)
if self.showNode then
local e=self.showNode:Find("spine_state")
if e then
local o=self.showNode:Find("bg_spine")
LuaUtils.SetActive(o.transform,t==false)
LuaUtils.SetActive(e.transform,t)
if t then
UIUtil.SpineCheckPlayAnimation(e,0,a,true)
end
end
end
end
function e:SetShowSpineBg(t)
if self.showNode then
local e=self.showNode:Find("bg_spine")
LuaUtils.SetActive(e.transform,t)
end
end
function e:SetShowSpineState2(t,a)
if self.showNode then
local e=self.showNode:Find("spine_state_2")
if e then
LuaUtils.SetActive(e.transform,t)
if t then
UIUtil.SpineCheckPlayAnimation(e,0,a,true)
end
end
end
end
function e:SetShowBtnTip(e)
if self.btn_enter_tip then
LuaUtils.SetActive(self.btn_enter_tip.transform,e)
end
end
function e:GetBtnTip()
return self.btn_enter_tip
end
function e:SetShowRepair(t)
if self.showNode then
local e=self.showNode:Find("im_repair")
if e then
LuaUtils.SetActive(e.transform,t)
end
end
end
function e:SetShowBtn1(t)
if self.showNode then
local e=self.showNode:Find("btn_enter_1")
if e then
LuaUtils.SetActive(e.transform,t)
end
end
end
function e:SetShowImage1(a,t)
if self.showNode then
local e=self.showNode:Find("im_state_1")
if e then
LuaUtils.SetActive(e.transform,a)
if a and t~=nil then
GameTools:SetImageSprite(e,t,true)
end
end
end
end
function e:SetShowImage2(t,a)
if self.showNode then
local e=self.showNode:Find("im_state_2")
if e then
LuaUtils.SetActive(e.transform,t)
if t and a~=nil then
GameTools:SetImageSprite(e,a,true)
end
end
end
end
function e:SetShowImage3(a,t)
if self.showNode then
local e=self.showNode:Find("im_state_3")
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
if t==3 then
e=GameTools.GetLocalize("hyakuniti_dragon_double",LanguageCategory.LangCommon)
elseif t==4 then
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
LuaUtils.SetActive(self.tips_trans,e)
end
function e:SetUnlock(e)
LuaUtils.SetActive(self.lock_trans,e==false)
end
function e:SetActTip(e)
LuaUtils.SetActive(self.im_actTip,e)
end
function e:GetTrans(e)
local e=self.trans:Find(e)
return e
end
function e:SetGray(t)
local e=self.trans:Find("img_prohibit")
if e then
UIUtil.SetGray4(self.trans,t,false,false,{e})
else
UIUtil.SetGray4(self.trans,t)
end
end
function e:SetHeFu(e,a)
local t=self.trans:Find("hefu")
LuaUtils.SetActive(t,e)
local o=self.trans:Find("img_prohibit")
LuaUtils.SetActive(o,e)
if not e then
return
end
local e=a-TimeUtil.GetServerTimeStamp()
local e=TimeUtil.TimestampToDate2(e)
local t=t:Find("tmp_hefuTip")
local t=t:GetComponent(typeof(CS.TMPro.TextMeshProUGUI))
LuaUtils.SetTextMeshText(t,GameTools.GetLocalize("heFuTip",LanguageCategory.LangCommon,e))
end
return e 
