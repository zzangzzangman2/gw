local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
a.RefreshEyeBuff(e)
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.AddEyeBuff(i,s,o)
o=o or 0
local e=i:GetBuffData()
if e[9]==nil then
e[9]={}
end
local t=e[9]
e[10]=e[10]or 0
local n=e[8]
for a=1,s do
if#t>=n then
table.remove(t,1)
end
table.insert(t,e[7]+o)
e[10]=e[10]+1
end
local e=#t
a.AddEyeBuffWithData(i,e)
end
function e.RefreshEyeBuff(o)
local e=o:GetBuffData()
if e[9]==nil then
e[9]={}
end
local e=e[9]
for t=#e,1,-1 do
e[t]=e[t]-1
if e[t]<=0 then
table.remove(e,t)
end
end
local e=#e
a.AddEyeBuffWithData(o,e)
end
function e.AddEyeBuffWithData(e,n)
local t=e:GetBuffData()
local i=t[1]
local o=t[2]
local a={}
for o=3,6 do
table.insert(a,t[o])
end
e.CurrHeroCtrl:AddBuffWithFinalFloor(e.CurrHeroCtrl,i,o,a,n)
end
function e.CheckConsumeEye(e,t)
local e=e:GetBuffData()
e[10]=e[10]or 0
if e[10]>=t then
e[10]=0
return true
end
return false
end
function e.GetEyeFloorsList(e)
end
function e.GetEyeFloors(e)
local e=e:GetBuffData()
if e[9]==nil then
e[9]={}
end
local e=e[9]
return#e
end
return a

