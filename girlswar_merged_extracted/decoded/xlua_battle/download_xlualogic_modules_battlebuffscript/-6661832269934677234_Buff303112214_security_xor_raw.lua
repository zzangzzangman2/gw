local e=require("Modules/Battle/BattleUtil")
local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,i,i,i,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.now then
o.AddBuffKenkai(e,a[1])
end
e.isExec=true
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.OnHeartEyeFloorsAdded(t,a)
if t==nil or t.CurrHeroCtrl==nil then
return
end
if a==nil or a<=0 then
return
end
local e=t:GetBuffData()
e[10]=e[10]+a
if e[10]>=e[2]then
local a=math.floor(e[10]/e[2])
e[10]=e[10]-e[2]*a
o.AddBuffKenkai(t,e[3]*a)
end
end
function t.AddBuffKenkai(t,a)
if a<=0 then
return
end
local e=t:GetBuffData()
if e[11]>=e[4]then
return
end
local o=e[4]-e[11]
local a=math.min(o,a)
e[11]=e[11]+a
local o=e[5]
local i=e[6]
local e={e[7],e[8],e[9]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,i,e,a)
end
return o

