function OnInit(e,e)
Image.onClick:AddListener(closeUI)
btn_queding.onClick:AddListener(closeUI)
end
function OnOpen(e)
end
function OnClose()
end
function OnBeforeDestroy()
end
function closeUI()
GameTools.CloseUIForm(UIFormId.UI_GameExplain)
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

