local e={
}
local n=e
function e.DoAction(t,o)
local e=t:JudgeSkillPreView(o)
local i=e[1]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
if(e[3]>=RandomMgr:GetBattleRandom())then
local i=e[4]
local o=e[5]
local e={e[6]}
a:AddBuff(t,i,o,e)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(t,a,o,i)
t:FuryHealth(FuryHealthType.Attack)
return nil
end
return n 
