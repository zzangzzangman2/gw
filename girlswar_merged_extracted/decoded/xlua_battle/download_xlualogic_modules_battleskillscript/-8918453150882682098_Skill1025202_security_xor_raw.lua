local e={}
local s=e
function e.DoAction(t,n)
local e=t:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local o=e[1]
local i=ModulesInit.ProcedureNormalBattle.GetAllLackCount()
local i=i*e[3]
i=math.min(i,e[4])
o=o+i
if(a.profession==ProfessionType.Mage)then
local e={
attrId=e[5],
value=e[6],
}
t:AddAttrValueInCurAttack(e)
end
local i=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(i~=nil)then
local n=e[7]
local a=e[8]
local o={e[9],e[10],t.HeroId}
local e=#i
for e=1,e do
local e=i[e]
if(e.profession==ProfessionType.Mage)then
e:AddBuff(t,n,a,o)
end
end
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,n,o)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return s

