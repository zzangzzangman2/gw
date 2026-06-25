local n=require("Modules/Battle/BattleUtil")
local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
end
function e.GetCanTrigger(e)
return false
end
function e.SetLogicData(e,e)
end
function e.HandleBuff(e,o,i)
local t=e:GetBuffData()
local a=t[1]
local t=302104418
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if t then
local e=t:GetBuffData()
a=e[2]
end
local t=math.floor(i*a*MillionCoe)
n:AddSepsisHp(e.CurrHeroCtrl,o,t)
end
return s

