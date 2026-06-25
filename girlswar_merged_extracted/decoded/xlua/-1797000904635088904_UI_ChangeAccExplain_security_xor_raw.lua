local e
function OnInit(e,e)
self:AddBtnClickListener(Image,closeUI)
self:AddBtnClickListener(btn_fanhui,closeUI)
self:AddBtnClickListener(btn_queren,gotoChangeView)
LuaUtils.RebuildLayout(Content.transform)
Content.transform.anchoredPosition=Vector2.zero
end
function OnOpen(t)
e=t and t.isLogin
end
function OnClose()
end
function OnBeforeDestroy()
end
function closeUI()
self:Close()
end
function gotoChangeView()
closeUI()
if e then
GameEntry.UI:OpenUIForm(UIFormId.UI_SetAcc)
else
GameEntry.UI:OpenUIForm(UIFormId.UI_ChangeAccSet)
end
end
function OnWillClose()
end

