local e={}
local i=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
t:ReduceFury(o.costMp)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local s=e[1]
local n=e[3]
local i=e[4]
local e={e[5],e[6],e[7],e[8],e[9]}
a:AddBuff(t,n,i,e)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,s)
return nil
end
return i

