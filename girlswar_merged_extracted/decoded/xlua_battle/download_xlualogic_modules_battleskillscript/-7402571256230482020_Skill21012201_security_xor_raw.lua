local s=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(e,n,t,t)
local a=e:JudgeSkillPreView(n)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
local h=a[1]
local a=a[3]
e:AddFuryWithSkill(a)
local a=302101210
local o=e.HeroBattleInfo:GetBuff(a)
if(o)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(a)
e.ConsumeEnergyToAddHp(o)
end
local o=0
local i=302101222
local a=e.HeroBattleInfo:GetBuff(i)
if(a)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
o=e.GetRealHurtValue(a,t)
e.DoBuffWithSmallSkill(a)
end
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,n,h,0,o)
local a=a[3]
local o=a.reduceHpValue
local a=302101201
local a=e.HeroBattleInfo:GetBuff(a)
if a then
local a=a:GetBuffData()
local a=a[5]
local a=math.floor(o*a*MillionCoe)
s:AddSepsisHp(e,t,a)
end
e:FuryHealth(FuryHealthType.Attack)
end
return h 
