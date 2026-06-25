local e={}
local a=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,o,i,i,i,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.now then
a.AddBuffFallingCherry(e,o[1])
elseif t.buffTriggerTime==BuffTriggerTime.eachRoundEnd then
a.AddBuffFallingCherry(e,o[5])
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.AddBuffFallingCherry(e,a)
local t=e:GetBuffData()
local i=t[2]
local o=t[3]
local t={t[4]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,i,o,t,a)
end
return a

