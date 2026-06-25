local e={
}
local o=e
function e.DoAction(e,a,t)
local a=e:JudgeSkillPreView(a)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(e)
local t=t.buffId
local e=e.HeroBattleInfo:GetBuff(t)
if(e)then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.ConsumeEnergyToAddHp(e)
end
return nil
end
return o 
