local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(t,e,o,o,a)
if a and a.attackType==AttackType.SmallSkill then
local i=e[1]
local o=e[2]
local a={e[3],e[4],e[5]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,o,a)
local o=e[6]
local a=e[7]
local e={e[8],e[9],e[10]}
if(o and a)then
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.skillAttackComplete)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return n

