local r=require("Modules/Battle/BattleUtil")
local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,i,i,i,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.isTriggerAllSkillAttackCompleteBuffForEver=true
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
elseif o.buffTriggerTime==BuffTriggerTime.eachRoundStart then
local t=t[10]
if t>0 then
a.AddBuffGrowth(e,t)
end
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
function t.AddBuffLightlessPearOnStart(e)
local t=e:GetBuffData()
if t[6]>0 then
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.eRandom,t[5])
if(o)then
for i,o in ipairs(o)do
a.AddBuffLightlessPear(e,o,t[6])
end
end
end
local t=303112109
local t=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if t then
local t=t:GetBuffData()
local t=t[1]
if t>0 then
a.AddBuffGrowth(e,t)
end
end
end
function t.AddBuffLightlessPear(e,a,i,o)
local t=e:GetBuffData()
local h=t[7]
local s=t[8]
local t={t[9]}
local n=303112114
local n=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(n)
if n then
local a=n:GetBuffData()
for e=3,6 do
table.insert(t,a[e])
end
else
for e=3,6 do
table.insert(t,0)
end
end
if o==nil then
a:AddBuff(e.CurrHeroCtrl,h,s,t,i)
else
a:CheckAddBuff(o,e.CurrHeroCtrl,h,s,t,i)
end
end
function t.AddBuffGrowth(e,i)
local t=e:GetBuffData()
local o=t[11]
local n=t[12]
local a={}
for e=13,16 do
table.insert(a,t[e])
end
table.insert(a,t[17])
local i=e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,n,a,i)
local t=303112109
local a=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if a then
local o=r:GetHeroBuffFloor(e.CurrHeroCtrl,o)
local e=ModulesInit.BattleBuffMgr.GetBuffScript(t)
e.OnAddBuffGrowth(a,o)
end
if i then
local t=303112114
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.OnAddBuffGrowth(e)
end
end
end
return a

