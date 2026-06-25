local o=require("Modules/Battle/BattleUtil")
local e={
}
local i=e
function e.DoAction(e,a)
local t=e:JudgeSkillPreView(a)
local i=t[1]
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
if o:IsNormalSkillAtkType(a.atkType)then
local a=303112114
local e=e.HeroBattleInfo:GetBuff(a)
if e then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.DoFire2ActionSkill(e,t)
end
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,i)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return i 
