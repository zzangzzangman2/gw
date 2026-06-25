local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.OnRemoveSelf(e,t)
if(e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.CurrBattleTeam==nil)then
return
end
if(e.buff_round)then
if(e.buff_round>0)then
local t=e.CurrHeroCtrl.CurrBattleTeam:GetOneRandomHeroExcludeHeroId(e.CurrHeroCtrl.HeroId)
if(t)then
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local o=e.buffId
local a=e.buff_round
local e=e.buff_Value
t:AddBuff(t,o,a,e)
end
end
end
end
function t.DoAction(e,t,a,a,a)
local a=t[1]
e.buff_round=a
e.buff_Value={t[1],t[2]}
local o={}
local a=HeroBuffValueInfo:New()
a.buffId=e.buffId
a.attrId=HeroAttrId.takeDamagePercent
a.value=t[2]
o[#o+1]=a
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return o
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.GetWeight(t,a,e)
return t.buffWeight[1]*e[1]
end
return i

