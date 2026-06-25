local e={
}
local o=e
function e.DoAction(e,a,t)
local o=e:JudgeSkillPreView(a)
local t=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.eAttrLow,1,HeroAttrId.hp)
if t==nil or#t==0 then
return nil
end
local t=t[1]
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrl(t)
local o=o[3]
ModulesInit.ProcedureNormalBattle.SkillHurt(e,t,a,o)
return nil
end
function e.GetCanTriggerSkill(e)
if e==BuffTriggerTime.smallRoundEndPetHelpSkill then
return true
end
return false
end
function e.DoPassiveAction(e,a)
local t=e:JudgeSkillPreView(a)
local o=t[1]
local t=t[2]
local a={a.id}
e:AddBuff(e,o,t,a)
return nil
end
return o

