local e={
}
local n=e
function e.DoAction(e,i)
local t=e:JudgeSkillPreView(i)
local a=t[1]
local o=303107215
local t=e.HeroBattleInfo:GetBuff(o)
if(t)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
a=e.ConsumeBeansDamageRate(t,a)
end
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,i,a)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return n 
