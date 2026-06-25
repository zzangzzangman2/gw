local n=require("Modules/Battle/BattleUtil")
local a={}
local s=a
function a.GetCanAdd(e,e)
return true
end
function a.DoAction(t,e,a,o,n,i)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if i.buffTriggerTime==BuffTriggerTime.attacked then
if a.profession==e[1]then
local a=HeroBuffValueInfo:New()
a.buffId=t.buffId
a.attrId=e[2]
a.value=e[3]
t.CurrHeroCtrl.HeroBattleInfo:AddTempBuffValue(a)
end
elseif i.buffTriggerTime==BuffTriggerTime.attack then
if o.profession==e[4]then
local a=HeroBuffValueInfo:New()
a.buffId=t.buffId
a.attrId=e[5]
a.value=e[6]
t.CurrHeroCtrl.HeroBattleInfo:AddTempBuffValue(a)
end
elseif i.buffTriggerTime==BuffTriggerTime.enemyTeamHeroDead then
if o.HeroBattleInfo and o.HeroBattleInfo.CurrSepsisHp>0 then
local a=e[14]
local o=e[15]
local i={e[16],e[17],e[18],e[19]}
local e=e[20]
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,i,e)
end
end
end
function a.GetCanTrigger(e)
if(e==BuffTriggerTime.attack
or e==BuffTriggerTime.attacked
or e==BuffTriggerTime.enemyTeamHeroDead)then
return true
end
return false
end
function a.SetLogicData(e,e)
end
function a.DoActionForSkill(t,e)
local a=n:GetEnemySepsisCount(t.CurrHeroCtrl)
local o=a
local a=e[7]
local i=e[8]
local n={e[9],e[10],e[11],e[12]}
local e=math.min(o,e[13])
t.CurrHeroCtrl:AddBuffWithFinalFloor(t.CurrHeroCtrl,a,i,n,e)
end
return s

