local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,i,i,i,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local o=e[1]
local i=e[2]
local a={e[3],e[4]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,i,a)
local a=e[5]
local o=e[6]
local e={e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
elseif a.buffTriggerTime==BuffTriggerTime.attacked then
o.AddBuffMoment(t,e[9])
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
local o=e[10]
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if a then
local a=a:GetFloors()
if a>=e[24]then
local a=e[25]
local i=e[26]
local e={e[27],e[28],e[29],e[30],e[21],e[22],e[23]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,i,e)
t.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
end
end
end
end
function a.GetCanTrigger(e)
if e==BuffTriggerTime.now
or e==BuffTriggerTime.attacked
or e==BuffTriggerTime.eachRoundStart then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.AddBuffMoment(e,i)
local t=e:GetBuffData()
local s=t[10]
local h=t[11]
local a={}
local n=t[24]
for o=12,23 do
table.insert(a,t[o])
end
e.CurrHeroCtrl:AddBuffWithMaxFloor(e.CurrHeroCtrl,s,h,a,i,n)
if e.CurrHeroCtrl and e.CurrHeroCtrl.HeroBattleInfo then
o.CheckAddMomentAttr(e,t)
end
end
function a.RemoveMonmentAttr(e)
local t=e:GetBuffData()
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffValue(e.buffId,t[12])
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffValue(e.buffId,t[17])
e.CurrHeroCtrl.HeroBattleInfo:RemoveBuffValue(e.buffId,t[19])
end
function a.CheckAddMomentAttr(e,t)
o.RemoveMonmentAttr(e)
local a=t[10]
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if a then
local a=a:GetFloors()
if a<t[16]then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[12],t[13])
else
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[17],t[18])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[19],t[20])
end
end
end
return o

