local e={
}
local h=e
function e.DoAction(e,n)
local t=e:JudgeSkillPreView(n)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
local i=302108008
local o=e.HeroBattleInfo:GetBuff(i)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.DoActionSmallSkill(o,a)
end
local s=t[1]
local o=t[3]
local i=t[4]
local t={t[5],t[6],t[7]}
e:AddBuff(e,o,i,t)
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,n,s)
e:FuryHealth(FuryHealthType.Attack)
end
return h 
