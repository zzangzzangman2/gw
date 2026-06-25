local e=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(a,s,e,t)
local t=a:JudgeSkillPreView(s)
local t=e.skillParam
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a,BattleHeroType.eColumn)
if(e==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local h=t[2]
local n=0
local i=303110501
local o=a.HeroBattleInfo:GetBuff(i)
if o then
local i=ModulesInit.BattleBuffMgr.GetBuffScript(i)
if i.CheckTriggerDeadQuick(o,t[4])then
local s=#e
local a={}
for t=1,s do
local e=e[t]
table.insert(a,e.HeroId)
end
local e=RandomTableWithSeed(a,t[3])
if#e>0 then
n=e[1]
end
local e=t[6]
local a=n
i.AddPursuitAttackIchinotakaCritial(o,e,a,t[4])
end
i.RemoveSwordMaster(o)
local e=303110503
local a=a.HeroBattleInfo:GetBuff(e)
if a then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
e.SetDelayDamageReduceValue(a,t[5])
end
end
local t=#e
for t=1,t do
local t=e[t]
local e=0
ModulesInit.ProcedureNormalBattle.SkillHurt(a,t,s,h,0,e)
end
return nil
end
return h 
