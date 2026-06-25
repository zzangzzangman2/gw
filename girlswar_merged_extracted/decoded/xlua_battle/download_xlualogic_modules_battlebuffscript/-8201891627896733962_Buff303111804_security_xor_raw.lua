local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.DoActionSmallSkill(e,t,a)
local e=e:GetBuffData()
if a>0 then
local o={
attrId=e[1],
value=e[2]*a,
}
t:AddAttrValueInCurAttack(o)
local e={
attrId=e[3],
value=e[4]*a,
}
t:AddAttrValueInCurAttack(e)
end
t:ReduceFuryWithBuffImmediately(e[5])
end
return i

