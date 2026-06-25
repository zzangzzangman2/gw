local s=ModulesInit.GuildTerritoryMgr
local h=nil
local a=nil
local e=nil
local n=nil
local r=nil
local i=0
local t=nil
local o=false
function OnInit(e)
end
function OnOpen(e)
e=e or{}
h=e.parentScriptEnv
LuaUtils.SetActive(un_GuildTerritory_teleport.transform,false)
end
function OnClose()
StopAnimSequence()
RemoveSpine()
a=nil
e=nil
h=nil
o=false
end
function OnRefresh(t)
if t==nil then
return
end
SetBuildInfo(t)
local t=e.name
if e.playerId==PlayerMgr.PlayerInfo.uid then
t="<color=#42e16f>"..t.."</color>"
end
LuaUtils.SetTextMeshText(text_name,t)
if o==false then
s:SetTransUILocalPos(transform,e.posId)
end
local e=PlayerCityMgr:GetDTPlayerCityAtlasCfg(e.skinId)
LoadModel(e.bigPrefab)
end
function SetBuildInfo(t)
if t==nil then
return
end
e=t
end
function GetBuildInfo()
return e
end
function SetIsTransferAnim(e)
o=e
if e==false then
LuaUtils.SetActive(un_GuildTerritory_teleport.transform,false)
end
end
function TransferRefreshBuildingPos()
s:SetTransUILocalPos(transform,e.posId)
GameTools:PlayAudioLua(792)
LuaUtils.SetActive(un_GuildTerritory_teleport.transform,true)
end
function LoadModel(e)
if IsNil(t)~=nil and i==e then
return
end
local o={scale=1,animName="idle",addSortingOrder=0}
UIUtil.GetSpinePrefabFromPool(e,function(a,n,n)
RemoveSpine()
i=e
t=a
UIUtil.HandlePoolSpinePrefab(a,building_root.transform,o)
end)
end
function RemoveSpine()
if t then
UIUtil.SpinePoolDespawn(t)
end
r=nil
t=nil
i=0
end
function CheckNeedAnim(e)
return a~=nil and a~=e
end
function StopAnimSequence()
if n~=nil then
n:Kill()
n=nil
end
end
function OnShowBuildingAnim(t,e)
a=t
StopAnimSequence()
if e then
e()
end
end
function OnHideBuildingAnim(e)
StopAnimSequence()
if e then
e()
end
end 
