local o={}
local n=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(t,e,a,i,i,o)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if o.buffTriggerTime==BuffTriggerTime.now then
if#e>=4 then
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[1],e[2])
t.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(t.buffId,e[3],e[4])
end
elseif o.buffTriggerTime==BuffTriggerTime.normalOrSmallSkillAttacked then
if a and#e>=7 then
local i=e[5]
local o=e[6]
local e=e[7]
local e=a:CheckAddBuff(i,t.CurrHeroCtrl,o,e)
if e then
a:SetEffectBuffIdAfterTimeline(o)
end
end
elseif o.buffTriggerTime==BuffTriggerTime.sufferSkillDmg then
if a and#e>=8 then
local i=e[5]
local o=e[6]
local e=e[8]
local e=a:CheckAddBuff(i,t.CurrHeroCtrl,o,e)
if e then
a:SetEffectBuffIdAfterTimeline(o)
end
end
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.sufferSkillDmg
or e==BuffTriggerTime.normalOrSmallSkillAttacked)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return n

