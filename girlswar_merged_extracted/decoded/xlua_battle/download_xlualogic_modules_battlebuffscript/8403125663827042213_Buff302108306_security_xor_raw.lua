local s=require("Modules/Battle/BattleUtil")
local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,i,i,i,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[5],t[6])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[7],t[8])
e.CurrHeroCtrl.isTriggerAllSkillAttackCompleteBuffForEver=true
e.CurrHeroCtrl.isTriggerAllHeroLockHpForEver=true
elseif a.buffTriggerTime==BuffTriggerTime.skillPlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill2PlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill3PlayEnd then
local t=t[9]
o.AddLickBlood(e,t)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.skillPlayEnd
or e==BuffTriggerTime.skill2PlayEnd
or e==BuffTriggerTime.skill3PlayEnd)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AddLickBlood(t,i)
local e=t:GetBuffData()
local n=e[10]
local a=e[11]
local o={e[12],e[13]}
local e=e[14]
t.CurrHeroCtrl:AddBuffWithMaxFloor(t.CurrHeroCtrl,n,a,o,i,e)
end
function t.AddPursuitAttack(e,h,n,i)
local o=e:GetBuffData()
local a=e.CurrHeroCtrl.HeroId
local t=e.CurrHeroCtrl.SmallSkillId
if t>0 then
o[15]=h
o[16]=n
local o={
buffId=e.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttack,
}
local e=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,a)
if e==nil then
local e={
triggerSkillAtkType=i
}
s:AddTriggerAttackTask(a,t,o,e)
end
end
end
function t.CheckCondition(a,e)
local t=e[15]
local e=e[16]
local e=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(e)
if a.CurrHeroCtrl.ForbidSmallSkill==true then
return false
end
if e and e.HeroBattleInfo.CurrHP>0 then
if e:CurrHPPer()<t*MillionCoe then
return true
end
end
return false
end
function t.HandleOnDoAction(t,e)
if o.CheckCondition(t,e)==false then
return false
end
return true
end
return o

