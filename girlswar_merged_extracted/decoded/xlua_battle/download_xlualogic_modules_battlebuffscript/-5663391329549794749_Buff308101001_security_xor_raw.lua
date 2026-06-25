local a=require("Modules/Battle/BattleUtil")
local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(t,e,n,n,i,n)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if i.isPetTrigger==false and a:IsNormalSkillAtkType(i.triggerSkillAtkType)then
e[3]=e[3]+1
if e[3]>=e[2]then
o.AddAttackTask(t)
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.allHeroSkillAttackComplete)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.AddAttackTask(e)
local o=e:GetBuffData()
local t=e.CurrHeroCtrl.HeroId
local o=o[1]
local e={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.Normal,
}
local i=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(o,t)
if i==nil then
local i={
triggerSkillAtkType=ETriggerSkillAtkType.Normal,
}
a:AddTriggerAttackTask(t,o,e,i)
end
end
function e.HandleOnDoAction(t,e,t)
if e[3]>=e[2]then
e[3]=e[3]-e[2]
return true
end
return false
end
return o

