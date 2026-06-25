local e=require("Modules/Battle/BattleUtil")
local e={
}
local n=e
function e.DoAction(e,o)
local t=e:JudgeSkillPreView(o)
local n=t[1]
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
local a=303107927
local i=e.HeroBattleInfo:GetBuff(a)
if(i)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(a)
e.DoActionWithKnightSun(i,t)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,o,n)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return n 
