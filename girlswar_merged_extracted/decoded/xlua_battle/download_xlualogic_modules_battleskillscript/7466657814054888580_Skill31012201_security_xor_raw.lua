local s=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(e,a,t,t)
local o=e:JudgeSkillPreView(a)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
local h=o[1]
local o=o[3]
e:AddFuryWithSkill(o)
local o=303101210
local i=e.HeroBattleInfo:GetBuff(o)
if(i)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.ConsumeEnergyToAddHp(i)
end
local n=0
local i=303101222
local o=e.HeroBattleInfo:GetBuff(i)
if(o)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
n=e.GetRealHurtValue(o,t)
e.DoBuffWithSmallSkill(o)
end
local o=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,h,0,n)
local o=o[3]
local i=o.reduceHpValue
local o=303101201
local o=e.HeroBattleInfo:GetBuff(o)
if o then
local a=o:GetBuffData()
local a=a[5]
local a=math.floor(i*a*MillionCoe)
s:AddSepsisHp(e,t,a)
end
local o=303101229
local i=e.HeroBattleInfo:GetBuff(o)
if(i)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.DoBeansActionSmallSkill(i,{triggerSkillAtkType=a.atkType},t.HeroId)
end
e:FuryHealth(FuryHealthType.Attack)
end
return h 
