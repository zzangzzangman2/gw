local e={
}
local i=e
function e.DoAction(t,e)
local e=t:JudgeSkillPreView(e)
local a=e[1]
local h=e[2]
local n={e[3]}
local s=e[4]
local i=e[5]
local o={e[6]}
local e=ModulesInit.ProcedureNormalBattle.GetBattleHeros(t,BattleHeroType.ourAll)
if(e)then
for r,e in ipairs(e)do
e:AddBuff(t,a,h,n)
e:AddBuff(t,s,i,o)
end
end
return nil
end
return i 
