local i=require("Modules/Battle/BattleUtil")
local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,h,o,r,s,n)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if n.buffTriggerTime==BuffTriggerTime.afterAttacked then
local n=e.CurrHeroCtrl.HeroId
if n==o.HeroId then
elseif n==r.HeroId then
local r=false
if t.CheckBaseConditionBigSkill(e,h)then
local t=302107716
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if t then
local n=t:GetBuffData()
local a=302107709
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if t then
local h=t:GetBuffData()
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
if a.CheckNightmareEnergyMaxFloor(t,h)then
local t=e.CurrHeroCtrl.HeroId
local a={
defHeroIds={o.HeroId},
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
fireData={n[1],n[2]},
isBigSkill=true,
}
local e=e.CurrHeroCtrl.BigSkillId
local o=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(e,t)
if o==nil then
i:AddTriggerAttackTask(t,e,a,s)
end
r=true
end
end
end
end
if r==false and a.CheckBaseConditionSamllSkill(e,h)then
local a=e.CurrHeroCtrl.HeroId
local t=e.CurrHeroCtrl.SmallSkillId
local e={
defHeroIds={o.HeroId},
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
}
local o=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,a)
if o==nil then
i:AddTriggerAttackTask(a,t,e,s)
end
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.afterAttacked)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.ResetBaseCondition(t,e)
if e[4]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[4]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[3]=0
e[5]=0
end
end
function t.CheckBaseConditionBigSkill(t,e)
a.ResetBaseCondition(t,e)
if e[5]<1 then
return true
else
return false
end
end
function t.CheckBaseConditionSamllSkill(o,e)
local t=e[2]
a.ResetBaseCondition(o,e)
if e[3]<t then
return true
else
return false
end
end
function t.CheckCondition(t,e,o)
if o==true then
if a.CheckBaseConditionBigSkill(t,e)then
return true
end
else
if a.CheckBaseConditionSamllSkill(t,e)then
if(t.CurrHeroCtrl:CurrHPPer()<e[1]*MillionCoe)then
return true
end
end
end
return false
end
function t.HandleOnDoAction(o,e,t)
if a.CheckCondition(o,e,t.skillData.isBigSkill)==false then
return false
end
if t.skillData.isBigSkill then
e[5]=e[5]+1
else
e[3]=e[3]+1
end
return true
end
return a

