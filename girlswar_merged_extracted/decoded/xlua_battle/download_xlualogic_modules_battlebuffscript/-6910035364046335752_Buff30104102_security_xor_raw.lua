local s=require("Modules/Battle/BattleUtil")
local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(o,e,i,n,a)
if a==nil or a.hurtValue==nil then
GameInit.LogError("Buff30104102 triggerData 不能为空")
return
end
local i=o.CurrHeroCtrl.HeroId
if i==n.HeroId and t.CheckCondition(o)then
if e==nil or#e<3 then
GameInit.LogError("Buff30104102 buffData 参数不足")
return
end
local h=a.reduceHpValueBeforeReduceLimit
if(n:GetHPPerByHp(h)>e[1]*MillionCoe)then
local n=e[2]
local h=e[3]
local e=t.GetSkillData(o,e)
local t=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(n,i)
if t==nil then
s:AddTriggerAttackTask(i,n,e,a)
end
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.afterAttacked)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.CheckCondition(e)
local e=e:GetFloors()
return e>0
end
function e.GetSkillData(e,t)
local t=t[3]
local e={
buffId=e.buffId,
floors=math.max(0,t-e.floors),
}
return e
end
function e.HandleOnDoAction(e,a)
if t.CheckCondition(e)==false then
return false
end
local t=t.GetSkillData(e,a)
e:ReduceFloors(1)
return true,t
end
return t

