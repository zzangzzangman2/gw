local e={}
local s=e
function e.DoAction(e,n)
local i=e:JudgeSkillPreView(n)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(o==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(o)
local a=i[1]
local t=ModulesInit.ProcedureNormalBattle.GetAllLackCount()
local t=t*i[3]
t=math.min(t,i[4])
a=a+t
ModulesInit.ProcedureNormalBattle.SkillHurt(e,o,n,a)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return s

