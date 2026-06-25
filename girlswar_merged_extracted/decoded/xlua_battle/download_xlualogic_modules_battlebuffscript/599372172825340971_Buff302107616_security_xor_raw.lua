local o=require("Modules/Battle/Formula")
local i=require("Modules/Battle/BattleUtil")
local t={}
local d=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,e,e,e)
end
function t.GetCanTrigger(e)
return false
end
function t.SetLogicData(e,e)
end
function t.DoActionBigSkill1(a,t)
local e=a:GetBuffData()
if ModulesInit.ProcedureNormalBattle.IsPVE()then
return
end
local t=i:FindMostBigAtk(t)
if t then
local s=math.floor(t:GetFinalAtk()*e[3]*MillionCoe)
local i=o:GetInjureData(t)
local i=math.floor(i.attackFinalInjureRate*e[4])
local n=o:GetInjureResData(t)
local n=math.floor(n.defFinalInjureResRate*e[5])
local o=o:CalculateHeroAttackCriticalRate(t,nil)
local o=math.floor(o.attackCriticalRate*e[6])
local d=e[1]
local r=e[2]
local h={HeroAttrId.atkAdd,s,HeroAttrId.injureRateAdd,i,HeroAttrId.injureResRateAdd,n,HeroAttrId.criticalRateAdd,o}
a.CurrHeroCtrl:AddBuffAfterRemove(a.CurrHeroCtrl,d,r,h)
local h=e[11]
local e=e[2]
local o={HeroAttrId.atkAdd,-s,HeroAttrId.injureRateAdd,-i,HeroAttrId.injureResRateAdd,-n,HeroAttrId.criticalRateAdd,-o}
t:AddBuffAfterRemove(a.CurrHeroCtrl,h,e,o)
end
end
function t.DoActionBigSkill2(e,t)
local e=e:GetBuffData()
local a={
attrId=e[7],
value=e[8],
}
t:AddAttrValueInCurAttack(a)
local e={
attrId=e[9],
value=e[10],
}
t:AddAttrValueInCurAttack(e)
end
return d

