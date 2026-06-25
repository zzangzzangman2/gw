local e=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(e,n)
local t=e:JudgeSkillPreView(n)
local s=t[1]
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local t=0
local o=302108228
local i=e.HeroBattleInfo:GetBuff(o)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
t=t+e.GetRealHurt(i)
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,n,s,0,t)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return s 
