local e={}
local h=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return
end
local i=#a
if(i==1)then
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Change,e[11],a)
end
t:ReduceFury(o.costMp)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local s=e[1]
local n=false
if(t:CurrHPPer()>e[6]*MillionCoe)then
n=true
local e={
attrId=e[7],
value=e[8],
}
t:AddAttrValueInCurAttack(e)
else
local e={
attrId=e[9],
value=e[10],
}
t:AddAttrValueInCurAttack(e)
end
local i=#a
for i=1,i do
local a=a[i]
local i=s
if(a.profession==e[3]or a.profession==e[4])then
i=i+e[5]
end
if n==false then
a.HeroBattleInfo:DispelAllGranBuff(true,false,t.HeroId)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,i)
end
local e=ModulesInit.BattleBuffMgr.GetBuffScript(302104103)
return e.HandleSkillChangeData(t)
end
return h

