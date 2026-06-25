local o=require("Modules/Battle/BattleUtil")
local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,o,o,o,t,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
a.AddAttackTask(e,t)
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.skillPlay)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.AddAttackTask(e,a)
local t=e:GetBuffData()
if t[3]>=RandomMgr:GetBattleRandom()then
local t=e.CurrHeroCtrl.HeroId
local e=e.CurrHeroCtrl.SmallSkillId
if e>0 then
local i={
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
}
local n=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(e,t)
if n==nil then
o:AddTriggerAttackTask(t,e,i,a)
end
end
end
end
return a

