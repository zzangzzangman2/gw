local e={}
local t=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
e.CurrHeroCtrl:AddForbidSpecialHeal(e.buffId)
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl:RemoveForbidSpecialHeal(e.buffId)
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.ExcuteAndCheckRemove(e)
if e==nil or e.CurrHeroCtrl==nil then
return
end
local t=e:GetBuffData()
e.CurrHeroCtrl:AddBuffTeamStatCount(e.buffId,1)
if e.CurrHeroCtrl:GetBuffTeamStatCount(e.buffId)>=t[1]then
return true
end
return false
end
return t

