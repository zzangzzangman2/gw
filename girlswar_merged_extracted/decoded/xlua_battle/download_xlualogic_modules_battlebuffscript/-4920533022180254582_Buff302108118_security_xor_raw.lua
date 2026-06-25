local i=require("Modules/Battle/BattleUtil")
local n=require("Modules/Battle/Formula")
local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,e,e,e)
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.DoActionBigSkill1(e)
local a=e:GetBuffData()
local e=ModulesInit.ProcedureNormalBattle.GetBattleHerosWithTeamId(e.teamId,BattleHeroType.fBack)
for t=1,#e do
local e=e[t]
e:AddFuryWithBuff(a[1])
end
end
function e.DoActionBigSkill2(e,t)
local t=e:GetBuffData()
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
local s,a=i:FindMostBigAtk(o)
local a=math.floor(a*t[4]*MillionCoe)
local s=e.CurrHeroCtrl:GetFinalAtk()
a=math.min(a,s*t[5]*MillionCoe)
local a={
attrId=HeroAttrId.atkAdd,
value=a,
}
e.CurrHeroCtrl:AddAttrValueInCurAttack(a)
local o,a=i:FindMostBigInjureRateAdd(o)
local a=math.floor(a*t[4])
local o=n:GetInjureData(e.CurrHeroCtrl)
local o=o.attackFinalInjureRate
a=math.min(a,o*t[5])
local a={
attrId=HeroAttrId.injureRateAdd,
value=a,
}
e.CurrHeroCtrl:AddAttrValueInCurAttack(a)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHerosWithTeamId(e.teamId,BattleHeroType.fBack)
for a=1,#e do
local e=e[a]
e:AddFuryWithBuff(t[6])
end
end
function e.GetReduceDefRage(e,a)
local t=e:GetBuffData()
local e=t[2]
if a:IsRealFirstRowHero()then
e=math.floor(e*t[3]*MillionCoe)
end
return e
end
function e.GetStateChangeCount(e)
local e=e:GetBuffData()
return e[7]
end
return s

