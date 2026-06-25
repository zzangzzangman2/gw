local e={}
local s=e
function e.DoAction(t,a)
local e=t:JudgeSkillPreView(a)
local o=e[1]
local s=e[3]
local n=e[4]
local i={e[5],e[6]}
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
e:AddBuff(t,s,n,i)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,a,o)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return s

