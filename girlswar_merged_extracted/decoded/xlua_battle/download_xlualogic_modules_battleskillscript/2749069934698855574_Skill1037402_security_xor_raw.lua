local e={
}
local s=e
function e.DoAction(e,t)
local t=e:JudgeSkillPreView(t)
e:AddImmuneBuff(t[1])
end
function e.GetAfterActionType()
return EBattleSkillAfterActionType.Normal
end
function e.DoAfterAction(t,e)
local e=t:JudgeSkillPreView(e)
local i=e[2]
local o=e[3]
local a={e[4]}
t:AddBuff(t,i,o,a)
local n=e[5]
local o=e[6]
local i={e[7]}
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a~=nil)then
for a,e in ipairs(a)do
e:AddBuff(t,n,o,i)
end
end
local a=e[8]
local o=e[9]
t:AddBuff(t,a,o,0)
return{
duration=e[10],
success=true
}
end
return s 
