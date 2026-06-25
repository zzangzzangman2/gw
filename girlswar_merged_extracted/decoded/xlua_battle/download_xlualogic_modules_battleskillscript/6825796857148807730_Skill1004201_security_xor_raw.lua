local e={}
local n=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
local o=t[1]
local n=t[3]
local i=t[4]
local t={t[5]}
e:AddBuff(e,n,i,t)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,o)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return n

