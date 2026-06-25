local h=require('Modules/BattleBuffScript/BuffPairTools')
local o={}
local r=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(t,e,a,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local n=0
if t.CurrHeroCtrl.battleStationRow==2 then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t.CurrHeroCtrl,BattleHeroType.selfColumn)
for t=1,#e do
if e[t].battleStationRow==1 then
n=e[t].HeroId
break
end
end
end
local a=ModulesInit.ProcedureNormalBattle.GetHeroCtrl(n)
if a~=nil then
local i={}
i.buffId=e[1]
i.buffRound=e[2]
i.buffValue={}
local o={}
o.buffId=e[3]
o.buffRound=e[4]
o.buffValue={}
local s={}
s.buffId=e[5]
s.buffRound=e[6]
local a=h.GetDefaultHpChainData()
a.assumedamagePercent=e[7]
a.reduceDamagePercent=e[8]
a.minHpPercent=e[9]
a.defHeroId=n
a.defBuffId=o.buffId
s.buffValue={a}
h.AddBuffPair(t.CurrHeroCtrl,i,s,o,n)
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return r

