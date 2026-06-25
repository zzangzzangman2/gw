local e=nil
local t=nil
function OnInit(a,a)
btn_queren.onClick:AddListener(function()
self:Close()
if e.onOkBtnClick then
e.onOkBtnClick(e)
end
end)
btn_quxiao.onClick:AddListener(function()
self:Close()
if e.onCancelBtnClick then
e.onCancelBtnClick(e)
end
end)
Image.onClick:AddListener(function()
end)
tipsBtn.onClick:AddListener(function()
e.tipsStatus=not e.tipsStatus
t=e.tipsStatus
RefreshTipSelectView()
end)
end
function OnOpen(t)
e=t
OnTipsShow(e)
end
function OnTipsShow(e)
LuaUtils.SetTextMeshText(text_title,e.titleText or GameTools.GetLocalize("guildTrials_desc_14",LanguageCategory.LangCommon))
LuaUtils.SetTextMeshText(quxiao_text,e.cancelBtnText or GameTools.GetLocalize("UI.Equip.Wear.12",LanguageCategory.LangCommon))
LuaUtils.SetTextMeshText(queren_text,e.okBtnText or GameTools.GetLocalize("UI.Equip.Wear.13",LanguageCategory.LangCommon))
LuaUtils.SetTextMeshText(text_message,e.messageText or"")
if e.tipsStatus~=nil then
LuaUtils.SetActive(tipSelectImg.transform,e.tipsStatus)
else
LuaUtils.SetActive(tipSelectImg.transform,false)
end
end
function RefreshTipSelectView()
if e.tipsStatus~=nil then
LuaUtils.SetActive(tipSelectImg.transform,e.tipsStatus)
else
LuaUtils.SetActive(tipSelectImg.transform,false)
end
end
function OnClose()
end
function OnBeforeDestroy()
end
function OnWillClose()
if ViewMgr then
ViewMgr:OnWillClose(self.UIFormId)
end
end

