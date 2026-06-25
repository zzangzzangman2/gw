local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,o,t,a)
if(t==nil or a==nil)then
GameInit.LogError("执行Buff脚本 atkHeroCtrl or beAtkHeroCtrl is nil")
return nil
end
local o=o[1]*MillionCoe
local a={}
local o=math.floor(t.HeroBattleInfo.MaxHP*o)
local t=HeroBuffValueInfo:New()
t.buffId=e.buffId
t.attrId=HeroAttrId.trueDmg
t.value=o
a[#a+1]=t
if(GameInit.DebugLog and not GameInit.IsBattlePlayVerify)then

end
return a
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.normalAttack or e==BuffTriggerTime.skill2Attack)then
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

