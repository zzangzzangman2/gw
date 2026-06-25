local n=require("Modules/Battle/BattleUtil")
local t={}
local h=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,a,a,s,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
local o=e.CurrHeroCtrl.HeroId
local a=82006399
local i={}
for e=1,5 do
table.insert(i,t[e])
end
local t={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.Normal,
cfgArgs=t,
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(a,o)
if e==nil then
n:AddTriggerAttackTask(o,a,t,s)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.battleBeginPetHelpSkill)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return h

