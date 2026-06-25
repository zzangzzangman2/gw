local o=require("Modules/Battle/BattleUtil")
local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,a,o,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local o=a[4]
local o=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(o)
if o then
return
end
if t.CheckCondition(e,a)then
t.AddAttackTask(e,true)
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.allNormalSkilAttack
or e==BuffTriggerTime.allSmallSkilAttack
or e==BuffTriggerTime.allSkillAttack
or e==BuffTriggerTime.allPetFightSkillAttack)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.AddAttackTask(e,i)
local a=e:GetBuffData()
local t=e.CurrHeroCtrl.HeroId
local a=a[1]
local e={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.AsistAttack,
needCheck=i,
}
local i=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(a,t)
if i==nil then
o:AddTriggerAttackTask(t,a,e,{triggerSkillAtkType=ETriggerSkillAtkType.Normal})
end
end
function e.SetSwallowHeroId(a,e)
local o=a:GetBuffData()
o[4]=e
if e==0 then
t.SetStatFuryBefore(a)
end
end
function e.GetSwallowHeroId(e)
local e=e:GetBuffData()
return e[4]
end
function e.SetStatFuryBefore(e)
local t=e:GetBuffData()
local e=e.CurrHeroCtrl:GetTeamTotalStatFuryAdd()
t[3]=e
end
function e.CheckCondition(t,e)
local t=t.CurrHeroCtrl:GetTeamTotalStatFuryAdd()
local t=t-e[3]
if t>=e[2]then
return true
end
return false
end
function e.HandleOnDoAction(e,o,a)
if a.needCheck==true and t.CheckCondition(e,o)==false then
return false
end
t.SetStatFuryBefore(e)
return true
end
return t

