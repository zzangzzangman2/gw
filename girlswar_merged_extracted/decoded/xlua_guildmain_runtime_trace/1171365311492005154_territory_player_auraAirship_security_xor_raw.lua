local e=ModulesInit.GuildTerritoryMgr
local i=nil
local n=nil
local t=nil
local o=0
local a=nil
function OnInit(e)
end
function OnOpen(a)
a=a or{}
i=a.parentScriptEnv
t=e:GetMapBaseCfg()
n=t.auraAirSpeed or 3000000
RefreshShow()
end
function OnClose()
transform:DOKill()
RemoveSpine()
n=0
i=nil
t=nil
end
function RefreshShow()
local t=t.auraAirSkin or{}
local t=t[math.random(1,#t)]
local t=e:GetAirShipCfg(t)
LoadModel(t.slgPrefab)
local a,t=i.GetAuraAirshipStartEndPos()
LuaUtils.SetLocalPos(transform,a.x,a.y,0)
local o=a.x>t.x
LuaUtils.SetLocalScale(airship_root.transform,o and-1 or 1,1,1)
local i,s=e:UILocalPos2MapPos(a.x,a.y)
local o,a=e:UILocalPos2MapPos(t.x,t.y)
local e=e:GetAirShipTime({i,s},{o,a},n)
transform:DOKill()
transform:DOLocalMove(Vector3(t.x,t.y,0),e):SetEase(CS.DG.Tweening.Ease.Linear):OnComplete(function()
RefreshShow()
end)
end
function LoadModel(e)
if IsNil(a)~=nil and o==e then
return
end
local i={
scale=0.7,
animName="idle",
addSortingOrder=0,
}
UIUtil.GetSpinePrefabFromPool(e,function(t,n,n)
RemoveSpine()
o=e
a=t
UIUtil.HandlePoolSpinePrefab(t,airship_root.transform,i)
LuaUtils.SetLocalPos(t.transform,0,0,0)
end)
end
function RemoveSpine()
if a then
UIUtil.SpinePoolDespawn(a)
end
o=0
a=nil
end 
