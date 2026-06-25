local s=require("Modules/Battle/BattleUtil")
local i={}
local r=i
function i.GetCanAdd(e,e)
return true
end
function i.DoAction(a,e,o,o,t,o)
if a==nil or a.CurrHeroCtrl==nil or a.CurrHeroCtrl.HeroBattleInfo==nil or a.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local i=t.triggerSkillAtkType
local o=e[1]
local n=e[2]
local h=e[3]
local t=e[6]or 0
if s:IsDependAtkType(i)then
for t=1,t do
o=o/e[4]
end
if t>=e[5]then
return nil
end
else
t=0
end
local i=s:GetUnderControlTransferSkinEnemyList(a.CurrHeroCtrl,n)
while#i>0 do
local i=RandomTableWithSeed(i,1)
local i=i[1]
if i==nil then
break
end
local a=i:CheckAddBuff(o,a.CurrHeroCtrl,n,h,0)
if a==false then
break
end
t=t+1
o=o/e[4]
if t>=e[5]then
break
end
end
e[6]=t
return nil
end
function i.GetCanTrigger(e)
if e==BuffTriggerTime.skillPlayEnd or e==BuffTriggerTime.skill2PlayEnd then
return true
end
return false
end
function i.SetLogicData(e,e)
end
return r

