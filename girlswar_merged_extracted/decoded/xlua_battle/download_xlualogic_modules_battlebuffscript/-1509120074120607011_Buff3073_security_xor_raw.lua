local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(t,e,a,o)
if(a==nil or o==nil)then
GameInit.LogError("执行Buff脚本 atkHeroCtrl or beAtkHeroCtrl is nil")
return nil
end
local i=e[1]
local o=e[2]
local a={e[3]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,o,a)
local o=e[4]
local a=e[5]
local e={e[6]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
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
return e.buffWeight[1]*t[1]+e.buffWeight[2]*t[2]+e.buffWeight[3]*t[3]+e.buffWeight[4]*t[4]+e.buffWeight[5]*t[5]+e.buffWeight[6]*t[6]
end
return o

