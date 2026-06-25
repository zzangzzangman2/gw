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
function e.DoActionSmallSkill(e,t)
local e=e:GetBuffData()
local a={
attrId=e[1],
value=e[2],
}
t:AddAttrValueInCurAttack(a)
local e={
attrId=e[3],
value=e[4],
}
t:AddAttrValueInCurAttack(e)
end
function e.DoActionSmallSkill2(e)
local t=e:GetBuffData()
e.CurrHeroCtrl:AddFuryWithBuff(t[5])
end
return o

