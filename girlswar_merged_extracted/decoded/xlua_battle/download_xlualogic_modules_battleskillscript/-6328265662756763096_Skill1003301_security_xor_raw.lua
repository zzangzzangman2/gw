local e={}
local i=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
e:ReduceFury(a.costMp)
local n=t[1]
local i=t[3]
local o=t[4]
local t={t[5]}
e:AddBuff(e,i,o,t)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,n)
return nil
end
return i

