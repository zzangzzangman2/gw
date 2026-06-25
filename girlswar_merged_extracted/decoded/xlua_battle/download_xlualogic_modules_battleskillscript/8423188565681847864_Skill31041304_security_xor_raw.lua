local e={}
local s=e
function e.DoAction(e,i,o)
local t=e:JudgeSkillPreView(i)
e:ReduceFury(i.costMp)
local a
if o~=nil then
a=o[1]
end
if a==nil then
a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
end
if(a==nil)then
return
end
local o={a}
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local n=303104105
local a=e.HeroBattleInfo:GetBuff(n)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionAllSkill(a,o)
end
local s=t[1]
local n=false
if(e:CurrHPPer()>t[6]*MillionCoe)then
n=true
local t={
attrId=t[7],
value=t[8],
}
e:AddAttrValueInCurAttack(t)
else
local t={
attrId=t[9],
value=t[10],
}
e:AddAttrValueInCurAttack(t)
end
local a=#o
for a=1,a do
local a=o[a]
local o=s
if(a.profession==t[3]or a.profession==t[4])then
o=o+t[5]
end
if n==false then
a.HeroBattleInfo:DispelAllGranBuff(true,false,e.HeroId)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,i,o)
end
local t=ModulesInit.BattleBuffMgr.GetBuffScript(303104103)
return t.HandleSkillChangeData(e)
end
return s

