local e={}
local r=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local h=e[1]
local i=e[3]
t:AddFuryWithSkill(i)
local s=e[4]
local i=e[5]
local n={e[6],e[7],e[8]}
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fBack)
for a=1,#e do
local e=e[a]
e:AddBuff(t,s,i,n)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,h)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return r

