local n=require("Modules/Battle/BattleUtil")
local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,o,i,s)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local o=e.CurrHeroCtrl.HeroId
if o==i.HeroId then
if a.CheckBaseCondition(e,t)then
local h=t[4]
local i=e.CurrHeroCtrl.HeroId
local o=e.CurrHeroCtrl.BigSkillId
if h>0 then
o=e.CurrHeroCtrl.SmallSkillId
end
local e=a.GetSkillData(e,t)
local t=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(o,i)
if t==nil then
n:AddTriggerAttackTask(i,o,e,s)
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
function t.CheckCondition(e,t)
if a.CheckBaseCondition(e,t)then
if(e.CurrHeroCtrl:CurrHPPer()<=t[1]*MillionCoe)then
return true
end
end
return false
end
function t.CheckBaseCondition(t,e)
local t=e[2]
if e[5]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[5]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[3]=0
end
if e[3]<t then
return true
else
return false
end
end
function t.GetSkillData(e,t)
local e={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
}
return e
end
function t.HandleOnDoAction(t,e)
if a.CheckCondition(t,e)==false then
return false
end
local t=a.GetSkillData(t,e)
e[4]=e[4]+1
e[3]=e[3]+1
return true,t
end
return a

