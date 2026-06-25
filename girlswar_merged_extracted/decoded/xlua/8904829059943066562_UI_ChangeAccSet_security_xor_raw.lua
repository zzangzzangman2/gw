function OnInit(e,e)
Image.onClick:AddListener(closeUI)
btn_fanhui.onClick:AddListener(closeUI)
btn_queren.onClick:AddListener(onSetAcc)
end
function OnOpen(e)
input_mail.text=UserAccountInfo:getMail()
input_pwd1.text=""
input_pwd2.text=""
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
function closeUI()
GameTools.CloseUIForm(UIFormId.UI_ChangeAccSet)
end
function onSetAcc()
if input_mail.text==nil or input_mail.text==""then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.Setting.Transfer.09",LanguageCategory.LangCommon))
return
end
local e=string.find(input_mail.text,"^.+@.+%..+")
if e==nil then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.Setting.Transfer.10",LanguageCategory.LangCommon))
return
end
if input_pwd1.text==nil or input_pwd1.text==""then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.Setting.Transfer.11",LanguageCategory.LangCommon))
return
end
if input_pwd2.text==nil or input_pwd2.text==""then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.Setting.Transfer.11",LanguageCategory.LangCommon))
return
end
if input_pwd2.text~=input_pwd1.text then
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.Setting.Transfer.12",LanguageCategory.LangCommon))
return
end
local e=PlayerMgr:sendSetAcc(input_mail.text,input_pwd1.text)
e.onCompleted=function()
UserAccountInfo:setMail(input_mail.text)
UserAccountInfo:setPwd(input_pwd1.text)
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.Setting.Transfer.13",LanguageCategory.LangCommon))
closeUI()
end
end
function OnWillClose()
end

