local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.OnRemoveSelf(e,e)
end
function e.DoAction(t,e,a,o)
if(a==nil or o==nil)then
GameInit.LogError("执行Buff脚本 atkHeroCtrl or beAtkHeroCtrl is nil")
return nil
end
local a=e[1]
local o=e[2]
local e={e[3],e[4],e[5],e[6]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
return nil
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.beBlocked)then
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

