local n=require("Modules/Battle/BattleUtil")
local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,i,i,i,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
a.AddBuffPhotonCharging(e,t[7])
elseif o.buffTriggerTime==BuffTriggerTime.skill2Attack then
a.AddBuffPhotonCharging(e,t[8])
elseif o.buffTriggerTime==BuffTriggerTime.eachRoundStart then
local i=t[5]
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if o then
local o=o:GetFloors()
if o>=t[9]then
local t=a.AddBuffLimiteLift(e)
if t then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(i,BuffRemoveType.Expire)
end
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.skill2Attack
or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AddBuffFloatGuardRandomOne(e)
local t=e:GetBuffData()
a.AddBuffFloatGuardByCount(e,t[24])
end
function t.AddBuffFloatGuardAllMate(e)
local t=e:GetBuffData()
a.AddBuffFloatGuardByCount(e,6)
end
function t.AddBuffFloatGuardByCount(e,o)
local t=e:GetBuffData()
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
local t=RandomTableWithSeed(t,o)
a.AddBuffFloatGuard(e,t)
end
function t.AddBuffFloatGuard(t,o,n)
local e=t:GetBuffData()
local s=e[21]
local h=e[22]
local i=t.CurrHeroCtrl.HeroBattleInfo.MaxHP
local e=math.floor(i*e[23]*MillionCoe)
local r={e}
local e=0
for a=1,#o do
local i=o[a]
i:AddBuff(t.CurrHeroCtrl,s,h,r)
local a=1
local o=303111320
local o=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if(o)then
local e=o:GetBuffData()
a=e[15]
end
if i.HeroId==t.CurrHeroCtrl.HeroId then
e=e+a
else
e=e+1
end
end
e=math.min(e,6)
if n~=false then
a.AddGuardLight(t,e)
end
end
function t.AddGuardLight(t,e)
local i=t:GetBuffData()
if e>0 then
local a=303111313
local o=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if o then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
t.RecordGuardLightCount(o,e)
end
local i=i[25]
local a=303111322
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if(a)then
local e=a:GetBuffData()
i=e[3]
end
local a=t.CurrHeroCtrl.HeroId
local o=31113102
local i={
triggerSkillAtkType=ETriggerSkillAtkType.PursuitComboAttack,
insertLevel=ETriggerSkillInsertLevel.ComboAttack,
skillHurtRate=i,
damageTargetCount=e,
}
local t=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(o,a)
if t==nil then
local e={
triggerSkillAtkType=ETriggerSkillAtkType.Normal,
}
n:AddTriggerAttackTask(a,o,i,e)
else
if t.skillData then
local a=t.skillData.damageTargetCount
t.skillData.damageTargetCount=a+e
end
end
end
end
function t.AddBuffPhotonCharging(e,a)
local t=e:GetBuffData()
local o=t[10]
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if o then
return
end
local o=t[5]
local t=t[6]
local i={}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,t,i,a)
end
function t.AddBuffLimiteLift(e)
local t=e:GetBuffData()
local i=t[10]
local o=t[11]
local a={}
for e=12,20 do
table.insert(a,t[e])
end
local t=303111320
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if(t)then
local e=t:GetBuffData()
for t=9,14 do
table.insert(a,e[t])
end
end
local e=e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,o,a)
return e
end
return a

