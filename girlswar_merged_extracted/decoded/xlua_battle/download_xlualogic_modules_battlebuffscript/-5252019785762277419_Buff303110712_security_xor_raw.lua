local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,o,o,o,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local i=e[1]
local o=e[2]
local a={e[3],e[4]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,o,a)
local i=e[5]
local o=e[6]
local a={e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,i,o,a)
local a=e[9]
local e=e[10]
local o={}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,e,o)
elseif a.buffTriggerTime==BuffTriggerTime.resurgence then
local a=e[9]
local o=e[10]
local e={}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,e)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.resurgence)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

