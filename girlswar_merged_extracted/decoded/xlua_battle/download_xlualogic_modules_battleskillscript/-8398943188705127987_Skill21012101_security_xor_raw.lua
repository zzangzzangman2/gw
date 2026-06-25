local n=require("Modules/Battle/BattleUtil")
local e={
}
local s=e
function e.DoAction(e,i)
local t=e:JudgeSkillPreView(i)
local s=t[1]
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.enemy)
if(t==nil)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
local o=302101210
local a=e.HeroBattleInfo:GetBuff(o)
if(a)then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(o)
e.ConsumeEnergyToAddHp(a)
end
local a=ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,i,s)
local a=a[3]
local o=a.reduceHpValue
local a=302101201
local a=e.HeroBattleInfo:GetBuff(a)
if a then
local a=a:GetBuffData()
local a=a[5]
local a=math.floor(o*a*MillionCoe)
n:AddSepsisHp(e,t,a)
end
e:FuryHealth(FuryHealthType.Attack)
return nil
end
return s 
