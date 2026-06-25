local a
local o
local t
function OnInit(e,e)
Image.onClick:AddListener(closeUI)
btn_fanhui.onClick:AddListener(closeUI)
btn_queren.onClick:AddListener(btnOk)
toggle.onValueChanged:AddListener(function(e)
if t~=e then
t=e
end
end)
end
function OnOpen(e)
a=e.cancelFunc
o=e.okFunc
local n=e.count
local i=e.title
local o=e.message
local a=e.itemId
local e=e.saveStatus
if i then
LuaUtils.SetTextMeshText(text_title,i)
end
if o then
LuaUtils.SetLabelText(text_message,o)
end
if a then
local e=ModulesInit.BagManager:GetBaseInfo(a)
GameTools:SetImageSprite(im_zuanshi,e.icon,false)
end
t=true
LuaUtils.SetToggleValue(toggle,t)
LuaUtils.SetLabelText(text_num,UIUtil.toBigNum(n))
end
function OnClose()
end
function OnBeforeDestroy()
end
function btnOk()
saveData(function()
if o then
o(t)
end
GameTools.CloseUIForm(UIFormId.UI_CostHCConfirm2)
end)
end
function closeUI(e)
GameTools.CloseUIForm(UIFormId.UI_CostHCConfirm2)
if e then e()end
if a then
a()
end
end
function saveData(e)
e()
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

