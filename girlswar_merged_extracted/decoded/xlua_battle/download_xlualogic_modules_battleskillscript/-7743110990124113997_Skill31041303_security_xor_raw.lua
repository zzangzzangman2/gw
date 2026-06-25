local e={}
local h=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.eColumn)
if(a==nil)then
return
end
local o=#a
if(o==1)then
return ModulesInit.ProcedureNormalBattle.GetSkillChangeData(SkillChangeType.Change,e[11],a)
end
t:ReduceFury(i.costMp)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(a)
local n=303104105
local o=t.HeroBattleInfo:GetBuff(n)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionAllSkill(o,a)
end
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
local o=#a
for o=1,o do
local a=a[o]
local o=s
if(a.profession==e[3]or a.profession==e[4])then
o=o+e[5]
end
if n==false then
a.HeroBattleInfo:DispelAllGranBuff(true,false,t.HeroId)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,o)
end
local e=ModulesInit.BattleBuffMgr.GetBuffScript(303104103)
return e.HandleSkillChangeData(t)
end
return h

