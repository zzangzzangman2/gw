local t
local o
local e
function OnInit(t,t)
Image.onClick:AddListener(closeUI)
btn_fanhui.onClick:AddListener(closeUI)
btn_queren.onClick:AddListener(btnOk)
toggle.onValueChanged:AddListener(function(t)
if e~=t then
e=t
end
end)
end
function OnOpen(a)
t=a.cancelFunc
o=a.okFunc
local t=a.count
e=true
LuaUtils.SetToggleValue(toggle,e)
LuaUtils.SetLabelText(text_num,UIUtil.toBigNum(t))
end
function OnClose()
end
function OnBeforeDestroy()
end
function btnOk()
saveData(function()
if o then
o()
end
GameTools.CloseUIForm(UIFormId.UI_CostHCConfirm)
end)
end
function closeUI(e)
GameTools.CloseUIForm(UIFormId.UI_CostHCConfirm)
if e then e()end
if t then
t()
end
end
function saveData(a)
local t=PlayerMgr:GetPlayerSetValue(PROTO_ENUM.ENUM_SETTING_ID.SID_COST_HC_TIPS)
if t~=not e then
local o={}
local t=1
if e then
t=0
end
table.insert(o,{id=PROTO_ENUM.ENUM_SETTING_ID.SID_COST_HC_TIPS,value=t})
local e=PlayerMgr:sendSetting(o)
e.onCompleted=function()
a()
end
else
a()
end
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

