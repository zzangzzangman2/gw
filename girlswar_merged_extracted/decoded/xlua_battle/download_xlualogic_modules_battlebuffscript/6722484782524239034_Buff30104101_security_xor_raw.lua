local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(t,e,a,a)
if#e<2 then
GameInit.LogError("Buff30104101 buffData 数量应该 大于2")
return
end
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return a

