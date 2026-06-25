local e={}
local n=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(i,t,a,e)
if(a==nil or e==nil)then
GameInit.LogError("执行Buff脚本 atkHeroCtrl or beAtkHeroCtrl is nil")
return nil
end
local o=t[1]*MillionCoe
local t={}
local e=HeroBuffValueInfo:New()
e.buffId=i.buffId
e.attrId=HeroAttrId.trueDmg
e.value=a.HeroBattleInfo.MaxHP*o
t[#t+1]=e
return t
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.normalAttack)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.GetWeight(e,a,t)
return e.buffWeight[1]*t[1]
end
return n

