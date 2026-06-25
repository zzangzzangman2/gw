local i=require("Modules/Battle/BattleUtil")
local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,o,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local o=a.GetRandomEventDatas(t,e)
for a=1,#o do
local a=o[a].buffId
if a==43282 then
local o=e[2]
local a=e[3]
local e={e[4],e[5],e[6]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
elseif a==43283 then
local i=e[8]
local o=e[9]
local a={}
for o=10,15 do
table.insert(a,e[o])
end
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,o,a)
elseif a==43284 then
local o=e[17]
local i=e[18]
local a={}
for o=19,25 do
table.insert(a,e[o])
end
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,i,a)
elseif a==43285 then
local i=e[27]
local o=e[28]
local a={}
for t=29,33 do
table.insert(a,e[t])
end
table.insert(a,0)
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,o,a)
end
end
local i=43290
local t=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if t then
e[34]=e[34]or 0
e[34]=e[34]+#o
local a=t:GetBuffData()
if e[34]>=a[3]then
e[34]=e[34]-a[3]
local e=ModulesInit.BattleBuffMgr.GetBuffScript(i)
e.AddBuffPreciousMemories(t,a[4])
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.GetRandomEventDatas(n,s)
local a=o.GetAllEventDatas(n,s,1)
local t={}
local e=nil
if#a==1 then
e=a[1]
else
local t=i:GetRandomWeightData(a,1)
e=t[1]
end
if e.buffId==0 then
local a=o.GetBuffEventDatas(n,s,e.eventCount)
if#a<=e.eventCount then
t=a
else
t=i:GetRandomWeightData(a,e.eventCount)
end
else
table.insert(t,e)
end
return t
end
function a.GetBuffEventDatas(s,e,n)
local t={}
local a={
buffId=e[2],
weight=e[1]
}
table.insert(t,a)
local a={
buffId=e[8],
weight=e[7]
}
table.insert(t,a)
local a={
buffId=e[17],
weight=e[16]
}
table.insert(t,a)
local e={
buffId=e[27],
weight=e[26]
}
table.insert(t,e)
local e={}
local o={}
for a=1,#t do
local i=s.CurrHeroCtrl.HeroBattleInfo:GetBuff(t[a].buffId)
if i==nil then
table.insert(e,t[a])
else
table.insert(o,t[a])
end
end
if#e<=n then
local t=n-#e
local t=i:GetRandomWeightData(o,t)
table.appendList(e,t)
end
return e
end
function a.GetAllEventDatas(t,a)
local e={}
local i=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(43290)
if i then
e=o.GetBuffEventDatas(t,a,0)
local t=i:GetBuffData()
local t={
buffId=0,
weight=t[1],
eventCount=t[2],
}
table.insert(e,t)
else
e=o.GetBuffEventDatas(t,a,1)
end
return e
end
return o

