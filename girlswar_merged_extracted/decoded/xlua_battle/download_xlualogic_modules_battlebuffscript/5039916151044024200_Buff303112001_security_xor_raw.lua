local n=require("Modules/Battle/BattleUtil")
local o={}
local s=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(e,a,s,o,i,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.isTriggerAllSkillAttackCompleteBuffForEver=true
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,a[1],a[2])
e.CurrHeroCtrl.HeroBattleInfo:CheckAddBuffValue(e.buffId,a[3],a[4])
elseif t.buffTriggerTime==BuffTriggerTime.afterAttacked then
if e.CurrHeroCtrl.HeroId==o.HeroId then
local t=i.reduceHpValue
e.CurrHeroCtrl:AddBuffTeamStatCount(e.buffId,t,e.CurrHeroCtrl.HeroId)
end
elseif t.buffTriggerTime==BuffTriggerTime.allHeroSkillAttackComplete then
local i=e.CurrHeroCtrl:GetAllBuffTeamStatCount(e.buffId)
local t=0
local o=0
for i,a in pairs(i)do
if a>t or(a>0 and a==t and i<o)then
t=a
o=i
end
end
e.CurrHeroCtrl:ResetAllBuffTeamStatCount(e.buffId)
if t>0 then
local a=math.floor(t*a[5]*MillionCoe)
local t=303112001
local i,t=n:GetHeroNoBuffByType(e.CurrHeroCtrl,BattleHeroType.ourAll,t)
for i=1,#t do
local t=t[i]
if t.HeroId~=o then
t:RealHurtWithBuff(a,e)
end
end
end
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.afterAttacked
or e==BuffTriggerTime.allHeroSkillAttackComplete)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return s

