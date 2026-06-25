local t={}
local o=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,a,t,o)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t and t.HeroBattleInfo then
local a=t.HeroBattleInfo:GetBuff(a[1])
if a then
local t=t.HeroBattleInfo:GetGranBuffCanSteal(true,1)
for a=1,#t do
local t=t[a]
local a=t.buffId
local i=t:GetRound()
local o=t:GetBuffData()
local t=t:GetFloors()
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,a,i,o)
if e.CurrHeroCtrl.HeroBattleInfo then
e.CurrHeroCtrl.HeroBattleInfo:PlayBattleEffectWithBuffId(a)
end
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return o

