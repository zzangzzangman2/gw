local i=require("Modules/Battle/BattleUtil")
local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,o,i,i,i,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.eachRoundStart then
local t=o[4]
a.AddFlower(e,t)
elseif t.buffTriggerTime==BuffTriggerTime.now then
local t=o[3]
a.AddFlower(e,t)
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.AddFlower(e,i)
local t=e:GetBuffData()
local o=t[1]
local a=t[2]
local t=t[5]
e.CurrHeroCtrl:AddBuffWithMaxFloor(e.CurrHeroCtrl,o,a,0,i,t)
end
function e.ReduceFlower(e,a)
local t=e:GetBuffData()
local o=303101219
local o=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if o and o.isExec==false then
local o=t[1]
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
local t=t[6]
local e=e:GetFloors()
local e=e-t
if e<a then
return false
end
end
local t=t[1]
i:ReduceHeroBuffFloor(e.CurrHeroCtrl,t,a)
return true
end
return a

