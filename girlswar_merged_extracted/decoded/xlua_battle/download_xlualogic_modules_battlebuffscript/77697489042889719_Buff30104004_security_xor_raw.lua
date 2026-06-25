local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,a,a)
if#e>=2 then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
end
if#e>=4 then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[3],e[4])
end
t.isExec=true
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return o

