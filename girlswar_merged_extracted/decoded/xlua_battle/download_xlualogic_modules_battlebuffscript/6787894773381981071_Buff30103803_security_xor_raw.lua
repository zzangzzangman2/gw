local o={}
local s=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(t,e,a,a,a,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if#e<6 or o==nil then
GameInit.LogError("Buff30103803 buffData 数量应该 大于等于 6")
return
end
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(e[1])
if(o.buffTriggerTime==BuffTriggerTime.skill2Attack and e[6]<=0)
or o.buffTriggerTime==BuffTriggerTime.skillAttack
then
if a then
local e=a:GetFloors()
a:ReduceFloors(1)
if e<=1 then
a:SetRound(1)
end
end
elseif o.buffTriggerTime==BuffTriggerTime.teamHeroDead
or(o.buffTriggerTime==BuffTriggerTime.enemyTeamHeroDead and e[6]>0)then
local s=e[1]
local i=e[2]
local n={e[3],e[4]}
local o=0
if(a)then
o=a:GetFloors()
end
if o<e[5]then
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,s,i,n)
end
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.skill2Attack
or e==BuffTriggerTime.skillAttack
or e==BuffTriggerTime.teamHeroDead
or e==BuffTriggerTime.enemyTeamHeroDead)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return s

