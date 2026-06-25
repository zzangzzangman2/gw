local e={}
local n=e
function e.DoAction(t,i)
local e=t:JudgeSkillPreView(i)
t:ReduceFury(i.costMp)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local o=e[1]
if(a.profession==ProfessionType.Mage)then
o=o+e[3]
end
local n={
attrId=e[4],
value=e[5],
}
t:AddAttrValueInCurAttack(n)
local n={
attrId=e[6],
value=e[7],
}
t:AddAttrValueInCurAttack(n)
local e=e[8]
a.HeroBattleInfo:DispelGranBuff(true,e,nil,nil,t.HeroId)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,i,o)
return nil
end
return n

