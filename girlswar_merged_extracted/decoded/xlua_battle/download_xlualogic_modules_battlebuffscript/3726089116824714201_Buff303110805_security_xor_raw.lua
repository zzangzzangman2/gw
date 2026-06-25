local s=require('Modules/BattleBuffScript/BuffPairTools')
local a={}
local h=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,a,e,e)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.ourAllExcludeSelf)
for o=1,#e do
local i=e[o]
local o=a[1]
local e=i.HeroBattleInfo:GetBuff(o)
if e==nil then
local n=a[2]
local e=s.GetDefaultHpChainData()
e.assumedamagePercent=0
e.reduceDamagePercent=0
e.minHpPercent=0
e.maxDamageHpPercent=a[3]
e.defHeroId=t.CurrHeroCtrl.HeroId
e.defBuffId=303110805
e.isShareDead=true
local e={e}
i:AddBuff(t.CurrHeroCtrl,o,n,e)
end
end
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

