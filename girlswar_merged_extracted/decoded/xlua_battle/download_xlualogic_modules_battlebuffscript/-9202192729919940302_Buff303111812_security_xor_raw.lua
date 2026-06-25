local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,o,o,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local a=e[1]
local o=e[2]
local i={e[3],e[4]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,i)
local a=e[5]
local o=e[6]
local e={e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
elseif a.buffTriggerTime==BuffTriggerTime.eachRoundStart then
local a=RandomMgr:GetBattleRandomWithRange(e[12],e[13])
local o={303111813,303111814,303111815}
local a=RandomTableWithSeed(o,a)
for o=1,#a do
local a=a[o]
if a==303111813 then
local o=e[14]
local a=e[15]
local e={e[16],e[17]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
elseif a==303111814 then
local a=e[18]
local o=e[19]
local e={e[20],e[21]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
elseif a==303111815 then
local a=e[22]
local o=e[23]
local e={e[24],e[25]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
end
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.DoBeansActionSkill(e,o)
local a=e:GetBuffData()
local t=303111801
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(t)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(t)
t.AddBuffFlaw(e,o,a[9])
end
end
return i

