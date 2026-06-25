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
function e.DoActionBigSkill(e,t)
local e=e:GetBuffData()
if t.HeroBattleInfo.SepsisHp>0 then
local a={
attrId=e[2],
value=e[3],
}
t:AddAttrValueInCurAttack(a)
local e={
attrId=e[4],
value=e[5],
}
t:AddAttrValueInCurAttack(e)
end
end
return o

