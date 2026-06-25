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
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[3],e[4])
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[5],e[6])
elseif a.buffTriggerTime==BuffTriggerTime.attack then
local o=302108507
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if a then
local o=ModulesInit.BattleBuffMgr.GetBuffScript(o)
o.GainTaskHalo(a,e[7])
local i=e[8]
local a=e[9]
local o={e[10],e[11]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,a,o)
e[12]=e[12]+1
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.attack)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.GetBraveTaskcount(e)
local e=e:GetBuffData()
return e[12]
end
return i

