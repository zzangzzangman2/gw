local s=require("Modules/Battle/BattleUtil")
local e={
}
local h=e
function e.DoAction(e,i,t,t)
local t=e:JudgeSkillPreView(i)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(a==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(a)
local h=t[1]
local o=t[3]
e:AddFuryWithSkill(o)
local n=t[4]
local o=t[5]
local t={t[6],t[7],t[8],t[9],t[10]}
e:AddBuff(e,n,o,t)
local o=302101210
local t=e.HeroBattleInfo:GetBuff(o)
if(t)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.ConsumeEnergyToAddHp(t)
end
local n=0
local o=302101222
local t=e.HeroBattleInfo:GetBuff(o)
if(t)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
n=e.GetRealHurtValue(t,a)
e.DoBuffWithSmallSkill(t)
end
local t=ModulesInit.ProcedureNormalBattle.SkillHurt(e,a,i,h,0,n)
local t=t[3]
local o=t.reduceHpValue
local t=302101201
local t=e.HeroBattleInfo:GetBuff(t)
if t then
local t=t:GetBuffData()
local t=t[5]
local t=math.floor(o*t*MillionCoe)
s:AddSepsisHp(e,a,t)
end
e:FuryHealth(FuryHealthType.Attack)
end
return h 
