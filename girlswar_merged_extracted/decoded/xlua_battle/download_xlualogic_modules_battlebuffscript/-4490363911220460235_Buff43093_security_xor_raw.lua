local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(t,o,a,e)
if(a==nil or e==nil)then
GameInit.LogError("执行Buff脚本 atkHeroCtrl or beAtkHeroCtrl is nil")
return nil
end
local e=HeroBuffValueInfo:New()
e.buffId=t.buffId
e.attrId=HeroAttrId.tureDmgAfterCritical
local t=a:GetFinalAtk()*o[1]*MillionCoe
t=math.floor(t)
e.value=t
a.HeroBattleInfo:AddTempBuffValue(e)
return nil
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.attack)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return i

