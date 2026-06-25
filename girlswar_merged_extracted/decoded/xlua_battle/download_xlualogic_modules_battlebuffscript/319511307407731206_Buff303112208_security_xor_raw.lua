local n=require('Modules/BattleBuffScript/BuffPairTools')
local e={}
local r=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.DoActionSmallSkill(e,a)
local t=e.CurrHeroCtrl
local e=e:GetBuffData()
local s=e[1]
local i=e[2]
local o={e[3],e[4]}
a:AddBuff(t,s,i,o)
local i=e[5]
local s=e[6]
local o={e[7],e[8]}
a:AddBuff(t,i,s,o)
local s=e[9]
local i=e[10]
local o={e[11],e[12]}
a:AddBuff(t,s,i,o)
local o=e[13]
local s=e[14]
local i={e[15],e[16]}
a:AddBuff(t,o,s,i)
local a=e[17]
if a>=RandomMgr:GetBattleRandom()then
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.fMinHpPercentWithCount,1)
if a and#a>0 then
local h=a[1]
local a=e[18]
local s=e[19]
local o=e[20]
local i=e[21]
local e=n.GetDefaultHpChainData()
e.assumedamagePercent=10000
e.reduceDamagePercent=o
e.minHpPercent=0
e.holderBuffId=a
local e={e,i}
h:AddBuff(t,a,s,e)
end
end
end
return r

