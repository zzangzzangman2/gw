local s=require('Modules/BattleBuffScript/BuffPairTools')
local o={}
local h=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(e,a,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local t=e.CurrHeroCtrl.CurrBattleTeam:GetFrontOrBackHeros(false)
for o=1,#t do
local i=t[o]
local o=a[1]
local t=i.HeroBattleInfo:GetBuff(o)
if t==nil then
local n=a[2]
local t=s.GetDefaultHpChainData()
t.assumedamagePercent=a[3]
t.reduceDamagePercent=a[4]
t.minHpPercent=a[5]
t.defHeroId=e.CurrHeroCtrl.HeroId
t.defBuffId=302105820
local t={t}
i:AddBuff(e.CurrHeroCtrl,o,n,t)
end
end
return nil
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return h

