local a=require("Modules/Battle/BattleUtil")
local t={}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.DoAction(e,i,o,o,t,n)
if e==nil or e.CurrHeroCtrl==nil or e.CurrHeroCtrl.HeroBattleInfo==nil or e.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
if a:CheckCanTriggerAttackTask(t.triggerSkillAtkType)==false then
return
end
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e.CurrHeroCtrl,BattleHeroType.ourAll)
for o=1,#t do
local a=303111003
local e=e.CurrHeroCtrl.HeroBattleInfo:GetBuff(a)
if e then
local a=ModulesInit.BattleBuffMgr.GetBuffScript(a)
if n.buffTriggerTime==BuffTriggerTime.skillPlay then
a.AddBuffBabai(e,t[o],i[1])
elseif n.buffTriggerTime==BuffTriggerTime.skill2Play then
a.AddBuffBabai(e,t[o],i[2])
end
end
end
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.skillPlay
or e==BuffTriggerTime.skill2Play)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
return s

