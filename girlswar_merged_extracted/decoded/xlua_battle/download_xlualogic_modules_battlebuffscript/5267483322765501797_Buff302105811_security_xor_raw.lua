local a={}
local o=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(e,t,a,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local i=t[1]
local o=t[2]
local a={t[3],t[4]}
local t=t[5]
e.CurrHeroCtrl:AddBuffWithMaxFloor(e.CurrHeroCtrl,i,o,a,1,t)
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.skill2Attack or e==BuffTriggerTime.mateSmallSkilAttack)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return o

