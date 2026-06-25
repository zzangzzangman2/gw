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
local n=t[1]
local i=t[2]
local o={}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,n,i,o)
a.AddBuffLockHp(e,t[3])
local t=303111606
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.CheckAddBuffLockHpByEnergyStorage(e)
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.CheckAddBuffLockHp(e,o)
local t=e:GetBuffData()
if o>=t[11]then
a.AddBuffLockHp(e,t[12])
return true
end
return false
end
function t.AddBuffLockHp(t,o)
local e=t:GetBuffData()
if o<=0 then
return
end
if e[14]>=e[13]then
return
end
e[14]=e[14]+1
local i=e[4]
local n=e[5]
local a={}
for o=6,10 do
table.insert(a,e[o])
end
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,n,a,o)
end
return a

