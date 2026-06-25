local r=require("Modules/Battle/BattleUtil")
local e={
}
local d=e
function e.DoAction(e,a,t,t)
local i=e:JudgeSkillPreView(a)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eState,1,nil,303110907)
local t=t[1]
if(t==nil)then
t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
end
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
local n=303110909
local o=e.HeroBattleInfo:GetBuff(n)
if o then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoActionSmallSkill(o,t,a.atkType)
end
local h=i[1]
local o=i[3]
local s=303110906
local n=e.HeroBattleInfo:GetBuff(s)
if n then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
if r:CheckCanTriggerAttackTask(a.atkType)then
e.AddBuffBloodPower(n,i[4])
end
o=o+e.GetRateHuntingMark(n,t)
end
local n=303110916
local i=e.HeroBattleInfo:GetBuff(n)
if(i)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
e.DoBeansActionSmallSkill(i,t)
end
if o>RandomMgr:GetBattleRandom()then
e.IgnoreBlock=true
e.IgnoreInjureRes=true
end
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,h)
e.IgnoreBlock=false
e.IgnoreInjureRes=false
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return d 
