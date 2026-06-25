local e=require("Modules/Battle/BattleUtil")
local a={
}
local n=a
function a.DoAction(t,i,e)
local a=t:JudgeSkillPreView(i)
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(e==nil or#e<=0)then
return nil
end
ModulesInit.ProcedureNormalBattle.SetCurrBeAttackHeroCtrls(e)
local o=a[5]
local n=t.CurrBattleTeam:GetTotalHPPercent()
local a=math.min((1-n)*a[7]/a[6],a[8]*MillionCoe)
a=math.max(0,a)
o=math.floor(o*(1+a))
local a=#e
for a=1,a do
local e=e[a]
ModulesInit.ProcedureNormalBattle.SkillHurt(t,e,i,o)
end
return nil
end
function a.GetCanTriggerSkill(e)
return false
end
function a.DoPassiveAction(a,e)
local t=a:JudgeSkillPreView(e)
local o=t[1]
local i=t[2]
local e={e.id}
for a=3,4 do
if t[a]then
table.insert(e,t[a])
else
table.insert(e,0)
end
end
table.insert(e,0)
a:AddBuff(a,o,i,e)
return nil
end
return n 
