local e={}
local s=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
t:ReduceFury(o.costMp)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local h=e[1]
local s=e[3]
local n=e[4]
local i=e[5]
local e={e[6],e[7],e[8],e[9],e[10]}
a:CheckAddBuff(s,t,n,i,e)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,h)
return nil
end
return s

