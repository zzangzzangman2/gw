local n=require("Modules/Battle/BattleUtil")
local a={}
local h=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,o,s,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
local t=math.floor(t[1]*t[2]*MillionCoe)
e.CurrHeroCtrl:RealHurtWithBuff(t,e)
elseif a.buffTriggerTime==BuffTriggerTime.normalAttack then
if#t>2 then
local i=e.CurrHeroCtrl.HeroId
local o=82001391
local a={}
for e=1,#t do
if t[e]then
table.insert(a,t[e])
end
end
local e={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttackMate,
skillParam=a
}
local t=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(o,i)
if t==nil then
n:AddTriggerAttackTask(i,o,e,s)
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundEnd or e==BuffTriggerTime.normalAttack)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return h

