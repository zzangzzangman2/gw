local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,o,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=a.triggerSkillAtkType
if a==ESkillAttackType.Normal then
local i=t[1]
local o=t[2]
local a={}
for e=4,12 do
table.insert(a,t[e])
end
local t=t[3]
e.CurrHeroCtrl:AddBuffWithMaxFloor(e.CurrHeroCtrl,i,o,a,1,t)
end
return nil
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.attack)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return n

