local a=require('Common/cs_coroutine')
local e
local t=false
function OnInit(e,e)
btn_mainPlay.onClick:AddListener(function()
if not t then
t=true
CloseMainEnterView()
end
end)
end
function OnOpen(e)
OpenMainEnterView()
end
function OnClose()
t=false
CloseMainPlayCor()
end
function OpenMainEnterView()
LuaUtils.SetActive(btn_mainPlay.transform,false)
GameTools:PlayAudioLua(431)
local o=spine_mainPlay.transform:GetComponent(typeof(CS.YouYou.UISpineCtr))
o:PlayAnimation(0,'in',false,function()
EventSystem.SendEvent(CommonEventId.OnReStartGuide,{event="ON_PLAY_MAINANIM_SUC"})
LuaUtils.SetActive(btn_mainPlay.transform,true)
CloseMainPlayCor()
e=a.start(function()
coroutine.yield(CS.UnityEngine.WaitForSeconds(1.5))
if not t then
t=true
CloseMainEnterView()
end
e=nil
end)
end)
ModulesInit.PhotoArtistMgr:sendViewId(ModulesInit.MainPageMgr.playMainSaveId)
ModulesInit.MainPageMgr.isFormEarthRoot=false
end
function CloseMainEnterView()
local e=spine_mainPlay.transform:GetComponent(typeof(CS.YouYou.UISpineCtr))
e:PlayAnimation(0,'out',false,function()
GameEntry.UI:OpenUIForm(UIFormId.UI_CommonLoading,
{
style=LoadingStyle.Cloud,
loadResFinish=function()
GameTools.CloseUIForm(UIFormId.UI_ChapterCityShow)
EventSystem.SendEvent(CommonEventId.PlayLoadingCloudAni)
end
})
end)
end
function CloseMainPlayCor()
if e then
a.stop(e)
end
e=nil
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

