local h=require("Modules/Battle/BattleUtil")
local s=require('Modules/BattleBuffScript/BuffPairTools')
local o={}
local n=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(e,a,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if e.CurrHeroCtrl:IsRealFirstRowHero()then
local t=e.CurrHeroCtrl.CurrBattleTeam:GetFrontOrBackHeros(false)
for o=1,#t do
local o=t[o]
local i=a[1]
if h:HasChainBuff(o,i)==false then
local n=a[2]
local t=s.GetDefaultHpChainData()
t.assumedamagePercent=a[4]
t.reduceDamagePercent=0
t.minHpPercent=a[3]
t.defHeroId=e.CurrHeroCtrl.HeroId
t.defBuffId=302108107
if o.battleStationColumn==e.CurrHeroCtrl.battleStationColumn then
t.assumedamagePercent=a[5]
t.reduceDamagePercent=a[6]
end
local t={t}
o:AddBuffAfterRemove(e.CurrHeroCtrl,i,n,t)
end
end
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.teamHeroDead)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return n

