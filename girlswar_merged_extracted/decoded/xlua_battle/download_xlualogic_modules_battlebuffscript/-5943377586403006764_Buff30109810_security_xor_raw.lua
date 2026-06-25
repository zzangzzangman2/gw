local n=require("Modules/Battle/BattleUtil")
local t={}
local h=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(t,e,s,a,o,i)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if i.buffTriggerTime==BuffTriggerTime.afterAttacked then
local t=t.CurrHeroCtrl.HeroId
if t==a.HeroId then
if e==nil or#e<3 then
GameInit.LogError("Buff30109810 buffData 参数不足")
return
end
local i=o.reduceHpValueBeforeReduceLimit
local i=o.triggerSkillAtkType
if(a.HeroBattleInfo:GetCurrFury()>=e[1]and a.ForbidSmallSkill==false and(e[3]<e[2]))then
e[3]=e[3]+1
local e=1098203
local a={}
local a={
defHeroIds={s.HeroId},
}
local i=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(e,t)
if i==nil then
n:AddTriggerAttackTask(t,e,a,o)
end
end
end
elseif i.buffTriggerTime==BuffTriggerTime.eachRoundStart then
e[3]=0
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.afterAttacked or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return h

