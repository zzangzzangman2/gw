local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,t,i,i,o,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.isTriggerAllSkillAttackCompleteBuffForEver=true
elseif a.buffTriggerTime==BuffTriggerTime.allHeroSkillAttackComplete then
if o.triggerSkillType==AttackType.BigSkill then
t[2]=t[2]+t[1]
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.allHeroSkillAttackComplete)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.ConsumeDragonDust(e)
local e=e:GetBuffData()
local t=e[2]
e[2]=0
return t
end
return i

