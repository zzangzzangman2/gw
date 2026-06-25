local e=1
local t=3
function OnInit(e,e)
self:AddBtnClickListener(Image,closeUI)
self:AddBtnClickListener(btn_cancel,closeUI)
self:AddBtnClickListener(btn_delete,btnDelete)
end
function OnOpen(a)
e=1
t=3
LuaUtils.SetLabelText(txt_delete,GameTools.GetLocalize("UI.Bag.Tips.03").."("..t..")")
EventSystem.AddListener(SysEventId.OnUpdate,OnUpdate)
UIUtil.SetGray(btn_delete.transform,true)
end
function OnClose()
EventSystem.RemoveListener(SysEventId.OnUpdate,OnUpdate)
end
function OnUpdate()
if e==nil then return end
e=e-Time.deltaTime
if e>0 then
return
end
e=1
t=t-1
if t>0 then
LuaUtils.SetLabelText(txt_delete,GameTools.GetLocalize("UI.Bag.Tips.03").."("..t..")")
else
e=nil
LuaUtils.SetLabelText(txt_delete,GameTools.GetLocalize("UI.Bag.Tips.03"))
UIUtil.SetGray(btn_delete.transform,false)
end
end
function OnBeforeDestroy()
end
function closeUI()
GameTools.CloseUIForm(UIFormId.UI_DeleteHint)
end
function OnWillClose()
end
function btnDelete()
if t>0 then return end
local e=function()
LuaUtils.DeletePrefsAll()
local e=LuaUtils.GetUUID()
local e=LuaUtils.GetAcc(e)
UserAccountInfo:setAcc(e)
LuaUtils.SetPlayerPrefsBool("IS_DELETE_ACC",true)
GameTools.IsRestartGame=true
CS.YouYou.PayManager.ColseHUD()
LuaUtils.RestartGame()
end
local t=NetManager.Send(ProtoId.PRT_PLAYER_DELETE_REQ)
t.onCompleted=function()
e()
end
end 
