local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,o,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime~=BuffTriggerTime.now then
t[3]=t[3]-1
end
local a=math.ceil(t[3]/2)
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,t[1],t[2]*a)
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.eachRoundStart
or e==BuffTriggerTime.eachRoundEnd)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return o

