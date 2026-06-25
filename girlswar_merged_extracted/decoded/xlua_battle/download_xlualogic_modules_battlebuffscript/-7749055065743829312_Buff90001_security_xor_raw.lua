local o={}
local n=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(o,e,t,t)
local i=o.CurrHeroCtrl
local t=#e
local a=""
for t=1,t,2 do
if e[t+1]then
if a==""then
a=e[t]..":"..e[t+1]
else
a=a..","..e[t]..":"..e[t+1]
end
o.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(o.buffId,e[t],e[t+1])
end
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
o.isExec=true
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return n

