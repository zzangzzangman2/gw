local e
function OnInit(e,e)
self:AddBtnClickListener(Image,closeUI)
self:AddBtnClickListener(btn_mail,btnMail)
self:AddBtnClickListener(btn_google,btnGoogle)
self:AddBtnClickListener(btn_apple,btnApple)
self:AddBtnClickListener(btn_delete,btnDelete)
end
function OnOpen(t)
e=false
Refresh()
LuaUtils.SetActive(btn_delete.transform,GameTools:IsReview())
EventSystem.AddListener(CommonEventId.OnSDKLoginCallBack,OnSDKLoginCallBack)
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnSDKLoginCallBack,OnSDKLoginCallBack)
end
function OnBeforeDestroy()
end
function closeUI()
GameTools.CloseUIForm(UIFormId.UI_ChangeAccSetSelect)
end
function OnWillClose()
end
function Refresh()
if CS.UnityEngine.Application.platform==CS.UnityEngine.RuntimePlatform.Android then
LuaUtils.SetActive(btn_google.transform,true)
LuaUtils.SetActive(btn_apple.transform,false)
e=UserAccountInfo.bindPlatform=="ANDROID"
LuaUtils.SetActive(txt_google_bind.transform,not e)
LuaUtils.SetActive(txt_google_unbind.transform,e)
else
LuaUtils.SetActive(btn_apple.transform,true)
LuaUtils.SetActive(btn_google.transform,false)
e=UserAccountInfo.bindPlatform=="IOS"
LuaUtils.SetActive(txt_apple_bind.transform,not e)
LuaUtils.SetActive(txt_apple_unbind.transform,e)
end
end
function setAccBind(e,o)
local a=""
local t=""
if e=="GOOGLE"then
a="bind_google_acc.php"
t="google_id_token"
elseif e=="APPLE"then
a="bind_apple_acc.php"
t="apple_id_token"
end
local t=string.format("%s=%s&acc=%s",t,o,UserAccountInfo.acc)
t=encodeURI(CS.XXTEAUtil.Encrypt(t,HTTP_SHIT))

local t=GameEntry.Data.SysDataManager.CurrChannelConfig.AccountWebUrl..a.."?data="..t

GameEntry.Http:SendData(
t,
function(t)
if(t.HasError==false)then
local a=JsonUtil.decode(t.Value)
local t=a["ret"]
if t==0 then
UserAccountInfo.bindPlatform=a["bind_platform"]
UserAccountInfo.bindUserId=a["bind_user_id"]
UIUtil.ShowCommonTips(GameTools.GetLocalize("UI.Setting.Transfer.13",LanguageCategory.LangCommon))
closeUI()
elseif t==1 then
local t=""
if e=="GOOGLE"then
t="set_acc_fail_google_1"
elseif e=="APPLE"then
t="set_acc_fail_apple_1"
end
showMessageBox({
buttons=MessageBoxButtons.OK,
text=GameTools.GetLocalize(t,LanguageCategory.LangCommon)
}
)
elseif t==2 then
local t=""
if e=="GOOGLE"then
t="set_acc_fail_google_2"
elseif e=="APPLE"then
t="set_acc_fail_apple_2"
end
showMessageBox({
buttons=MessageBoxButtons.OK,
text=GameTools.GetLocalize(t,LanguageCategory.LangCommon)
}
)
else
showMessageBox({
buttons=MessageBoxButtons.OK,
text=GameTools.GetLocalize("set_acc_fail",LanguageCategory.LangCommon)
}
)
end
else
showMessageBox({
onOkBtnClick=function()
end,
onBgBtnClick=function()
end,
buttons=MessageBoxButtons.OK,
text=GameTools.GetLocalize("net_poor_retry",LanguageCategory.LangCommon)
}
)
end
end,
false,
true,
nil,
2
)
end
function setAccUnBind()
local e=""
if CS.UnityEngine.Application.platform==CS.UnityEngine.RuntimePlatform.Android then
e="unbind_google_password.php"
else
e="unbind_apple_password.php"
end
local t=string.format("acc=%s",UserAccountInfo.acc)
t=encodeURI(CS.XXTEAUtil.Encrypt(t,HTTP_SHIT))
local e=GameEntry.Data.SysDataManager.CurrChannelConfig.AccountWebUrl..e.."?data="..t
GameEntry.Http:SendData(
e,
function(e)
if(e.HasError==false)then
local e=JsonUtil.decode(e.Value)
local e=e["ret"]
if e==0 then
UserAccountInfo.bindPlatform=""
UserAccountInfo.bindUserId=""
UIUtil.ShowCommonTips(GameTools.GetLocalize("unbind_acc_succ",LanguageCategory.LangCommon))
Refresh()
else
UIUtil.ShowCommonTips(GameTools.GetLocalize("unbind_acc_fail",LanguageCategory.LangCommon))
end
else
showMessageBox({
onOkBtnClick=function()
end,
onBgBtnClick=function()
end,
buttons=MessageBoxButtons.OK,
text=GameTools.GetLocalize("net_poor_retry",LanguageCategory.LangCommon)
}
)
end
end,
false,
true,
nil,
2
)
end
function OnSDKLoginCallBack(e)

if e.ret=="YES"then

setAccBind(e.plat,e.token)
else
if CS.UnityEngine.Application.platform==CS.UnityEngine.RuntimePlatform.Android then
UIUtil.ShowCommonTips(GameTools.GetLocalize("google_one_tap_login_err_"..e.reason,LanguageCategory.LangCommon))
else
end
end
end
function btnMail()
closeUI()
GameEntry.UI:OpenUIForm(UIFormId.UI_ChangeAccExplain)
end
function btnGoogle()
if e then
setAccUnBind()
else
BuildPatchMgr.LoginSDK()
end
end
function btnApple()
if e then
setAccUnBind()
else
BuildPatchMgr.LoginSDK()
end
end
function btnDelete()
GameEntry.UI:OpenUIForm(UIFormId.UI_DeleteHint)
end 
