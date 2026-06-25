local h=require("DataNode/DataTable/Create/hero/DTHeroDBModel")
local a=nil
local t=nil
local e=""
local l=false
local r=0
local s=0
local i=nil
local n=true
local d=0
local o=nil
function OnInit(e,e)
btn_fanhui.onClick:AddListener(closeUI)
btn_chusuo.onClick:AddListener(btnGoOutView)
btn_tujian.onClick:AddListener(btnHeroAtlasView)
Sound_button.onClick:AddListener(btnSoundView)
a=Video_hero.transform:GetComponent(typeof(CS.YouYou.UIVideoPlayer))
a:SetCallbackEvent(OnLoopPointReached)
if not i then
i=GameEntry.Audio:GetBGMCurrAudioEventId()
end
end
function OnLoopPointReached()

l=true
if e~=""then
GameTools:PlayUIVideo(a,e)
ErrInfoCollectMgr:AddInfo("[AVProVideo] Error","PrepareVideo",e)
end
end
function OnOpen(i)
EventSystem.AddListener(SysEventId.OnUpdate,OnUpdate)
EventSystem.AddListener(CommonEventId.OnEnterBackground,OnEnterBackground)
EventSystem.AddListener(CommonEventId.OnEnterForeground,OnEnterForeground)
t=i.heroId
o=h.GetEntity(t).smallTheater
GameEntry.Audio:StopAllAudio()
LuaUtils.SetActive(sound_on.transform,false)
LuaUtils.SetActive(sound_off.transform,false)
n,d=PlayerMgr:GetBGMVolume()
if not n then
GameEntry.Audio.IsPlayBGM=true
GameEntry.Audio:SetBGMVolumeSlow(0)
LuaUtils.SetActive(sound_off.transform,true)
else
LuaUtils.SetActive(sound_on.transform,true)
end
SaveMgr.SetBoolByAccServerIdPlayerUid("SMALLTHEATER_"..t,"",true)
RedPointMgr:notify()
local i={t}
if t~=o then
table.insert(i,o)
end
DynamicModuleRes.CheckResAndDownload({[1]=i,[14]=i,[15]=i},function()
e=HeroMgr:GetHeroVideoPath2(o)
NetManager.Send(ProtoId.PRT_HERO_DRAMA_OPEN_REQ,{heroDid=t})
refreshView()
if e~=""then
GameTools:PlayUIVideo(a,e)
ErrInfoCollectMgr:AddInfo("[AVProVideo] Error","PrepareVideo",e)
local e=20000+o
GameTools:PlayBGMLua(e)
end
end)
end
function OnEnterBackground()
if e~=""then
a:Stop()
GameEntry.Audio:StopBGM()
end
end
function OnEnterForeground()
if e~=""then
a:Stop()
GameTools:PlayUIVideo(a,e)
ErrInfoCollectMgr:AddInfo("[AVProVideo] Error","PrepareVideo",e)
local e=20000+o
GameTools:PlayBGMLua(e)
end
end
function OnUpdate()
s=s-Time.deltaTime
if s>0.3 then
return
end
s=0.3
r=r+1
end
function OnClose()
EventSystem.RemoveListener(SysEventId.OnUpdate,OnUpdate)
EventSystem.RemoveListener(CommonEventId.OnEnterBackground,OnEnterBackground)
EventSystem.RemoveListener(CommonEventId.OnEnterForeground,OnEnterForeground)
if i and i>0 then
GameTools:PlayBGMLua(i)
end
if a then
NetManager.Send(ProtoId.PRT_HERO_DRAMA_CLOSE_REQ,{heroDid=t,isFinish=l,seeMS=math.ceil(r*100)})
a:Stop()
end
local e,t=PlayerMgr:GetBGMVolume()
if not e then
GameEntry.Audio.IsPlayBGM=e
end
GameEntry.Audio:SetBGMVolumeSlow(t/100)
end
function refreshView()
local e=h.GetEntity(t).jumpId
LuaUtils.SetActive(btn_chusuo.transform,false)
end
function closeUI()
ViewMgr:OnWillClose(self.UIFormId)
GameTools.CloseUIForm(UIFormId.UI_HeroSmallTheater)
end
function btnGoOutView()
local e=h.GetEntity(t).jumpId
if e and e~=0 then
GameTools.CloseUIForm(UIFormId.UI_HeroSmallTheater)
JumpMgr:OnJumpUI(e)
else
local e,t=JumpMgr.CheckOpenExtractSSRByHeroId(t)
if e then
GameTools.CloseUIForm(UIFormId.UI_HeroSmallTheater)
end
end
end
function btnHeroAtlasView()
if GameFunction.IsFunctionUnLock(GameFunctionType.Gallery,true)then
GameTools.CloseUIForm(UIFormId.UI_HeroSmallTheater)
GameEntry.UI:OpenUIForm(UIFormId.UI_HeroExhibition,{heroDid=t,spineType=true})
end
end
function btnSoundView()
LuaUtils.SetActive(sound_off.transform,false)
LuaUtils.SetActive(sound_on.transform,false)
n=not n
if not n then
GameEntry.Audio:SetBGMVolumeSlow(0)
LuaUtils.SetActive(sound_off.transform,true)
else
GameEntry.Audio:SetBGMVolumeSlow(d/100)
LuaUtils.SetActive(sound_on.transform,true)
end
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

