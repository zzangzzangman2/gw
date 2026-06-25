local n=require("Modules/Battle/BattleUtil")
local t={}
local h=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,s,a,o,t,i)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if i.buffTriggerTime==BuffTriggerTime.afterAttacked then
if a==nil or o==nil or t==nil then
return
end
if e.CurrHeroCtrl.HeroId~=a.HeroId then
return
end
if t.triggerSkillType~=AttackType.BigSkill then
return
end
local t=t.reduceHpValue
if t==nil or t<=0 then
return
end
local a=e:GetFloors()
local t=math.floor(t*s[1]*a*MillionCoe)
if t>0 then
n:AddSepsisHp(e.CurrHeroCtrl,o,t,true,true)
end
end
end
function t.GetCanTrigger(e)
if e==BuffTriggerTime.afterAttacked then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return h

