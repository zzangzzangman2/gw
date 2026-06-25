local o={}
local i=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(t,e,i,o,n,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
elseif a.buffTriggerTime==BuffTriggerTime.attack then
local a=308100902
local a=o.HeroBattleInfo:GetBuff(a)
if a then
local a=HeroBuffValueInfo:New()
a.buffId=t.buffId
a.attrId=e[3]
a.value=e[4]
i.HeroBattleInfo:AddTempBuffValue(a)
end
table.insert(e[7],o.HeroId)
elseif a.buffTriggerTime==BuffTriggerTime.skillPlay
or a.buffTriggerTime==BuffTriggerTime.skill2Play
or a.buffTriggerTime==BuffTriggerTime.skill3Play then
e[7]={}
elseif a.buffTriggerTime==BuffTriggerTime.skillPlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill2PlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill3PlayEnd then
local t=t.releaseHeroId
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(t)
if a then
local t=308100901
local a=a.HeroBattleInfo:GetBuff(t)
if a then
if e[5]>=RandomMgr:GetBattleRandom()then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(t)
e.AddAttackTask(a,n,"isNormal")
end
local o=e[7]
for i=1,#o do
local o=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(o[i])
if o==nil then
if e[6]>=RandomMgr:GetBattleRandom()then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(t)
e.AddAttackTask(a,{triggerSkillAtkType=ETriggerSkillAtkType.Normal},"isKill")
end
break
end
end
end
end
e[7]={}
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.attack
or e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.skill2Play
or e==BuffTriggerTime.skill3Play
or e==BuffTriggerTime.skillPlayEnd
or e==BuffTriggerTime.skill2PlayEnd
or e==BuffTriggerTime.skill3PlayEnd)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return i

