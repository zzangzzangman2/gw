local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t,t)
if e.CurrHeroCtrl:GetArmor()<=0 then
e:SetRound(1)
if e.CurrHeroCtrl.HeroBattleInfo then
e:RemoveBuffEffect()
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.armorDown)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return t

