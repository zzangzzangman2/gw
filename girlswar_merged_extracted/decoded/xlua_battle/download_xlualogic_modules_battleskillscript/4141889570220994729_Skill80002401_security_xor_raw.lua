local e=require("Modules/Battle/BattleUtil")
local e={
}
local a=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
return nil
end
function e.GetCanTriggerSkill(e)
if(e==BuffTriggerTime.battleBeginPetHelpSkill)then
return true
end
return false
end
return a 
