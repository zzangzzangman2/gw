function OnInit(e,e)
Image.onClick:AddListener(closeUI)
inputAcc.onValueChanged:AddListener(function(e)
if e then
end
end)
btn_get.onClick:AddListener(btnGet)
btn_fanhui.onClick:AddListener(closeUI)
btn_paste.onClick:AddListener(btnPaste)
end
function OnOpen(e)
inputAcc.text=""
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
end
function OnEventNetReconnectSuccess()
closeUI()
end
function OnBeforeDestroy()
end
function btnPaste()
inputAcc.text=CS.UnityEngine.GUIUtility.systemCopyBuffer
end
function btnGet()
local e=inputAcc.text or""
if e==""then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.Setting.Code.02",LanguageCategory.LangCommon))
return
end
local e=PlayerMgr:sendCDKCodeChange(e)
e.onCompleted=function()
closeUI()
end
end
function closeUI()
GameTools.CloseUIForm(UIFormId.UI_CDKExchange)
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

