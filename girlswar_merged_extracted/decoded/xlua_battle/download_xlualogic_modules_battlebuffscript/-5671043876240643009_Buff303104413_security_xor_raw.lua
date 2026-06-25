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
function e.DoActionSmallSkill(t)
local e=t:GetBuffData()
local i=e[2]
local o=e[3]
local a={e[4],e[5]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,o,a)
return e[6]
end
function e.DoActionBigSkill(e,i,o)
local t=e:GetBuffData()
local a=t[1]
local t=303104418
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if t then
local e=t:GetBuffData()
a=e[2]
end
local t=math.floor(o*a*MillionCoe)
n:AddSepsisHp(e.CurrHeroCtrl,i,t)
end
return s

