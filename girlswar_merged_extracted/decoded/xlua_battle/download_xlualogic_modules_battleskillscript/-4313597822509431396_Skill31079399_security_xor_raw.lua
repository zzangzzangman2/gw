local e={
}
local h=e
function e.DoAction(t,a,o)
local e=t:JudgeSkillPreView(a)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(e==nil)then
return
end
local s=0
local n=o.realHurt or 0
local o=303107922
local i=t.HeroBattleInfo:GetBuff(o)
if i then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(o)
t.DoActionWithEnergyExplode(i,e)
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local o=#e
for o=1,o do
local e=e[o]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,a,s,0,n)
end
return nil
end
return h 
