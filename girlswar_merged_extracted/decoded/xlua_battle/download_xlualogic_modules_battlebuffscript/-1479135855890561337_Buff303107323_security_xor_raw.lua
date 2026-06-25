local s=require("Modules/Battle/BattleUtil")
local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,a,a,a,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.now then
o.AddBuffEquivalent(e)
elseif t.buffTriggerTime==BuffTriggerTime.eachRoundStart then
o.AddBuffEquivalent(e)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AddBuffEquivalent(e)
local t=e:GetBuffData()
local i=t[2]
local o=303107328
local a={}
local n=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll,nil,nil,nil,nil,{isContainUsualState=true})
for e=1,#n do
local e=n[e]
local i=e.HeroBattleInfo:GetBuff(i)
if i==nil then
local o=e.HeroBattleInfo:GetBuff(o)
if o==nil or o:GetFloors()<t[1]then
table.insert(a,e)
end
end
end
local a=s:GetMinHpPercentHeroArr(a,1)
local a=a[1]
if a then
local s=t[3]
local n={}
for e=4,7 do
table.insert(n,t[e])
end
local t=a:AddBuff(e.CurrHeroCtrl,i,s,n)
if t then
local i=-1
local t={}
a:AddBuff(e.CurrHeroCtrl,o,i,t,1)
end
end
end
return o

