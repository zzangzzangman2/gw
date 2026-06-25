local n=require("Modules/Battle/BattleUtil")
local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.AddPursuitAttack(e,o)
local t=false
for e,e in pairs(o)do
t=true
end
if t==false then
return
end
local i=e:GetBuffData()
local t=e.CurrHeroCtrl.HeroId
local a=31105305
local e={
buffId=e.buffId,
costMp=false,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitComboAttack,
heroMapKnife=o,
skillParam={i[1],i[2]}
}
local o=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(a,t)
if o==nil then
local o={
triggerSkillAtkType=ETriggerSkillAtkType.Normal,
}
n:AddTriggerAttackTask(t,a,e,o)
end
end
return s

