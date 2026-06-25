local s=require('Modules/BattleBuffScript/BuffPairTools')
local o={}
local h=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if e.CurrHeroCtrl.battleStationRow==1 then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAllExcludeSelf)
for o=1,#a do
if a[o].profession~=t[1]then
local i=a[o]
local o=t[2]
local a=i.HeroBattleInfo:GetBuff(o)
if a==nil then
local n=t[3]
local a=s.GetDefaultHpChainData()
a.assumedamagePercent=t[4]
a.reduceDamagePercent=t[5]
a.minHpPercent=t[6]
a.defHeroId=e.CurrHeroCtrl.HeroId
a.defBuffId=303110604
local t={a}
i:AddBuff(e.CurrHeroCtrl,o,n,t)
end
end
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

