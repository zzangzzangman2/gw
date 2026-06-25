local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,o,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local t=o[1]
local a=302104308
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if a then
local e=a:GetBuffData()
t=t+e[2]
end
if(t>=RandomMgr:GetBattleRandom())then
e.CurrHeroCtrl.HeroBattleInfo:DispelGranBuff(false,o[2],true)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return i

