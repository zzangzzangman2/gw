local i=require("Modules/Battle/BattleUtil")
local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
i:ShowBgEffectByBuff(e,{isPlayAnim=false})
e.CurrHeroCtrl:AddImmuneReduceFury(e.buffId)
e.CurrHeroCtrl:AddImmuneThorn(e.buffId)
a.CheckAddDamageConvert(e)
end
function t.OnRemoveSelf(e,t)
i:RemoveBgEffectByBuff(e)
e.CurrHeroCtrl:RefreshImmuneReduceFury()
e.CurrHeroCtrl:RefreshImmuneThorn()
e.CurrHeroCtrl:ClearDamageConvertData(e.buffId)
end
function t.DoAction(e,t,n,s,s,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
for i=1,#o do
local o=o[i]
a.AddMateBuff(e,t,o)
end
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
for i=1,#o do
local o=o[i]
a.AddEnemyBuff(e,t,o)
end
elseif o.buffTriggerTime==BuffTriggerTime.eachRoundStart then
a.RefreshAddDamageConvertPercent(e,t,t[5],true)
if i.IsBigRoundStart(o.buffTriggerTime,e.CurrHeroCtrl)then
a.CheckAddDamageConvert(e)
end
elseif o.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
a.RefreshAddDamageConvertPercent(e,t,t[6])
elseif o.buffTriggerTime==BuffTriggerTime.enemyRoundStart then
if i.IsBigRoundStart(o.buffTriggerTime,e.CurrHeroCtrl)then
a.CheckAddDamageConvert(e)
end
elseif o.buffTriggerTime==BuffTriggerTime.addMyMate then
a.AddMateBuff(e,t,n)
elseif o.buffTriggerTime==BuffTriggerTime.addEnemy then
a.AddEnemyBuff(e,t,n)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.eachRoundEnd
or e==BuffTriggerTime.enemyRoundStart
or e==BuffTriggerTime.addMyMate
or e==BuffTriggerTime.addEnemy)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.OnDamageConvert(e,a)
local t=e:GetBuffData()
local o=t[1]
local i={
totalHurtValue=a,
round=t[4],
leftPercent=OneMillion,
}
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if a then
local e=a:GetBuffData()
table.insert(e,i)
else
local t=t[2]
local a={i}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,t,a)
end
end
function t.CheckAddDamageConvert(e)
local t=e:GetBuffData()
e.CurrHeroCtrl:ClearDamageConvertData(e.buffId)
local a=t[3]
if t[7]>0 and t[8]>0 then
a=a-t[7]*(ModulesInit.ProcedureNormalBattle.CurrBattleBigRound-t[8])
end
if a>0 then
local t={
buffId=e.buffId,
reduceHpConvertRate=a,
damageResHeroId=e.CurrHeroCtrl.HeroId,
}
e.CurrHeroCtrl:AddDamageConvertData(t)
end
end
function t.RefreshAddDamageConvertPercent(t,e,i,s)
local n=e[1]
local e=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(n)
if e then
local o=0
local a=e:GetBuffData()
for t=#a,1,-1 do
local e=a[t]
e.leftPercent=e.leftPercent-i
if e.leftPercent<=0 then
table.remove(a,t)
else
if s then
local i=e.leftPercent/e.round
local n=e.totalHurtValue*i*MillionCoe
o=o+n
e.round=e.round-1
e.leftPercent=e.leftPercent-i
if e.leftPercent<=0 or e.round<=0 then
table.remove(a,t)
end
end
end
end
if#a<=0 then
t.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(n,BuffRemoveType.Expire)
end
if o>0 and t.CurrHeroCtrl and t.CurrHeroCtrl.HeroBattleInfo then
t.CurrHeroCtrl:RealHurtWithBuff(o,t)
end
end
end
function t.SetDelayDamageReduceValue(e,t)
local e=e:GetBuffData()
if e[7]<=0 then
e[7]=t
e[8]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
end
end
function t.AddMateBuff(i,e,o)
local a=e[9]
local t=e[10]
local e={e[11],e[12]}
o:AddBuff(i.CurrHeroCtrl,a,t,e)
end
function t.AddEnemyBuff(t,e,a)
local o=e[13]
local i=e[14]
local e={e[15],e[16]}
a:AddBuff(t.CurrHeroCtrl,o,i,e)
end
return a

