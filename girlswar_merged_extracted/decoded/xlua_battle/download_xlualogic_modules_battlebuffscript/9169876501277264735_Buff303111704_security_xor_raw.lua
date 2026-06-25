local i=require("Modules/Battle/BattleUtil")
local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
e.CurrHeroCtrl.HeroBattleInfo:AddHPAndMaxHPPer(t[3]*MillionCoe)
e.CurrHeroCtrl:AddImmuneSepsisHp(e.buffId,0)
end
function t.OnRemoveSelf(e,t)
e.CurrHeroCtrl.HeroBattleInfo:ReduceHPAndMaxHPPer(t[3]*MillionCoe)
e.CurrHeroCtrl:ReduceImmuneSepsisHp(e.buffId)
end
function t.DoAction(e,o,i,n,n,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,o[1],o[2])
a.AddBuffTheMind(e,o[4])
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
for o=1,#t do
local t=t[o]
a.AddBuffTheMindListener(e,t)
end
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
for o=1,#t do
local t=t[o]
a.AddBuffThePowerListener(e,t)
end
elseif t.buffTriggerTime==BuffTriggerTime.eachRoundStart then
a.AddBuffTheMind(e,o[5])
elseif t.buffTriggerTime==BuffTriggerTime.addMyMate then
a.AddBuffTheMindListener(e,i)
elseif t.buffTriggerTime==BuffTriggerTime.HeroDead then
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
for o=1,#t do
local t=t[o]
a.RemoveBuffTheMindListener(e,t)
end
elseif t.buffTriggerTime==BuffTriggerTime.addEnemy then
a.AddBuffThePowerListener(e,i)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.addMyMate
or e==BuffTriggerTime.HeroDead
or e==BuffTriggerTime.addEnemy
or e==BuffTriggerTime.resurgence)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AddBuffTheMind(e,i)
local t=e:GetBuffData()
local o=t[6]
local t=t[7]
local a={}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,t,a,i)
end
function t.AddBuffTheMindListener(e,t)
local a=e:GetBuffData()
local o=303111720
local i=a[11]
if t.HeroId==e.CurrHeroCtrl.HeroId then
i=a[12]
end
local n=t.HeroBattleInfo:GetBuff(o)
if n then
local o=n:GetBuffData()
table.insert(o[1],e.CurrHeroCtrl.HeroId)
if t.HeroId==e.CurrHeroCtrl.HeroId then
o[2]=a[12]
end
else
local s=-1
local n={e.CurrHeroCtrl.HeroId}
local a=a[8]
local a={n,a,i,0}
t:AddBuff(e.CurrHeroCtrl,o,s,a)
end
end
function t.AddBuffThePowerListener(o,e)
local t=o:GetBuffData()
local a=303111722
local t=e.HeroBattleInfo:GetBuff(a)
if t==nil then
local i=-1
local t={}
local n={
heroId=e.HeroId,
triggerCount=0,
buffFloors=0,
bigRound=0,
}
table.insert(t,n)
e:AddBuff(o.CurrHeroCtrl,a,i,t)
end
end
function t.RemoveBuffTheMindListener(t,e)
local a=t:GetBuffData()
local a=303111720
local e=e.HeroBattleInfo:GetBuff(a)
if e then
local e=e:GetBuffData()
local e=e[1]
for a=1,#e do
if e[a]==t.CurrHeroCtrl.HeroId then
table.remove(e,a)
break
end
end
if#e<=0 then
t.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
end
end
end
function t.CheckCondHpLock(t)
local e=t:GetBuffData()
if e[22]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
e[22]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
e[21]=0
end
if e[21]>=e[10]then
return false
end
local e=e[6]
local e=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(e)
if e==nil then
return false
end
return true
end
function t.OnDamageRes(e,t)
local o=e:GetBuffData()
a.OnHpLockConsume(e)
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local a=a*o[9]*MillionCoe
t:HpHealthWithDirect(a,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
local a=t.HeroId
local t=t.SmallSkillId
local n={
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
}
local o=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(t,a)
if o==nil then
local e={
triggerSkillAtkType=ETriggerSkillAtkType.Normal
}
i:AddTriggerAttackTask(a,t,n,e)
end
local t=303111716
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if(t)then
local t=t:GetBuffData()
e.CurrHeroCtrl:AddFuryWithBuff(t[13])
end
end
function t.OnHpLockConsume(t)
local e=t:GetBuffData()
e[21]=e[21]+1
local e=e[6]
i:ReduceHeroBuffFloor(t.CurrHeroCtrl,e,1)
end
function t.AddBuffVijnanavada(a,e,h,r)
local o=a:GetBuffData()
local i=o[13]
local n=o[14]
local t={}
for e=15,20 do
table.insert(t,o[e])
end
local o=0
local s=303111716
local s=a.CurrHeroCtrl.HeroBattleInfo:GetBuff(s)
if(s)then
local e=s:GetBuffData()
o=e[14]
end
table.insert(t,o)
table.insert(t,0)
local o=false
if h then
o=e:CheckAddBuff(h,a.CurrHeroCtrl,i,n,t)
else
o=e:AddBuff(a.CurrHeroCtrl,i,n,t)
end
if r and o and e and e.HeroBattleInfo then
e.HeroBattleInfo:PlayBattleEffectWithBuffId(i)
end
end
return a

