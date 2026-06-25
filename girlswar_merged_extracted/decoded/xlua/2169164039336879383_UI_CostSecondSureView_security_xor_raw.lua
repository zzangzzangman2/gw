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
local n=e.title
local i=e.message
local a=e.message2
local o=e.saveStatus
local o=e.cancelText
local e=e.sureText
if n then
LuaUtils.SetTextMeshText(text_title,n)
end
if i then
LuaUtils.SetLabelText(text_message,i)
end
if a then
LuaUtils.SetLabelText(text_message2,a)
end
if o then
LuaUtils.SetTextMeshText(text_fanhui,o)
end
if e then
LuaUtils.SetTextMeshText(text_queren,e)
end
t=true
LuaUtils.SetToggleValue(toggle,t)
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
GameTools.CloseUIForm(UIFormId.UI_CostSecondSureView)
end)
end
function closeUI(e)
GameTools.CloseUIForm(UIFormId.UI_CostSecondSureView)
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

