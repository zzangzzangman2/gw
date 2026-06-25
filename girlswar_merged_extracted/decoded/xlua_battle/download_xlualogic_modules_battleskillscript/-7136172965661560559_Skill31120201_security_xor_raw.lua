local e=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(e,n,t,t)
local a=e:JudgeSkillPreView(n)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eMaxHpPercentWithCount,1)
if(t==nil)then
return nil
end
local t=t[1]
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
local s=a[1]
local i=303112012
local o=e.HeroBattleInfo:GetBuff(i)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.DoActionSmallSkill(o,t)
end
local o=303112003
local i=e.HeroBattleInfo:GetBuff(o)
if i then
local o=ModulesInit.BattleBuffMgr.GetBuffScript(o)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAllExcludeSelf)
local e=RandomTableWithSeed(e,a[3])
table.insert(e,t)
for t=1,#e do
o.AddBuffFragileAlliance(i,e[t])
end
end
local a=0
local t=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,n,s,nil,a)
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return h 
