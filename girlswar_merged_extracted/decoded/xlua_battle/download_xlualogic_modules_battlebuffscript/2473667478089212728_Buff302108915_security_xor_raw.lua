local i=require("Modules/Battle/BattleUtil")
local e={}
local n=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,o,t,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.attacked then
local e=t.HeroBattleInfo:GetBuff(302108908)
if e then
t.ForbidCriticalInCurAttack=true
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.DoActionBigSkill(t,a)
local o=t:GetBuffData()
local n=true
for e=1,#a do
local e=a[e]
e.HeroBattleInfo:DispelGranBuff(true,o[1],nil,nil,t.CurrHeroCtrl.HeroId)
end
local a=nil
if t.CurrHeroCtrl:IsRealFirstRowHero()then
a=i.GetOtherHeroInSameColumn(t.CurrHeroCtrl)
end
if a==nil then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAllExcludeSelf)
if#e>0 then
local e=RandomTableWithSeed(e,1)
a=e[1]
end
end
if a then
e.AddMatePursuitSmallAttack(a)
end
local e=302108905
local t=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(e)
if t then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(e)
e.GainJinBuff(t,o[2])
end
return n
end
function e.AddMatePursuitSmallAttack(e)
local t=e.HeroId
local e=e.SmallSkillId or 0
if e>0 then
local o={
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
}
local a=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(e,t)
if a==nil then
local a={
triggerSkillAtkType=ETriggerSkillAtkType.Normal
}
i:AddTriggerAttackTask(t,e,o,a)
end
end
end
return n

