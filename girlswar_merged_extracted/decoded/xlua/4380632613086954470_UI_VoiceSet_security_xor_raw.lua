local e=true
local o=true
local i=true
local n
local s
local d
local r
local a
local t
local h
function OnInit(e,e)
Image.onClick:AddListener(closeUI)
btn_fanhui.onClick:AddListener(closeUI)
btn_save.onClick:AddListener(btnSave)
btn_bg_music.onClick:AddListener(handler(1,changeOpen))
btn_effect_music.onClick:AddListener(handler(2,changeOpen))
btn_language_chnage.onClick:AddListener(changeLanguage)
n=slider_bg_music:GetComponent(typeof(CS.UnityEngine.UI.Slider))
n.onValueChanged:AddListener(
function()
bgVolumeChange()
end
)
s=slider_effect_music:GetComponent(typeof(CS.UnityEngine.UI.Slider))
s.onValueChanged:AddListener(
function()
effectVolumeChange()
end
)
toggle1.onValueChanged:AddListener(
function(e)
if e then
r=1
LuaUtils.SetActive(p_set_volume.transform,true)
LuaUtils.SetActive(p_set_game.transform,false)
end
end
)
toggle2.onValueChanged:AddListener(
function(e)
if e then
r=2
LuaUtils.SetActive(p_set_volume.transform,false)
LuaUtils.SetActive(p_set_game.transform,true)
end
end
)
toggle_ui_set_30.onValueChanged:AddListener(
function(e)
a=30
RefreshUIFrameRate()
end
)
toggle_ui_set_45.onValueChanged:AddListener(
function(e)
a=45
RefreshUIFrameRate()
end
)
toggle_ui_set_60.onValueChanged:AddListener(
function(e)
a=60
RefreshUIFrameRate()
end
)
toggle_battle_set_30.onValueChanged:AddListener(
function(e)
t=30
RefreshBattleFrameRate()
end
)
toggle_battle_set_45.onValueChanged:AddListener(
function(e)
t=45
RefreshBattleFrameRate()
end
)
toggle_battle_set_60.onValueChanged:AddListener(
function(e)
t=60
RefreshBattleFrameRate()
end
)
toggle_game_quality_1.onValueChanged:AddListener(
function(e)
h=1
RefreshGameQuality()
end
)
toggle_game_quality_2.onValueChanged:AddListener(
function(e)
h=2
RefreshGameQuality()
end
)
end
function OnOpen(t)
d=0
e,n.value=PlayerMgr:GetBGMVolume()
o,s.value=PlayerMgr:GetEffectVolume()
i=PlayerMgr:GetAudioLanguageJp()
refreshView()
end
function OnClose()
d=0
end
function OnBeforeDestroy()
end
function refreshView()
refreshBgView()
refreshEffectView()
refreshLanguageView()
LuaUtils.SetActive(toggle_ui_set_45.transform,false)
LuaUtils.SetActive(toggle_battle_set_45.transform,false)
a=GetUIFrameRate()
t=GetBattleFrameRate()
h=GetGameQuality()
RefreshUIFrameRate()
RefreshBattleFrameRate()
RefreshGameQuality()
r=1
LuaUtils.SetToggleValue(toggle1,r==1,false)
LuaUtils.SetActive(p_set_volume.transform,r==1)
LuaUtils.SetActive(p_set_game.transform,r==2)
end
function refreshBgView()
LuaUtils.SetActive(im_bg_music_on.transform,e)
LuaUtils.SetActive(im_bg_music_off.transform,not e)
GameEntry.Audio:SetBGMVolumeSlow(n.value/100)
LuaUtils.SetLabelText(text_bg_music,math.floor(n.value))
end
function refreshEffectView()
LuaUtils.SetActive(im_effect_music_on.transform,o)
LuaUtils.SetActive(im_effect_music_off.transform,not o)
GameEntry.Audio.EffectVolumeScale=s.value/100
LuaUtils.SetLabelText(text_effect_music,math.floor(s.value))
end
function refreshLanguageView()
LuaUtils.SetActive(im_jp.transform,i)
LuaUtils.SetActive(im_kr.transform,not i)
end
function bgVolumeChange()
local e=math.floor(n.value)
refreshBgView()
end
function effectVolumeChange()
local e=math.floor(s.value)
refreshEffectView()
if d+0.3<Time.realtimeSinceStartup then
GameTools:PlayAudioLua(201)
d=Time.realtimeSinceStartup
end
end
function changeOpen(t)
if t==1 then
e=not e
GameEntry.Audio.IsPlayBGM=e
if e then
local e=GameTools:GetMainPageBgmId()
GameTools:PlayBGMLua(e,true)
else
GameEntry.Audio:StopBGM()
end
refreshBgView()
else
o=not o
GameEntry.Audio.IsPlayEffect=o
refreshEffectView()
end
end
function changeLanguage()
i=not i
GameTools:SetAudioLanguage(i)
refreshLanguageView()
end
function btnSave()
PlayerMgr:SaveBGMVolume(n.value)
PlayerMgr:SaveBGMOpen(e)
PlayerMgr:SaveEffectVolume(s.value)
PlayerMgr:SaveEffectOpen(o)
PlayerMgr:SaveAudioLanguageJp(i)
SaveUIFrameRate(a)
SaveBattleFrameRate(t)
SaveGameQuality(h)
ApplyQSUI()
CS.UnityEngine.Application.targetFrameRate=GetUIFrameRate()

closeUI()
end
function closeUI()
PlayerMgr:SetBGMVolume()
PlayerMgr:SetEffectVolume()
local t,a=PlayerMgr:GetBGMVolume()
if t then
if t~=e then
local e=GameTools:GetMainPageBgmId()
GameTools:PlayBGMLua(e,true)
end
else
GameEntry.Audio:StopBGM()
end
local e=PlayerMgr:GetAudioLanguageJp()
GameTools:SetAudioLanguage(e)
LuaUtils.SetToggleValue(toggle1,true)
GameTools.CloseUIForm(UIFormId.UI_VoiceSet)
end
function RefreshUIFrameRate()
LuaUtils.SetToggleValue(toggle_ui_set_30,a==30,false)
LuaUtils.SetToggleValue(toggle_ui_set_45,a==45,false)
LuaUtils.SetToggleValue(toggle_ui_set_60,a==60,false)
end
function RefreshBattleFrameRate()
LuaUtils.SetToggleValue(toggle_battle_set_30,t==30,false)
LuaUtils.SetToggleValue(toggle_battle_set_45,t==45,false)
LuaUtils.SetToggleValue(toggle_battle_set_60,t==60,false)
end
function RefreshGameQuality()
LuaUtils.SetToggleValue(toggle_game_quality_1,h==1,false)
LuaUtils.SetToggleValue(toggle_game_quality_2,h==2,false)
end
function OnWillClose()
ViewMgr:OnWillClose(self.UIFormId)
end

