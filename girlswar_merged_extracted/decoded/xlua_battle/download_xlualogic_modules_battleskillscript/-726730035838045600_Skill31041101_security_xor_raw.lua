local e={
}
local s=e
function e.DoAction(e,i)
local t=e:JudgeSkillPreView(i)
local n=t[1]
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
local a=303104105
local o=e.HeroBattleInfo:GetBuff(a)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(a)
e.DoActionAllSkill(o,{t})
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,i,n)
e:FuryHealth(FuryHealthType.Attack)
local t=ModulesInit.BattleBuffMgr.GetBuffScript(303104103)
return t.HandleSkillChangeData(e)
end
return s 
