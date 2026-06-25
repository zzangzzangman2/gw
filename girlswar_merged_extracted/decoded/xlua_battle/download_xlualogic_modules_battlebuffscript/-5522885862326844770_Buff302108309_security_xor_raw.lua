local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,i,a,i,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
local t=302108310
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if a then
local o=a:GetBuffData()
local t=o[1]
local i=#t
for e=#t,1,-1 do
t[e]=t[e]-1
if t[e]<=0 then
table.remove(t,e)
end
end
local t=#t
e.CurrHeroCtrl:ModifyBuffWithFinalFloor(a,t)
local t=e.CurrHeroCtrl.HeroBattleInfo:GetMaxHP()
local t=math.floor(t*o[2]*MillionCoe*i)
if t>0 then
e.CurrHeroCtrl:RealHurtWithBuff(t,e)
end
end
elseif o.buffTriggerTime==BuffTriggerTime.teamHeroFatalDmgBefore
or o.buffTriggerTime==BuffTriggerTime.teamHeroLockHp then
if a and a.HeroBattleInfo and a.HeroBattleInfo.CurrHP>0 and a.HeroId==e.CurrHeroCtrl.HeroId then
local a=t[3]
if t[5]~=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound then
t[5]=ModulesInit.ProcedureNormalBattle.CurrBattleBigRound
t[4]=0
end
if t[4]>=a then
return
end
t[4]=t[4]+1
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.enemyAll)
for o=1,#a do
local a=a[o]
local o=a.HeroBattleInfo.MaxHP
local o=math.floor(o*t[1]*MillionCoe)
a:HpHealthWithBuffImmediately(o,EBattleSrcType.Buff,e.releaseHeroId,e.buffId)
a:AddFuryWithBuffImmediately(t[2])
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundEnd
or e==BuffTriggerTime.teamHeroFatalDmgBefore
or e==BuffTriggerTime.teamHeroLockHp)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return i

