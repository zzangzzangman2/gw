local s=require("Modules/Battle/BattleUtil")
local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
if e==nil or e.CurrHeroCtrl==nil or t==nil then
return
end
a.CheckAddDamageRes(e)
end
function t.OnRemoveSelf(e,t)
if e==nil or e.CurrHeroCtrl==nil then
return
end
e.CurrHeroCtrl:ClearDamageResData(e.buffId)
end
function t.DoAction(e,t,i,i,i,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
elseif o.buffTriggerTime==BuffTriggerTime.attacked then
a.AddBuffPowerOfNineTailedFox(e,t[5])
elseif o.buffTriggerTime==BuffTriggerTime.eachRoundStart then
local o=t[25]
e.CurrHeroCtrl:AddFuryWithBuffImmediately(o)
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAllExcludeSelf)
local a=s:GetNotFullFuryHero(a,1)
for i=1,#a do
a[i]:AddFuryWithBuffImmediately(o)
local n=t[23]
local t=t[24]
local o={o,ModulesInit.ProcedureNormalBattle.CurrBattleBigRound}
a[i]:AddBuff(e.CurrHeroCtrl,n,t,o)
end
elseif o.buffTriggerTime==BuffTriggerTime.HeroDead
or o.buffTriggerTime==BuffTriggerTime.addMyMate then
a.ResetBuffPowerOfNineTailedFoxHaloToOther(e,t)
a.ResetBuffSpiritSpellHalo(e,t)
elseif o.buffTriggerTime==BuffTriggerTime.addEnemy then
a.ResetBuffSpiritSpellHalo(e,t)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.attacked
or e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.HeroDead
or e==BuffTriggerTime.addMyMate
or e==BuffTriggerTime.addEnemy)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AddBuffPowerOfNineTailedFox(t,s)
local e=t:GetBuffData()
local n=e[7]
local r=e[8]
local h={e[9],e[10],e[11],e[12],e[13],e[14]}
local i=0
local o=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(n)
if o then
i=o:GetFloors()
end
local o=i+s
if i<e[6]and o>=e[6]then
local s=303110321
local i=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(s)
if i then
local e=ModulesInit.BattleBuffMgr.GetBuffScript(s)
e.AddBuffCurseKill(i)
end
if e[44]<e[43]then
o=o-e[6]
e[44]=e[44]+1
t.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(n,BuffRemoveType.Expire)
local o=e[29]
local i=e[30]
local n={}
local s=e[31]
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,i,n,s)
a.ResetBuffSpiritSpellHalo(t,e)
else
t.CurrHeroCtrl:ClearDamageResData(t.buffId)
end
end
t.CurrHeroCtrl:AddBuffWithFinalFloor(t.CurrHeroCtrl,n,r,h,o)
a.ResetBuffPowerOfNineTailedFoxHaloToOther(t,e)
end
function t.ResetBuffSpiritSpellHalo(a,e)
local t=e[29]
local i,t=s:GetbuffMaxFloorsInTeam(a.CurrHeroCtrl,t)
if t then
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a.CurrHeroCtrl,BattleHeroType.ourAll)
local h=e[35]
local s=e[36]
local n={e[37],e[38]}
for e=1,#o do
local e=o[e]
e:AddBuffWithFinalFloor(t,h,s,n,i)
end
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(a.CurrHeroCtrl,BattleHeroType.enemyAll)
local n=e[39]
local o=e[40]
local s={e[41],e[42]}
for e=1,#a do
local e=a[e]
e:AddBuffWithFinalFloor(t,n,o,s,i)
end
end
end
function t.ResetBuffPowerOfNineTailedFoxHaloToOther(e,t)
local n=t[7]
local h,i=s:GetbuffMaxFloorsInTeam(e.CurrHeroCtrl,n)
local o=t[15]
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
for s=1,#e do
local e=e[s]
if i then
local n=e.HeroBattleInfo:GetBuff(n)
if n then
e.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
else
a.AddBuffPowerOfNineTailedFoxHaloToOther(e,i,t,h)
end
else
e.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
end
end
end
function t.AddBuffPowerOfNineTailedFoxHaloToOther(a,n,e,o)
local r=e[15]
local h=e[16]
local t=e[17]*MillionCoe
local s=math.floor(e[10]*t)
local i=math.floor(e[12]*t)
local t=math.floor(e[14]*t)
local e={e[9],s,e[11],i,e[13],t}
a:AddBuffWithFinalFloor(n,r,h,e,o)
end
function t.IsYoung(e)
local a=e:GetBuffData()
local o=a[7]
local t=0
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if e then
t=e:GetFloors()
end
if t<=a[20]then
return true
end
return false
end
function t.GetNineTailState(a)
local e=a:GetBuffData()
local o=e[7]
local t=0
local a=a.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if a then
t=a:GetFloors()
end
if t<=e[20]then
return 1
elseif t<=e[21]then
return 2
else
return 3
end
end
function t.OnDamageRes(e,t)
local t=e:GetBuffData()
a.OnDamageResOnce(e)
end
function t.OnDamageResOnce(e)
local t=e:GetBuffData()
a.AddBuffPowerOfNineTailedFox(e,t[27])
e.CurrHeroCtrl:ClearSepsisHpDirect(true)
local a=e.CurrHeroCtrl.HeroBattleInfo.MaxHP
local t=math.floor(a*t[28]*MillionCoe)-e.CurrHeroCtrl.HeroBattleInfo.CurrHP
e.CurrHeroCtrl:HpHealthWithBuffImmediately(t,EBattleSrcType.Buff,e.releaseHeroId,e.buffId,true)
e.CurrHeroCtrl.HeroBattleInfo:DispelAllGranBuff(false)
end
function t.CheckAddDamageRes(e)
local t=e:GetBuffData()
e.CurrHeroCtrl:ClearDamageResData(e.buffId)
local t={
buffId=e.buffId,
reduceHpMinHpPercent=0,
reduceHpResRate=0,
minHpLockPercent=t[26],
damageResHeroId=e.CurrHeroCtrl.HeroId,
isNeedCheck=false,
}
e.CurrHeroCtrl:AddDamageResData(t)
end
return a

