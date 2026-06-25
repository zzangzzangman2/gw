local i=require("Modules/Battle/BattleUtil")
local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
if e.CurrHeroCtrl:GetBuffTeamStatCount(e.buffId,"Immune")<t[4]
and e.CurrHeroCtrl:GetBuffTeamStatCount(e.buffId,e.CurrHeroCtrl.HeroId)<t[5]then
e.CurrHeroCtrl:AddImmuneLockHp(e.buffId,EBuffTriggerlLevel.Ten)
end
end
function e.OnRemoveSelf(e,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
e.CurrHeroCtrl:RemoveImmuneLockHp(e.buffId)
end
function e.DoAction(e,a,n,s,o,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t.buffTriggerTime==BuffTriggerTime.now then
e.CurrHeroCtrl.HeroBattleInfo:AddBuffValue(e.buffId,a[1],a[2])
elseif t.buffTriggerTime==BuffTriggerTime.attacked then
if i:IsNormalSkillAtkType(o.triggerSkillAtkType)then
local t=HeroBuffValueInfo:New()
t.buffId=e.buffId
t.attrId=HeroAttrId.trueDmg
t.value=a[6]
n.HeroBattleInfo:AddTempBuffValue(t)
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.attacked)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.OnImmuneLockHp(e)
local t=e:GetBuffData()
e.CurrHeroCtrl:AddBuffTeamStatCount(e.buffId,1,e.CurrHeroCtrl.HeroId)
e.CurrHeroCtrl:AddBuffTeamStatCount(e.buffId,1,"Immune")
if e.CurrHeroCtrl:GetBuffTeamStatCount(e.buffId,"Immune")>=t[4]
or e.CurrHeroCtrl:GetBuffTeamStatCount(e.buffId,e.CurrHeroCtrl.HeroId)>=t[5]then
e.CurrHeroCtrl:RemoveImmuneLockHp(e.buffId)
end
end
return o

