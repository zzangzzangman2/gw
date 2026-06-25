local t={}
local a=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,i,i,i,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[1],t[2])
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,t[3],t[4])
a.AddBuffMustSkill(e)
elseif o.buffTriggerTime==BuffTriggerTime.resurgence then
a.AddBuffMustSkill(e)
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.resurgence)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.AddBuffMustSkill(e)
local t=e:GetBuffData()
local a=t[5]
local o=t[6]
local t={}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,o,t)
end
return a

