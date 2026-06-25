local e={}
local o=e
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
function e.DoBeansActionSmallSkill(e,a,t)
local e=e:GetBuffData()
if t>0 then
local e={
attrId=e[1],
value=e[2]*t,
}
a:AddAttrValueInCurAttack(e)
end
end
function e.DoBeansActionBigSkill(e,a,t)
local e=e:GetBuffData()
if t>0 then
local e={
attrId=e[3],
value=e[4]*t,
}
a:AddAttrValueInCurAttack(e)
end
end
return o

