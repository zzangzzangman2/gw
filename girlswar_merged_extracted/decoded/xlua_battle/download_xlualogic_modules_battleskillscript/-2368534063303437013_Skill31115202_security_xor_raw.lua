local e=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(e,i,t,t)
local a=e:JudgeSkillPreView(i)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemyAll)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(t)
local o=303111508
local n=e.HeroBattleInfo:GetBuff(o)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.DoActionSmallSkill(n,{triggerSkillAtkType=i.atkType})
end
local h=a[1]
local n=303111503
local o=e.HeroBattleInfo:GetBuff(n)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.AddBuffGhostsPower(o,a[5]*#t)
end
local s=#t
for s=1,s do
local t=t[s]
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.AddBuffGhostsPoisonWine(o,t,a[3],a[4])
end
local e=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,i,h)
end
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return s 
