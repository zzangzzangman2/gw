local e=require("Modules/Battle/BattleUtil")
local a={}
local i=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,a,o,i)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local e=e:GetCurEnemyList(t.CurrHeroCtrl)
if#e==1 then
local e=HeroBuffValueInfo:New()
e.buffId=t.buffId
e.attrId=a[1]
e.value=a[2]
o.HeroBattleInfo:AddTempBuffValue(e)
e.buffId=t.buffId
e.attrId=a[3]
e.value=a[4]
o.HeroBattleInfo:AddTempBuffValue(e)
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.normalAttack)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
return i

