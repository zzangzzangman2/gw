local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(o,e,a,t)
if(a==nil or t==nil)then
GameInit.LogError("执行Buff脚本 atkHeroCtrl or beAtkHeroCtrl is nil")
return nil
end
local i=e[1]
local n=e[2]
local a={}
local e=HeroBuffValueInfo:New()
e.buffId=o.buffId
e.attrId=HeroAttrId.IgnoreDefRate
e.value=i
if(t.HeroBattleInfo:GetBuff(2003)~=nil or t.HeroBattleInfo:GetBuff(2004)~=nil)then
e.value=n
end
a[#a+1]=e
return a
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
return e.buffWeight[1]*t[1]+e.buffWeight[2]*t[2]
end
return i

