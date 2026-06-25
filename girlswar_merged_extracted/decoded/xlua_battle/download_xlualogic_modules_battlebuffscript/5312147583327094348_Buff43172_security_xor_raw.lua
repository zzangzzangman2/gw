local n=require('Modules/BattleBuffScript/BuffPairTools')
local o=require("Modules/Battle/BattleUtil")
local a={}
local h=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,s,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local i=o:GetDataByWeight(t)
if i then
local a=e.CurrHeroCtrl
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAllExcludeSelf)
if#t>0 then
local e=o:GetMaxHpPercentHeroArrByHeroArr(t,1)
a=e[1]
end
if a then
local t=n.GetDefaultHpChainData()
t.assumedamagePercent=i
t.reduceDamagePercent=0
t.minHpPercent=0
t.defHeroId=a.HeroId
t.defBuffId=43174
local o=43174
local n=-1
local i={}
a:AddBuff(e.CurrHeroCtrl,o,n,i)
s:SetHpChainDataInCurAttack(t)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.attack)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return h

