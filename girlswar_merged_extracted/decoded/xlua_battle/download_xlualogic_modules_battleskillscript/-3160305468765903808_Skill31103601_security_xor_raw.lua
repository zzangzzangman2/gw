local e={
}
local s=e
function e.DoAction(e,t)
local t=e:JudgeSkillPreView(t)
local n=t[1]
local i=t[2]
local a={}
for o=3,31 do
table.insert(a,t[o])
end
e:AddBuff(e,n,i,a)
return nil
end
function e.GetAfterActionType()
return EBattleSkillAfterActionType.Normal
end
function e.DoAfterAction(t,e)
local e=t:JudgeSkillPreView(e)
local o=e[23]
local n=e[24]
local i={e[25],e[26],e[27],e[28]}
local a=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.enemyAll)
if(a~=nil)then
for a,e in ipairs(a)do
e:AddBuff(t,o,n,i)
end
end
local a=e[29]
local i=e[30]
local o={e[31],o}
t:AddBuff(t,a,i,o)
return{
duration=e[31],
success=true
}
end
return s

