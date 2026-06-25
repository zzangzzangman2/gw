local a={}
local d=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,r,a,s,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=t[1]
local o=t[2]
local n={t[3],t[4]}
local h=t[5]
if i.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,n,h)
elseif i.buffTriggerTime==BuffTriggerTime.afterAttacked then
local i=e.CurrHeroCtrl.HeroId
if i==r.HeroId then
local i=s.criticalOrBlock
if i==1 then
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if o then
local i=o:GetFloors()
local n=t[6]
o:ReduceFloors(t[6])
if i<=n then
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(a,BuffRemoveType.Expire)
end
e.CurrHeroCtrl:AddFuryWithBuff(t[7])
end
else
local t=t[8]
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,n,t)
end
end
elseif i.buffTriggerTime==BuffTriggerTime.teamHeroDead then
local i=t[9]
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,n,i)
local a=e.CurrHeroCtrl.HeroBattleInfo:GetMaxHP()
local a=math.floor(a*t[10]*MillionCoe)
e.CurrHeroCtrl:HpHealthWithBuffImmediately(a,EBattleSrcType.Buff,e.releaseHeroId,e.buffId,true)
e.CurrHeroCtrl:AddFuryWithBuff(t[11])
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.afterAttacked or e==BuffTriggerTime.teamHeroDead)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return d

