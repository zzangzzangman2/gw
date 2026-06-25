local i=require("Modules/Battle/BattleUtil")
local o={}
local s=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(e,t,o,o,n,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.skill3Play
or a.buffTriggerTime==BuffTriggerTime.skill2Play
or a.buffTriggerTime==BuffTriggerTime.skillPlay then
local a=303102520
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if(o)then
local o=o:GetFloors()
if(o*t[1]>=RandomMgr:GetBattleRandom())then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
e.CurrHeroCtrl:AddAttackInvalid(e.buffId)
t[2]=1
t[3]=1
end
end
elseif a.buffTriggerTime==BuffTriggerTime.skillPlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill2PlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill3PlayEnd then
e.CurrHeroCtrl:RemoveAttackInvalid(e.buffId)
t[2]=0
t[3]=0
elseif a.buffTriggerTime==BuffTriggerTime.attackInvalid then
local a=n.hurtValue
if t[2]==1 and t[3]==1 and a>0 then
t[3]=0
local e=e.CurrHeroCtrl.HeroId
local t=31025103
local a={
triggerSkillAtkType=ETriggerSkillAtkType.PursuitAttackMate,
hurtValue=a,
insertLevel=ETriggerSkillInsertLevel.DisruptAttack,
}
local o=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,e)
if o==nil then
local o={
triggerSkillAtkType=ETriggerSkillAtkType.Normal,
}
i:AddTriggerAttackTask(e,t,a,o)
end
end
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.skill3Play
or e==BuffTriggerTime.skill2Play
or e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.skillPlayEnd
or e==BuffTriggerTime.skill2PlayEnd
or e==BuffTriggerTime.skill3PlayEnd
or e==BuffTriggerTime.attackInvalid)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return s

