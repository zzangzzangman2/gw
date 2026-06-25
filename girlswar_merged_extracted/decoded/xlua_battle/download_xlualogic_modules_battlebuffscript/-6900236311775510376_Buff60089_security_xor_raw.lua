local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t)
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,t[1],t[2],{t[3]})
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.enemyFirstBigSkill)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(t,a,e)
return t.buffWeight[1]*e[1]
end
return a

