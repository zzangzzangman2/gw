local e=nil
local t=false
local a=nil
function OnInit(e,e)
bg.onClick:AddListener(function()
t=true
GameTools.CloseUIForm(UIFormId.UI_Line_Show)
end)
btn_go.onClick:AddListener(function()
GameTools.CloseUIForm(UIFormId.UI_Line_Show)
LuaUtils.OpenUrl(Constant.line_url)
end)
end
function OnOpen(o)
EventSystem.AddListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
t=false
e=o
spine:PlayAnimation(1,'in',false,function()
spine:PlayAnimation(1,'idle',true)
end)
a=GameTools:PlayAudioLua(525)
end
function OnClose()
EventSystem.RemoveListener(CommonEventId.OnEventNetReconnectSuccess,OnEventNetReconnectSuccess)
if a then
GameEntry.Audio:StopAudio(a)
a=nil
end
if e and e.callback then
e.callback(e.sender,t,self.UIFormId)
end
end
function OnBeforeDestroy()
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end
function OnEventNetReconnectSuccess()
t=true
GameTools.CloseUIForm(UIFormId.UI_Line_Show)
end 
