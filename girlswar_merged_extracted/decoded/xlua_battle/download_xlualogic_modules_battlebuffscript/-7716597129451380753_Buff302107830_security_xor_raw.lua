local e={}
local o=e
function e.GetCanAdd(e,e)
return true
end
function e.DoAction(e,a,o,o,t)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if t and t.triggerSkillAtkType==ETriggerSkillAtkType.Normal then
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
for t=1,#e do
local e=e[t]
local t=a[1]
local o=e.HeroBattleInfo:GetBuff(302107815)
if o then
t=t*a[2]
end
e:AddFuryWithBuff(t)
e.HeroBattleInfo:PlayBattleEffectWithType(BattleEffectType.AddFury)
end
end
end
function e.GetCanTrigger(e)
if(e==BuffTriggerTime.skillAttackComplete)then
return true
end
return false
end
function e.SetLogicData(e,e)
end
return o

