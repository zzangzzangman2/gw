local e=require("Modules/Battle/BattleUtil")
local e={
}
local i=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
return nil
end
function e.GetCanTriggerSkill(e)
return false
end
function e.DoPassiveAction(e,t)
local t=e:JudgeSkillPreView(t)
local o=ModulesInit.ProcedureNormalBattle.GetBattleHeros(e,BattleHeroType.fFightPet)
if o then
local n=t[1]
local i=t[2]
local a={}
for e=3,11 do
table.insert(a,t[e])
end
for e=1,4 do
table.insert(a,0)
end
o:AddBuff(e,n,i,a)
end
return nil
end
return i 
