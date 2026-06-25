local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(i,a,t,o,e)
if(t==nil or o==nil or e==nil)then
GameInit.LogError("执行Buff脚本 atkHeroCtrl or beAtkHeroCtrl is nil")
return nil
end
if(e.heroDid==a[1])then
t:ResetFuryWithBuff(a[2])
end
return nil
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.teamHeroDead)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return i

