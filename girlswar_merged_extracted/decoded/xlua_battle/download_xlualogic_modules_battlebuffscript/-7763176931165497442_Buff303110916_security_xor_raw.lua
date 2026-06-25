local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,o,i,o,a)
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
elseif a.buffTriggerTime==BuffTriggerTime.enemyTeamHeroDead then
local a=303110907
local a=i.HeroBattleInfo:GetBuff(a)
if a then
local a=303110906
local o=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if o then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(a)
t.AddBuffBloodPower(o,e[9])
end
t.CurrHeroCtrl:AddFuryWithBuff(e[10])
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.enemyTeamHeroDead)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.DoBeansActionSmallSkill(o,i)
local e=o:GetBuffData()
local t=303110901
local t=o.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if t then
local a=t:GetFloors()
local n=e[11]
local s=e[12]
local t={}
if a>=e[13]then
table.insert(t,e[14])
table.insert(t,e[15])
end
if a>=e[16]then
table.insert(t,e[17])
table.insert(t,e[18])
end
if a>=e[19]then
table.insert(t,e[20])
table.insert(t,e[21])
end
if a>=e[22]then
table.insert(t,e[23])
table.insert(t,e[24])
end
i:AddBuff(o.CurrHeroCtrl,n,s,t)
end
end
return i

