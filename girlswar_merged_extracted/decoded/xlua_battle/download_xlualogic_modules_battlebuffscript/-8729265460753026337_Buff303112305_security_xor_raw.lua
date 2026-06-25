local o=require("Modules/Battle/BattleUtil")
local e={}
local i=e
function e.GetCanAdd(e,e)
return true
end
function e.OnAdd(e,t)
e.CurrHeroCtrl.isTriggerAllSkillAttackCompleteBuffForEver=true
end
function e.OnRemoveSelf(e,t)
e.CurrHeroCtrl.isTriggerAllSkillAttackCompleteBuffForEver=false
end
function e.DoAction(e,s,n,h,t,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a.buffTriggerTime==BuffTriggerTime.allHeroSkillAttackComplete then
if n==nil or t==nil then
return
end
if t.teamId~=e.CurrHeroCtrl:GetTeamId()then
return
end
if o:IsDependAtkType(t.triggerSkillAtkType)then
return
end
i.TryAddDestinyOnOurHeroActionEnd(e,s)
end
end
function e.GetCanTrigger(e)
if e==BuffTriggerTime.allHeroSkillAttackComplete then
return true
end
return false
end
function e.SetLogicData(e,e)
end
function e.TryAddDestinyOnOurHeroActionEnd(e,t)
if t[1]<RandomMgr:GetBattleRandom()then
return
end
local a=303112301
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
a.AddBuffDestiny(e,e:GetBuffData(),t[2])
end
end
function e.SyncExSkillStolenGranBuffToSelfRow(e,a)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil then
return
end
if a==nil then
return
end
local t=e.CurrHeroCtrl
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.selfRow)
for i=1,#e do
local e=e[i]
if e.HeroId~=t.HeroId
and e.HeroBattleInfo~=nil
and e.HeroBattleInfo.CurrHP>0 then
o:AddBuffWithBuffCopy(e,t,a)
end
end
end
return i

