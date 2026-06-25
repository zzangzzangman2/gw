local e=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(e,n,t,t)
local a=e:JudgeSkillPreView(n)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
local o=303110513
local i=e.HeroBattleInfo:GetBuff(o)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.DoActionSmallSkill(i,t)
end
local s=a[1]
e:AddFuryWithSkill(a[3])
local i=303110501
local o=e.HeroBattleInfo:GetBuff(i)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.AddSwordMaster(o,a[4])
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,n,s,0,0)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return h 
