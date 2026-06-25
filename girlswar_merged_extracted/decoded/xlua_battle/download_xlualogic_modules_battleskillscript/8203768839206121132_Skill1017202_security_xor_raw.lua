local e={
}
local s=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local s=e[1]
local n=e[3]
local a=e[4]
local i={e[5]}
t:AddBuff(t,n,a,i)
local n=e[6]
local a=e[7]
local i={e[8]}
t:AddBuff(t,n,a,i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local i=e[9]
local n=e[10]
local e={e[11]}
a:AddBuff(t,i,n,e)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,s)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return s 
