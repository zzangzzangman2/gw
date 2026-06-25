local e={}
local h=e
function e.DoAction(t,i,o)
local e=t:JudgeSkillPreView(i)
t:ReduceFury(i.costMp)
local a
if o~=nil then
a=o[1]
end
if a==nil then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
end
if(a==nil)then
return
end
local o={a}
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
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
local a=#o
for a=1,a do
local a=o[a]
local o=s
if(a.profession==e[3]or a.profession==e[4])then
o=o+e[5]
end
if n==false then
a.HeroBattleInfo:DispelAllGranBuff(true,false,t.HeroId)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,o)
end
local e=ModulesInit.BattleBuffMgr.GetBuffScript(302104103)
return e.HandleSkillChangeData(t)
end
return h

