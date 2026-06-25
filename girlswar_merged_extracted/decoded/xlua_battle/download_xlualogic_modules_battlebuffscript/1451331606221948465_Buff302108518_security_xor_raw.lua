local o={}
local n=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(t,e,o,i,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
t.CurrHeroCtrl.isTriggerAllHeroLockHpForEver=true
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[3],e[4])
elseif a.buffTriggerTime==BuffTriggerTime.skillPlay
or a.buffTriggerTime==BuffTriggerTime.skill2Play
or a.buffTriggerTime==BuffTriggerTime.skill3Play then
e[20]=1
e[21]=0
elseif a.buffTriggerTime==BuffTriggerTime.skillPlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill2PlayEnd
or a.buffTriggerTime==BuffTriggerTime.skill3PlayEnd then
e[20]=0
elseif a.buffTriggerTime==BuffTriggerTime.enemyTeamHeroFatalDmgBefore
or a.buffTriggerTime==BuffTriggerTime.enemyTeamHeroLockHp then
if e[20]==1 then
local a=302108507
local o=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if o then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.GainTaskHalo(o,e[5])
local o=e[6]
local n=e[7]
local a={e[8],e[9]}
i:AddBuff(t.CurrHeroCtrl,o,n,a)
local o=e[10]
local a=e[11]
local e={e[12],e[13]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
end
end
elseif a.buffTriggerTime==BuffTriggerTime.skillAttackComplete then
local a=e[21]
e[21]=0
if a==1 then
if t.CurrHeroCtrl:CurrHPPer()<=e[14]*MillionCoe then
local o=e[15]
local a=e[16]
local i={e[17],e[18]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,i)
local a=t.CurrHeroCtrl.HeroBattleInfo:GetCurrHP()
local o=t.CurrHeroCtrl.HeroBattleInfo:GetMaxHP()
local a=o-a
local e=math.floor(a*e[19]*MillionCoe)
t.CurrHeroCtrl:HpHealthWithBuffImmediately(e,EBattleSrcType.Buff,t.releaseHeroId,t.buffId)
end
end
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.skill2Play
or e==BuffTriggerTime.skill3Play
or e==BuffTriggerTime.skillPlayEnd
or e==BuffTriggerTime.skill2PlayEnd
or e==BuffTriggerTime.skill3PlayEnd
or e==BuffTriggerTime.enemyTeamHeroFatalDmgBefore
or e==BuffTriggerTime.enemyTeamHeroLockHp
or e==BuffTriggerTime.skillAttackComplete
)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
function o.SetTriggerBuff(e)
local e=e:GetBuffData()
e[21]=1
end
return n

