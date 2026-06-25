local o={}
local s=o
function o.GetCanAdd(e,e)
return true
end
function o.DoAction(t,e,i,o,n,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.now then
local a=e[1]
local o=e[2]
local i={e[3],e[4]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,a,o,i)
local o=e[5]
local a=e[6]
local e={e[7],e[8]}
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,a,e)
elseif a.buffTriggerTime==BuffTriggerTime.hpChange then
local o=e[9]
local a=t.CurrHeroCtrl:CurrHPPer()
if a*OneMillion<e[11]then
local a=math.floor((e[11]-a*OneMillion)*e[13])
a=math.min(a,e[14])
local i=e[10]
local n={e[12],a}
local e=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(o)
if e then
local t=ModulesInit.BattleBuffMgr.GetBuffScript(o)
t.ResetEvadeValue(e,a)
else
t.CurrHeroCtrl:AddBuff(t.CurrHeroCtrl,o,i,n)
end
else
t.CurrHeroCtrl.HeroBattleInfo:RemoveBuffWithId(o,BuffRemoveType.Expire)
end
elseif a.buffTriggerTime==BuffTriggerTime.allSkillAttack then
if(i.IsOurHero==t.CurrHeroCtrl.IsOurHero)then
if n.triggerSkillType==AttackType.BigSkill then
local a=303111606
local t=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if t then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.AddBuffEnergyStorage(t,e[16])
end
end
end
elseif a.buffTriggerTime==BuffTriggerTime.skill2Attack
or a.buffTriggerTime==BuffTriggerTime.skillAttack then
local a=303111607
local a=t.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if a then
local a=a:GetFloors()
local o=math.min(a,e[21])
local a=HeroBuffValueInfo:New()
a.buffId=t.buffId
a.attrId=e[17]
a.value=e[18]*o
i.HeroBattleInfo:AddTempBuffValue(a)
local a=HeroBuffValueInfo:New()
a.buffId=t.buffId
a.attrId=e[19]
a.value=e[20]*o
i.HeroBattleInfo:AddTempBuffValue(a)
end
end
end
function o.GetCanTrigger(e)
if(e==BuffTriggerTime.now
or e==BuffTriggerTime.hpChange
or e==BuffTriggerTime.allSkillAttack
or e==BuffTriggerTime.skill2Attack
or e==BuffTriggerTime.skillAttack)then
return true
end
return false
end
function o.SetLogicData(e,e)
end
return s

