local i=require("Modules/Battle/BattleUtil")
local a={}
local l=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,o,o,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local o=e[1]
local a=e[2]
local i={e[3],e[4]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,i)
local a=e[5]
local o=e[6]
local e={e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.DoBeansActionBigSkill1(t,a)
local e=t:GetBuffData()
if a then
local o=e[9]
local a=e[10]
local e={e[11],e[12]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
end
end
function a.DoBeansActionBigSkill2(o,a)
local t=o:GetBuffData()
local e={}
for t,o in pairs(a)do
local t=i:GetTargetHeroCtrl(t)
if t then
local a=303111722
local t=t.HeroBattleInfo:GetBuff(a)
if(t)then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
local t=a.GetEnemyBuffData(t)
t.buffFloors=t.buffFloors+o
table.insert(e,t)
end
end
end
table.sort(e,function(e,t)
return e.heroId<t.heroId
end)
local d=t[16]
local s=t[17]
local r=t[18]
local n={}
local h=1
for a=1,#e do
local e=e[a]
if e.triggerCount<h and e.buffFloors>=t[15]then
local a=i:GetTargetHeroCtrl(e.heroId)
if a then
local i=a:CheckAddBuff(d,o.CurrHeroCtrl,s,r,n)
if i then
local e=303111721
local t=1
local i={}
a:AddBuff(o.CurrHeroCtrl,e,t,i)
end
e.triggerCount=e.triggerCount+1
e.buffFloors=e.buffFloors-t[15]
end
end
end
end
return l

