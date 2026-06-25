local e=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
local n=t[1]
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
local o=302108106
local i=e.HeroBattleInfo:GetBuff(o)
local o=ModulesInit.BattleBuffMgr.GetBuffScript(o)
local o=o.GetRealHurtValue(i,t)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,n,0,o)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return s 
