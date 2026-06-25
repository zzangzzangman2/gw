local o=require("Modules/Battle/BattleUtil")
local a={}
local n=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,a,a,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=o.GetOtherHeroInSameColumn(t.CurrHeroCtrl)
if a then
if a.battleStationRow==1 then
local o=e[1]
local i=e[2]
local e={e[3],e[4]}
a:AddBuff(t.CurrHeroCtrl,o,i,e)
else
local o=e[5]
local i=e[6]
local e={e[7],e[8],e[9]}
a:AddBuffAfterRemove(t.CurrHeroCtrl,o,i,e)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.skill3Play
or e==BuffTriggerTime.skill2Play
or e==BuffTriggerTime.skillPlay)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return n

