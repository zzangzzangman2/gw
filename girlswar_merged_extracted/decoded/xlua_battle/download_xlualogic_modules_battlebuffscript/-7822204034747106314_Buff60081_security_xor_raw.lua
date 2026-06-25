local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,o,a,t)
if(a==nil or t==nil)then
GameInit.LogError("执行Buff脚本 atkHeroCtrl or beAtkHeroCtrl is nil")
return nil
end
local a={}
local t=HeroBuffValueInfo:New()
t.buffId=e.buffId
t.attrId=HeroAttrId.furyRate
t.value=o[1]
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
a[#a+1]=t
return a
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.attacked)then
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

