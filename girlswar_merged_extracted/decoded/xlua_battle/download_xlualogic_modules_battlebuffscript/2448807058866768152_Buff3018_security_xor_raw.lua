local t={}
local i=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(i,t,e,a)
if(e==nil or a==nil)then
GameInit.LogError("执行Buff脚本 atkHeroCtrl or beAtkHeroCtrl is nil")
return nil
end
local o=t[1]
local a=t[2]
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
local t=e.HeroBattleInfo:GetGranBuff(true)
local e=0
local t=#t-1
for t=1,t do
e=e+o
end
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then


end
e=math.min(e,a)
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
local a={}
local t=HeroBuffValueInfo:New()
t.buffId=i.buffId
t.attrId=HeroAttrId.injureRateAdd
t.value=e
a[#a+1]=t
return a
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.normalAttack)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]+e.buffWeight[2]*t[2]
end
return i

