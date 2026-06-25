local s=require('Modules/BattleBuffScript/BuffPairTools')
local a={}
local h=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,a,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local t=0
if e.CurrHeroCtrl.battleStationRow==1 then
local t=e.CurrHeroCtrl.CurrBattleTeam:GetFrontOrBackHeros(false)
for o=1,#t do
local i=t[o]
local o=a[1]
local t=i.HeroBattleInfo:GetBuff(o)
if t==nil then
local n=a[2]
local t=s.GetDefaultHpChainData()
t.assumedamagePercent=a[3]
t.reduceDamagePercent=0
t.minHpPercent=a[4]
t.defHeroId=e.CurrHeroCtrl.HeroId
t.defBuffId=30105610
local t={t}
i:AddBuff(e.CurrHeroCtrl,o,n,t)
end
end
end
return nil
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return h

