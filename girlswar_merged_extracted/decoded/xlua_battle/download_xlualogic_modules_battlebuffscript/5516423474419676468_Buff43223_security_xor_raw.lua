local i={}
local s=i
function i.GetCanAdd(e,e)
return true
end
function i.DoAction(e,t,a,a,a,n)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if n.buffTriggerTime==BuffTriggerTime.after then
local o=0
local a=43228
local i=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if i then
local e=i:GetBuffData()
o=o+e[1]
end
local a=t[10]
local n=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if n==nil then
local n=t[11]
local o={}
for e=6,8 do
table.insert(o,t[e])
end
for e=12,26 do
table.insert(o,t[e])
end
if i then
local t=i:GetBuffData()
for e=3,12 do
table.insert(o,t[e])
end
end
table.insert(o,0)
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,n,o)
end
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
local i=t[6]
local n=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if n then
o=o+t[5]
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
t.ReduceMoonPhaseFloors(e,o)
end
end
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(i)
if t==nil then
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
t.InitMoonPhase(e)
end
end
elseif n.buffTriggerTime==BuffTriggerTime.skill2Play then
local a=t[10]
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.ReduceMoonPhaseFloors(e,t[9])
end
end
end
function i.GetCanTrigger(e)
if(e==BuffTriggerTime.after
or e==BuffTriggerTime.skill2Play)then
return true
end
return false
end
function i.SetLogicData(e,e)
end
return s

