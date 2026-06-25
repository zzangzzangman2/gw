local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[5],t[6])
local t=302108412
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.CheckAddDamageRes(e)
end
elseif a.buffTriggerTime==BuffTriggerTime.attacked then
local a=e.CurrHeroCtrl.HeroBattleInfo:GetMaxHP()-e.CurrHeroCtrl.HeroBattleInfo:GetCurrHP()
local t=a*t[7]*MillionCoe
if t>0 then
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
end
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
local a=math.floor(#a*t[9]*MillionCoe)
if a>0 then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.eMostTotalDamage,a)
local o=0
for i=1,#a do
local h=t[10]
local s=t[11]
local n={}
local n=a[i]:AddBuff(e.CurrHeroCtrl,h,s,n)
if n then
o=o+1
end
local o=t[13]
local n=t[14]
local t={t[15],t[16],t[17],t[18],t[19],t[10]}
a[i]:AddBuff(e.CurrHeroCtrl,o,n,t)
end
local a=302108408
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
local t=o*t[12]
if t>0 then
a.GainMirror(e,t)
end
end
end
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
local i=t[10]
local o=0
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
if a and#a>0 then
for e=1,#a do
local e=a[e]
local t=e.HeroBattleInfo:GetBuff(i)
if t~=nil then
o=o+1
end
e.HeroBattleInfo:RemoveBuffWithId(i,BuffRemoveType.Expire)
end
end
if o>0 then
local i=302108408
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if a then
local i=ModulesInit.BattleBuffMgr.GetBuffScript(i)
local e=o*t[20]
if e>0 then
i.GainMirror(a,e)
end
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.attacked
or e==BuffTriggerTime.eachRoundEnd
or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.GetMinHpLockPercent(e)
local e=e:GetBuffData()
return e[8]
end
return s

