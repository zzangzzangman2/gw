local n=require("Modules/Battle/BattleUtil")
local e=require("Modules/Battle/Formula")
local t={}
local s=t
function t.GetCanAdd(e,e)
return true
end
function t.OnAdd(e,t)
if e==nil or e.CurrHeroCtrl==nil or t==nil then
return
end
local t={
buffId=e.buffId,
reduceHpMinHpPercent=0,
reduceHpResRate=t[1],
resBeAttackType=AttackType.BigSkill,
}
e.CurrHeroCtrl:AddDamageResData(t)
end
function t.OnRemoveSelf(e,t)
if e==nil or e.CurrHeroCtrl==nil then
return
end
e.CurrHeroCtrl:ClearDamageResData(e.buffId)
end
function t.DoAction(t,e,a,a,i,a)
if t==nil or t.CurrHeroCtrl==nil or t.CurrHeroCtrl.HeroBattleInfo==nil or t.CurrHeroCtrl.HeroBattleInfo.CurrHP<=0 then
return
end
e[10]=e[10]or 0
e[10]=e[10]+e[2]
ModulesInit.ProcedureNormalBattle:PlayAudioLua(312)
if e[10]>=e[3]then
local a=t.CurrHeroCtrl.HeroId
local o=1907101
local e={
buffId=t.buffId,
triggerSkillAtkType=ETriggerSkillAtkType.FightBack,
skillParam=e,
}
local t=ModulesInit.ProcedureNormalBattle.GetAttackTaskBySkillDidAndHeroId(o,a)
if t==nil then
n:AddTriggerAttackTask(a,o,e,i)
end
end
return nil
end
function t.GetCanTrigger(e)
if(e==BuffTriggerTime.sufferSkillDmg)then
return true
end
return false
end
function t.SetLogicData(e,e)
end
function t.HandleOnDoAction(t,e)
e[10]=0
return true
end
return s

