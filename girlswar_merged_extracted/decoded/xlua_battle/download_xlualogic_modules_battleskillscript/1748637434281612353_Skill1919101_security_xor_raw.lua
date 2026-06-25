local e=require("Modules/Battle/BattleUtil")
local e={
}
local i=e
function e.DoAction(t,e,a)
local e=ModulesInit.ProcedureNormalBattle:GetTeamSkillArgs(e)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
local a=92440
local t=t.HeroBattleInfo:GetBuff(92440)
if t then
local o=ModulesInit.BattleBuffMgr.GetBuffScript(a)
for a=1,#e do
local e=e[a]
o.TriggerEffectMate(t,e)
end
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
return nil
end
return i 
