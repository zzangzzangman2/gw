local e=require("Modules/Battle/BattleUtil")
local e={}
local n=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,t,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e.isExec=true
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.StartAttackWithSmallSkill(t,a)
local e=t:GetBuffData()
local o=0
for i=1,#a do
local a=a[i]
local i=a.HeroBattleInfo.CurrHP
local i=i*e[1]*MillionCoe
local i=a:RealHurtWithBuff(i,t)
if i then
local i=i.hurtValue
o=o+i
local i=e[2]
local o=e[3]
local e={e[4],e[5]}
a:AddBuffAfterRemove(t.CurrHeroCtrl,i,o,e)
end
end
local o=e[6]
local a=e[7]
local i={e[8],e[9]}
local e=e[10]
t.CurrHeroCtrl:AddBuffWithMaxFloor(t.CurrHeroCtrl,o,a,i,1,e)
end
return n

