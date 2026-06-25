local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(o,t,a,e)
if(a==nil or e==nil)then
GameInit.LogError("执行Buff脚本 atkHeroCtrl or beAtkHeroCtrl is nil")
return nil
end
e:AddFuryWithBuff(t[1])
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.mateSkillAttack)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return o

