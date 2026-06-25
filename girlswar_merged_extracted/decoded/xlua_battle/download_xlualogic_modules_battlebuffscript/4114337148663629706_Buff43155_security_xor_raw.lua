local o=require("Modules/Battle/BattleUtil")
local e={}
local t=e
local s=43150
local n=43152
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,i,a,a,n)
if e==nil or e.teamId==nil then
return
end
local a=e.teamId
if t.CheckCondition(e,i,false)then
local t=1903101
local e={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.TeamAttack,
teamId=a,
skillParam=i,
}
o:AddTriggerTeamAttackTask(a,t,e,n)
end
return nil
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.smallRoundStartTeamAttack)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.isBuffEnoughFloor(o,a,t,e)
local e=t.HeroBattleInfo:GetBuff(e)
if e then
local e=e:GetFloors()
if e>=a[1]then
return true
end
end
return false
end
function e.CheckCondition(a,i,r)
local e=a.teamId
local e=ModulesInit.ProcedureNormalBattle.GetBattleHerosByTeamId(e,BattleHeroType.ourAll)
for h=1,#e do
local e=e[h]
if t.isBuffEnoughFloor(a,i,e,s)
and t.isBuffEnoughFloor(a,i,e,n)then
if r then
local t=i[1]
o:ReduceHeroBuffFloor(e,s,t)
o:ReduceHeroBuffFloor(e,n,t)
end
return true
end
end
return false
end
function e.HandleOnDoAction(a,e)
if t.CheckCondition(a,e,true)==false then
return false
end
return true
end
return t

