local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(a,o,t,e)
if(t==nil or e==nil)then
GameInit.LogError("执行Buff脚本 atkHeroCtrl or beAtkHeroCtrl is nil")
return nil
end
local e=(1-(e.HeroBattleInfo.CurrHP/e.HeroBattleInfo.MaxHP))*o[1]
e=math.floor(e)
if(e>0)then
local o={}
local t=HeroBuffValueInfo:New()
t.buffId=a.buffId
t.attrId=HeroAttrId.injureRateAdd
t.value=e
o[#o+1]=t
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return o
else
return nil
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.attack)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return i

