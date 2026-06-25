local e={}
local s=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,o,n,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local a=a.triggerSkillAtkType
if a~=ESkillAttackType.Attach then
local i=t[1]
local o=t[2]
local a={}
for e=3,9 do
table.insert(a,t[e])
end
n:AddBuff(e.CurrHeroCtrl,i,o,a)
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
return s

