local t={}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,o,a)
if(t[1]>=RandomMgr:GetBattleRandom())then
local t=t[2]
local i=1050
local n=-1
local o={t}
a:AddBuff(a,i,n,o)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
if(e.CurrHeroCtrl.HeroBattleInfo:GetBuff(60078)~=nil)then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,HeroAttrId.defRate,t)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.attack)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.GetWeight(t,a,e)
return t.buffWeight[1]*e[1]
end
return s

