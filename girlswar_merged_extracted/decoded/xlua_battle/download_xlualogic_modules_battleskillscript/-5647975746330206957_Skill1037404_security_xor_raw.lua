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
local i=e[6]
local o={e[7]}
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a~=nil)then
for a,e in ipairs(a)do
e:AddBuff(t,n,i,o)
end
end
local o=e[8]
local a=e[9]
t:AddBuff(t,o,a,0)
local a=e[11]
local o=e[12]
local i={e[13],e[14],e[15],e[16],e[17]}
t:AddBuff(t,a,o,i)
return{
duration=e[10],
success=true
}
end
return s 
