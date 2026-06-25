local t={}
local n=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,t,o,i,a,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
local i=e.CurrHeroCtrl.HeroId
if i==o.HeroId then
local o=a.criticalOrBlock
local a=a.triggerSkillType
if o~=1 and a==EBattleSkillType.SkillSmall then
local o=t[4]
local a=t[5]
local t={t[6],t[7]}
e.CurrHeroCtrl:AddBuff(e.CurrHeroCtrl,o,a,t)
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.afterAttacked)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.DoActionSmallSkill(t,a)
local e=t:GetBuffData()
local o=e[1]
local i=e[2]
local e=e[3]
local n=0
a:CheckAddBuff(o,t.CurrHeroCtrl,i,e,n)
end
return n

