local i=ModulesInit.GuildTerritoryMgr
local o=nil
local a=0
local e=nil
local s=nil
local r=false
local h=0
local n=nil
local t=nil
function OnInit(e)
btn_click.onClick:AddListener(function()
if o then
o.OnClickSelectTask(a)
end
end)
end
function OnOpen(e)
e=e or{}
o=e.parentScriptEnv
SetCollectEffectShow(false)
end
function OnClose()
if t then
GameEntry.Audio:StopAudio(t)
t=nil
end
RemoveSpine()
o=nil
a=0
e=nil
s=nil
r=false
end
function GetTaskInfo()
return e
end
function OnRefresh(t)
if t<=0 then
return
end
a=t
if GetTaskInfoAndCheckShow()==false then
if o then
o.RemoveRadarEvent(a)
end
return
end
i:SetTransUILocalPos(transform,e.posId,true)
s=i:GetRadarMissionCfgByDid(e.taskDid)
if s==nil then
return
end
LoadModel(s.prefab)
end
function SetCollectEffectShow(e)
LuaUtils.SetActive(effect_battle_parent.transform,e)
if e then
if t==nil then
t=GameTools:PlayAudioLua(672)
end
else
if t then
GameEntry.Audio:StopAudio(t)
end
t=nil
end
end
function GetTaskInfoAndCheckShow()
r=true
e=i:GetRadarEventInfoByRadarEventId(a)
if e==nil then
e=i:GetOtherRadarEventInfoByRadarEventId(a)
r=false
end
if e==nil or e.status==1 then
return false
end
local e=i:GetAirshipInfoByRadarEventId(a)
if e~=nil then
if i:GetLocalServerTime()>=e.battleOverTime then
if e.result==nil or e.result.win==true then
return false
end
end
end
return true
end
function LoadModel(e)
if IsNil(n)~=nil and h==e then
return
end
local a={scale=1,animName="idle",addSortingOrder=0}
GameTools:PoolGameObjectSpawnWithPath(e,nil,function(t,o,o)
RemoveSpine()
n=t
h=e
UIUtil.HandlePoolSpinePrefab(t,event_root.transform,a)
end)
end
function RemoveSpine()
if n then
UIUtil.SpinePoolDespawn(n)
end
n=nil
h=0
end 
