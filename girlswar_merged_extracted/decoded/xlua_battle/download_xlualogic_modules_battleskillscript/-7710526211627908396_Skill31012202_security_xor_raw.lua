local s=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(e,o,t,t)
local t=e:JudgeSkillPreView(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local h=t[1]
local i=t[3]
e:AddFuryWithSkill(i)
local i=t[4]
local n=t[5]
local t={t[6],t[7],t[8],t[9],t[10]}
e:AddBuff(e,i,n,t)
local t=303101210
local i=e.HeroBattleInfo:GetBuff(t)
if(i)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(t)
e.ConsumeEnergyToAddHp(i)
end
local i=0
local n=303101222
local t=e.HeroBattleInfo:GetBuff(n)
if(t)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(n)
i=e.GetRealHurtValue(t,a)
e.DoBuffWithSmallSkill(t)
end
local t=ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,o,h,0,i)
local t=t[3]
local i=t.reduceHpValue
local t=303101201
local t=e.HeroBattleInfo:GetBuff(t)
if t then
local t=t:GetBuffData()
local t=t[5]
local t=math.floor(i*t*MillionCoe)
s:AddSepsisHp(e,a,t)
end
local i=303101229
local t=e.HeroBattleInfo:GetBuff(i)
if(t)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.DoBeansActionSmallSkill(t,{triggerSkillAtkType=o.atkType},a.HeroId)
end
e:FuryHealth(FuryHealthType.Attack)
end
return h 
